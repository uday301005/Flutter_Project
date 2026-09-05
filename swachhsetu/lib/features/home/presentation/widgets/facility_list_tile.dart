import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/home_summary.dart';

class FacilityListTile extends StatelessWidget {
  const FacilityListTile({
    super.key,
    required this.facility,
    required this.onTap,
  });

  final NearbyFacility facility;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: const CircleAvatar(child: Icon(Icons.location_on_outlined)),
      title: Text(facility.name),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Text('${facility.type}  •  ${facility.distance}'),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
