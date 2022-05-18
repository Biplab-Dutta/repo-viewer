import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:repo_viewer/features/core/presentation/toasts.dart';
import 'package:repo_viewer/features/github/core/presentation/no_results_display.dart';
import 'package:repo_viewer/features/github/repos/core/application/paginated_repos_notifier.dart';
import 'package:repo_viewer/features/github/repos/core/presentation/widgets/failure_repo_tile.dart';
import 'package:repo_viewer/features/github/repos/core/presentation/widgets/repo_tile.dart';
import 'package:repo_viewer/features/github/repos/core/presentation/widgets/shimmer_tile.dart';

typedef PaginatedReposNotifierProvider = AutoDisposeStateNotifierProvider<
    PaginatedReposNotifier, PaginatedReposState>;

class PaginatedReposListView extends StatefulWidget {
  const PaginatedReposListView({
    super.key,
    required this.paginatedReposNotifierProvider,
    required this.getNextPage,
    required this.noResultMessage,
  });

  final PaginatedReposNotifierProvider paginatedReposNotifierProvider;
  final void Function() getNextPage;
  final String noResultMessage;

  @override
  State<PaginatedReposListView> createState() => _PaginatedReposListViewState();
}

class _PaginatedReposListViewState extends State<PaginatedReposListView> {
  bool _canLoadNextPage = false;
  bool _hasAlreadyShownNoConnectionToast = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        ref.listen<PaginatedReposState>(
          widget.paginatedReposNotifierProvider,
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
        final state = ref.watch(widget.paginatedReposNotifierProvider);
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            final limit =
                metrics.maxScrollExtent - metrics.viewportDimension / 3;
            // final limit = 0.75 * metrics.maxScrollExtent;
            if (_canLoadNextPage && metrics.pixels >= limit) {
              _canLoadNextPage = false;
              widget.getNextPage();
            }
            return false;
          },
          child: state.maybeWhen<bool>(
            loaded: (repos, _) => state.repos.entity.isEmpty,
            orElse: () => false,
          )
              ? NoResultsDisplay(
                  message: widget.noResultMessage,
                )
              : _PaginatedListView(state: state, key: widget.key),
        );
      },
    );
  }
}

class _PaginatedListView extends StatelessWidget {
  const _PaginatedListView({
    required this.state,
    super.key,
  });

  final PaginatedReposState state;

  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context)?.widget;
    return ListView.builder(
      padding: fsb == null
          ? EdgeInsets.zero
          : EdgeInsets.only(
              top: fsb.height + 8 + MediaQuery.of(context).padding.top,
            ),
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
