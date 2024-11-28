# team-hot-dog food_tracker_app
## Team Members:
- Aaron Dewanz
- Anthony Kuismi
- Colin Malecha
- Eli McGovern
- Samuel Ortiz Fishman
- Calvin Thompson

## Branch Guide:
Please follow the following branch naming convention:
```
- master: Production
- dev: Development
- feature/branch-name: Feature development
- bugfix/branch-name: Bugfix development
- hotfix/branch-name: Hotfix development
- release/branch-name: Release development
- support/branch-name: Support development
```

## Commits:
Please commit your code frequently with an explanatory message.

## Project Technologies:
This project uses the API [CalorieNinjas](https://calorieninjas.com/).
> For the scope of this project, the key is stored in the `searchmodel.dart` file. This is not secure and should be changed in the future if the project would be made public.

In addition, the project uses Firestore through [Firebase](https://firebase.google.com/) to store user data. The project uses the `firebase_core` and `cloud_firestore` packages.
> Note that the project is currently running in test mode. This means that the Firestore database is not secure and should be changed in the future if the project would be made public.

The project uses Flutter 78.02 and Dart 3.2.5.
