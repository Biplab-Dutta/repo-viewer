import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/features/github/core/shared/providers.dart';
import 'package:repo_viewer/features/github/repos/core/presentation/widgets/paginated_repos_list_view.dart';

class SearchedReposPage extends ConsumerStatefulWidget {
  const SearchedReposPage({
    super.key,
    required String searchTerm,
  })  : _searchTerm = searchTerm;

  final String _searchTerm;

  @override
  ConsumerState<SearchedReposPage> createState() => _SearchedReposPageState();
}

class _SearchedReposPageState extends ConsumerState<SearchedReposPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        ref
            .read(searchedReposNotifierProvider.notifier)
            .getNextSearchedReposPage(widget._searchTerm);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._searchTerm),
      ),
      body: PaginatedReposListView(
        paginatedReposNotifierProvider: searchedReposNotifierProvider,
        getNextPage: () => ref
            .read(searchedReposNotifierProvider.notifier)
            .getNextSearchedReposPage(widget._searchTerm),
        noResultMessage:
            'This is all we could find for your search term. Really...',
      ),
    );
  }
}
