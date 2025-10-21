import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';

class CommonErrorWidget extends StatelessWidget {
  final String title;
  final String? details;
  final VoidCallback? onRetry;

  const CommonErrorWidget({
    super.key,
    this.title = 'Something went wrong',
    this.details,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (details != null) ...[
              const SizedBox(height: 4),
              Text(details!, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
