import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About CodeSlice"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.heart),
            title: const Text("Made by my lovely Boyfriend"),
            trailing: const Icon(CupertinoIcons.heart),
         ),
        ],
      ),
    );
  }
}
