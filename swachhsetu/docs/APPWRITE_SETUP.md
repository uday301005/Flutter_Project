# Appwrite Setup

SwachhSetu uses Appwrite only when `DEMO_MODE=false`. No project, IDs, keys, or permissions are included in this repository.

## Project

1. Create an Appwrite Cloud project.
2. Add an Android platform using the final Android application ID from `android/app/build.gradle.kts`.
3. Set these Dart defines when running:

```text
--dart-define=DEMO_MODE=false
--dart-define=APPWRITE_ENDPOINT=https://<region>.cloud.appwrite.io/v1
--dart-define=APPWRITE_PROJECT_ID=<project-id>
--dart-define=APPWRITE_DATABASE_ID=<database-id>
```

Provide collection and bucket IDs with the matching `APPWRITE_*_COLLECTION_ID` and `APPWRITE_*_BUCKET_ID` defines. Never commit these values if they are environment-specific.

## Database

Create a database and these collections: `users`, `waste_reports`, `pickup_requests`, `waste_classifications`, `waste_bins`, `collection_centers`, `notifications`, `tracking_events`, `complaints`, and `support_requests`.

Required document attributes include:

- `users`: `userId`, `name`, `email`, `phone`, `address`, `profileImageId`, `createdAt`, `updatedAt`
- `waste_reports`: `reportId`, `userId`, `imageFileId`, `description`, `category`, `severity`, `latitude`, `longitude`, `address`, `status`, `createdAt`, `updatedAt`
- `pickup_requests`: `pickupId`, `userId`, `wasteType`, `quantity`, `address`, `latitude`, `longitude`, `preferredDate`, `preferredTime`, `notes`, `status`, `createdAt`, `updatedAt`
- `notifications`: `userId`, `title`, `message`, `type`, `isRead`, `createdAt`, `relatedEntityId`
- `support_requests`: `userId`, `issueType`, `description`, `imageFileId`, `createdAt`, `status`

Add indexes on `userId`, `createdAt`, and relevant status fields. Use string attributes for enum names and ISO-8601 date strings, matching the repository adapters.

## Permissions

Configure document-level permissions manually in the Appwrite Console. For user-owned collections, grant the authenticated user read/update access only to documents whose owner is that user, and create access only to authenticated users. Do not grant client users collection-wide update/delete access. Master data such as bins and collection centers should be read-only for clients. Status assignment and administrative updates must be performed by a separate server/admin application.

Storage buckets should grant authenticated users create access for their own uploads and read access only to files permitted by the product policy. Report/profile/AI files must be stored in Storage; database documents contain file IDs only.

## Realtime

Enable Realtime for reports, pickup requests, and notifications after permissions are configured. The app includes a disposable `AppwriteRealtimeService`; callers should retain and dispose subscriptions when screens/controllers are destroyed. If Realtime is unavailable, refresh repositories normally.

## Maps and AI

Set `GOOGLE_MAPS_API_KEY` only in the Android resource `android/app/src/main/res/values/maps_config.xml` for a local build, or provide an equivalent secret-managed release resource. The checked-in value is empty. A production AI endpoint can be supplied with `AI_ENDPOINT`; no model is included. Until configured, the demo map and mock classifier remain active.

## Demo mode

The default is `DEMO_MODE=true`. Demo repositories, local session/profile storage, demo facilities, and mock classification require no Appwrite project. Production mode must be tested only after all IDs, attributes, permissions, and platform configuration have been created in Appwrite.
