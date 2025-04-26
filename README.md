# Shade UI
A UI system used by JappeOS apps. Works alongside material widgets.

## How to use
Want to use ShadeUI in your Flutter project? Here's how.

### 1. Add to pubspec.yaml
Open the projects `pubspec.yaml` file and add this under the `dependencies` section:
```yaml
shade_ui:
  git:
    url: https://github.com/Jappe-OS/shade_ui.git
    ref: master-2.0
```
This will add the Shade UI's repository's main branch as a dependency.


You'll then need to add the `provider` package using the following command:
```
flutter pub add provider
```
This is needed for the theming system.

### 2. main.dart
Just replace your `MaterialApp` with `ShadeApp` (Won't work with Cupertino), also remember to import the ShadeUI package:
```dart
import 'package:shade_ui/shade_ui.dart';
```
The `theme` and `darkTheme` parameters that you might've used, will not be usable with `ShadeApp`, remove those. Use `customThemeProperties` instead, to change theme properties in runtime, see `Provider` and `ShadeCustomThemeProperties`.

Here is a simple example of `ShadeApp`'s usage:
```dart
ShadeApp(
  customThemeProperties: ShadeCustomThemeProperties(ThemeMode.light, null),
  home: Scaffold(
    body: const Center(child: Text('Hello!')),
    floatingActionButton: FloatingActionButton.large(onPressed: () {}, child: const Icon(Icons.add)),
  ),
),
```

### 3. Done!
You should now be able to use ShadeUI within your app!

* If you encounter any problems, join the Discord server (link on organization's main page).
* If you encounter a bug, please report it to the `issues` section.

Important resources:
* [Main organization page](https://github.com/Jappe-OS/)
* [Shade UI](https://github.com/Jappe-OS/shade_ui)
* [Shade UI Issues](https://github.com/Jappe-OS/shade_ui/issues)
