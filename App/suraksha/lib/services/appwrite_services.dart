import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import '../ui/environment.dart';

class AppwriteService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Realtime realtime;

  AppwriteService() {
    client = Client()
        .setEndpoint(Environment.appwritePublicEndpoint)
        .setProject(Environment.appwriteProjectId);

    account = Account(client);
    databases = Databases(client);
    realtime = Realtime(client);
  }

  RealtimeSubscription subscribeToLocation(
      String userId,
      Function(Map<String, dynamic>) onUpdate,
      ) {
    return realtime.subscribe([
      'databases.${Environment.appwriteDatabaseId}.collections.live_locations.documents.$userId'
    ])
      ..stream.listen((event) {
        final data = event.payload;
        print("🔥 REALTIME EVENT");
        print(event.events);
        print(event.payload);
        onUpdate(data);
      });
  }
  RealtimeSubscription subscribeToNotifications(
      String receiverId,
      Function(Map<String, dynamic>) onNotification,
      ) {
    return realtime.subscribe([
      'databases.${Environment.appwriteDatabaseId}.collections.notifications.documents'
    ])
      ..stream.listen((event) {

        final data = event.payload;

        if (data['receiverId'] == receiverId &&
            data['status'] == 'pending') {

          print("🚨 NEW SOS RECEIVED");
          print(data);

          onNotification(data);
        }
      });
  }
  RealtimeSubscription subscribeToAlert(
      String alertId,
      Function(Map<String, dynamic>) onUpdate,
      ) {
    return realtime.subscribe([
      'databases.${Environment.appwriteDatabaseId}.collections.alerts.documents.$alertId'
    ])
      ..stream.listen((event) {
        onUpdate(event.payload);
      });
  }

 Future<void> testPing() async {
  try {
    final user = await account.get();
    print("✅ Connected! User: ${user.email}");
  } catch (e) {
    print("❌ Ping failed: $e");
  }
}
  Future<appwrite_models.User> login(String email, String password) async {
    await account.createEmailPasswordSession(email: email, password: password);
    return account.get();
  }

  Future<appwrite_models.User> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final user = await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );

    await account.createEmailPasswordSession(email: email, password: password);

    await createUserProfile(
      userId: user.$id,
      name: name,
      email: email,
      phone: phone,
    );

    return account.get();
  }

  Future<void> logout() {
    return account.deleteSession(sessionId: 'current');
  }

  Future<appwrite_models.User> getSession() {
    return account.get();
  }

  Future<String> getCurrentUserId() async {
    final currentUser = await getSession();
    return currentUser.$id;
  }

  Future<appwrite_models.Document> createUserProfile({
    required String userId,
    required String name,
    required String email,
    required String phone,
  }) async {

    print("🔥 Creating profile for $userId");

    final doc = await databases.createDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteUsersCollectionId,
      documentId: userId,
      data: {
        'uid': userId,
        'name': name,
        'email': email,
        'phone': phone,
      },
    );

    print('Profile created');

    return doc;
  }

  Future<appwrite_models.Document> getUserProfile(String userId) {
    return databases.getDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteUsersCollectionId,
      documentId: userId,
    );
  }

  Future<appwrite_models.DocumentList> searchUserByEmail(String email) {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteUsersCollectionId,
      queries: [Query.equal('email', email)],
    );
  }

  Future<appwrite_models.DocumentList> listContacts(String ownerId) {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteContactsCollectionId,
      queries: [Query.equal('ownerId', ownerId)],
    );
  }

  Future<appwrite_models.DocumentList> findContact(
    String ownerId,
    String contactUid,
  ) {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteContactsCollectionId,
      queries: [
        Query.equal('ownerId', ownerId),
        Query.equal('contactUid', contactUid),
      ],
    );
  }

  Future<appwrite_models.Document> addContact({
    required String ownerId,
    required Map<String, dynamic> contactData,
  }) {
    return databases.createDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteContactsCollectionId,
      documentId: ID.unique(),
      data: {'ownerId': ownerId, ...contactData},
    );
  }

  Future<void> deleteContact(String documentId) {
    return databases.deleteDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteContactsCollectionId,
      documentId: documentId,
    );
  }

  Future<appwrite_models.Document> createAlert({
    required String senderId,
    required double latitude,
    required double longitude,
  }) {
    return databases.createDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteAlertsCollectionId,
      documentId: ID.unique(),
      data: {
        'uid': senderId,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'status': 'active',
      },
    );
  }

  Future<appwrite_models.DocumentList> listUsers() {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteUsersCollectionId,
    );
  }

  Future<appwrite_models.DocumentList> listNotifications(
    String receiverId, {
    String status = 'pending',
  }) {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteNotificationsCollectionId,
      queries: [
        Query.equal('receiverId', receiverId),
        Query.equal('status', status),
      ],
    );
  }
  Future<appwrite_models.DocumentList> getAllNotifications(
      String receiverId,
      ) {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteNotificationsCollectionId,
      queries: [
        Query.equal('receiverId', receiverId),
      ],
    );
  }

  Future<appwrite_models.Document> createNotification({
    required String senderId,
    required String receiverId,
    required String alertId,
    required String type,
    required double lat,
    required double lon,
    required String status,
  }) {
    return databases.createDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteNotificationsCollectionId,
      documentId: ID.unique(),
      data: {
        'senderId': senderId,
        'receiverId': receiverId,
        'alertId': alertId,
        'type': type,
        'lat': lat,
        'lon': lon,
        'status': status,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  Future<appwrite_models.Document> updateNotificationStatus({
    required String documentId,
    required String status,
  }) {
    return databases.updateDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteNotificationsCollectionId,
      documentId: documentId,
      data: {'status': status},
    );
  }
  Future<void> closeAlert(String alertId) async {
    await databases.updateDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteAlertsCollectionId,
      documentId: alertId,
      data: {
        'status': 'closed',
        'closedAt':
        DateTime.now().toUtc().toIso8601String(),
      },
    );
  }
  Future<appwrite_models.DocumentList> getActiveAlerts() {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteAlertsCollectionId,
      queries: [
        Query.equal('status', 'active'),
      ],
    );
  }
  Future<appwrite_models.DocumentList> getMyAlerts(
      String userId,
      ) {
    return databases.listDocuments(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteAlertsCollectionId,
      queries: [
        Query.equal('uid', userId),
        Query.orderDesc('\$createdAt'),
      ],
    );
  }

  Future<appwrite_models.Document> updateUserLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) {
    print("🔥 Updating user doc: $userId");

    return databases.updateDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteUsersCollectionId,
      documentId: userId,
      data: {
        'lat': latitude,
        'lon': longitude,
      },
    );
  }
  Future<void> updateLiveLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {

    try {
      print("🔄 Trying Update: $userId");

      await databases.updateDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.appwriteLiveLocationCollectionId,
        documentId: userId,
        data: {
          'userId': userId,
          'latitude': latitude,
          'longitude': longitude,
          'updatedAt': DateTime.now().toUtc().toIso8601String(),
        },
      );

      print("✅ Update Success");

    } catch (e) {

      print("❌ Update Failed: $e");

      try {

        await databases.createDocument(
          databaseId: Environment.appwriteDatabaseId,
          collectionId: Environment.appwriteLiveLocationCollectionId,
          documentId: userId,
          data: {
            'userId': userId,
            'latitude': latitude,
            'longitude': longitude,
            'updatedAt': DateTime.now().toUtc().toIso8601String(),
          },
        );
        print("✅ Create Success");
      } catch (e) {
        print("❌ Create Failed: $e");
      }
    }
  }


  Future<String> sendSOS({
    required String senderId,
    required double latitude,
    required double longitude,
  }) async {
    final alertDoc = await createAlert(
      senderId: senderId,
      latitude: latitude,
      longitude: longitude,
    );
    print("Sender ID = $senderId");
    await updateUserLocation(
      userId: senderId,
      latitude: latitude,
      longitude: longitude,
    );
    await updateLiveLocation(
      userId: senderId,
      latitude: latitude,
      longitude: longitude,
    );
    final contactDocs = await listContacts(senderId);
    final Set<String> notifiedUsers = {};

    for (var doc in contactDocs.documents) {
      final contact = doc.data as Map<String, dynamic>;
      final contactUid = contact['contactUid'] as String? ?? '';
      if (contactUid.isEmpty) continue;
      notifiedUsers.add(contactUid);
      await createNotification(
        senderId: senderId,
        receiverId: contactUid,
        alertId: alertDoc.$id,
        type: 'SOS',
        lat: latitude,
        lon: longitude,
        status: 'pending',
      );
    }

    final users = await listUsers();
    for (var userDoc in users.documents) {
      final userData = userDoc.data as Map<String, dynamic>;
      final userId = userData['uid'] as String? ?? '';
      if (userId.isEmpty ||
          userId == senderId ||
          notifiedUsers.contains(userId))
        continue;

      final userLat = (userData['lat'] as num?)?.toDouble() ?? 0;
      final userLon = (userData['lon'] as num?)?.toDouble() ?? 0;
      final distance = _calculateDistance(
        latitude,
        longitude,
        userLat,
        userLon,
      );
      if (distance <= 2) {
        await createNotification(
          senderId: senderId,
          receiverId: userId,
          alertId: alertDoc.$id,
          type: 'SOS',
          lat: latitude,
          lon: longitude,
          status: 'pending',
        );
        notifiedUsers.add(userId);
      }
    }
    return alertDoc.$id;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dx = lat1 - lat2;
    final dy = lon1 - lon2;
    return (dx * dx + dy * dy) * 111;
  }
}
