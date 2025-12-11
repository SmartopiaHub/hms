// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../authenticator.dart';
import '../notification.dart';
import 'base.dart';
import '../widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../api.dart';
import '../model/database.dart';


/// A generic task list page that loads pages of tasks with infinite scroll.
class TastTemplateListPage extends StatefulWidget {
  /// e.g. 'active', 'inactive', 'today', 'tomorrow'
  //final String filter;

  const TastTemplateListPage({super.key});

  @override
  State<TastTemplateListPage> createState() => _TastTemplateListPageState();
}

class _TastTemplateListPageState extends PageBaseState<TastTemplateListPage> {
  static const _pageSize = 5;

  
  final PagingController<int, TaskTemplate> _templatePagingController =
      PagingController(
        getNextPageKey: (state){
          if (state.pages != null && state.pages!.isNotEmpty) {
            if (state.pages!.last.length < _pageSize) {
              return null;
            }
          } 
          return (state.keys?.last ?? 0) + 1;
        },
        fetchPage: (pageKey) async => await apiService.fetchTaskTemplates(
          pageKey: pageKey,
          tasksPerPage: _pageSize,
        ),
      );

  @override
  void dispose() {
    _templatePagingController.dispose();

    super.dispose();
  }

  bool _canEdit(TaskTemplate template) {
    final auth = context.read<AuthProvider>();
    return auth.isParent || template.creator == auth.username;
  }

  bool _canDelete(TaskTemplate template) {
    final auth = context.read<AuthProvider>();
    return auth.isParent || template.creator == auth.username;
  }

  Widget _buildTemplateList(BuildContext context){
    final templateList = PagingListener(
        controller: _templatePagingController,
        builder: (context, state, fetchNextPage) => PagedListView<int, TaskTemplate>(
          state: state,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) => TaskTemplateItem(
              template: item,
              onEdit: !_canEdit(item) ? null : () async {
                final didChange = await GoRouter.of(context).pushNamed<bool>('taskEdit', pathParameters: {'id': item.id.toString()}, extra: item);
                if (didChange!= null && didChange) {
                  _templatePagingController.refresh();
                }
              },
              onDelete: !_canDelete(item) ? null : () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.taskDelete),
                    content: Text(localizations.taskDeleteConfirmation),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(localizations.cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await apiService.deleteTaskTemplate(item.id);
                            _templatePagingController.refresh();
                            if (context.mounted) context.pop();
                          } catch (e) {
                            if (context.mounted) {
                              showErrorNotification(localizations.taskDeleteError, context: context);
                            }
                          }
                        },
                        child: Text(localizations.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
            noItemsFoundIndicatorBuilder: (_) => Center(child: Text(localizations.noTasks)),
            firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            //noMoreItemsIndicatorBuilder: (_) => const Center(child: Text('No more task templates')),
          ),
        ),
      );

    return templateList;
  }

  @override
  Widget buildContent(BuildContext context) {
    return _buildTemplateList(context);
  }

  @override
  String get pageTitle => localizations.taskTemplates;

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return (!isParent && !allowSelfHomeworkManagement) ? null : FloatingActionButton(
        onPressed:  () async {
          final didChange = await GoRouter.of(context).pushNamed<bool>('taskCreate');
          if (didChange != null && didChange) {
            _templatePagingController.refresh();
          }
        },
        child: const Icon(Icons.add),
      ); 
  }
}
