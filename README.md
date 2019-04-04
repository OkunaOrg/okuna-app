<img alt="Open book logo" src="https://snag.gy/oaVCPq.jpg" width="200">

The Openbook mobile app.

## Table of contents

- [Requirements](#requirements)
- [Project overview](#project-overview)
- [Contributing](#contributing)
    + [Code of Conduct](#code-of-conduct)
    + [License](#license)
    + [Other issues](#other-issues)
    + [Git commit message conventions](#git-commit-message-conventions)
- [Getting started](#getting-started)

## Requirements

* [openbook-api](https://github.com/OpenbookOrg/openbook-api)
* [Flutter](https://flutter.io/get-started/install/)

## Project overview

The project is a [Flutter](https://flutter.dev) application.
 
It's dependent on the [openbook-api](https://github.com/OpenbookOrg/openbook-api) backend.

## Contributing

There are many different ways to contribute to the website development, just find the one that best fits with your skills and open an issue/pull request in the repository.

Examples of contributions we love include:

- **Code patches**
- **Bug reports**
- **Patch reviews**
- **Translations**
- **UI enhancements**

#### Code of Conduct

Please read and follow our [Code of Conduct](https://github.com/OpenBookOrg/openbook-app/blob/master/CODE_OF_CONDUCT.md).

#### License

Every contribution accepted is licensed under [AGPL v3.0](http://www.gnu.org/licenses/agpl-3.0.html) or any later version. 
You must be careful to not include any code that can not be licensed under this license.

Please read carefully [our license](https://github.com/OpenBookOrg/openbook-app/blob/master/LICENSE.txt) and ask us if you have any questions.

#### Responsible disclosure

Cyber-hero? Check out our [Vulnerability Disclosure page](https://www.open-book.org/en/vulnerability-report).

#### Other issues

We're available almost 24/7 in the Openbook slack channel. [Join us!](https://join.slack.com/t/openbookorg/shared_invite/enQtNDI2NjI3MDM0MzA2LTYwM2E1Y2NhYWRmNTMzZjFhYWZlYmM2YTQ0MWEwYjYyMzcxMGI0MTFhNTIwYjU2ZDI1YjllYzlhOWZjZDc4ZWY)

#### Git commit message conventions

Help us keep the repository history consistent 🙏!

We use [gitmoji](https://gitmoji.carloscuesta.me/) as our git message convention.

If you're using git in your command line, you can download the handy tool [gitmoji-cli](https://github.com/carloscuesta/gitmoji-cli).

## Getting started

### 1. Install the `openbook-api` backend.

Follow the [instructions here](https://github.com/OpenbookOrg/openbook-api#getting-started) and make sure the server is running.

### 2. Install Flutter

Visit the [Flutter Install website](https://flutter.io/docs/get-started/install) and follow instructions.

Once you're done, make sure everything works properly by running `flutter doctor`.

````sh
flutter doctor
````

### 3. Clone the repository

```sh
git clone git@github.com:OpenbookOrg/openbook-app.git
cd openbook-app
```

### 4. Create the `env.json` file

We use a `.env.json` file to pass environment variables to the application such as the backend endpoint.

Create a copy of `.sample.env.json` named `.env.json`

````bash
cp .sample.env.json .env.json
````

Edit the `.env.json` file  with your environment settings.

````json
{
   "API_URL": "<MANDATORY: The url of the openbook-api backend>",
   "MAGIC_HEADER_NAME" : "<OPTIONAL: The name of a header to append on every request used for access-control.",
   "MAGIC_HEADER_VALUE" : "<OPTIONAL: The value of the header to append on every request used for access-control.>"
}
````

### 5. Configure a signing key
_(Android only step)_

**Create a keystore**

If you have an existing keystore, skip to the next step. If not, create one by running the following at the command line: 

````bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
````

**Note:** keytool might not be in your path. It is part of the Java JDK, which is installed as part of Android Studio. For the concrete path, run flutter doctor -v and see the path printed after ‘Java binary at:’, and then use that fully qualified path replacing java with keytool.

**Reference the keystore from the app**

Create a file named <app dir>/android/key.properties that contains a reference to your keystore:

````properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<location of the key store file, e.g. /Users/<user name>/key.jks>
````

**Note:** Although the file <app dir>/android/key.properties is ignored, make double sure the file remains private; do not check it into public source control.

### 6. Open the iOS/Android simulator or connect a device.

**iOS Simulator**

1. Launch Xcode

2. Click on the XCode top left menu item (Next to the Apple logo)

3. Open Developer Tool -> iOS Simulator

**Android Simulator**

1. Launch Android Studio

2. Select Tools -> AVD Manager

3. If no virtual device available, click Create Virtual Device and follow steps.

4. Select the ▶️ icon next to the device to run.

**Connect a device**

1. Plug the device

2. Allow any permission request shown in the device

### 7. Run the flutter app

**Note**: We use [flavors](https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36) to configure different names and settings for different environments.

**Development flavor**

````bash
flutter run --flavor development
````

**Production flavor**

````bash
flutter run --flavor production
````

**Profile**

Not a flavor but Flutter's way to profile the app. [Read more here](https://flutter.io/docs/testing/ui-performance).

````bash
flutter run --profile
````

### 8. Contribute! 

Help us keep Openbook going! Please look into our open issues. All contribution, no matter how small, makes a big difference.

## Official work-around's list

Unfourtunately, Flutter is still in it's early steps as a framework and ecosystem.

Work-arounds to get the app to work are something we see frequently.

This is the section where we'll be documenting the work-arounds to avoid confusion in the future.

### OneSignal iOS Build Failing

The [OneSignal Flutter SDK](https://github.com/OneSignal/OneSignal-Flutter-SDK) does not work out of the box.

In Android, the SDK Setup Guide contains wrong instructions which were adressed on [this Github Issue](https://github.com/OneSignal/OneSignal-Flutter-SDK/issues/56).

In iOS, there was no official solution to it and the fix was an absolute "hack".

The original issue for the build error is [this one](https://github.com/OneSignal/OneSignal-Flutter-SDK/issues/57) and the "hack" we implemented is found in [this issue](https://github.com/OneSignal/OneSignal-Flutter-SDK/issues/42#issuecomment-459476383) plus [disabling bitcode](https://stackoverflow.com/questions/50553443/xcode-ios-build-linker-command-failed-with-exit-code) in the service extension. 


## Questions/stuck?

[Join our Slack channel](https://join.slack.com/t/openbookorg/shared_invite/enQtNDI2NjI3MDM0MzA2LTYwM2E1Y2NhYWRmNTMzZjFhYWZlYmM2YTQ0MWEwYjYyMzcxMGI0MTFhNTIwYjU2ZDI1YjllYzlhOWZjZDc4ZWY), we're happy to help you troubleshoot your issue.


# Glossary

Have a term we use you would like an explanation for? [Let us know by opening an issue](https://github.com/OpenbookOrg/openbook-api/issues)!

#### Circle

An audience composed of multiple people created with the purpose of sharing content exclusively with it.

For example, Friends, Family, Work, BFFs.

#### World Circle

The audience composed of the entire internet! Everyone can post to it.

#### Connection

A connection between two users, initiated by any of the two. It's linked to an specific circle.

#### Connections Circle

The audience composed by all of the people you're connected with

#### Linked users

Users that are either connected to us or are following us.

#### Community administrators

Members of a community that have the power to modify the community details + moderator powers.

#### Community moderators

Members of a community that have the power to ban, unban, review community post/comments reports and act on them.

#### Community member

A member of a community with the power to post to it and receive it's content in it's timeline.

<br>

#### Happy coding 🎉!
