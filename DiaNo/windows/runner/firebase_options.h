#ifndef FIREBASE_OPTIONS_H_
#define FIREBASE_OPTIONS_H_

namespace firebase {
namespace options {
const char* GetApiKey();
const char* GetAppId();
const char* GetMessagingSenderId();
const char* GetProjectId();
const char* GetAuthDomain();
const char* GetStorageBucket();
}  // namespace options
}  // namespace firebase

#endif  // FIREBASE_OPTIONS_H_