import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/app_item.dart';
import '../../../services/app_loader_service.dart';
import '../../../services/auth_notifier_service.dart';
import '../../components/appListPage/app_list_item.dart';
import '../../components/custom_navbar.dart';

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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreApps();
    }
  }

  Future<void> _loadApps() async {
    try {
      final token = ref.read(authProvider).token;
      final loadedApps = await _appLoader.loadApps(token, page: 0, pageSize: pageSize);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Apps affecting your Score',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: apps.length + (hasMoreItems ? 1 : 0),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    if (index == apps.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return AppListItem(app: apps[index]);
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}