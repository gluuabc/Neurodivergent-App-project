import 'dart:convert'; // ← NEW
import 'package:flutter/services.dart' show rootBundle; // ← NEW
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bar.dart';
import 'package:just_audio/just_audio.dart';

class FifthRoute extends StatelessWidget {
  const FifthRoute({super.key, required this.appTitle});
  final String appTitle;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(appTitle)),
        body: const Center(child: SettingsPage()),
        bottomNavigationBar: const CustomBottomBar(currentIndex: 4),
      );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
/* ─── existing visual-preference fields ─────────────────────────────── */
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

/* ─── Background Image fields ────────────────────────────────────────── */
  String _selectedBackgroundImage =
      'lib/assets/images/GreenBlue1.jpg'; // Default image

/* ─── AUDIO fields ─────────────────────────────────────────────────── */
  late final AudioPlayer _player;
  bool _isPlaying = false;

  /// Auto-populated at runtime from AssetManifest.
  final List<Map<String, String>> _tracks = [];
  String _currentTrackFile = '';

  List<String> _backgroundImages = [
    'None', // Option for no background image
    'lib/assets/images/GreenBlue1.jpg',
    'lib/assets/images/GreenBlue2.jpg',
    'lib/assets/images/GreenBlue3.jpg',
    'lib/assets/images/GreenBlue4.jpg',
    'lib/assets/images/GreenBlue5.jpg'
  ];

  String _currentBackgroundImage = ''; // To track the selected background image

  // RGB values for custom background color
  int _customRed = 74, _customGreen = 107, _customBlue = 146;

  // Font style variables
  String _selectedFontFamily = 'Roboto'; // Default font
  final List<String> _fontFamilies = [
    'Roboto',
    'Serif',
    'Monospace',
    'OpenDyslexic'
  ];

/* ─── lifecycle ─────────────────────────────────────────────────────── */
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    // keep UI synced with actual playback state
    _player.playingStream.listen((playing) {
      if (mounted) setState(() => _isPlaying = playing);
    });

    _initTrackList(); // ← NEW: build dropdown list dynamically
    _loadSettings();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

/* ─── discover .mp3 assets dynamically ─────────────────────────────── */
  Future<void> _initTrackList() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = jsonDecode(manifestJson);

    final audioPaths = manifest.keys
        .where((p) => p.startsWith('lib/assets/audio/') && p.endsWith('.mp3'))
        .toList()
      ..sort(); // optional: alphabetical

    setState(() {
      _tracks
        ..clear()
        ..addAll(audioPaths.map((path) => {
              'label': path.split('/').last.replaceAll('.mp3', ''),
              'file': path,
            }));
      if (_tracks.isNotEmpty) {
        _currentTrackFile = _tracks.first['file']!;
      }
    });
  }

/* ─── prefs loader (unchanged) ─────────────────────────────────────── */
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
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

/* ─── audio control ─────────────────────────────────────────────────── */
  Future<void> _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      if (_currentTrackFile.isEmpty) return; // guard if no asset yet
      setState(() => _isPlaying = true); // instant feedback

      if (_player.position == Duration.zero) {
        await _player.setAsset(_currentTrackFile); // Start from beginning
      } else {
        await _player.seek(_player.position); // Continue from current position
      }
      await _player.setLoopMode(LoopMode.one);
      await _player.play();
    }
  }

/* ─── UI helpers (appearance etc.) – only audio section is new ─────── */
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
          _backgroundColor =
              Color.fromARGB(255, _customRed, _customGreen, _customBlue);
          _textColor = (_customRed + _customGreen + _customBlue > 382)
              ? Colors.black
              : Colors.white; // Brightness check
          break;
      }
    });
  }

  // Predefined color schemes
  void _applyPredefinedColorScheme(int red, int green, int blue) {
    setState(() {
      _customRed = red;
      _customGreen = green;
      _customBlue = blue;
      _applyColorScheme();
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
          const Divider(height: 32),
          _buildSectionTitle('Background Image'),
          _buildSubTitle('Choose Image'),
          _backgroundImageDropdown(), // Add dropdown to select image
          const Divider(height: 32),
          _buildSectionTitle('Background Color'),
          _buildSubTitle('Customize RGB'),
          _buildRGBSliders(), // RGB sliders
          const Divider(height: 32),
          _buildSectionTitle('Predefined Colors'),
          _buildPredefinedColorButtons(), // Buttons for predefined color schemes
          const Divider(height: 32),
          _buildSectionTitle('Background Music'),
          if (_tracks.isEmpty) const Text('No audio assets found.'),
          if (_tracks.isNotEmpty) ...[
            _buildSubTitle('Choose Track'),
            _audioDropdown(),
            const SizedBox(height: 16),
            _playPauseButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildColorSchemeButtons() {
    final schemes = ['Low Contrast', 'High Contrast', 'Dark Mode', 'Customize'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
          schemes.length,
          (i) => ElevatedButton(
                onPressed: () {
                  setState(() => _selectedColorScheme = i);
                  _applyColorScheme();
                },
                style: _buttonStyle,
                child: Text(schemes[i]),
              )),
    );
  }

  Widget _buildFontStyleButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
            onPressed: () => setState(() {
                  _selectedFontFamily = 'Roboto'; // Default font
                  _useOpenDyslexic = false;
                }),
            style: _buttonStyle,
            child: const Text('Roboto')),
        ElevatedButton(
            onPressed: () => setState(() {
                  _selectedFontFamily = 'OpenDyslexic'; // OpenDyslexic font
                  _useOpenDyslexic = true;
                }),
            style: _buttonStyle,
            child: const Text('OpenDyslexic')),
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
      onChanged: (v) => setState(() => _fontSize = v),
    );
  }

  Widget _backgroundImageDropdown() {
    return DropdownButton<String>(
      value: _currentBackgroundImage.isEmpty ? null : _currentBackgroundImage,
      items: _backgroundImages.map((image) {
        return DropdownMenuItem<String>(
          value: image,
          child: Text(image.split('/').last), // Display image name
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _currentBackgroundImage = val ?? '';
        });
      },
    );
  }

  Widget _buildRGBSliders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Red: $_customRed'),
        Slider(
          value: _customRed.toDouble(),
          min: 0,
          max: 255,
          divisions: 255,
          label: '$_customRed',
          onChanged: (value) {
            setState(() {
              _customRed = value.toInt();
              _applyColorScheme();
            });
          },
        ),
        Text('Green: $_customGreen'),
        Slider(
          value: _customGreen.toDouble(),
          min: 0,
          max: 255,
          divisions: 255,
          label: '$_customGreen',
          onChanged: (value) {
            setState(() {
              _customGreen = value.toInt();
              _applyColorScheme();
            });
          },
        ),
        Text('Blue: $_customBlue'),
        Slider(
          value: _customBlue.toDouble(),
          min: 0,
          max: 255,
          divisions: 255,
          label: '$_customBlue',
          onChanged: (value) {
            setState(() {
              _customBlue = value.toInt();
              _applyColorScheme();
            });
          },
        ),
      ],
    );
  }

  Widget _buildPredefinedColorButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: () => _applyPredefinedColorScheme(255, 99, 71), // Tomato
          style: _buttonStyle,
          child: const Text('Tomato'),
        ),
        ElevatedButton(
          onPressed: () =>
              _applyPredefinedColorScheme(135, 206, 235), // SkyBlue
          style: _buttonStyle,
          child: const Text('SkyBlue'),
        ),
        ElevatedButton(
          onPressed: () =>
              _applyPredefinedColorScheme(255, 223, 186), // Light Peach
          style: _buttonStyle,
          child: const Text('Light Peach'),
        ),
      ],
    );
  }

  Widget _buildNotificationsSubpage() {
    return _buildSettingsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Notifications'),
          _buildSwitch('Daily Notifications', _dailyNotifications,
              (v) => setState(() => _dailyNotifications = v)),
          _buildSwitch('Upcoming Tasks', _upcomingTasks,
              (v) => setState(() => _upcomingTasks = v)),
          _buildSwitch('Overdue Tasks', _overdueTasks,
              (v) => setState(() => _overdueTasks = v)),
        ],
      ),
    );
  }

  Widget _buildHelpSubpage() {
    return _buildSettingsContainer(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Help',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Q: Question\nA: Answer'),
          Divider(height: 32),
          Text('Phone number: .......\nEmail: ......@....'),
        ],
      ),
    );
  }

  Widget _buildSettingsContainer({required Widget child}) =>
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: _fontSize,
            color: _textColor,
            fontFamily: _selectedFontFamily, // Apply selected font
          ),
          child: child,
        ),
      );

  Widget _buildSwitch(String t, bool v, Function(bool) f) =>
      SwitchListTile(title: Text(t), value: v, onChanged: f);

  Widget _buildSectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  Widget _buildSubTitle(String st) => Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Text(st, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
    foregroundColor: Colors.white,
  );

  Widget _audioDropdown() => DropdownButton<String>(
        value: _currentTrackFile,
        items: _tracks
            .map((t) => DropdownMenuItem<String>(
                  value: t['file'],
                  child: Text(t['label']!),
                ))
            .toList(),
        onChanged: (val) async {
          if (val == null) return;
          setState(() => _currentTrackFile = val);
          if (_player.playing) {
            await _player.setAsset(val);
            await _player.play();
          }
        },
      );

  Widget _playPauseButton() => ElevatedButton.icon(
        style: _buttonStyle,
        onPressed: _togglePlay,
        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
        label: Text(_isPlaying ? 'Pause' : 'Play'),
      );

  @override
  Widget build(BuildContext ctx) {
    final subs = [
      _buildAppearanceSubpage(),
      _buildNotificationsSubpage(),
      _buildHelpSubpage(),
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: _currentBackgroundImage.isNotEmpty &&
                  _currentBackgroundImage != 'None'
              ? DecorationImage(
                  image: AssetImage(_currentBackgroundImage),
                  fit: BoxFit
                      .cover, // Ensures the image covers the entire screen
                )
              : null, // No background image
          color: _backgroundColor, // Background color
        ),
        child: subs[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.color_lens), label: 'Appearance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
        ],
      ),
    );
  }
}
