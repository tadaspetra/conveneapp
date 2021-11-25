## Table Of Contents
- [Forking the project](#forking-the-project)
- [Setting the project up locally](#setting-the-project-up-locally)
- [pub get](#pub-get)
- [Creating an upload keystore](#Creating-an-upload-keystore)
- [Setting up a firebase Project](#Setting-up-firebase)
    - [Setting Up Authentication in Firebase ](#Setting-up-authentication-in-firebase)
- [Setting up Firebase Emulators ](#Setting-up-Firebase-Emulators)
    -   [Terminal](#Terminal)
    -   [Setting it in the Flutter Project](#Setting-it-in-the-Flutter-Project)
- [Starting the app](#Starting-the-app)

---
<br />

## Forking the project
Forking the project is like making your own copy of the project.
To fork the project you are going to to go the main github [here](https://github.com/tadaspetra/conveneapp)
then clicking on the fork button on the top right
It should redirect you to the page of your fork.
<br />
<br>
<br />

## Setting the project up locally
To setup the project locally, we are going to use [Github Desktop](https://desktop.github.com/). So after you've downloaded github desktop, login into your GitHub account. Then press on file (top left) and clone repository. Click on the fork you just made and select the path of where you want to install it in the bottom textfield
<br />
<br>
<br />

## pub get
After its done cloning the repo, open the folder in vs code or your preferred code editor, and run a ``` flutter pub get``` to get download all the dependencies the project uses.
<br />
<br>
<br />

## Creating an upload keystore
OFFICIAL DOC ON HOW TO DO IT [HERE](https://docs.flutter.dev/deployment/android#signing-the-app)

To create an upload keystore, you'll need to have [Java](https://www.java.com/download/ie_manual.jsp) downloaded and in your path. 
in your terminal/powershell you need to run the following command
:
<br />
On Mac/Linux: 
<br />
```
  keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
On Windows:
```
  keytool -genkey -v -keystore c:\Users\USER_NAME\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
#### AND REMEMBER TO CHANGE THE C:\Users\USER_NAME\upload-keystore.jks TO YOUR PREFERRED LOCATION 
<br />
<br />

Now when its done, you are going to create a `key.properties` file in the android folder of the convene app project and here is what to type:
```
storePassword='YOUR UPLOAD KEYSTORE PASSWORD'
keyPassword='THE KEY PASSWORD'
keyAlias=upload
storeFile='LOCATION OF THE KEYSTORE FILE YOU JUST CREATED'
```
After that, you're gonna simply go the `/android/app/build.gradle` in the project and Find the buildTypes block:
```
   buildTypes {
       release {
           // TODO: Add your own signing config for the release build.
           // Signing with the debug keys for now,
           // so `flutter run --release` works.
           signingConfig signingConfigs.debug
       }
   }
   ``` 
   and change it to:
   ```
      signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
   ``` 
And when you're done with that, run the project. It will throw many errors at you, but don't worry. This is because we're not done yet.
<br />
<br>
<br />

## Setting up firebase
 
 To set up firebase, were going to create a new firebae project by going to [firebase console](https://console.firebase.google.com/u/0/) and creating a new project. When we're done creating the firebase project, youre gonna enable the following features:
 
 * Firestore Database
 * Authentication
 
To enable a feature, press on the feature in the left navbar under the build section, then clicking on 'Get Started' Or 'Create Database' respectively

And when you're done, run a ```.\gradlew signingReport``` (Windows) or a ```./gradlew signingReport```(Mac/Linux) in the ``` android``` folder in the convene app project terminal, and copy both the SHA-1 and SHA-256 keys from the first part. After that, go to the firebase project settings from the firebase console and scroll till you find ```Your Apps```. There, choose your app and then click on ``` Add fingerprint ```, paste the keys there one after another respectively.
<br />
<br> 

### Setting up authentication in firebase

<br>
After you enable the authentication feature in your firebase project, you're going to enable Google sign in if youre developing on android, and both google and apple if youre developing on ios
<br>
<br>

## Setting up Firebase Emulators
<br>

### You'll need the up-to-date firebase CLI for this which cane be downloaded from [here](https://firebase.google.com/docs/cli)
<br>

#### Terminal

1. To get started create a folder `backend` (any applicable name would be fine) outside of the project.

```terminal
mkdir backend && cd backend
```

2. run `firebase login` and login with your associated account. Skip if you are already logged in

1. run `firebase init` please follow the flow to initialize your project. From the first prompt make sure to select `firestore` and `emulators`.
   Once you reach the emulator prompt select the `authentication,firestore` (we can install others later if we require them).

After you have finished the initialization you will see a file called `firebase.json` you would see some thing like this

```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "port": 8080
    },
    "ui": {
      "enabled": true
    }
  },
  "storage": {
    "rules": "storage.rules"
  }
}
```

All the emulators will be by default pointing to your `localhost`.

In my case the default (localhost) configuration doesn't work for me. This default configuration will only work on `emulators` and `simulators`.
To make it work for all devices we have to point the `host` to our network ip (your desktop ip).

```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "emulators": {
    "auth": {
      "host": "0.0.0.0",
      "port": 9099
    },
    "firestore": {
      "host": "0.0.0.0",
      "port": 8080
    },
    "ui": {
      "enabled": true
    }
  },
  "storage": {
    "rules": "storage.rules"
  }
}
```

Adding the host as `0.0.0.0` will set the emulators to your network ip ex. (192.168.8.131).

4. To start the emulators run `firebase emulators:start`

#### Setting it in the Flutter Project

- create a folder `configs` in the `root` of the project with a file called `emulator_config.json`. You can skip this step if u have not changed `hosts` or `ports`

```json
{
  "ip": "192.168.8.131",
  "auth_port": 9099,
  "firestore_port": 8080
}
```

- `ip` add this field if u have changed the port to your device ip, if this field is not there the app will by default use `10.0.2.2` for android and `localhost` for ios.
- `auth_port` your authentication port in the `firebase.json`, remove this if u have not changed your default ports.
- `firestore_port` your firestore port in the `firebase.json`. remove this if u have to changed the default ports

## Starting the app

- If you are using `vscode` as your editor goto your debug panel , you will see two new launch configs

  1. `Conveneapp Production` this points to your original firebase project so running this will not connect to your firebase emulators
  1. `Conveneapp Development` running this will use the firebase emulators.

- If your are using other editors to make use of the firebase emulators your have to add the following as arguments for your `--dart-define=ENV=DEV`
- If you are using terminal `flutter run --dart-define=ENV=DEV`

If you start the app without the provided args this will point to your production database.

