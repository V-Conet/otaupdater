import 'package:flutter/material.dart';
import 'package:otaupdater/src/rust/api/status.dart';

class UpdateButton extends StatelessWidget {
  final UpdateButtStatus status;
  final double progress;
  final VoidCallback? onPressed;

  const UpdateButton({
    super.key,
    required this.status,
    this.progress = 0,
    this.onPressed,
  });

  ButtonStyle _buttonStyle(BuildContext context) => ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case UpdateButtStatus.downloading:
        return _DownloadingButton(
          progress: progress,
          style: _buttonStyle(context),
        );

      case UpdateButtStatus.noUpdate:
        return ElevatedButton(
          onPressed: onPressed,
          style: _buttonStyle(context),
          child: const Text("No Update Available"),
        );

      case UpdateButtStatus.updateAvailable:
        return ElevatedButton(
          onPressed: onPressed,
          style: _buttonStyle(context),
          child: const Text("Download Update"),
        );

      case UpdateButtStatus.readyToInstall:
        return ElevatedButton(
          onPressed: onPressed,
          style: _buttonStyle(context),
          child: const Text("Install Update"),
        );
    }
  }
}

class _DownloadingButton extends StatelessWidget {
  final double progress;
  final ButtonStyle style;

  const _DownloadingButton({required this.progress, required this.style});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = style.foregroundColor?.resolve({}) ?? scheme.onPrimary;

    return SizedBox(
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景轨道
            Container(color: scheme.primary.withAlpha(128)),

            // 进度填充
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: Container(color: scheme.primary),
            ),

            // 进度文字
            Center(
              child: Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
