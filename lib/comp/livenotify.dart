import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';

class StaticLiveActivityPage extends StatefulWidget {
  const StaticLiveActivityPage({super.key});

  @override
  State<StaticLiveActivityPage> createState() => _StaticLiveActivityPageState();
}

class _StaticLiveActivityPageState extends State<StaticLiveActivityPage> {
  final LiveActivities _liveActivities = LiveActivities();

  String? _activityId;

  @override
  void initState() {
    super.initState();
    _initLiveActivities();
  }

  Future<void> _initLiveActivities() async {
    await _liveActivities.init(
      appGroupId: 'group.top.vconet.otaupdater',
      requestAndroidNotificationPermission: true,
    );
  }

  Future<void> _startStaticActivity() async {
    final id = await _liveActivities.createActivity(
      {
        "title": "Downloading update.zip",
        "progress": 37,
        "eta": "5 min",
      },
    );

    setState(() {
      _activityId = id;
    });
  }

  Future<void> _updateOnce() async {
    if (_activityId == null) return;

    await _liveActivities.updateActivity(
      _activityId!,
      {
        "title": "Downloading update.zip",
        "progress": 78,
        "eta": "2 min",
      },
    );
  }

  Future<void> _endActivity() async {
    if (_activityId == null) return;

    await _liveActivities.endActivity(_activityId!);

    setState(() {
      _activityId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Static Live Activity"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _startStaticActivity,
              child: const Text("Start Activity"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _updateOnce,
              child: const Text("Update Once"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _endActivity,
              child: const Text("End Activity"),
            ),
            const SizedBox(height: 24),
            Text(
              _activityId == null
                  ? "No active activity"
                  : "Activity ID: $_activityId",
            ),
          ],
        ),
      ),
    );
  }
}