import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/app_item.dart';
import '../../../services/app_loader_service.dart';
import '../../../services/auth_notifier_service.dart';
import '../../components/appListPage/app_list_item.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/header.dart';

class AppList extends ConsumerStatefulWidget {
  const AppList({super.key});

  @override
  ConsumerState<AppList> createState() => _AppListState();
}

class _AppListState extends ConsumerState<AppList> {
  final AppLoaderService _appLoader = AppLoaderService();
  final ScrollController _scrollController = ScrollController();
  List<AppItem> apps = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreItems = true;
  int currentPage = 0;
  static const int pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadApps();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreApps();
    }
  }

  Future<void> _loadApps() async {
    try {
      final token = ref.read(authProvider).token;
      final loadedApps =
          await _appLoader.loadApps(token, page: 0, pageSize: pageSize);
      setState(() {
        apps = loadedApps;
        isLoading = false;
        hasMoreItems = loadedApps.length == pageSize;
        currentPage = 0;
      });
    } catch (e) {
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
    if (isLoadingMore || !hasMoreItems) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final token = ref.read(authProvider).token;
      final loadedApps = await _appLoader.loadApps(
        token,
        page: currentPage + 1,
        pageSize: pageSize,
      );

      setState(() {
        apps.addAll(loadedApps);
        isLoadingMore = false;
        hasMoreItems = loadedApps.length == pageSize;
        currentPage++;
      });
    } catch (e) {
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

  List<AppItem> get frequentlyUsedApps => apps.take(3).toList();
  List<AppItem> get otherApps => apps.skip(3).toList();

  Widget _buildSection(String title, List<AppItem> sectionApps) {
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sectionApps.length,
          itemBuilder: (context, index) => AppListItem(app: sectionApps[index]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(
              title: 'Apps affecting your Score',
              onBackPressed: () => Navigator.pop(context),
            ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSection('Frequently Used Apps', frequentlyUsedApps),
                    _buildSection('Other Applications', otherApps),
                    if (hasMoreItems && isLoadingMore)
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
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
