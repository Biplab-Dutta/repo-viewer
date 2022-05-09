import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/core/presentation/toasts.dart';
import 'package:repo_viewer/features/github/core/presentation/no_results_display.dart';
import 'package:repo_viewer/features/github/core/shared/providers.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/application/starred_repos_state.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/presentation/widgets/failure_repo_tile.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/presentation/widgets/repo_tile.dart';
import 'package:repo_viewer/features/github/repos/starred_repos/presentation/widgets/shimmer_tile.dart';

class PaginatedReposListView extends StatefulWidget {
  const PaginatedReposListView({
    Key? key,
  }) : super(key: key);

  @override
  State<PaginatedReposListView> createState() => _PaginatedReposListViewState();
}

class _PaginatedReposListViewState extends State<PaginatedReposListView> {
  bool _canLoadNextPage = false;
  bool _hasAlreadyShownNoConnectionToast = false;
  final _noResultsMessage =
      "That's about everything we could find in your starred repos right now.";

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        ref.listen<StarredReposState>(
          starredReposNotifierProvider,
          (_, state) {
            state.map(
              initial: (_) => _canLoadNextPage = true,
              loading: (_) => _canLoadNextPage = false,
              loaded: (_) {
                if (!_.repos.isFresh && !_hasAlreadyShownNoConnectionToast) {
                  _hasAlreadyShownNoConnectionToast = true;
                  showNoConnectionToast(
                    'You are not online 📵. Some information may be outdated.',
                    context: context,
                  );
                }
                _canLoadNextPage = _.isNextPageAvailable;
              },
              failed: (_) => _canLoadNextPage = false,
            );
          },
        );
        final state = ref.watch(starredReposNotifierProvider);
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            final limit =
                metrics.maxScrollExtent - metrics.viewportDimension / 3;
            // final limit = 0.75 * metrics.maxScrollExtent;
            if (_canLoadNextPage && metrics.pixels >= limit) {
              _canLoadNextPage = false;
              ref
                  .read(starredReposNotifierProvider.notifier)
                  .getNextStarredReposPage();
            }
            return false;
          },
          child: state.maybeWhen<bool>(
            loaded: (repos, _) => state.repos.entity.isEmpty,
            orElse: () => false,
          )
              ? NoResultsDisplay(
                  message: _noResultsMessage,
                )
              : _PaginatedListView(state: state),
        );
      },
    );
  }
}

class _PaginatedListView extends StatelessWidget {
  const _PaginatedListView({
    Key? key,
    required this.state,
  }) : super(key: key);

  final StarredReposState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return state.when<Widget>(
          initial: (_) => const SizedBox.shrink(),
          loading: (repos, itemsPerPage) {
            if (index < repos.entity.length) {
              return RepoTile(
                repo: repos.entity[index],
              );
            } else {
              return const ShimmerTile();
            }
          },
          loaded: (repos, _) => RepoTile(
            repo: repos.entity[index],
          ),
          failed: (previouslyLoadedRepos, failure) {
            if (index < previouslyLoadedRepos.entity.length) {
              return RepoTile(
                repo: previouslyLoadedRepos.entity[index],
              );
            } else {
              return FailureRepoTile(failure: failure);
            }
          },
        );
      },
      itemCount: state.map(
        initial: (_) => 0,
        loading: (instance) =>
            instance.repos.entity.length + instance.itemsPerPage,
        loaded: (instance) => instance.repos.entity.length,
        failed: (instance) => instance.repos.entity.length + 1,
        /* Providing some space for `Try Again option in the ListView` */
      ),
    );
  }
}
