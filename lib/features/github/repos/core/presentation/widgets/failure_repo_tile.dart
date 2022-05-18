import 'package:flutter/material.dart';
import 'package:repo_viewer/features/github/core/domain/github_failure.dart';
import 'package:repo_viewer/features/github/repos/core/presentation/widgets/paginated_repos_list_view.dart';

class FailureRepoTile extends StatelessWidget {
  const FailureRepoTile({
    super.key,
    required this.failure,
  });

  final GithubFailure failure;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      textColor: Theme.of(context).colorScheme.onError,
      iconColor: Theme.of(context).colorScheme.onError,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Theme.of(context).errorColor,
        child: ListTile(
          title: const Text('An error occured. Please retry.'),
          subtitle: Text(
            failure.when<String>(
              api: (errorCode) => 'API returned $errorCode',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const SizedBox(
            height: double.infinity,
            child: Icon(Icons.warning),
          ),
          trailing: IconButton(
            onPressed: () => context
                .findAncestorWidgetOfExactType<PaginatedReposListView>()
                ?.getNextPage(),
            icon: const Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }
}
