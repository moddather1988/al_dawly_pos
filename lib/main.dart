import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlDawlyPosApp());
}

/// أداة مالية دقيقة (تتعامل بالقروش لتجنب أخطاء الفاصلة العشرية)
class MoneyUtil {
  MoneyUtil._();

  static final NumberFormat _arabicCurrencyFormat = NumberFormat.currency(
    locale: 'ar_EG',
    symbol: 'ج.م',
    decimalDigits: 2,
  );

  static String formatMinor(int amountInMinor) {
    return _arabicCurrencyFormat.format(amountInMinor / 100.0);
  }
}

/// ثيم التطبيق (الكحلي الداكن والأخضر الزمردي والذهبي)
class AppTheme {
  AppTheme._();

  static const Color darkNavyBg = Color(0xFF0B132B);
  static const Color darkCardBg = Color(0xFF1C2541);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color goldAccent = Color(0xFFF59E0B);
  static const Color alertRed = Color(0xFFEF4444);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkNavyBg,
      primaryColor: emeraldGreen,
      colorScheme: const ColorScheme.dark(
        primary: emeraldGreen,
        secondary: goldAccent,
        surface: darkCardBg,
        error: alertRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCardBg,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: darkCardBg,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      primaryColor: emeraldGreen,
      colorScheme: const ColorScheme.light(
        primary: emeraldGreen,
        secondary: goldAccent,
        surface: Colors.white,
        error: alertRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0B132B),
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }
}

class AlDawlyPosApp extends StatefulWidget {
  const AlDawlyPosApp({super.key});

  @override
  State<AlDawlyPosApp> createState() => _AlDawlyPosAppState();
}

class _AlDawlyPosAppState extends State<AlDawlyPosApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الدولي لقطع غيار الموتسيكلات - AL DAWLY POS',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MainShellScreen(
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

/// الهيكل الرئيسي المتجاوب (موبايل vs تابلت) مع دعم RTL بالكامل
class MainShellScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const MainShellScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 700;

    final List<Widget> screens = [
      const DashboardTab(),
      const PosTab(),
      const InventoryTab(),
      const SettingsTab(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الدولي لقطع غيار الموتسيكلات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'AL DAWLY POS — جاهز للاختبار والتشغيل',
                style: TextStyle(fontSize: 11, color: Color(0xFF10B981)),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'تبديل المظهر',
              onPressed: widget.onToggleTheme,
              icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: Row(
          children: [
            if (isTablet)
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
                labelType: NavigationRailLabelType.all,
                selectedItemColor: const Color(0xFF10B981),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text('الرئيسية'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.point_of_sale_outlined),
                    selectedIcon: Icon(Icons.point_of_sale),
                    label: Text('الكاشير'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.inventory_2_outlined),
                    selectedIcon: Icon(Icons.inventory_2),
                    label: Text('المخزن'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: Text('الإعدادات'),
                  ),
                ],
              ),
            Expanded(
              child: screens[_selectedIndex],
            ),
          ],
        ),
        bottomNavigationBar: isTablet
            ? null
            : BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (idx) => setState(() => _selectedIndex = idx),
                selectedItemColor: const Color(0xFF10B981),
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.point_of_sale),
                    label: 'الكاشير',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.inventory_2),
                    label: 'المخزن',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'الإعدادات',
                  ),
                ],
              ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981)),
          ),
          child: const Row(
            children: [
              Icon(Icons.cloud_done, color: Color(0xFF10B981)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'النظام يعمل محلياً بنجاح — واجهة عربية متكاملة ومؤشرات حية جاهزة.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width >= 700 ? 3 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            _MetricCard(title: 'مبيعات اليوم', value: MoneyUtil.formatMinor(154000), icon: Icons.trending_up, accentColor: const Color(0xFF10B981)),
            _MetricCard(title: 'مجمل الأرباح', value: MoneyUtil.formatMinor(42000), icon: Icons.monetization_on, accentColor: const Color(0xFFF59E0B)),
            _MetricCard(title: 'رصيد الخزنة', value: MoneyUtil.formatMinor(310000), icon: Icons.account_balance_wallet, accentColor: const Color(0xFF10B981)),
            _MetricCard(title: 'قيمة المخزون', value: MoneyUtil.formatMinor(1250000), icon: Icons.warehouse, accentColor: const Color(0xFFF59E0B)),
          ],
        ),
      ],
    );
  }
}

class PosTab extends StatelessWidget {
  const PosTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('شاشة الكاشير السريع', style: TextStyle(fontSize: 18)));
}

class InventoryTab extends StatelessWidget {
  const InventoryTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('إدارة المخزون وقطع الغيار', style: TextStyle(fontSize: 18)));
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('الإعدادات والنسخ الاحتياطي', style: TextStyle(fontSize: 18)));
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _MetricCard({required this.title, required this.value, required this.icon, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Icon(icon, color: accentColor, size: 22),
              ],
            ),
            Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: accentColor)),
          ],
        ),
      ),
    );
  }
}
