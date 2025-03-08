import 'package:Cryptcube_mobile_app/core/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/app_item.dart';
import '../../../services/app_loader_service.dart';
import '../../../services/auth_notifier_service.dart';
import '../../../services/logger_service.dart';
import '../../components/appListPage/app_list_item.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/header.dart';
import '../../components/appListPage/app_search_bar.dart';

class AppList extends ConsumerStatefulWidget {
  const AppList({super.key});

  @override
  ConsumerState<AppList> createState() => _AppListState();
}

class _AppListState extends ConsumerState<AppList> with LoggerMixin {
  final AppLoaderService _appLoader = AppLoaderService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  List<AppItem> allApps = [];
  List<AppItem> filteredApps = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreItems = true;
  int currentPage = 0;
  static const int pageSize = 20;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    logInfo('Initializing AppList screen');
    _scrollController.addListener(_onScroll);
    _loadApps();
  }

  @override
  void dispose() {
    logInfo('Disposing AppList screen');
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreApps();
    }
  }

  void _onSearch(String query) {
    logInfo('User searching apps with query: "$query"');
    setState(() {
      searchQuery = query.toLowerCase();
      _filterApps();
    });
  }

  void _filterApps() {
    if (searchQuery.isEmpty) {
      filteredApps = List.from(allApps);
    } else {
      filteredApps = allApps
          .where((app) => app.name.toLowerCase().contains(searchQuery))
          .toList();
    }
    logDebug('Filtered apps count: ${filteredApps.length}');
  }

  Future<void> _loadApps() async {
    try {
      logInfo('Loading apps (page: 0)');
      final token = ref.read(authProvider).token;
      final loadedApps = await _appLoader.loadApps(token, page: 0, pageSize: pageSize);
      
      setState(() {
        allApps = loadedApps;
        _filterApps();
        isLoading = false;
        hasMoreItems = loadedApps.length == pageSize;
        currentPage = 0;
      });

      logInfo('Successfully loaded ${loadedApps.length} apps');
    } catch (e, stackTrace) {
      logError('Failed to load apps', e, stackTrace);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load apps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadMoreApps() async {
    if (isLoadingMore || !hasMoreItems || searchQuery.isNotEmpty) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      logInfo('Loading more apps (page: ${currentPage + 1})');
      final token = ref.read(authProvider).token;
      final loadedApps = await _appLoader.loadApps(
        token,
        page: currentPage + 1,
        pageSize: pageSize,
      );

      setState(() {
        allApps.addAll(loadedApps);
        _filterApps();
        isLoadingMore = false;
        hasMoreItems = loadedApps.length == pageSize;
        currentPage++;
      });

      logInfo('Loaded ${loadedApps.length} additional apps');
    } catch (e, stackTrace) {
      logError('Failed to load more apps', e, stackTrace);
      setState(() {
        isLoadingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load more apps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<AppItem> get frequentlyUsedApps => 
      filteredApps.take(searchQuery.isEmpty ? 3 : filteredApps.length).toList();
      
  List<AppItem> get otherApps => 
      searchQuery.isEmpty ? filteredApps.skip(3).toList() : [];

  Widget _buildSection(String title, List<AppItem> sectionApps) {
    if (sectionApps.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < sectionApps.length; i++) ...[
                AppListItem(app: sectionApps[i]),
                if (i < sectionApps.length - 1)
                  const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(
                title: 'Apps affecting your Score',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  color: AppColors.contentAreaBackground,
                  child: Column(
                    children: [
                      AppSearchBar(
                        onSearch: _onSearch,
                        controller: _searchController,
                      ),
                      Expanded(
                        child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              children: [
                                _buildSection('Frequently Used Apps', frequentlyUsedApps),
                                if (searchQuery.isEmpty)
                                  _buildSection('Other Applications', otherApps),
                                if (hasMoreItems && isLoadingMore && searchQuery.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
