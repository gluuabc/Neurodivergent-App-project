import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        child: SettingsPage(),
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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedColorScheme = prefs.getInt('colorScheme') ?? 0;
      _useOpenDyslexic = prefs.getBool('useOpenDyslexic') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _dailyNotifications = prefs.getBool('dailyNotifications') ?? true;
      _upcomingTasks = prefs.getBool('upcomingTasks') ?? true;
      _overdueTasks = prefs.getBool('overdueTasks') ?? false;
      _pomodoroSound = prefs.getString('pomodoroSound') ?? 'Radar (Default)';
    });
    _applyColorScheme();
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
    return _buildSettingsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Appearance'),
          _buildSubTitle('Color Scheme'),
          _buildColorSchemeButtons(),
          _buildSubTitle('Font Style'),
          _buildFontStyleButtons(),
          _buildSubTitle('Font Size'),
          _buildFontSizeSlider(),
        ],
      ),
    );
  }

  Widget _buildColorSchemeButtons() {
    final schemes = ['Low Contrast', 'High Contrast', 'Dark Mode', 'Customize'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(schemes.length, (index) {
        return ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedColorScheme = index;
            });
            _applyColorScheme();
          },
          style: _buttonStyle,
          child: Text(schemes[index]),
        );
      }),
    );
  }

  Widget _buildFontStyleButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _useOpenDyslexic = false;
            });
          },
          style: _buttonStyle,
          child: const Text('Default'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _useOpenDyslexic = true;
            });
          },
          style: _buttonStyle,
          child: const Text('OpenDyslexic'),
        ),
      ],
    );
  }

  Widget _buildFontSizeSlider() {
    return Slider(
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
    );
  }

  Widget _buildNotificationsSubpage() {
    return _buildSettingsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Notifications'),
          _buildSwitch('Daily Notifications', _dailyNotifications, (value) {
            setState(() => _dailyNotifications = value);
          }),
          _buildSwitch('Upcoming Tasks', _upcomingTasks, (value) {
            setState(() => _upcomingTasks = value);
          }),
          _buildSwitch('Overdue Tasks', _overdueTasks, (value) {
            setState(() => _overdueTasks = value);
          }),
        ],
      ),
    );
  }

  Widget _buildHelpSubpage() {
    return _buildSettingsContainer(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Help', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Q: Question\nA: Answer'),
          Divider(height: 32),
          Text('Phone number: .......\nEmail: ......@....'),
        ],
      ),
    );
  }

  Widget _buildSettingsContainer({required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: _fontSize,
          color: _textColor,
          fontFamily: _useOpenDyslexic ? 'OpenDyslexic' : null,
        ),
        child: child,
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildSubTitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
    foregroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final subpages = [_buildAppearanceSubpage(), _buildNotificationsSubpage(), _buildHelpSubpage()];
    return Scaffold(
      body: subpages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: 'Appearance'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
        ],
      ),
    );
  }
}
