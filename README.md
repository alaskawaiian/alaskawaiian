# Starter Architecture Demo for Flutter & Firebase Realtime Apps

## Motivation

This repository contains a redesign of the "starter architecture" documentated in [Code with Andrea: Starter Architecture for Flutter & Firebase Apps using Riverpod](https://codewithandrea.com/videos/starter-architecture-flutter-firebase/). 

I redesigned the original starter architecture for the following reasons:

1. The original app no longer builds and runs. To fix it, I did the following:
  * Deleted the tests.
  * Updated several package versions.
  * Inlined several external packages maintained by the original author, which also suffered from outdated version information.

2. After getting it to run, I wanted to try to improve the source code, so I did the following:
  * Added Dart documentation comments to most top-level classes. 
  * Fixed source code to remove several dozen Dart Analysis errors.
  * Refactored the directory structure in an attempt to adhere to [Code with Andrea: Flutter Project Structure: Feature-first or Layer-first?](https://codewithandrea.com/articles/flutter-project-structure/).

## Results

Getting the app to build and run, adding Dart documentation, and removing Dart Analysis errors were all quite straightforward.

Refactoring the system to conform to a feature-first project structure was complicated and illuminating. This system is now structured in a feature-first manner in which each feature contains up to three layers: Presentation, Domain, and Data. There was no need for an "Application" layer for any feature.  

In addition to a set of features, there is one additional top-level directory: repositories, which provides access to Firebase and SharedPreferences. 

An important architectural principle was a strict downward dependency direction. In particular, the "repository" layer does not depend on any classes in the "features" layer. (In contrast, the original app's repository access files manipulated the domain model classes, creating an "upward" dependency between the "Data Layer" and the "Domain Layer".)

I found it quite useful to use [lakos](https://pub.dev/packages/lakos) to visualize the dependencies in the app. Here is the current dependency structure (you will need to open the image in a new browser window and expand it to see the details):

<img width="700px" src="https://github.com/philipmjohnson/flutter_starter_architecture_firebase/raw/master/README-dependency-graph.png">

What is architecturally important in this image is that all arrows point downward; the domain/ directories are low in the diagram; and the repositories/ directory is lowest.

Here are some things I found particularly interesting and useful about this application:

* **Firestore Access**. [FirestoreService], [FirestorePath], and [authStateChangesProvider] implements a very nice design pattern for accessing Firestore from Flutter using Riverpod.  These classes can be easily copied, pasted, and modified for use in other apps using Firebase and Riverpod.
* **Signin**. The signin classes and workflow are also a nice design pattern. Note that I tried the "reset" link and never got an email. Perhaps a more recent version of [FirebaseAuth] is needed? Here's an article which indicates the reset process should be pretty easy: <https://blog.logrocket.com/implementing-secure-password-reset-flutter-firebase/>.
* **Onboarding**. It was kind of cool to see the onboarding feature, in which you are shown it the first time you open the app, and then it is toggled off from then on (by saving a flag in SharedPreferences).
* **ListItemsBuilder**. The [ListItemsBuilder] class shows how to display [AsyncValue]s, which is cool and reusable.  See [Code with Andrea: AsyncValueWidget: a reusable Flutter widget to work with AsyncValue (using Riverpod)](https://codewithandrea.com/articles/async-value-widget-riverpod/) for more documentation about this.
* **The static show() method**. Widgets such as [EntryPage], [EditJobPage], and [JobEntriesPage] all have a static show() method that can be called from any other widget in order to navigate to this page.  That's a nice design pattern. 

Things that need more work:

* **Testing**. I had to delete the testing directory to get the app to run. This made refactoring a lot harder. I would like to reintegrate testing in future. 
* **Bottom navigation**. I think it would be better to use the Material [BottomNavigationBar] rather than [CupertinoTabBar], but I didn't change it.
* **Feature utility classes**. I kept all of the utility classes at top-level in the features/ directory because this improved the ability of Lakos to layout the dependencies. But maybe they should be organized into subdirectories. 
* **Use Riverpod exclusively for controllers.** There are a few classes like [SignInViewModel] which use [ChangeNotifier]. It seems to me that it would be better to use Riverpod whenever there is a need for state. 
* **Migrate to Freezed**. The original system (and this revised version) use [equatable](https://pub.dev/packages/equatable) along with custom code to translate back and forth between maps. It seems like a better solution nowadays is [Freezed](https://pub.dev/packages/freezed). 

## App structure

The Lakos dependency diagram is somewhat overwhelming.  Here is a simplified overview of the current app structure:

### lib/

As with all Flutter apps, the lib/ directory is the top level. It has a simple structure:

* [main], [MyApp] classes (to kick off the app).
* features/  (contains the "features" implementing app behavior)
* repositories/ (contains low-level, domain-independent utilities for accessing storage)

Note that the repositories/ code has no knowledge of the "higher level" (domain) code. 

### features/

The features/ directory contains a set of subdirectories, each implementing a major behavioral "feature" of the app.  Each feature can have a presentation/, data/, and domain/ subdirectory.

* account/
  * presentation/
    * [AccountPage], [Avatar]
* authorization/
  * presentation/
    * [AuthWidget]
    * sign_in/
      * (Various signin classes)
* entry/
  * data/
    * [EntryDatabase], [entryDatabaseProvider]
  * domain/
    * [Entry]
  * presentation/
    * (Various entry-related classes)
* home/
  * presentation/
    * (Various home page classes)
* job/
  * data/
    * [JobDatabase], [jobDatabaseProvider]
  * domain/
    * [Job]
  * presentation/
    * (Various job-related classes)
* onboarding/
  * presentation/
    * (Various classes to implement onboarding page)
* 8 additional files containing "utility" classes that are used by multiple features.)

Note that features are not entirely independent of each other. For example, the domain model class(es) for any feature can be referenced by any other feature.

### repositories/

The repositories directory contains code to connect the app to various storage services. In the case of this app, there are two: 

* firestore/
  * (Various classes to implement access to the Firestore database)
* shared_preferences/
  * (Various classes to implement access to SharedPreferences).

By design, this code is pretty generic and easily adapted for use in other applications.

## Installation

Before running the system, you must create a Firebase project. I found [Create and configure a Firebase project](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#2) from the Get to know Firebase for Flutter codelab to be a useful guide.

## Source code

The source code is available at: <https://github.com/philipmjohnson/flutter_starter_architecture_firebase>
