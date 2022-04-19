import 'package:auto_route/auto_route.dart';
import 'package:repo_viewer/features/auth/presentation/pages/authorization_page.dart';
import 'package:repo_viewer/features/auth/presentation/pages/sign_in_page.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/presentation/pages/starred_repos_page.dart';
import 'package:repo_viewer/features/splash/presentation/splash_page.dart';

@MaterialAutoRouter(
  routes: [
    AutoRoute<bool>(page: SplashPage, initial: true),
    AutoRoute<bool>(page: SignInPage, path: '/sign-in'),
    AutoRoute<bool>(page: AuthorizationPage, path: '/auth'),
    AutoRoute<bool>(page: StarredReposPage, path: '/starred')
  ],
  replaceInRouteName: 'Page,Route',
)
class $AppRouter {}
