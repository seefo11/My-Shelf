// OPTIONAL cloud sync. Leave these placeholders and My Shelf works on this device only.
// To sync across phones/browsers:
//  1. console.firebase.google.com -> Add project -> Add app (Web) -> paste its config below.
//  2. Build -> Authentication -> enable Email/Password (and Google if you like).
//     Authentication -> Settings -> Authorized domains -> add  YOUR-USERNAME.github.io
//  3. Build -> Firestore Database -> Create database -> Rules tab -> publish:
//       rules_version = '2';
//       service cloud.firestore { match /databases/{db}/documents {
//         match /users/{uid}/{document=**} { allow read, write: if request.auth != null && request.auth.uid == uid; }
//       } }
window.FIREBASE_CONFIG = {
  apiKey: 'YOUR_API_KEY',
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  messagingSenderId: 'YOUR_SENDER_ID',
  appId: 'YOUR_APP_ID'
};
