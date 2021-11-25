# Introduction
TOC
- fork
- set up project locally
- pub get
- upload key 
- firebase emulator
- do your task
- how to create a PR

## Firebase Emulator Configuration

There are many ways around for this the one which will be listed below is efficient in my POV.

### Initialize a Firebase project

This step is important, if u already have an initialization ready with the emulators u can skip this.

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

#### Setting it to Flutter Project

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

#### Starting the app

- If you are using `vscode` as your editor goto your debug panel , you will see two new launch configs

  1. `Conveneapp Production` this points to your original firebase project so running this will not connect to your firebase emulators
  1. `Conveneapp Development` running this will use the firebase emulators.

- If your are using other editors to make use of the firebase emulators your have to add the following as arguments for your `--dart-define=ENV=DEV`
- If you are using terminal `flutter run --dart-define=ENV=DEV`

If you start the app without the provided args this will point to your production database.