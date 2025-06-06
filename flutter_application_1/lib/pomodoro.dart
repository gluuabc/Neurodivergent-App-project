import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'bar.dart';
import 'alarm_provider.dart';

class Alarm {
  String name;
  List<SubAlarm> subAlarms;
  String audioFile;
  Alarm({
    required this.name,
    required this.subAlarms,
    required this.audioFile
  });

  // used in AlarmStorage class
  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        name: json['name'],
        subAlarms: (json['subAlarms'] as List<dynamic>)
            .map((e) => SubAlarm.fromJson(e))
            .toList(),
        audioFile: json['audioFile']
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'subAlarms': subAlarms.map((e) => e.toJson()).toList(),
        'audioFile': audioFile
      };
}

class SubAlarm {
  String name;
  Duration duration;

  SubAlarm({
    required this.name,
    required this.duration
  });

  // used in AlarmStorage class
  factory SubAlarm.fromJson(Map<String, dynamic> json) => SubAlarm(
        name: json['name'],
        duration: Duration(seconds: json['duration']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'duration': duration.inSeconds,
      };
}

class PomodoroRoute extends StatefulWidget {
  final String appTitle;
  const PomodoroRoute({super.key, required this.appTitle});
  @override
  _PomodoroRouteState createState() => _PomodoroRouteState();
}

class _PomodoroRouteState extends State<PomodoroRoute> {
  Alarm? _currentAlarm;
  SubAlarm? _currentSub;
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<bool>? _playSub;
  Timer? _timer;

  List<Alarm> get _alarms => Provider.of<AlarmProvider>(context, listen: false).alarms;

  bool _isRunning = false;
  bool _audioPlaying = false;
  Duration _remaining = Duration.zero;
  int _segIndex = 0;

  @override
  void initState() {
    super.initState();
    // watch audio state so we can show “Stop Alarm”
    _playSub = _player.playingStream.listen((playing) {
      setState(() => _audioPlaying = playing);
    });
  }

  // reset function
  @override
  void dispose() {
    _timer?.cancel();
    _playSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _startPause() {
    final alarmProvider = context.read<AlarmProvider>();
    final currentSub = alarmProvider.currentSub;

    // check current subalarm is valid
    if (currentSub == null) return;

    if (alarmProvider.isRunning) {
      _timer?.cancel();
      alarmProvider.pause();
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // check if timer is still going
      if (alarmProvider.remaining > Duration.zero) {
        alarmProvider.decrementRemaining(const Duration(seconds: 1));
        return;
      }
      
      // stop timer at 0s 
      _timer?.cancel();
      alarmProvider.pause();

      final currentAlarm = alarmProvider.currentAlarm;
      if (currentAlarm == null) return;

      // play sound on end
      _player
          .setAsset(currentAlarm.audioFile)
          .then((_) => _player.play())
          .catchError((_) {});

      // continue to next segment (work/break)
      alarmProvider.advanceSegment();
    });

    alarmProvider.start();
  }

  // user taps on one of the saved alarms
  void _selectAlarm(int i) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    final a = alarmProvider.alarms[i];

    _timer?.cancel();
    _player.stop();

    alarmProvider.setCurrentAlarm(a);
    
    // reset segment index and player state
    setState(() {
      _currentAlarm = a;
      _segIndex = 0;
      _currentSub = a.subAlarms.isNotEmpty ? a.subAlarms.first : null;
      _remaining = _currentSub?.duration ?? Duration.zero;
      _isRunning = false;
    });
  }

  // push create/edit form and await back a new Alarm
  Future<void> _pushForm({Alarm? existing, int? idx}) async {
    final got = await Navigator.push<Alarm>(
      context,
      MaterialPageRoute(builder: (_) => AlarmFormPage(alarm: existing)),
    );
    if (got == null) return;

    // use provider for data storage
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    setState(() {
      if (idx == null) {
        alarmProvider.addAlarm(got);
      } else {
        alarmProvider.updateAlarm(idx, got);
        // if they edited the currently-running alarm, re-select it
        if (existing == _currentAlarm) _selectAlarm(idx);
      }
    });
  }

  void _deleteAlarm(int i) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    // check if deleted alarm is currently active -> then stop
    if (alarmProvider.currentAlarm == alarmProvider.alarms[i]) {
      _timer?.cancel();
      _player.stop();
    }
    alarmProvider.deleteAlarm(i);
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = context.watch<AlarmProvider>();
    final remaining = alarmProvider.remaining;
    final isRunning = alarmProvider.isRunning;
    final currentAlarm = alarmProvider.currentAlarm;
    final currentSub = alarmProvider.currentSub;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // ── Alarm List ─────────────────────────────
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: alarmProvider.alarms.length,
              itemBuilder: (_, i) {
                final a = alarmProvider.alarms[i];
                return ListTile(
                  title: Text(a.name),
                  subtitle: Text('${a.subAlarms.length} segment(s)'),
                  onTap: () => _selectAlarm(i),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _pushForm(existing: a, idx: i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteAlarm(i),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // ── Active Timer ────────────────────────
          if (currentAlarm == null)
            const Expanded(
              flex: 3,
              child: Center(
                child: Text('No alarm selected.\nTap “Create” below.',
                    textAlign: TextAlign.center),
              ),
            )
          else
            Expanded(
              flex: 3,
              child: Column(children: [
                Text('Alarm: ${currentAlarm.name}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text('Segment: ${currentSub?.name ?? "---"}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  '${remaining.inHours.toString().padLeft(2, '0')}:'
                  '${remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
                  '${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startPause,
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),

                // “Stop” button shows only while audio is playing
                if (_audioPlaying)
                  TextButton(
                    onPressed: () => _player.stop(),
                    child: const Text('Stop Alarm',
                        style: TextStyle(color: Colors.red)),
                  ),
              ]),
            ),

          // ── Create / Edit Button ───────────────
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create / Edit Alarm'),
            onPressed: () => _pushForm(),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
          ),
        ]),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }
}

/// full-featured alarm form
class AlarmFormPage extends StatefulWidget {
  final Alarm? alarm;
  const AlarmFormPage({super.key, this.alarm});
  @override
  _AlarmFormPageState createState() => _AlarmFormPageState();
}

class _AlarmFormPageState extends State<AlarmFormPage> {
  final _nameCtrl = TextEditingController();
  final _segName = <TextEditingController>[];
  final _hr = <TextEditingController>[];
  final _min = <TextEditingController>[];
  final _sec = <TextEditingController>[];

  List<String> _tracks = [];
  String? _selectedTrack;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks().then((_) {
      // load data as long as not empty
      if (widget.alarm != null) _populate(widget.alarm!);
      setState(() => _loading = false);
    });
  }

  // load audio files
  Future<void> _loadTracks() async {
    final manifest =
        json.decode(await rootBundle.loadString('AssetManifest.json'))
            as Map<String, dynamic>;
    _tracks = manifest.keys
        .where((p) =>
            p.startsWith('lib/assets/audio/alarms/') &&
            (p.endsWith('.mp3') || p.endsWith('.wav')))
        .toList()
      ..sort();
    _selectedTrack =
        widget.alarm?.audioFile ?? (_tracks.isNotEmpty ? _tracks.first : null);
  }

  // load data for alarm
  void _populate(Alarm a) {
    _nameCtrl.text = a.name;
    for (final s in a.subAlarms) {
      _segName.add(TextEditingController(text: s.name));
      _hr.add(TextEditingController(text: s.duration.inHours.toString()));
      _min.add(TextEditingController(
          text: s.duration.inMinutes.remainder(60).toString()));
      _sec.add(TextEditingController(
          text: s.duration.inSeconds.remainder(60).toString()));
    }
  }

  // break alarm into segments (work/break)
  void _addSeg() {
    setState(() {
      _segName.add(TextEditingController());
      _hr.add(TextEditingController(text: '0'));
      _min.add(TextEditingController(text: '0'));
      _sec.add(TextEditingController(text: '0'));
    });
  }

  void _removeSeg(int i) {
    setState(() {
      _segName.removeAt(i);
      _hr.removeAt(i);
      _min.removeAt(i);
      _sec.removeAt(i);
    });
  }

  void _save() {
    final n = _nameCtrl.text.trim();
    if (n.isEmpty || _segName.isEmpty || _selectedTrack == null) return;

    final subs = <SubAlarm>[];
    for (var i = 0; i < _segName.length; i++) {
      final hh = int.tryParse(_hr[i].text) ?? 0;
      final mm = int.tryParse(_min[i].text) ?? 0;
      final ss = int.tryParse(_sec[i].text) ?? 0;
      subs.add(SubAlarm(
          name: _segName[i].text.trim(),
          duration: Duration(hours: hh, minutes: mm, seconds: ss)));
    }

    Navigator.pop(
        context, Alarm(name: n, subAlarms: subs, audioFile: _selectedTrack!));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // display alarms as widget
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.alarm == null
              ? 'Create Pomodoro Alarm'
              : 'Edit Pomodoro Alarm')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Alarm Name'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Alarm Sound'),
            value: _selectedTrack,
            items: _tracks
                .map((p) =>
                    DropdownMenuItem(value: p, child: Text(p.split('/').last)))
                .toList(),
            onChanged: (v) => setState(() => _selectedTrack = v),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Segments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add), onPressed: _addSeg),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _segName.length,
              itemBuilder: (_, i) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _segName[i],
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _numField(_hr[i], 'H'),
                      const SizedBox(width: 4),
                      _numField(_min[i], 'M'),
                      const SizedBox(width: 4),
                      _numField(_sec[i], 'S'),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeSeg(i)),
                    ]),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
            child: const Text('Save Alarm'),
          ),
        ]),
      ),
    );
  }

  Widget _numField(TextEditingController c, String label) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
