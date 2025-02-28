import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Controls which subpage is displayed (0 = Appearance, 1 = Notifications, 2 = Help)
  int _selectedIndex = 0;

  // 0 = Low Contrast, 1 = High Contrast, 2 = Dark Mode, 3 = Customize
  int _selectedColorScheme = 0;

  // Dynamic background & text colors to simulate scheme changes
  Color _backgroundColor = const Color(0xFFFFFBEA); // default background
  Color _textColor = Colors.black87;

  // Font style states
  bool _useOpenDyslexic = false; // toggles a pseudo "OpenDyslexic" style
  double _fontSize = 16.0; // slider to adjust font size

  // ------------------------ Notifications States -------------------------
  bool _dailyNotifications = true;
  bool _upcomingTasks = true;
  bool _overdueTasks = false;

  // Pomodoro Timer
  String _pomodoroSound = 'Radar (Default)';

  // ---------------------- Navigation / Build Logic -----------------------
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Applies a color scheme to the background & text
  void _applyColorScheme() {
    switch (_selectedColorScheme) {
      case 0: // Low Contrast
        _backgroundColor = const Color(0xFFFFFBEA); // soft cream
        _textColor = Colors.black87;
        break;
      case 1: // High Contrast
        _backgroundColor = Colors.white;
        _textColor = Colors.black;
        break;
      case 2: // Dark Mode
        _backgroundColor = const Color(0xFF333333); // dark gray
        _textColor = Colors.white;
        break;
      case 3: // Customize
        _backgroundColor = const Color(0xFFFAF8E6); // pale background
        _textColor = Colors.brown;
        break;
    }
  }

  // -------------------------- Subpage Widgets ---------------------------
  Widget _buildAppearanceSubpage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      // DefaultTextStyle to propagate text color & font size
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: _fontSize,
          color: _textColor,
          // For real apps, load the actual OpenDyslexic font. Here, just italic:
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

            // Color Scheme
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
                      _applyColorScheme();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 111, 104),
                    foregroundColor: Colors.white, // make text white
                  ),
                  child: const Text('Low Contrast'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedColorScheme = 1;
                      _applyColorScheme();
                    });
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
                      _applyColorScheme();
                    });
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
                      _applyColorScheme();
                    });
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

            // Font Style
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

            // Font Size
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

            // Daily Notifications
            SwitchListTile(
              title: const Text('Daily Notifications'),
              subtitle: const Text(
                "You have 3 tasks to work on today. You've got this!",
              ),
              value: _dailyNotifications,
              onChanged: (bool value) {
                setState(() {
                  _dailyNotifications = value;
                });
              },
            ),

            // Schedule
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Schedule',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                // Days of the week
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: const [
                      Chip(label: Text('S')),
                      Chip(label: Text('M')),
                      Chip(label: Text('T')),
                      Chip(label: Text('W')),
                      Chip(label: Text('T')),
                      Chip(label: Text('F')),
                      Chip(label: Text('S')),
                    ],
                  ),
                ),
                // Time picker placeholder
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    // Show time picker logic here
                  },
                ),
                const Text('9:00 AM'),
              ],
            ),
            const Divider(height: 32),

            // Upcoming Tasks
            SwitchListTile(
              title: const Text('Upcoming Tasks'),
              subtitle: const Text(
                "Your task NAME is due in 1 hour. Hang in there!",
              ),
              value: _upcomingTasks,
              onChanged: (bool value) {
                setState(() {
                  _upcomingTasks = value;
                });
              },
            ),

            // Overdue Tasks
            SwitchListTile(
              title: const Text('Overdue Tasks'),
              subtitle: const Text(
                "You have 1 task overdue. It’s okay, you’ll catch up!",
              ),
              value: _overdueTasks,
              onChanged: (bool value) {
                setState(() {
                  _overdueTasks = value;
                });
              },
            ),
            const Divider(height: 32),

            // Pomodoro Timer
            const Text(
              'Pomodoro Timer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Sound: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _pomodoroSound,
                  items: const [
                    DropdownMenuItem(
                      value: 'Radar (Default)',
                      child: Text('Radar (Default)'),
                    ),
                    DropdownMenuItem(
                      value: 'Bulletin',
                      child: Text('Bulletin'),
                    ),
                    DropdownMenuItem(
                      value: 'Chime',
                      child: Text('Chime'),
                    ),
                    DropdownMenuItem(
                      value: 'Sencha',
                      child: Text('Sencha'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _pomodoroSound = value ?? 'Radar (Default)';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Extend Time: '),
                const SizedBox(width: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 5 minutes logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 76, 111, 104),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('5 minutes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // 15 minutes logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 76, 111, 104),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('15 minutes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Custom logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 76, 111, 104),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Custom'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Disabled logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 76, 111, 104),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Disabled'),
                    ),
                  ],
                ),
              ],
            ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Frequently asked questions
            const Text(
              'Frequently asked questions',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Q: Question\nA: Answer\nKeep writing idk'),
            const Divider(height: 32),

            // Help center
            const Text(
              'Help center',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Phone number: .......\nEmail: ......@....'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decide which subpage to display
    Widget currentSubpage;
    switch (_selectedIndex) {
      case 0:
        currentSubpage = _buildAppearanceSubpage();
        break;
      case 1:
        currentSubpage = _buildNotificationsSubpage();
        break;
      case 2:
        currentSubpage = _buildHelpSubpage();
        break;
      default:
        currentSubpage = _buildAppearanceSubpage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 76, 111, 104),
      ),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 200,
            color: const Color(0xFFFAF8E6), // Light background for the sidebar
            child: Column(
              children: [
                _SidebarButton(
                  label: 'Appearance',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                _SidebarButton(
                  label: 'Notifications',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _SidebarButton(
                  label: 'Help',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            // The main content container changes color based on the chosen scheme
            child: Container(
              color: _backgroundColor,
              child: currentSubpage,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
      backgroundColor: Colors.white,
    );
  }
}

/// A simple widget for each sidebar button.
/// It highlights itself when selected.
class _SidebarButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Slight highlight when selected
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        color: isSelected
            ? const Color.fromARGB(255, 76, 111, 104).withOpacity(0.2)
            : Colors.transparent,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? const Color.fromARGB(255, 76, 111, 104)
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 76, 111, 104),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Alarm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outlined),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
