import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(InstaCloneApp());

class InstaCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insta UI Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: InstaHomePage(),
    );
  }
}

class InstaHomePage extends StatelessWidget {
  // Replace with your local asset path if you added the uploaded image to assets
  final String localPostImage = 'assets/images/your_post_image.png';

  // Fallback network image (Unsplash) if local asset missing
  final String networkPostImage =
      'https://images.unsplash.com/photo-1549880338-65ddcdfd017b?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.0.3&s=9b6d1e8f4c6c7d0b44a1a0b6b8f2c0b0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stories
          Container(
            height: 110,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                _MyStoryTile(),
                SizedBox(width: 8),
                StoryTile(name: 'john.jake7', imageUrl: _sampleAvatar(1)),
                StoryTile(name: 'ching.wang', imageUrl: _sampleAvatar(2)),
                StoryTile(name: 'dj.jakal', imageUrl: _sampleAvatar(3)),
                StoryTile(name: 'kriss.kill', imageUrl: _sampleAvatar(4)),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey[300]),

          // Feed (single post for this clone)
          Expanded(
            child: ListView(
              children: [
                PostWidget(
                  username: 'wanjiru.sarah',
                  avatarUrl: _sampleAvatar(5),
                  location: 'Unknown',
                  // If you added a local asset use: Image.asset(localPostImage)
                  postImageProvider: AssetImage(localPostImage),
                  // If local asset not present, fallback to NetworkImage:
                  fallbackImage: NetworkImage(networkPostImage),
                ),
                // Add more PostWidget() for multiple posts...
              ],
            ),
          ),
        ],
      ),

      // bottom navigation bar
      bottomNavigationBar: BottomNavBar(),
    );
  }

  // Simple avatar provider generator (Unsplash)
  String _sampleAvatar(int seed) =>
      'https://i.pravatar.cc/150?img=${10 + seed}';
}

class _MyStoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(radius: 36, backgroundColor: Colors.grey[300]),
            Positioned(
              bottom: 0,
              right: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            'your story',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class StoryTile extends StatelessWidget {
  final String name;
  final String imageUrl;

  const StoryTile({Key? key, required this.name, required this.imageUrl})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      margin: EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.pink, Colors.purple],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 34,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String location;
  final ImageProvider postImageProvider;
  final ImageProvider fallbackImage;

  const PostWidget({
    Key? key,
    required this.username,
    required this.avatarUrl,
    required this.location,
    required this.postImageProvider,
    required this.fallbackImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to try load the asset; if it fails, switch to network fallback.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          title: Text(username, style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(location, style: TextStyle(fontSize: 12)),
          trailing: Icon(Icons.more_vert),
        ),

        // Post image with safe fallback
        Builder(
          builder: (context) {
            // Attempt to paint provided ImageProvider inside a fixed aspect ratio.
            return FutureBuilder(
              future: _testImageProvider(context, postImageProvider),
              builder: (context, snapshot) {
                final ImageProvider imageToShow =
                    (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data == true)
                    ? postImageProvider
                    : fallbackImage;

                return AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Image(
                    image: imageToShow,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),

        // Action row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
              IconButton(icon: Icon(Icons.send_outlined), onPressed: () {}),
              Spacer(),
              IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
            ],
          ),
        ),

        // Likes and caption area
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1,024 likes',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: '  A wonderful evening at the fair...'),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Text('2 hours ago', style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 12),
            ],
          ),
        ),

        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  // Try to resolve the image provider (use ImageStreamListener to detect failures)
  Future<bool> _testImageProvider(
    BuildContext context,
    ImageProvider provider,
  ) async {
    final completer = Completer<bool>();
    final ImageStream stream = provider.resolve(
      ImageConfiguration(devicePixelRatio: 1.0),
    );
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        completer.complete(true);
        stream.removeListener(listener);
      },
      onError: (err, stack) {
        completer.complete(false);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
    return completer.future;
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 8,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIcon(icon: Icons.home_filled, active: true),
            _NavIcon(icon: Icons.search),
            _NavIcon(icon: Icons.add_box_outlined),
            _NavIcon(icon: Icons.favorite_border),
            _NavIcon(icon: Icons.person_outline),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _NavIcon({Key? key, required this.icon, this.active = false})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: active ? Colors.black : Colors.grey[700]),
      onPressed: () {},
    );
  }
}
