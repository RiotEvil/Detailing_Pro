import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';

import '../core/theme.dart';

/// Shown when encrypted local storage (Hive) cannot be opened at startup.
class StorageStartupErrorApp extends StatelessWidget {
  final String message;

  const StorageStartupErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: _StorageStartupErrorScreen(message: message),
    );
  }
}

class _StorageStartupErrorScreen extends StatelessWidget {
  final String message;

  const _StorageStartupErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.storage_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                l10n.storageStartupTitle,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(l10n.storageStartupBody),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              Text(l10n.storageStartupHint),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Text(l10n.storageStartupCloseApp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
