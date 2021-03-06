import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/auth/shared/providers.dart';
import 'package:repo_viewer/features/github/core/shared/providers.dart';
import 'package:repo_viewer/features/github/repos/core/presentation/widgets/paginated_repos_list_view.dart';
import 'package:repo_viewer/features/search/presentation/search_bar.dart';
import 'package:repo_viewer/routes/app_router.gr.dart';

class StarredReposPage extends ConsumerStatefulWidget {
  const StarredReposPage({super.key});

  @override
  ConsumerState<StarredReposPage> createState() => _StarredReposPageState();
}

class _StarredReposPageState extends ConsumerState<StarredReposPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        ref
            .read(starredReposNotifierProvider.notifier)
            .getNextStarredReposPage();
      },
    );

    // We can also use this:
    // WidgetsBinding.instance?.addPostFrameCallback(
    //   (_) {
    //     ref
    //         .read(starredReposNotifierProvider.notifier)
    //         .getNextStarredReposPage();
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchBar(
        title: 'Starred Repositories',
        hint: 'Search all repositories...',
        onShouldNavigateToResultPage: (searchedTerm) =>
            AutoRouter.of(context).push(
          SearchedReposRoute(searchTerm: searchedTerm),
        ),
        body: PaginatedReposListView(
          paginatedReposNotifierProvider: starredReposNotifierProvider,
          getNextPage: () => ref
              .read(starredReposNotifierProvider.notifier)
              .getNextStarredReposPage(),
          noResultMessage: '''
                That's about everything we could 
              find in your starred repos right now.''',
        ),
        onShouldSignOutPressed: () =>
            ref.read(authNotifierProvider.notifier).signOut(),
      ),
    );
  }
}
