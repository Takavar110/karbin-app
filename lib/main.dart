import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'logic/labor_calculator.dart';

void main() {
  runApp(const KarBinApp());
}

class KarBinApp extends StatelessWidget {
  const KarBinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'کاربین - دستیار قانون کار',
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    SanavatScreen(),
    LeaveScreen(),
    UnemploymentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کاربین | مرجع قانون کار و تأمین اجتماعی'),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'محاسبه سنوات',
          ),
          NavigationDestination(
            icon: Icon(Icons.beach_access_outlined),
            selectedIcon: Icon(Icons.beach_access),
            label: 'مانده مرخصی',
          ),
          NavigationDestination(
            icon: Icon(Icons.security_outlined),
            selectedIcon: Icon(Icons.security),
            label: 'بیمه بیکاری',
          ),
        ],
      ),
    );
  }
}

// ----------------- صفحه ۱: محاسبه سنوات -----------------
class SanavatScreen extends StatefulWidget {
  const SanavatScreen({super.key});

  @override
  State<SanavatScreen> createState() => _SanavatScreenState();
}

class _SanavatScreenState extends State<SanavatScreen> {
  final _dailyWageController = TextEditingController();
  final _workingDaysController = TextEditingController();
  double _result = 0;
  final _numberFormat = NumberFormat('#,###');

  void _calculate() {
    final dailyWage = double.tryParse(_dailyWageController.text.replaceAll(',', '')) ?? 0;
    final totalDays = int.tryParse(_workingDaysController.text) ?? 0;

    setState(() {
      _result = LaborCalculator.calculateSanavat(
        lastDailyWage: dailyWage,
        totalWorkingDays: totalDays,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('محاسبه حق سنوات (ماده ۲۴ قانون کار)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          TextField(
            controller: _dailyWageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'آخرین مزد ثابت روزانه (ریال)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _workingDaysController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'تعداد کل روزهای کارکرد (مثلاً ۳۶۵ برای ۱ سال)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculate,
            child: const Text('محاسبه مبلغ سنوات'),
          ),
          const SizedBox(height: 20),
          if (_result > 0)
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'مبلغ سنوات استحقاقی: ${_numberFormat.format(_result.round())} ریال',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ----------------- صفحه ۲: مانده مرخصی -----------------
class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _dailyWageController = TextEditingController();
  final _leaveDaysController = TextEditingController();
  double _result = 0;
  final _numberFormat = NumberFormat('#,###');

  void _calculate() {
    final dailyWage = double.tryParse(_dailyWageController.text.replaceAll(',', '')) ?? 0;
    final leaveDays = double.tryParse(_leaveDaysController.text) ?? 0;

    setState(() {
      _result = LaborCalculator.calculateLeaveBuyout(
        lastDailyWage: dailyWage,
        remainingDays: leaveDays,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('محاسبه بازخرید مرخصی (ماده ۶۴ و ۷۱ قانون کار)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          TextField(
            controller: _dailyWageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'آخرین مزد روزانه (ریال)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _leaveDaysController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'تعداد روزهای مرخصی مانده',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculate,
            child: const Text('محاسبه بازخرید مرخصی'),
          ),
          const SizedBox(height: 20),
          if (_result > 0)
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'مبلغ قابل پرداخت: ${_numberFormat.format(_result.round())} ریال',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ----------------- صفحه ۳: بیمه بیکاری -----------------
class UnemploymentScreen extends StatefulWidget {
  const UnemploymentScreen({super.key});

  @override
  State<UnemploymentScreen> createState() => _UnemploymentScreenState();
}

class _UnemploymentScreenState extends State<UnemploymentScreen> {
  bool _isInvoluntary = true;
  final _monthsController = TextEditingController();
  final _daysSinceController = TextEditingController();
  final _avgWageController = TextEditingController();
  final _dependentsController = TextEditingController(text: '0');
  final _minWageController = TextEditingController(text: '2388728'); // حداقل مزد روزانه ۱۴۰۳
  Map<String, dynamic>? _result;
  final _numberFormat = NumberFormat('#,###');

  void _evaluate() {
    final months = int.tryParse(_monthsController.text) ?? 0;
    final daysSince = int.tryParse(_daysSinceController.text) ?? 0;
    final avgWage = double.tryParse(_avgWageController.text.replaceAll(',', '')) ?? 0;
    final dependents = int.tryParse(_dependentsController.text) ?? 0;
    final minWage = double.tryParse(_minWageController.text.replaceAll(',', '')) ?? 0;

    setState(() {
      _result = LaborCalculator.evaluateUnemployment(
        isInvoluntary: _isInvoluntary,
        insuranceMonthsInLastJob: months,
        daysSinceDismissal: daysSince,
        averageLast90DaysDailyWage: avgWage,
        dependentsCount: dependents,
        dailyMinWage: minWage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('شرط‌سنج و تخمین مقرری بیمه بیکاری',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('آیا بیکاری شما غیرارادی (اخراج یا پایان قرارداد) بوده است؟'),
            value: _isInvoluntary,
            onChanged: (val) => setState(() => _isInvoluntary = val),
          ),
          TextField(
            controller: _monthsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'سابقه بیمه در آخرین کارگاه (ماه)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _daysSinceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'چند روز از تاریخ بیکاری گذشته است؟',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _avgWageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'میانگین مزد روزانه در ۹۰ روز آخر (ریال)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dependentsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'تعداد افراد تحت تکفل (همسر و فرزندان - تا ۴ نفر)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _evaluate,
            child: const Text('بررسی شرایط و محاسبه'),
          ),
          const SizedBox(height: 20),
          if (_result != null)
            Card(
              color: _result!['eligible'] ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _result!['eligible']
                    ? Text(
                        'وضعیت: واجد شرایط دریافت مقرری\n\n'
                        'مقرری ماهانه تخمینی: ${_numberFormat.format((_result!['monthlyBenefit'] as double).round())} ریال\n'
                        'مقرری روزانه: ${_numberFormat.format((_result!['dailyBenefit'] as double).round())} ریال',
                        style: const TextStyle(fontWeight: FontWeight.bold, height: 1.6),
                      )
                    : Text(
                        'وضعیت: عدم احراز شرایط\nدلیل: ${_result!['reason']}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, height: 1.5),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
