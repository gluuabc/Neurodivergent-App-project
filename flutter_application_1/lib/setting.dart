import 'package:flutter/material.dart';
import 'bar.dart';

class FifthRoute extends StatelessWidget {
  const FifthRoute({super.key, required this.appTitle});

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const Center(
        child: Text(
          'SETTING',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 4),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  int _selectedColorScheme = 0;
  Color _backgroundColor = const Color(0xFFFFFBEA);
  Color _textColor = Colors.black87;
  bool _useOpenDyslexic = false;
  double _fontSize = 16.0;
  bool _dailyNotifications = true;
  bool _upcomingTasks = true;
  bool _overdueTasks = false;
  String _pomodoroSound = 'Radar (Default)';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _applyColorScheme() {
    setState(() {
      switch (_selectedColorScheme) {
        case 0:
          _backgroundColor = const Color(0xFFFFFBEA);
          _textColor = Colors.black87;
          break;
        case 1:
          _backgroundColor = Colors.white;
          _textColor = Colors.black;
          break;
        case 2:
          _backgroundColor = const Color(0xFF333333);
          _textColor = Colors.white;
          break;
        case 3:
          _backgroundColor = const Color(0xFFFAF8E6);
          _textColor = Colors.brown;
          break;
      }
    });
  }

  Widget _buildAppearanceSubpage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: _fontSize,
          color: _textColor,
          fontStyle: _useOpenDyslexic ? FontStyle.italic : FontStyle.normal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Color Scheme',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedColorScheme = 0;
                    });
                    _applyColorScheme();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Low Contrast'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedColorScheme = 1;
                    });
                    _applyColorScheme();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('High Contrast'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedColorScheme = 2;
                    });
                    _applyColorScheme();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Dark Mode'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedColorScheme = 3;
                    });
                    _applyColorScheme();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Customize'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Font Style',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _useOpenDyslexic = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Default'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _useOpenDyslexic = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('OpenDyslexic'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Font Size',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _fontSize,
              min: 9,
              max: 30,
              divisions: 9,
              label: '${_fontSize.round()}',
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSubpage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: _fontSize,
          color: _textColor,
          fontStyle: _useOpenDyslexic ? FontStyle.italic : FontStyle.normal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Daily Notifications'),
              value: _dailyNotifications,
              onChanged: (bool value) {
                setState(() {
                  _dailyNotifications = value;
                });
              },
            ),
            const Divider(height: 32),
            SwitchListTile(
              title: const Text('Upcoming Tasks'),
              value: _upcomingTasks,
              onChanged: (bool value) {
                setState(() {
                  _upcomingTasks = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Overdue Tasks'),
              value: _overdueTasks,
              onChanged: (bool value) {
                setState(() {
                  _overdueTasks = value;
                });
              },
            ),
            const Divider(height: 32),
            const Text(
              'Pomodoro Timer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            DropdownButton<String>(
              value: _pomodoroSound,
              items: const [
                DropdownMenuItem(value: 'Radar (Default)', child: Text('Radar (Default)')),
                DropdownMenuItem(value: 'Bulletin', child: Text('Bulletin')),
                DropdownMenuItem(value: 'Chime', child: Text('Chime')),
                DropdownMenuItem(value: 'Sencha', child: Text('Sencha')),
              ],
              onChanged: (value) {
                setState(() {
                  _pomodoroSound = value ?? 'Radar (Default)';
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSubpage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: _fontSize,
          color: _textColor,
          fontStyle: _useOpenDyslexic ? FontStyle.italic : FontStyle.normal,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Q: Question\nA: Answer\nKeep writing idk'),
            Divider(height: 32),
            Text('Phone number: .......\nEmail: ......@....'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subpages = [
      _buildAppearanceSubpage(),
      _buildNotificationsSubpage(),
      _buildHelpSubpage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: subpages[_selectedIndex],
      bottomNavigationBar: CustomBottomBar(currentIndex: _selectedIndex),
    );
  }
}



