# main.dart — Structure & Overview

This document explains the structure and key components of the `lib/main.dart` file in this project. It describes the app entry point, the main widgets, state/behavior patterns used, and notes for customizing or running the example.

**File:** `lib/main.dart`

**Purpose:** A small Instagram-style UI clone demonstrating layout, a simple stories row, a feed with a single post, and a bottom navigation bar.

---

**Entry Point:**
- **`main()`**: Calls `runApp(InstaCloneApp())`. This bootstraps the Flutter app.

**Root Widget:**
- **`InstaCloneApp`** (extends `StatelessWidget`):
  - Returns a `MaterialApp` with:
    - `title: 'Insta UI Clone'`
    - `debugShowCheckedModeBanner: false`
    - A simple `ThemeData` setting white primary/scaffold background
    - `home: InstaHomePage()`

**Primary Screen:**
- **`InstaHomePage`** (extends `StatelessWidget`):
  - Contains the full scaffold for the app: `AppBar`, body (stories + feed), and `bottomNavigationBar`.
  - Key fields:
    - `localPostImage`: an asset path (`assets/images/your_post_image.png`) for using a local post image.
    - `networkPostImage`: fallback Unsplash network image URL used if the local image isn't available.
  - Body layout:
    - A vertical `Column` containing:
      - Stories section: a horizontal `ListView` with `_MyStoryTile` and several `StoryTile` widgets using `_sampleAvatar()` for avatar URLs.
      - A divider.
      - Feed: an `Expanded` `ListView` containing one `PostWidget`. You can add more `PostWidget(...)` entries to show additional posts.
  - Bottom navigation: `BottomNavBar()` (see below).

**Story Widgets:**
- **`_MyStoryTile`** (private `StatelessWidget`):
  - Shows a large circular avatar placeholder and a blue `+` badge to mimic the user's story tile.
  - Includes a small label `'your story'` below the avatar.

- **`StoryTile`** (`StatelessWidget`):
  - Constructor: `StoryTile({ required String name, required String imageUrl })`
  - Renders a circular avatar with a gradient border and the story's `name` below.

**Post Widget:**
- **`PostWidget`** (`StatelessWidget`): the main post UI component, contains:
  - Constructor arguments: `username`, `avatarUrl`, `location`, `postImageProvider`, `fallbackImage`.
  - Header: `ListTile` with avatar, username, location, and more menu icon.
  - Post image area: uses a `FutureBuilder` that awaits `_testImageProvider(...)` to verify whether the provided `postImageProvider` (e.g., an `AssetImage`) can be resolved. If the provider loads successfully, it is shown; otherwise `fallbackImage` (a `NetworkImage`) is used.
    - The image is contained in an `AspectRatio(aspectRatio: 4/5)` and uses `errorBuilder` to render a broken-image placeholder if required.
  - Actions row: Icons for like, comment, send, and save.
  - Likes/caption/time: simple `Text` and `RichText` showing likes and caption text.
  - Ends with a `Divider`.

**Image Load Test:**
- `_testImageProvider(BuildContext, ImageProvider)` — asynchronous helper that resolves an `ImageProvider` to an `ImageStream` and returns `true` if it loads successfully, or `false` on error. `PostWidget` uses this to safely attempt an `AssetImage` first and fallback to network if unavailable.

**Bottom Navigation:**
- **`BottomNavBar`** (`StatelessWidget`):
  - Renders a `BottomAppBar` with a row of 5 icons: home, search, add, favorites, and profile.
  - Uses `_NavIcon` for each icon.

- **`_NavIcon`** (private `StatelessWidget`):
  - Props: `icon` (`IconData`) and optional `active` (`bool`) to color the active icon differently.

---

Notes & Customization
- Local image: If you want to show a local post image replace `localPostImage` with your asset filename and add it to `pubspec.yaml` under `assets:`. Example:

```yaml
flutter:
  assets:
    - assets/images/your_post_image.png
```

- To ensure the asset loads, run `flutter pub get` and then `flutter run`.
- The `PostWidget` already contains a fallback network image (`fallbackImage`) so the app will display a network image if the asset isn't present.
- To add multiple posts, duplicate the `PostWidget(...)` call inside the `ListView` under the feed.

---

How to run
- From the project root run:

```powershell
flutter pub get
flutter run
```

Troubleshooting
- If you see a broken image icon, check the `postImageProvider` path and `pubspec.yaml` asset registration.
- On slow networks, image loading may be delayed — the `_testImageProvider` may fall back to the network image depending on asset availability.

Further improvements (suggestions)
- Convert `InstaHomePage` to `StatefulWidget` if you want to manage dynamic state (likes, bookmarked state, etc.).
- Extract more widgets into separate files (e.g., `widgets/post_widget.dart`, `widgets/story_tile.dart`) for better maintainability.
- Add navigation routes and dedicated post/detail screens.

---

If you want, I can:
- Add the local asset to `pubspec.yaml` and commit it.
- Split major widgets into separate files and update imports.
- Add sample multiple posts and mock data.

