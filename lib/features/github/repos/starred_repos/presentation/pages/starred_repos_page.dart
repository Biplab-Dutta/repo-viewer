import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/auth/shared/providers.dart';
import 'package:repo_viewer/features/github/core/shared/providers.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/presentation/widgets/paginated_repos_list_view.dart';

class StarredReposPage extends ConsumerStatefulWidget {
  const StarredReposPage({Key? key}) : super(key: key);

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
    // WidgetsBinding.db?.addPostFrameCallback(
    //   (timeStamp) {
    //     ref
    //         .read(starredReposNotifierProvider.notifier)
    //         .getNextStarredReposPage();
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starred Repos'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const PaginatedReposListView(),
    );
  }
}
