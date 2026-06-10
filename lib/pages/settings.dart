import 'package:flutter/material.dart';
import 'package:otaupdater/comp/debug.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Software Update Settings
  bool _networkEnabled = true;
  bool _builtinDMEnabled = false;

  // Other stuff:
  // Clear Application data
  // OpenSource Licenses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("General"),
            tiles: [
              SettingsTile.switchTile(
                leading: const Icon(Icons.public_outlined),
                title: const Text("Enable Network Access"),
                description: const Text(
                  "Allow this application to check for PortRom updates.",
                ),
                initialValue: _networkEnabled,
                onToggle: (v) {
                  setState(() => _networkEnabled = v);

                  PrintDebugInfo.show(context, "切换网络访问：${v ? "启用" : "禁用"}");
                },
              ),
              SettingsTile.switchTile(
                leading: const Icon(Icons.file_download_outlined),
                title: const Text("Use builtin Downloader"),
                description: const Text(
                  "Use the builtin Downloader instead of the system Download Manager.",
                ),
                initialValue: _builtinDMEnabled,
                onToggle: (v) {
                  setState(() => _builtinDMEnabled = v);

                  PrintDebugInfo.show(
                    context,
                    "切换下载器：${v ? "内置下载器" : "系统下载器"}",
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text("Other"),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text("Clear Application Data"),
                description: const Text(
                  "This may fix some download-related issues.",
                ),
                onPressed: (context) {
                  
                  PrintDebugInfo.show(context, "清除应用数据");
                },
              ),
              SettingsTile(
                //opensource licenses icon
                leading: const Icon(Icons.attribution_outlined),
                title: const Text("Open Source Licenses"),
                onPressed: (context) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LicensePage(
                      applicationName: "OTA Updater",
                      applicationVersion: "1.0.0",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
