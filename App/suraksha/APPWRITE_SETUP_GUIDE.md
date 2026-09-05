# Appwrite Setup Guide for Suraksha App

## Database ID
Create a database named `suraksha_db` and copy its ID below:
```
Database ID: 6a27a3660025f1e9432a
```

---

## Collections to Create

### 1. **users** Collection
**Purpose**: Store user profiles

**Attributes:**
- `uid` (String, Required) - User ID from auth
- `name` (String, Required) - User's full name
- `email` (String, Required) - User's email
- `phone` (String, Required) - User's phone number
- `lat` (Float, Optional) - Last known latitude
- `lon` (Float, Optional) - Last known longitude

**Indexes:**
- Index on `email` (Ascending)

**Collection ID:** `YOUR_USERS_COLLECTION_ID`

---

### 2. **contacts** Collection
**Purpose**: Store user's emergency contacts

**Attributes:**
- `ownerId` (String, Required) - User ID of the contact owner
- `contactUid` (String, Required) - User ID of the contact person
- `name` (String, Required) - Contact's name
- `email` (String, Required) - Contact's email
- `phone` (String, Optional) - Contact's phone

**Indexes:**
- Index on `ownerId` (Ascending)
- Index on `contactUid` (Ascending)

**Collection ID:** `YOUR_CONTACTS_COLLECTION_ID`

---

### 3. **alerts** Collection
**Purpose**: Store SOS alerts sent by users

**Attributes:**
- `uid` (String, Required) - User ID who sent SOS
- `latitude` (Float, Required) - Alert location latitude
- `longitude` (Float, Required) - Alert location longitude
- `timestamp` (String, Required) - ISO8601 timestamp
- `status` (String, Required) - pending/responded/closed

**Indexes:**
- Index on `uid` (Ascending)

**Collection ID:** `YOUR_ALERTS_COLLECTION_ID`

---

### 4. **notifications** Collection
**Purpose**: Store notifications for users about nearby SOS alerts

**Attributes:**
- `senderId` (String, Required) - User who sent the SOS
- `receiverId` (String, Required) - User receiving the notification
- `alertId` (String, Required) - Reference to the alert
- `type` (String, Required) - "SOS" or other types
- `lat` (Float, Required) - Alert latitude
- `lon` (Float, Required) - Alert longitude
- `status` (String, Required) - pending/opened/ignored
- `timestamp` (String, Required) - ISO8601 timestamp

**Indexes:**
- Index on `receiverId` (Ascending)
- Index on `status` (Ascending)

**Collection ID:** `YOUR_NOTIFICATIONS_COLLECTION_ID`

---

## Steps to Create Collections in Appwrite Console

1. Go to **Databases** → Select your database `suraksha_db`
2. Click **+ Create Collection**
3. Fill in collection name (e.g., "users")
4. Click **Create**
5. Go to **Attributes** tab
6. Add each attribute one by one (click + icon)
7. Set attribute type, name, and mark as Required if needed
8. Go to **Indexes** tab
9. Add indexes for fields like `email`, `ownerId`, `receiverId`

---

## After Creating Collections

Copy all the IDs and update `lib/ui/environment.dart`:

```dart
class Environment {
  static const String appwriteProjectId = '6a26df87003b0454aa2e';
  static const String appwriteProjectName = 'FlutterApp';
  static const String appwritePublicEndpoint =
      'https://sgp.cloud.appwrite.io/v1';

  static const String appwriteDatabaseId = 'YOUR_DATABASE_ID_HERE';
  static const String appwriteUsersCollectionId = 'YOUR_USERS_COLLECTION_ID_HERE';
  static const String appwriteContactsCollectionId = 'YOUR_CONTACTS_COLLECTION_ID_HERE';
  static const String appwriteAlertsCollectionId = 'YOUR_ALERTS_COLLECTION_ID_HERE';
  static const String appwriteNotificationsCollectionId = 'YOUR_NOTIFICATIONS_COLLECTION_ID_HERE';
}
```

---

## Database Permissions (Important!)

For each collection, set these permissions:

1. Go to Collection → **Settings** tab
2. Under **Permissions**, set:
   - **Create**: Any (allow all users to create their own records)
   - **Read**: Any
   - **Update**: Role: User (only own records)
   - **Delete**: Role: User (only own records)

Or you can set more restrictive permissions based on your security needs.

---

## Next Steps

After updating `environment.dart`:
1. Run `flutter pub get`
2. Run app: `flutter run`
3. Test login/signup
4. Test adding contacts
5. Test SOS functionality
