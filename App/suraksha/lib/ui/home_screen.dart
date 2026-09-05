import 'package:flutter/material.dart';
import 'dart:async';
import '../services/shake_service.dart';
import '../services/location_service.dart';
import '../services/appwrite_services.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:vibration/vibration.dart';
import 'sos_dialog.dart';
import 'widgets/toggle_switch.dart';
import 'widgets/status_view.dart';
import '../services/api_service.dart';
import 'map_screen.dart';
import 'widgets/auth_screen.dart';
import 'profile_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'contacts_screen.dart';
import 'notification_screen.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:appwrite/appwrite.dart';
import 'history_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   StreamSubscription? _trackingSubscription;
   RealtimeSubscription? _notificationSubscription;

  final shakeService = ShakeService();
  final locationService = LocationService();
  final AppwriteService _appwriteService = AppwriteService();
  final Set<String> _shownNotifications = {};
  bool isSOSActive = false;
  bool isProcessing = false;



  @override
  void initState() {
    super.initState();
    debugPrint('🔍 HomeScreen.initState() called');

    shakeService.onShakeDetected = handleSOS;

    initializeRealtimeNotifications();
  }

  // 5 minute cooldown after a confirmed send
  final int cooldownSeconds = 300;

  // Track timestamp of last confirmed send. Initialize to epoch so ready.
  DateTime lastSOS = DateTime.fromMillisecondsSinceEpoch(0);
  bool isDialogOpen = false;
  // Remaining cooldown seconds (live-updated). 0 = ready.
  int remainingCooldownSeconds = 0;
  Timer? cooldownTimer;

  Future<void> handleSOS() async {
    debugPrint('🚨 handleSOS() called');
    if (!isSOSActive) {
      debugPrint('⚠️ SOS is not active');
      return;
    }
    final int since = DateTime.now().difference(lastSOS).inSeconds;
    if (since < cooldownSeconds) {
      final remaining = cooldownSeconds - since;
      debugPrint('⏱️ SOS cooldown active, $remaining seconds remaining');
      return;
    }
    if (isDialogOpen) {
      debugPrint('⚠️ Dialog already open');
      return;
    }

    // mark dialog open to prevent duplicate dialogs
    isDialogOpen = true;
    final result = await showSOSDialog(context);
    if (!mounted) return;
    // If user confirmed (true) -> send and start cooldown
    if (result == true) {
      debugPrint('📍 Getting location...');
      setState(() {
        isProcessing = true;
      });

      try {
        final pos = await locationService.getLocation();

        if (pos != null) {
          debugPrint('🔥 Sending SOS');
          bool serverSuccess = true;
          if (!ApiService.sendToConsoleOnly) {
            try {
              await ApiService.sendSOS(pos.latitude, pos.longitude);
            } catch (e) {
              serverSuccess = false;
              debugPrint('⚠️ Local backend failed, continuing to Appwrite: $e');
            }
          } else {
            debugPrint(
              'ℹ️ Skipping local backend send (configured for device testing)',
            );
          }

          final currentUser = await _appwriteService.getSession();
          await _appwriteService.sendSOS(
            senderId: currentUser.$id,
            latitude: pos.latitude,
            longitude: pos.longitude,
          );
          await FlutterBackgroundService().startService();
          _trackingSubscription?.cancel();

_trackingSubscription =
    locationService.startTracking().listen(
  (Position livePos) async {

    await _appwriteService.updateLiveLocation(
      userId: currentUser.$id,
      latitude: livePos.latitude,
      longitude: livePos.longitude,
    );

    debugPrint(
      "📍 Live Location Updated: "
      "${livePos.latitude}, ${livePos.longitude}",
    );
  },
);
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MapScreen(
                      userId: currentUser.$id,
                      lat: pos.latitude,
                      lon: pos.longitude,

                    ),
              ),
            );
          }

          lastSOS = DateTime.now();

          if (!serverSuccess && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'SOS saved to Appwrite, but local backend is unreachable.',
                ),
              ),
            );
          }

          // Start live cooldown counter
          remainingCooldownSeconds = cooldownSeconds;
          cooldownTimer?.cancel();
          cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
            setState(() {
              remainingCooldownSeconds--;
              if (remainingCooldownSeconds <= 0) {
                remainingCooldownSeconds = 0;
                t.cancel();
              }
            });
          });
        } else {
          debugPrint('❌ Location not available');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to get location.')),
            );
          }
        }

        // ✅ vibration
        debugPrint('📳 Vibrating device');
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 500);
          debugPrint('✅ Vibration done');
        }

        // ✅ message
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("🚨 SOS Sent")));
          debugPrint('✅ SnackBar shown');
        }
      } catch (e, st) {
        debugPrint('❌ handleSOS error: $e');
        debugPrint('$st');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to send SOS: $e')));
        }
      } finally {
        isDialogOpen = false;
        setState(() {
          isProcessing = false;
        });
      }
    } else {
      // cancelled or dismissed -> clear dialog flag, no cooldown
      debugPrint('🔍 Dialog cancelled or dismissed');
      isDialogOpen = false;
      setState(() {
        isProcessing = false;
      });
    }
  }
   Future<void> initializeRealtimeNotifications() async {
     final currentUser =
     await _appwriteService.getSession();

     _notificationSubscription =
         _appwriteService.subscribeToNotifications(
           currentUser.$id,
               (data) {
             debugPrint("🚨 REALTIME SOS");
             showSOSRealtimePopup(data);
           },
         );
   }
   void showSOSRealtimePopup(
       Map<String, dynamic> data,
       ) {

     if (!mounted) return;

     showDialog(
       context: context,
       builder: (_) => AlertDialog(
         title: const Text("🚨 SOS Alert"),
         content: const Text(
           "Nearby user needs help",
         ),
         actions: [

           TextButton(
             onPressed: () {

               Navigator.pop(context);

               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (_) => MapScreen(
                     userId: data['senderId'],
                     lat: (data['lat'] as num).toDouble(),
                     lon: (data['lon'] as num).toDouble(),
                     alertId: data['alertId'],
                   ),
                 ),
               );
             },
             child: const Text("View"),
           ),

           TextButton(
             onPressed: () {
               Navigator.pop(context);
             },
             child: const Text("Ignore"),
           ),
         ],
       ),
     );
   }
  void showSOSPopup(appwrite_models.Document doc) {
    if (isDialogOpen) return; // ❌ prevent multiple

    if (!mounted) return;
    isDialogOpen = true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚨 SOS Alert'),
        content: const Text('Nearby user needs help'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openMap(doc);
            },
            child: const Text('View'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ignoreSOS(doc);
            },
            child: const Text('Ignore'),
          ),
        ],
      ),
    ).whenComplete(() {
      isDialogOpen = false;
    });
  }

  void openMap(appwrite_models.Document doc) async {
    final data = doc.data as Map<String, dynamic>?;
    if (data == null || data['lat'] == null || data['lon'] == null) {
      debugPrint('❌ Missing location data');
      return;
    }
    final lat = (data['lat'] as num).toDouble();
    final lon = (data['lon'] as num).toDouble();
    final senderId = data['senderId'];

    await _appwriteService.updateNotificationStatus(
      documentId: doc.$id,
      status: 'opened',
    );
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(userId: senderId, lat: lat, lon: lon,
          alertId: data['alertId'],
        ),
      ),
    );
  }

  void ignoreSOS(appwrite_models.Document doc) async {
    await _appwriteService.updateNotificationStatus(
      documentId: doc.$id,
      status: 'ignored',
    );
  }
   Future<void> endSOS() async {

     _trackingSubscription?.cancel();
     _trackingSubscription = null;

       FlutterBackgroundService()
         .invoke("stop");

     setState(() {
       isSOSActive = false;
     });

     if (!mounted) return;

     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text("SOS Closed"),
       ),
     );
   }

  void toggleSOS(bool val) {
    debugPrint('🔄 toggleSOS($val) called');
    setState(() {
      isSOSActive = val;
    });

    if (val) {
      debugPrint('✅ Starting shake service');
      // When user toggles ON, reset any cooldown so immediate send is allowed
      lastSOS = DateTime.fromMillisecondsSinceEpoch(0);
      remainingCooldownSeconds = 0;
      cooldownTimer?.cancel();
      _shownNotifications.clear();
      shakeService.start();

    } else {
      debugPrint('✅ Stopping shake service');
      // _pollTimer?.cancel();
      cooldownTimer?.cancel();
      shakeService.stop();

      _trackingSubscription?.cancel();
      _trackingSubscription = null;

      setState(() {
        remainingCooldownSeconds = 0;
        isDialogOpen = false;
        isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    debugPrint('🔍 HomeScreen.dispose() called');
    shakeService.stop();
    cooldownTimer?.cancel();
    
_trackingSubscription?.cancel();
    _notificationSubscription?.close();
    super.dispose();
    debugPrint('✅ HomeScreen disposed');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 HomeScreen.build() called');
    return Scaffold(
      appBar: AppBar(title: const Text("Safety App")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text("Contacts"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ContactsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("SOS History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const HistoryScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                // bad me kar
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await _appwriteService.logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => AuthScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ToggleSwitch(value: isSOSActive, onChanged: toggleSOS),
              Expanded(
                child: StatusView(
                  isProcessing: isProcessing,
                  isSOSActive: isSOSActive,
                  cooldownLeftSeconds: remainingCooldownSeconds,
                ),
              ),
            ],
          ),
          if (isSOSActive)
            Positioned(
              right: 16,
              bottom: 16,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: remainingCooldownSeconds > 0
                    ? Container(
                        key: ValueKey('timer_$remainingCooldownSeconds'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime(remainingCooldownSeconds),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        key: const ValueKey('ready_badge'),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          if (isSOSActive)
            Positioned(
              left: 16,
              bottom: 16,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.stop),
                label: const Text("End SOS"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: endSOS,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
