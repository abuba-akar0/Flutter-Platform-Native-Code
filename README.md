# 📱 Flutter Platform Channel (Android Java)

A simple Flutter project demonstrating communication between **Flutter (Dart)** and **Android native code (Java)** using a **MethodChannel**. The app fetches and displays device information from the Android system.

---

## What this repo includes

- A minimal Flutter app that calls into Android native code via a MethodChannel.
- Android host code implemented in Java (under `android/app/src/main/java/...`).
- Example showing how to return the device manufacturer, model, and Android SDK version from the host platform to Dart.

---

## Quick checklist (what I'll cover)

- [x] How to run the app locally
- [x] Where the native Java code lives
- [x] Example Dart and Java MethodChannel code
- [x] Troubleshooting tips

---

## Prerequisites

- Flutter SDK (stable). Confirm with:

```bash
flutter --version
```

- Android SDK and an Android emulator or a physical Android device connected.
- (Optional) Android Studio or another editor with Flutter plugin.

---

## Run the app

1. Install dependencies:

```bash
flutter pub get
```

2. Run the app on the default connected Android device or emulator:

```bash
flutter run
```

To target a specific Android device, list devices and run:

```bash
flutter devices
flutter run -d <deviceId>
```

---

## Project structure (relevant parts)

- `lib/` – Flutter Dart code (UI + MethodChannel client)
  - `main.dart` – app entrypoint and example MethodChannel usage
- `android/` – Android project
  - `app/src/main/java/...` – Java host code (where the MethodChannel handler lives)

Note: depending on the package name set for the Android app, the Java files may be nested under a package folder such as `com/example/platform_native_code`.

---

## How the MethodChannel communication works (high level)

1. Dart creates a MethodChannel with a name (a string identifier).
2. Dart calls `invokeMethod` on that channel.
3. Android native code (Java) registers a MethodCallHandler for the same channel name and handles incoming calls, returning results or errors.
4. Dart receives the result (or catches an error) and updates the UI.

This repo demonstrates that flow with a simple `getDeviceInfo` method.

---

## Example Dart side (client)

Below is a simplified example of what you might find in `lib/main.dart`:

```dart
import 'package:flutter/services.dart';

final _channel = MethodChannel('com.example.platform_native/device');

Future<Map<String, String>> getDeviceInfo() async {
  final result = await _channel.invokeMethod<Map>('getDeviceInfo');
  if (result == null) return {};
  return Map<String, String>.from(result.cast<String, String>());
}
```

The UI calls `getDeviceInfo()` and displays the returned map keys such as `manufacturer`, `model`, and `sdkInt`.

---

## Example Java side (host)

A typical Java handler (placed in `android/app/src/main/java/<your/package>/MainActivity.java`) looks like this:

```java
package com.example.platform_native; // replace with your app package

import android.os.Build;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.example.platform_native/device";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
      .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, MethodChannel.Result result) {
          if (call.method.equals("getDeviceInfo")) {
            Map<String, Object> info = new HashMap<>();
            info.put("manufacturer", Build.MANUFACTURER);
            info.put("model", Build.MODEL);
            info.put("sdkInt", String.valueOf(Build.VERSION.SDK_INT));
            result.success(info);
          } else {
            result.notImplemented();
          }
        }
      });
  }
}
```

If your project uses Kotlin or a different activity setup, adapt accordingly. The important parts are the channel name and implementing `onMethodCall` to respond to Dart calls.

---

## Where to find and edit the native code

Open:

```
android/app/src/main/java/<your/package>/MainActivity.java
```

Replace `<your/package>` with the package folders for your app (for example, `com/example/platform_native_code`). If your project was created with Kotlin you may instead see `MainActivity.kt` and the same MethodChannel logic will be there but written in Kotlin.

---

## Troubleshooting

- If `invokeMethod` throws a MissingPluginException or you get `notImplemented`, verify the channel name matches exactly on both sides.
- If you change the native code, rebuild the Android app (a hot restart may not pick up native changes):

```bash
flutter clean
flutter pub get
flutter run
```

- Check the Android logcat for native-side errors. In Android Studio use the Logcat panel or run:

```bash
adb logcat
```

---

## Extending this example

- Add more native methods that return sensors, battery state, or custom platform APIs.
- Implement MethodChannel error handling (return `result.error(...)` on failures).
- Securely validate inputs if you accept parameters from Dart.

---

## Contributing

Contributions are welcome. Open an issue or submit a PR with a clear description of the change.

---

## License

This project is provided as-is for learning and experimentation. Add a license file if you plan to publish or share it publicly.
