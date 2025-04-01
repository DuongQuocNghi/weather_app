import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/features/home/home_page.dart';
import 'package:weather_app/i18n/app_localizations.dart';

import 'core/constants/local.dart';

void main() async {
  runApp(MaterialApp.router(
    title: appName,
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  ));
}

/// This handles deepLink.
final router = GoRouter(
  errorBuilder: (_, __) => const HomePage(),
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
      routes: [
        GoRoute(
          path: 'details/:data',
          builder: (context, state) {
            // demo: https://example.com/details/123
            var data = state.pathParameters['data'];
            return HomePage();
          },
        ),
      ],
    ),
  ],
);
