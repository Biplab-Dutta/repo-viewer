import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/auth/application/auth_state.dart';
import 'package:repo_viewer/features/auth/shared/providers.dart';
import 'package:repo_viewer/l10n/l10n.dart';
import 'package:repo_viewer/routes/app_router.gr.dart';

final initializationProvider = FutureProvider<void>((ref) async {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();
});

class App extends ConsumerWidget {
  App({Key? key}) : super(key: key);

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(initializationProvider)
      ..listen<AuthState>(
        authNotifierProvider,
        (_, state) {
          state.maybeWhen(
            authenticated: () {
              appRouter.pushAndPopUntil<bool>(
                const StarredReposRoute(),
                predicate: (_) => false,
              );
            },
            unauthenticated: () {
              appRouter.pushAndPopUntil<bool>(
                const SignInRoute(),
                predicate: (_) => false,
              );
            },
            orElse: () {},
          );
        },
      );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Repo Viewer',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
