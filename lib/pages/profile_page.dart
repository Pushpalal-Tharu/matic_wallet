import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Color> _colors = const [
    Color(0xFFFAC40F),
    Color(0xFFE67E22),
    Color(0xFF1ABC9C),
    Color(0xFF2ECC71),
    Color(0xFF3498DB),
  ];

  final _containerHeight = 200.0;

  final ScrollController _scrollController = ScrollController();

  int _currentScrollIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colors[1],
        title: const Text("Tap to scroll"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 90,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: index == _currentScrollIndex
                      ? const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        )))
                      : null,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                height: _containerHeight,
                color: _colors[index],
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 100,
                    color: Colors.black45,
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
