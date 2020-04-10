# B.E.A.N.S
<p align="center">
    <img src="assets/beansAppLogo.png" alt="logo" width="200"/>
</p>

# Firebase:
* Set up a new firebase project, and link it with an android app (work with the `/android` folder in flutter). Follow along the steps.
* In the firebase console under "Authentication", set up email and anonymous login methods.


# Learnings
* keep models(classes) seperate from the UI files. Also bunch related UI files together.
* We use `Streams` in dart to lisen for changes (eg: listen for change in authentication status in the wrapper). 
    * Each peice of information in a `Stream` in being continually sent. Basically, dont send shit all at once, but send it as and when you recieve it.
* We use the `Provider` package for listening to changes lower in the widget tree from somewhere higher in the widget tree. It is the recommended way for state management in flutter. It is used in the root widget (`main.dart` here)
* Can pass functions to children as parameters, which toggle the parent's state (here, to switch views). For example, check out how register and sign in are switched. There is no `Material.push()` or whatever that is, to manually push/pop a page from the stack. It's all handled by a parent class controlling both the states.
* We are also use another stream from firebase, which notifies us of and document/document changes that happen in our database. We user `Provider` again, in the `home.dart` (the homepage)
* getters are usually used for stream definition, so other classes just call this getter.
* make sure streams are getting updated with the data they are listening to changes for
* Can actually have more than 1 emulator running, with each acting as a seperate user.
* `flutter clean` when you have no clue on why your app won't build.
* Make sure returned value from firebase cloud function,eg, in `index.ts`, is JSON-serialisable.
* Devices are identified with a `fcm` (got in `getDeviceToken` in `pushNotification.dart`). You can't use the the Firebase Auth uid as the fcm. Gotta store and use it seperately.
* Sometimes users will have to be re-registered for fcm token to be valid. (Do this if the notifications are not working)

# TODO: 
* remove setstyle for map from emergency services map
* fix emergencyservicemap
* use snackbar/dialog for alerting

* remove api key from `android/app/src/main/AndroidManifest.xml` and everywhere else after project is over.

# Login process
![img](doc_images/loginprocess.png)


# References
* [Hot reload on multiple devices](https://stackoverflow.com/a/58355638)
* [Pass provider state to another route](https://stackoverflow.com/a/57915045)
* [Circular button](https://stackoverflow.com/a/51117463)
* [Adding assets](https://flutter.dev/docs/development/ui/assets-and-images)
* [Get directions from A to B in google maps](https://medium.com/flutter-community/drawing-route-lines-on-google-maps-between-two-locations-in-flutter-4d351733ccbe)
* [Making a page scrollable](https://stackoverflow.com/a/51773359)
* [Push notifications with flutter](https://www.youtube.com/watch?v=Lq9-DPKWtIc). Can send notification on firebase console > Cloud messaging
* [Firebase puch notification to custom user](https://www.youtube.com/watch?v=2TSm2YGBT1s). Seems to use Typescript to define a custom cloud function. Unnessessarily complicated.
* [Firebase custom fn tutorial](https://medium.com/@jackwong_60367/cloud-function-flutter-128b8c3695b4)
* [Firebase cloud fns on pub.dev](https://pub.dev/packages/cloud_functions#-readme-tab-)
* [bugfix: gradle has no permission](https://stackoverflow.com/a/58998688)
* [Set up Firebase CLI](https://firebase.google.com/docs/functions/get-started)
* Set up firebase functions in project root using `firebase init functions`, and after adding function run `firebase deploy`
* [Firebase versioning error fix](https://stackoverflow.com/a/51846868)
* [Get documents from firestore collection : typescript](https://firebase.google.com/docs/firestore/query-data/get-data#get_multiple_documents_from_a_collection)
* [Rename app](https://stackoverflow.com/a/56039224) 
* Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
* [Change app icon](https://pub.dev/packages/flutter_launcher_icons)
* [Pass scaffold context with key](https://stackoverflow.com/a/53889100)
* [Keyboard causing bottom overflow fix: SingleChildScrollView](https://www.youtube.com/watch?time_continue=14&v=2E9iZgg5TOY&feature=emb_logo)
* [Align images in markdown](https://davidwells.io/snippets/how-to-align-images-in-markdown)