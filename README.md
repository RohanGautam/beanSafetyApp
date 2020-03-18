# firebase_tutorial

A new Flutter project.


# Firebase:
* Set up a new firebase project, and link it with an android app (work with the `/android` folder in flutter). Follow along the steps.
* In the firebase console under "Authentication", set up email and anonymous login methods.

# Learnings
* keep models(classes) seperate from the UI files. Also bunch related UI files together.
* We use `Streams` in dart to lisen for changes (eg: listen for change in authentication status in the wrapper). 
    * Each peice of information in a `Stream` in being continually sent. Basically, dont send shit all at once, but send it as and when you recieve it.
* We use the `Provider` package for listening to changes lower in the widget tree from somewhere higher in the widget tree. It is the recommended way for state management in flutter. It is used in the root widget (`main.dart` here)