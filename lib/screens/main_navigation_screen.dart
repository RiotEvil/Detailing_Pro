import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import '../core/onboarding_prefs.dart';
import 'dashboard_screen.dart';
import 'jobs_screen.dart';
import 'clients_screen.dart';
import 'calendar_screen.dart';
import 'inventory_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'photos_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final BusinessMode businessMode;
  final AppRole appRole;

  const MainNavigationScreen({
    super.key,
    required this.businessMode,
    required this.appRole,
  });
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _hintInProgress = false;
  bool _initialHintsScheduled = false;
  late final Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box(HiveBoxes.settings);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialHintsScheduled) return;
    _initialHintsScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeShowHintForIndex(_selectedIndex);
    });
  }

  void _navigate(int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() => _selectedIndex = index);
    _maybeShowHintForIndex(index);
  }

  List<_NavItem> get _navItems {
    final l10n = AppLocalizations.of(context)!;
    final isDirector =
        widget.appRole == AppRole.director ||
        widget.appRole == AppRole.masterOwner;

    final items = [
      _NavItem(
        id: 'dashboard',
        icon: Icons.dashboard,
        label: l10n.navDashboard,
        page: const DashboardScreen(),
      ),
      _NavItem(
        id: 'orders',
        icon: Icons.list_alt,
        label: l10n.navOrders,
        page: const JobsScreen(),
      ),
      _NavItem(
        id: 'clients',
        icon: Icons.people,
        label: l10n.navClients,
        page: const ClientsScreen(),
      ),
      _NavItem(
        id: 'calendar',
        icon: Icons.calendar_month,
        label: l10n.navCalendar,
        page: const CalendarScreen(),
      ),
      _NavItem(
        id: 'inventory',
        icon: Icons.science,
        label: l10n.navInventory,
        page: const InventoryScreen(),
      ),
      _NavItem(
        id: 'photos',
        icon: Icons.photo_library,
        label: l10n.navPhotos,
        page: const PhotosScreen(),
      ),
      _NavItem(
        id: 'settings',
        icon: Icons.settings,
        label: l10n.navSettings,
        page: const SettingsScreen(),
      ),
    ];

    if (isDirector) {
      items.insert(
        5,
        _NavItem(
          id: 'stats',
          icon: Icons.bar_chart,
          label: l10n.navStats,
          page: const StatsScreen(),
        ),
      );
    }

    return items;
  }

  Future<void> _maybeShowHintForIndex(int index) async {
    if (_hintInProgress) return;
    if (_settingsBox.get(
          OnboardingPrefs.keyPostAuthCompleted,
          defaultValue: false,
        ) ==
        true) {
      return;
    }

    final navItems = _navItems;
    if (index < 0 || index >= navItems.length) return;

    final item = navItems[index];
    if (OnboardingPrefs.isNavHintSeen(_settingsBox, item.id)) {
      return;
    }

    final message = _hintMessage(item.id);
    if (message == null || message.isEmpty) {
      await OnboardingPrefs.markNavHintSeen(_settingsBox, item.id);
      return;
    }

    _hintInProgress = true;
    if (!mounted) {
      _hintInProgress = false;
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await OnboardingPrefs.markNavHintSeen(_settingsBox, item.id);
    _hintInProgress = false;
  }

  String? _hintMessage(String id) {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    final isRu = lang == 'ru';

    final ru = {
      'dashboard': 'Подсказка: здесь сводка дня и ключевые показатели.',
      'orders':
          'Подсказка: в заказах удобно создавать и вести работу по этапам.',
      'clients': 'Подсказка: храните базу клиентов и историю обращений.',
      'settings':
          'Подсказка: в настройках можно включать подсказки и менять параметры приложения.',
      'calendar':
          'Подсказка: календарь показывает занятость и помогает планировать нагрузку.',
      'inventory':
          'Подсказка: следите за остатками, чтобы не срывать работы из-за расходников.',
      'photos':
          'Подсказка: фото-архив помогает фиксировать результат и прогресс по заказам.',
      'stats':
          'Подсказка: аналитика показывает динамику выручки и эффективность команды.',
    };

    final en = {
      'dashboard': 'Tip: this screen shows your day summary and key metrics.',
      'orders':
          'Tip: use Orders to create jobs and track progress through stages.',
      'clients': 'Tip: keep your client base and visit history organized here.',
      'settings':
          'Tip: in Settings you can reopen hints and adjust app behavior.',
      'calendar':
          'Tip: calendar helps you manage workload and schedule availability.',
      'inventory': 'Tip: monitor stock levels to avoid workflow interruptions.',
      'photos': 'Tip: keep before/after and process photos for each job.',
      'stats':
          'Tip: analytics helps you track revenue trends and team performance.',
    };

    return isRu ? ru[id] : en[id];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    // Десктопный лейаут только для действительно больших окон.
    final isWideScreen = size.width >= 1000 && size.height >= 700;

    if (isWideScreen) {
      return _buildDesktopLayout(l10n);
    } else {
      return _buildMobileLayout(l10n);
    }
  }

  Widget _buildDesktopLayout(AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _navigate,
            scrollable: true,
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppColors.surface,
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            selectedLabelTextStyle: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.car_repair,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            destinations: _navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: IndexedStack(
                index: _selectedIndex,
                children: _navItems.map((item) => item.page).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _navItems.map((item) => item.page).toList(),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: const BoxDecoration(color: AppColors.card),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.car_repair,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Text(
                      l10n.appTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ..._navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return ListTile(
                leading: Icon(
                  item.icon,
                  color: _selectedIndex == index
                      ? AppColors.primary
                      : Colors.grey,
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? AppColors.primary
                        : Colors.white,
                    fontWeight: _selectedIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: _selectedIndex == index,
                selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
                onTap: () {
                  _navigate(index);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(_navItems[_selectedIndex].label),
        backgroundColor: AppColors.surface,
      ),
    );
  }
}

class _NavItem {
  final String id;
  final IconData icon;
  final String label;
  final Widget page;

  const _NavItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.page,
  });
}
