import 'package:flutter/material.dart';
import 'stateful_text_field.dart';

export 'stateful_text_field.dart';

class ZoneCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const ZoneCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class ModernZoneCard extends StatelessWidget {
  final String title;
  final String? emoji;
  final IconData? icon;
  final Color color;
  final Widget child;
  final double? progress; // 0.0 to 1.0

  const ModernZoneCard({
    super.key,
    required this.title,
    this.emoji,
    this.icon,
    required this.color,
    required this.child,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (emoji != null) ...[
                  Text(emoji!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 8),
                ] else if (icon != null) ...[
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                if (progress != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        backgroundColor: color.withValues(alpha: 0.1),
                        color: color,
                        strokeWidth: 4,
                      ),
                      Text(
                        '${(progress! * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (progress != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.1),
                  color: color,
                  minHeight: 6,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class DailyProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int points;
  final String label;

  const DailyProgressIndicator({
    super.key,
    required this.progress,
    required this.points,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$points',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class InteractiveActionCard extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final String label;
  final bool isChecked;
  final VoidCallback onTap;
  final Color color;
  final double? width;

  const InteractiveActionCard({
    super.key,
    this.emoji,
    this.icon,
    required this.label,
    required this.isChecked,
    required this.onTap,
    required this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isChecked ? color.withValues(alpha: 0.3) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isChecked ? color : Colors.grey.shade300,
            width: 3,
          ),
          boxShadow: isChecked
              ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2)]
              : null,
        ),
        child: Column(
          children: [
            if (emoji != null)
              Text(emoji!, style: const TextStyle(fontSize: 40))
            else if (icon != null)
              Icon(icon, size: 40, color: isChecked ? color : Colors.grey),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isChecked ? color : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            if (isChecked)
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
          ],
        ),
      ),
    );
  }
}
