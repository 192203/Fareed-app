import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = 'https://iwkhajjxybunfkaoapht.supabase.co';
const String supabasePublishableKey = 'sb_publishable_jhGme2oBxCchOfy-h4ALyA_1GYYuHs2';

SupabaseClient get db => Supabase.instance.client;

class AppColors {
  static const Color navy = Color(0xFF06142B);
  static const Color navyDeep = Color(0xFF02060E);
  static const Color card = Color(0xFF0C2140);
  static const Color blue = Color(0xFF1976E8);
  static const Color blueDark = Color(0xFF0356C5);
  static const Color gold = Color(0xFFD6B56A);
  static const Color text = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFFAFC7E8);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color ok = Color(0xFF3DDC97);
}

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.navyDeep,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue,
      secondary: AppColors.gold,
      surface: AppColors.navy,
      error: AppColors.danger,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navy,
      indicatorColor: const Color(0x40D6B56A),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 11, color: AppColors.text),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.navyDeep,
    ),
  );
}

const List<String> caseStatuses = ['جارية', 'مؤجلة', 'محكوم فيها', 'منتهية'];
const List<String> caseTypes = [
  'القضايا التجارية',
  'القضايا الجنائية',
  'القضايا المدنية',
  'الأحوال الشخصية',
  'عمالي',
  'إداري',
  'إيجارات',
  'أخرى',
];

String two(int n) => n.toString().padLeft(2, '0');

String fmtDate(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';

String fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final p = d.hour < 12 ? 'ص' : 'م';
  return '$h:${two(d.minute)} $p';
}

String fmtDateTime(dynamic iso) {
  if (iso == null) return '';
  final d = DateTime.parse(iso.toString()).toLocal();
  return '${fmtDate(d)} • ${fmtTime(d)}';
}

String relName(dynamic rel, String key) {
  if (rel is Map) {
    final v = rel[key];
    return v == null ? '' : v.toString();
  }
  return '';
}

void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<bool> confirmDialog(BuildContext context, String message) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('تأكيد', style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ),
  );
  return res == true;
}

Future<String?> pickFromList(
  BuildContext context,
  String title,
  List<MapEntry<String, String>> items,
) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.card,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final e in items)
                  ListTile(
                    title: Text(e.key),
                    onTap: () => Navigator.pop(ctx, e.value),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class Backdrop extends StatelessWidget {
  final Widget child;
  const Backdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
      ),
      child: child,
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  const Panel({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const PageHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.gold,
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String text;
  const StatusChip(this.text, {super.key});

  Color get _color {
    switch (text) {
      case 'جارية':
        return AppColors.blue;
      case 'مؤجلة':
        return AppColors.gold;
      case 'محكوم فيها':
      case 'منتهية':
        return AppColors.ok;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const EmptyState({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: AppColors.muted),
          const SizedBox(height: 14),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class ErrorBox extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const ErrorBox({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.danger),
            const SizedBox(height: 12),
            const Text('تعذّر تحميل البيانات'),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blueDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon, size: 20),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}

InputDecoration appInputDecoration(String label, {Widget? prefix, Widget? suffix}) {
  OutlineInputBorder b(Color c) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: c),
    );
  }

  return InputDecoration(
    labelText: label,
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0x14FFFFFF),
    labelStyle: const TextStyle(color: AppColors.muted),
    border: b(Colors.transparent),
    enabledBorder: b(Colors.transparent),
    focusedBorder: b(AppColors.gold),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

class AppField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboard;
  final int maxLines;
  const AppField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.obscure = false,
    this.keyboard,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: appInputDecoration(
          label,
          prefix: icon == null ? null : Icon(icon, color: AppColors.muted),
        ),
      ),
    );
  }
}

class PickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: InputDecorator(
          decoration: appInputDecoration(
            label,
            suffix: const Icon(Icons.arrow_drop_down, color: AppColors.muted),
          ),
          child: Text(value.isEmpty ? ' ' : value),
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool _signup = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  String _arabicError(String m) {
    final s = m.toLowerCase();
    if (s.contains('invalid login')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    }
    if (s.contains('already registered') || s.contains('already been registered')) {
      return 'هذا البريد مسجّل بالفعل';
    }
    if (s.contains('email not confirmed')) {
      return 'أكّد بريدك الإلكتروني أولًا من الرسالة التي وصلتك';
    }
    if (s.contains('password')) {
      return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
    }
    return m;
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final pass = _pass.text;
    if (email.isEmpty || pass.isEmpty) {
      toast(context, 'اكتب البريد الإلكتروني وكلمة المرور');
      return;
    }
    if (_signup && _name.text.trim().isEmpty) {
      toast(context, 'اكتب الاسم');
      return;
    }
    setState(() => _loading = true);
    try {
      if (_signup) {
        final res = await db.auth.signUp(
          email: email,
          password: pass,
          data: {'full_name': _name.text.trim(), 'phone': _phone.text.trim()},
        );
        if (res.session == null && mounted) {
          toast(context, 'تم إنشاء الحساب. أكّد بريدك الإلكتروني ثم سجّل الدخول');
          setState(() => _signup = false);
        }
      } else {
        await db.auth.signInWithPassword(email: email, password: pass);
      }
    } on AuthException catch (e) {
      if (mounted) toast(context, _arabicError(e.message));
    } catch (_) {
      if (mounted) toast(context, 'تعذّر الاتصال. تأكد من الإنترنت');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.12),
                      border: Border.all(color: AppColors.gold),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('assets/images/fareed_logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'فريد عبدالهادي',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'للمحاماة والاستشارات القانونية',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 32),
                  if (_signup) AppField(controller: _name, label: 'الاسم الكامل', icon: Icons.person_outline),
                  if (_signup)
                    AppField(
                      controller: _phone,
                      label: 'رقم الهاتف',
                      icon: Icons.phone_outlined,
                      keyboard: TextInputType.phone,
                    ),
                  AppField(
                    controller: _email,
                    label: 'البريد الإلكتروني',
                    icon: Icons.mail_outline,
                    keyboard: TextInputType.emailAddress,
                  ),
                  AppField(
                    controller: _pass,
                    label: 'كلمة المرور',
                    icon: Icons.lock_outline,
                    obscure: true,
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: _signup ? 'إنشاء حساب' : 'تسجيل الدخول',
                    icon: _signup ? Icons.person_add_alt : Icons.login,
                    loading: _loading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: _loading ? null : () => setState(() => _signup = !_signup),
                    child: Text(
                      _signup ? 'لديك حساب؟ تسجيل الدخول' : 'عميل جديد؟ إنشاء حساب',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SessionsPage extends StatefulWidget {
  final bool lawyer;
  const SessionsPage({super.key, required this.lawyer});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final data = await db
        .from('sessions')
        .select('*, cases(case_number, title)')
        .order('session_at', ascending: true);
    return List<Map<String, dynamic>>.from(data);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _add() async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      builder: (_) => const SessionForm(),
    );
    if (ok == true) _reload();
  }

  Future<void> _delete(Map<String, dynamic> s) async {
    final ok = await confirmDialog(context, 'حذف هذه الجلسة؟');
    if (!ok) return;
    try {
      await db.from('sessions').delete().eq('id', s['id']);
      _reload();
    } catch (e) {
      if (mounted) toast(context, 'تعذّر الحذف');
    }
  }

  Widget _tile(Map<String, dynamic> s) {
    final when = DateTime.parse(s['session_at'].toString()).toLocal();
    final past = when.isBefore(DateTime.now());
    final caseTitle = relName(s['cases'], 'title');
    final caseNumber = relName(s['cases'], 'case_number');
    final parts = <String>[
      if (caseTitle.isNotEmpty) caseTitle,
      if (caseNumber.isNotEmpty) 'رقم $caseNumber',
    ];
    final place = (s['location'] ?? '').toString();
    return Opacity(
      opacity: past ? 0.55 : 1,
      child: Panel(
        child: Row(
          children: [
            Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(
                    '${when.day}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.gold,
                    ),
                  ),
                  Text(
                    '${when.month}/${when.year}',
                    style: const TextStyle(fontSize: 10, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (s['title'] ?? 'جلسة').toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    fmtTime(when) + (place.isEmpty ? '' : ' • $place'),
                    style: const TextStyle(fontSize: 12, color: AppColors.gold),
                  ),
                  if (parts.isNotEmpty)
                    Text(
                      parts.join(' • '),
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                ],
              ),
            ),
            if (widget.lawyer)
              IconButton(
                onPressed: () => _delete(s),
                icon: const Icon(Icons.delete_outline, color: AppColors.muted),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: widget.lawyer
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: const Text('جلسة جديدة'),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: widget.lawyer ? 'الجلسات' : 'جلساتي',
            subtitle: widget.lawyer ? 'مواعيد الجلسات القادمة والسابقة' : 'مواعيد جلسات قضاياك',
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _reload();
                try {
                  await _future;
                } catch (_) {}
              },
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return ErrorBox(error: snap.error!, onRetry: _reload);
                  }
                  final rows = snap.data ?? [];
                  if (rows.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        EmptyState(icon: Icons.event_available, text: 'لا توجد جلسات مسجّلة بعد'),
                      ],
                    );
                  }
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                    children: [for (final s in rows) _tile(s)],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SessionForm extends StatefulWidget {
  final String? caseId;
  const SessionForm({super.key, this.caseId});

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  final TextEditingController _title = TextEditingController(text: 'جلسة');
  final TextEditingController _location = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String? _caseId;
  String _caseLabel = '';
  DateTime? _date;
  TimeOfDay? _time;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _caseId = widget.caseId;
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickCase() async {
    try {
      final data = await db
          .from('cases')
          .select('id, case_number, title')
          .order('created_at', ascending: false);
      final rows = List<Map<String, dynamic>>.from(data);
      if (!mounted) return;
      if (rows.isEmpty) {
        toast(context, 'أضف قضية أولًا');
        return;
      }
      final items = <MapEntry<String, String>>[];
      for (final r in rows) {
        final number = (r['case_number'] ?? '').toString();
        final title = (r['title'] ?? '').toString();
        final label = number.isEmpty ? title : '$title ($number)';
        items.add(MapEntry<String, String>(label, r['id'].toString()));
      }
      final v = await pickFromList(context, 'اختر القضية', items);
      if (v == null) return;
      setState(() {
        _caseId = v;
        _caseLabel = items.firstWhere((e) => e.value == v).key;
      });
    } catch (e) {
      if (mounted) toast(context, 'تعذّر تحميل القضايا');
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (t != null) setState(() => _time = t);
  }

  Future<void> _save() async {
    if (_caseId == null) {
      toast(context, 'اختر القضية');
      return;
    }
    if (_date == null || _time == null) {
      toast(context, 'اختر التاريخ والوقت');
      return;
    }
    final dt = DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
    setState(() => _saving = true);
    try {
      await db.from('sessions').insert({
        'case_id': _caseId,
        'session_at': dt.toUtc().toIso8601String(),
        'title': _title.text.trim(),
        'location': _location.text.trim(),
        'notes': _notes.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        toast(context, 'تعذّر الحفظ: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final caseText = widget.caseId != null
        ? 'القضية الحالية'
        : (_caseLabel.isEmpty ? 'اختر القضية' : _caseLabel);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'جلسة جديدة',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.gold),
            ),
            const SizedBox(height: 16),
            PickerField(
              label: 'القضية',
              value: caseText,
              onTap: widget.caseId != null ? () {} : _pickCase,
            ),
            AppField(controller: _title, label: 'عنوان الجلسة', icon: Icons.title),
            PickerField(
              label: 'التاريخ',
              value: _date == null ? 'اختر التاريخ' : fmtDate(_date!),
              onTap: _pickDate,
            ),
            PickerField(
              label: 'الوقت',
              value: _time == null ? 'اختر الوقت' : _time!.format(context),
              onTap: _pickTime,
            ),
            AppField(controller: _location, label: 'المكان / القاعة', icon: Icons.place_outlined),
            AppField(controller: _notes, label: 'ملاحظات', maxLines: 3),
            const SizedBox(height: 4),
            PrimaryButton(label: 'حفظ الجلسة', icon: Icons.check, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class CasesPage extends StatefulWidget {
  final bool lawyer;
  final String? clientId;
  final String? clientName;
  const CasesPage({
    super.key,
    required this.lawyer,
    this.clientId,
    this.clientName,
  });

  @override
  State<CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    var q = db.from('cases').select('*, profiles(full_name)');
    if (widget.clientId != null) {
      q = q.eq('client_id', widget.clientId!);
    }
    final data = await q.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _add() async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      builder: (_) => CaseForm(
        presetClientId: widget.clientId,
        presetClientName: widget.clientName,
      ),
    );
    if (ok == true) _reload();
  }

  Future<void> _open(Map<String, dynamic> row) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CaseDetailPage(caseRow: row, lawyer: widget.lawyer),
      ),
    );
    _reload();
  }

  Widget _tile(Map<String, dynamic> r) {
    final client = relName(r['profiles'], 'full_name');
    final number = (r['case_number'] ?? '').toString();
    final parts = <String>[
      if (number.isNotEmpty) 'رقم $number',
      if (client.isNotEmpty) client,
    ];
    return Panel(
      onTap: () => _open(r),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.folder_outlined, color: AppColors.blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (r['title'] ?? '').toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 3),
                Text(
                  parts.join(' • '),
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          StatusChip((r['status'] ?? '').toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: widget.lawyer
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: const Text('قضية جديدة'),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.clientId == null)
            PageHeader(
              title: widget.lawyer ? 'القضايا' : 'قضاياي',
              subtitle: widget.lawyer
                  ? 'كل القضايا وحالتها في مكان واحد'
                  : 'قضاياك المسجّلة لدى المكتب',
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _reload();
                try {
                  await _future;
                } catch (_) {}
              },
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return ErrorBox(error: snap.error!, onRetry: _reload);
                  }
                  final rows = snap.data ?? [];
                  if (rows.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        EmptyState(
                          icon: Icons.folder_open,
                          text: widget.lawyer
                              ? 'لا توجد قضايا بعد.\nاضغط «قضية جديدة» لإضافة أول قضية.'
                              : 'لا توجد قضايا مرتبطة بحسابك بعد.\nسيربط المكتب قضاياك بحسابك.',
                        ),
                      ],
                    );
                  }
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                    children: [for (final r in rows) _tile(r)],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CaseForm extends StatefulWidget {
  final String? presetClientId;
  final String? presetClientName;
  const CaseForm({super.key, this.presetClientId, this.presetClientName});

  @override
  State<CaseForm> createState() => _CaseFormState();
}

class _CaseFormState extends State<CaseForm> {
  final TextEditingController _number = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _court = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String _type = caseTypes.first;
  String _status = caseStatuses.first;
  String? _clientId;
  String _clientName = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _clientId = widget.presetClientId;
    _clientName = widget.presetClientName ?? '';
  }

  @override
  void dispose() {
    _number.dispose();
    _title.dispose();
    _court.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickType() async {
    final v = await pickFromList(
      context,
      'نوع القضية',
      [for (final t in caseTypes) MapEntry<String, String>(t, t)],
    );
    if (v != null) setState(() => _type = v);
  }

  Future<void> _pickStatus() async {
    final v = await pickFromList(
      context,
      'حالة القضية',
      [for (final t in caseStatuses) MapEntry<String, String>(t, t)],
    );
    if (v != null) setState(() => _status = v);
  }

  Future<void> _pickClient() async {
    try {
      final data = await db
          .from('profiles')
          .select('id, full_name')
          .eq('role', 'client')
          .order('full_name');
      final rows = List<Map<String, dynamic>>.from(data);
      if (!mounted) return;
      final items = <MapEntry<String, String>>[
        MapEntry<String, String>('بدون عميل', ''),
      ];
      for (final r in rows) {
        final name = (r['full_name'] ?? '').toString();
        items.add(MapEntry<String, String>(name.isEmpty ? 'بدون اسم' : name, r['id'].toString()));
      }
      final v = await pickFromList(context, 'اختر العميل', items);
      if (v == null) return;
      setState(() {
        if (v.isEmpty) {
          _clientId = null;
          _clientName = '';
        } else {
          _clientId = v;
          _clientName = items.firstWhere((e) => e.value == v).key;
        }
      });
    } catch (e) {
      if (mounted) toast(context, 'تعذّر تحميل العملاء');
    }
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      toast(context, 'اكتب عنوان القضية');
      return;
    }
    setState(() => _saving = true);
    try {
      await db.from('cases').insert({
        'case_number': _number.text.trim(),
        'title': _title.text.trim(),
        'case_type': _type,
        'court': _court.text.trim(),
        'status': _status,
        'client_id': _clientId,
        'notes': _notes.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        toast(context, 'تعذّر الحفظ: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'قضية جديدة',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.gold),
            ),
            const SizedBox(height: 16),
            AppField(controller: _title, label: 'عنوان القضية', icon: Icons.gavel),
            AppField(controller: _number, label: 'رقم القضية', icon: Icons.numbers),
            PickerField(label: 'نوع القضية', value: _type, onTap: _pickType),
            AppField(controller: _court, label: 'المحكمة', icon: Icons.account_balance),
            PickerField(label: 'الحالة', value: _status, onTap: _pickStatus),
            PickerField(
              label: 'العميل',
              value: _clientName.isEmpty ? 'بدون عميل' : _clientName,
              onTap: _pickClient,
            ),
            AppField(controller: _notes, label: 'ملاحظات', maxLines: 3),
            const SizedBox(height: 4),
            PrimaryButton(label: 'حفظ القضية', icon: Icons.check, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class CaseDetailPage extends StatefulWidget {
  final Map<String, dynamic> caseRow;
  final bool lawyer;
  const CaseDetailPage({super.key, required this.caseRow, required this.lawyer});

  @override
  State<CaseDetailPage> createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  late Map<String, dynamic> _c;
  late Future<List<Map<String, dynamic>>> _sessions;

  @override
  void initState() {
    super.initState();
    _c = Map<String, dynamic>.from(widget.caseRow);
    _sessions = _loadSessions();
  }

  Future<List<Map<String, dynamic>>> _loadSessions() async {
    final data = await db
        .from('sessions')
        .select()
        .eq('case_id', _c['id'])
        .order('session_at', ascending: true);
    return List<Map<String, dynamic>>.from(data);
  }

  void _reloadSessions() {
    setState(() {
      _sessions = _loadSessions();
    });
  }

  Future<void> _changeStatus() async {
    final v = await pickFromList(
      context,
      'تغيير حالة القضية',
      [for (final t in caseStatuses) MapEntry<String, String>(t, t)],
    );
    if (v == null) return;
    try {
      await db.from('cases').update({'status': v}).eq('id', _c['id']);
      setState(() => _c['status'] = v);
    } catch (e) {
      if (mounted) toast(context, 'تعذّر التحديث');
    }
  }

  Future<void> _delete() async {
    final ok = await confirmDialog(context, 'حذف القضية وكل جلساتها نهائيًا؟');
    if (!ok) return;
    try {
      await db.from('cases').delete().eq('id', _c['id']);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) toast(context, 'تعذّر الحذف');
    }
  }

  Future<void> _addSession() async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      builder: (_) => SessionForm(caseId: _c['id'].toString()),
    );
    if (ok == true) _reloadSessions();
  }

  Widget _info(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = relName(_c['profiles'], 'full_name');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text((_c['title'] ?? 'القضية').toString()),
      ),
      body: Backdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'بيانات القضية',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.gold),
                        ),
                        StatusChip((_c['status'] ?? '').toString()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _info('رقم القضية', (_c['case_number'] ?? '').toString()),
                    _info('النوع', (_c['case_type'] ?? '').toString()),
                    _info('المحكمة', (_c['court'] ?? '').toString()),
                    _info('العميل', client),
                    _info('ملاحظات', (_c['notes'] ?? '').toString()),
                  ],
                ),
              ),
              if (widget.lawyer)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _changeStatus,
                        icon: const Icon(Icons.flag_outlined),
                        label: const Text('تغيير الحالة'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _delete,
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('حذف'),
                      ),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionTitle('جلسات القضية'),
                  if (widget.lawyer)
                    TextButton.icon(
                      onPressed: _addSession,
                      icon: const Icon(Icons.add, color: AppColors.gold),
                      label: const Text('إضافة جلسة', style: TextStyle(color: AppColors.gold)),
                    ),
                ],
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _sessions,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snap.hasError) {
                    return ErrorBox(error: snap.error!, onRetry: _reloadSessions);
                  }
                  final rows = snap.data ?? [];
                  if (rows.isEmpty) {
                    return const EmptyState(icon: Icons.event_busy, text: 'لا توجد جلسات مسجّلة لهذه القضية');
                  }
                  return Column(
                    children: [
                      for (final s in rows)
                        Panel(
                          child: Row(
                            children: [
                              const Icon(Icons.event, color: AppColors.gold),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (s['title'] ?? 'جلسة').toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      fmtDateTime(s['session_at']),
                                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final data = await db
        .from('profiles')
        .select()
        .eq('role', 'client')
        .order('full_name');
    return List<Map<String, dynamic>>.from(data);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  void _open(Map<String, dynamic> c) {
    final name = (c['full_name'] ?? '').toString();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(name.isEmpty ? 'قضايا العميل' : name),
          ),
          body: Backdrop(
            child: SafeArea(
              child: CasesPage(
                lawyer: true,
                clientId: c['id'].toString(),
                clientName: name,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tile(Map<String, dynamic> c) {
    final name = (c['full_name'] ?? '').toString();
    final phone = (c['phone'] ?? '').toString();
    final email = (c['email'] ?? '').toString();
    final initial = name.isEmpty ? '؟' : name.substring(0, 1);
    final parts = <String>[
      if (phone.isNotEmpty) phone,
      if (email.isNotEmpty) email,
    ];
    return Panel(
      onTap: () => _open(c),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.gold.withValues(alpha: 0.18),
            child: Text(
              initial,
              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'بدون اسم' : name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                if (parts.isNotEmpty)
                  Text(
                    parts.join(' • '),
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left, color: AppColors.muted),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'العملاء',
            subtitle: 'العملاء المسجّلون في التطبيق وقضاياهم',
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _reload();
                try {
                  await _future;
                } catch (_) {}
              },
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return ErrorBox(error: snap.error!, onRetry: _reload);
                  }
                  final rows = snap.data ?? [];
                  if (rows.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        EmptyState(
                          icon: Icons.people_outline,
                          text: 'لا يوجد عملاء بعد.\nيظهر العميل هنا بعد أن ينشئ حسابه من التطبيق.',
                        ),
                      ],
                    );
                  }
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [for (final c in rows) _tile(c)],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  final bool lawyer;
  const AccountPage({super.key, required this.lawyer});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final uid = db.auth.currentUser!.id;
      final p = await db.from('profiles').select().eq('id', uid).maybeSingle();
      if (p != null) {
        _name.text = (p['full_name'] ?? '').toString();
        _phone.text = (p['phone'] ?? '').toString();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final uid = db.auth.currentUser!.id;
      await db.from('profiles').update({
        'full_name': _name.text.trim(),
        'phone': _phone.text.trim(),
      }).eq('id', uid);
      if (mounted) toast(context, 'تم حفظ البيانات');
    } catch (e) {
      if (mounted) toast(context, 'تعذّر الحفظ');
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final email = db.auth.currentUser?.email ?? '';
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                const PageHeader(title: 'حسابي', subtitle: 'بياناتك الشخصية'),
                Panel(
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, color: AppColors.gold),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lawyer ? 'حساب المحامي' : 'حساب عميل',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              email,
                              style: const TextStyle(fontSize: 12, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                AppField(controller: _name, label: 'الاسم الكامل', icon: Icons.person_outline),
                AppField(
                  controller: _phone,
                  label: 'رقم الهاتف',
                  icon: Icons.phone_outlined,
                  keyboard: TextInputType.phone,
                ),
                PrimaryButton(label: 'حفظ', icon: Icons.check, loading: _saving, onPressed: _save),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () async {
                    await db.auth.signOut();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('تسجيل الخروج'),
                ),
              ],
            ),
    );
  }
}

class LawyerHome extends StatefulWidget {
  final String name;
  const LawyerHome({super.key, required this.name});

  @override
  State<LawyerHome> createState() => _LawyerHomeState();
}

class _LawyerHomeState extends State<LawyerHome> {
  int _index = 0;

  void _go(int i) {
    setState(() => _index = i);
  }

  Widget _page() {
    switch (_index) {
      case 1:
        return const ClientsPage();
      case 2:
        return const CasesPage(lawyer: true);
      case 3:
        return const SessionsPage(lawyer: true);
      case 4:
        return const AccountPage(lawyer: true);
      default:
        return LawyerDashboard(name: widget.name, onGo: _go);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(child: SafeArea(child: _page())),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.gold),
            label: 'المكتب',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: AppColors.gold),
            label: 'العملاء',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder, color: AppColors.gold),
            label: 'القضايا',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event, color: AppColors.gold),
            label: 'الجلسات',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.gold),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}



class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ContactItem({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    CircleAvatar(backgroundColor: const Color(0xFF173D75), child: Icon(icon, color: AppColors.text, size: 18)),
    const SizedBox(height: 6),
    Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: AppColors.muted)),
  ]));
}

class LegalServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const LegalServiceCard({
    super.key, required this.icon, required this.title,
    required this.subtitle, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0A2044),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFF24518D), width: 1),
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF102D59), Color(0xFF071936)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: title == 'القضايا التجارية' ? AppColors.gold : const Color(0xFF69A8FF), size: 31),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              Text(subtitle, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, fontSize: 10)),
              const SizedBox(height: 7),
              const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class LawyerDashboard extends StatefulWidget {
  final String name;
  final void Function(int) onGo;
  const LawyerDashboard({super.key, required this.name, required this.onGo});

  @override
  State<LawyerDashboard> createState() => _LawyerDashboardState();
}

class _LawyerDashboardState extends State<LawyerDashboard> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>> _load() async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final clients = await db.from('profiles').select('id').eq('role', 'client');
    final cases = await db.from('cases').select('id');
    final upcoming = await db
        .from('sessions')
        .select('*, cases(case_number, title)')
        .gte('session_at', nowIso)
        .order('session_at', ascending: true)
        .limit(20);
    final list = List<Map<String, dynamic>>.from(upcoming);
    return {
      'clients': (clients as List).length,
      'cases': (cases as List).length,
      'upcoming': list,
    };
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _addCase() async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      builder: (_) => const CaseForm(),
    );
    if (ok == true) _reload();
  }

  Future<void> _addSession() async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      builder: (_) => const SessionForm(),
    );
    if (ok == true) _reload();
  }

  Widget _action(IconData icon, String label, VoidCallback onTap) {
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.name.trim().isEmpty ? '' : '، ${widget.name.trim()}';
    return RefreshIndicator(
      onRefresh: () async {
        _reload();
        try { await _future; } catch (_) {}
      },
      child: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          final data = snap.data;
          final upcoming = data == null
              ? <Map<String, dynamic>>[]
              : List<Map<String, dynamic>>.from(data['upcoming'] as List);
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Row(
                children: [
                  const Icon(Icons.notifications_none, color: AppColors.text, size: 25),
                  const Spacer(),
                  Column(children: [
                    Image.asset('assets/images/fareed_logo.png', width: 48, height: 48),
                    const Text('فريد حسام عبدالهادي', style: TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                  const Spacer(),
                  const Icon(Icons.menu, color: AppColors.text, size: 27),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2765B5)),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight, end: Alignment.bottomLeft,
                    colors: [Color(0xFF12366B), Color(0xFF06152F), Color(0xFF020B1D)],
                  ),
                  boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: .16), blurRadius: 22)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('مكتب المستشار', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('فريد حسام عبدالهادي', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 7),
                    const Text('للمحاماة والاستشارات القانونية',
                      style: TextStyle(color: AppColors.muted, fontSize: 14)),
                    const SizedBox(height: 12),
                    const Text('نحن معك في كل خطوة نحو حقك',
                      style: TextStyle(color: AppColors.gold, fontSize: 12)),
                    const SizedBox(height: 18),
                    Row(children: [
                      Expanded(child: PrimaryButton(
                        label: 'إضافة قضية', icon: Icons.folder_open,
                        onPressed: _addCase,
                      )),
                      const SizedBox(width: 9),
                      Expanded(child: PrimaryButton(
                        label: 'حجز جلسة', icon: Icons.calendar_month,
                        onPressed: _addSession,
                      )),
                    ]),
                  ],
                ),
              ),
              if (snap.hasError) ErrorBox(error: snap.error!, onRetry: _reload),
              const SectionTitle('خدماتنا القانونية'),
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.08,
                children: [
                  LegalServiceCard(icon: Icons.balance, title: 'القضايا التجارية', subtitle: 'شركات • منازعات', onTap: () => widget.onGo(2)),
                  LegalServiceCard(icon: Icons.verified_user_outlined, title: 'القضايا الجنائية', subtitle: 'جنايات • جنح', onTap: () => widget.onGo(2)),
                  LegalServiceCard(icon: Icons.description_outlined, title: 'القضايا المدنية', subtitle: 'عقود • تعويضات', onTap: () => widget.onGo(2)),
                  LegalServiceCard(icon: Icons.people_alt_outlined, title: 'الأحوال الشخصية', subtitle: 'زواج • طلاق • نفقة', onTap: () => widget.onGo(2)),
                ],
              ),
              const SizedBox(height: 14),
              Panel(
                padding: const EdgeInsets.all(17),
                onTap: () => widget.onGo(2),
                child: Row(children: [
                  const CircleAvatar(backgroundColor: Color(0xFF604B2C), child: Icon(Icons.folder_open, color: AppColors.gold)),
                  const SizedBox(width: 13),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('قضايا المكتب', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                    Text('تابع حالة القضايا ومواعيدها', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  ])),
                  Text(data == null ? '—' : '${data['cases']}', style: const TextStyle(fontSize: 22, color: AppColors.text, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8), const Icon(Icons.chevron_right, color: AppColors.muted),
                ]),
              ),
              const SectionTitle('ملخص المكتب'),
              if (data != null) Row(children: [
                Expanded(child: StatTile(label: 'العملاء', value: data['clients'].toString(), onTap: () => widget.onGo(1))),
                const SizedBox(width: 8),
                Expanded(child: StatTile(label: 'القضايا', value: data['cases'].toString(), onTap: () => widget.onGo(2))),
                const SizedBox(width: 8),
                Expanded(child: StatTile(label: 'جلسات قادمة', value: upcoming.length.toString(), onTap: () => widget.onGo(3))),
              ]),
              const SectionTitle('أقرب الجلسات'),
              if (data != null && upcoming.isEmpty)
                const EmptyState(icon: Icons.event_available, text: 'لا توجد جلسات قادمة'),
              for (final item in upcoming.take(3))
                Panel(child: Row(children: [
                  const Icon(Icons.event, color: AppColors.gold),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(relName(item['cases'], 'title').isEmpty ? (item['title'] ?? 'جلسة').toString() : relName(item['cases'], 'title'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(fmtDateTime(item['session_at']), style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ])),
                ])),
              const SizedBox(height: 12),
              const Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('تواصل معنا مباشرة', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _ContactItem(icon: Icons.phone, label: 'اتصال', value: '01092790355'),
                  _ContactItem(icon: Icons.chat, label: 'واتساب', value: '01067095323'),
                  _ContactItem(icon: Icons.email_outlined, label: 'البريد', value: 'fareedhosam983@gmail.com'),
                ]),
                SizedBox(height: 8),
                Text('محافظة كفر الشيخ • الرياض • الوزارية الجديدة',
                  style: TextStyle(color: AppColors.muted, fontSize: 11)),
              ])),
            ],
          );
        },
      ),
    );
  }
}

class ClientHome extends StatefulWidget {
  final String name;
  const ClientHome({super.key, required this.name});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int _index = 0;

  void _go(int i) {
    setState(() => _index = i);
  }

  Widget _page() {
    switch (_index) {
      case 1:
        return const CasesPage(lawyer: false);
      case 2:
        return const SessionsPage(lawyer: false);
      case 3:
        return const AccountPage(lawyer: false);
      default:
        return ClientDashboard(name: widget.name, onGo: _go);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(child: SafeArea(child: _page())),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.gold),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder, color: AppColors.gold),
            label: 'قضاياي',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event, color: AppColors.gold),
            label: 'جلساتي',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.gold),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}

class ClientDashboard extends StatefulWidget {
  final String name;
  final void Function(int) onGo;
  const ClientDashboard({super.key, required this.name, required this.onGo});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>> _load() async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final cases = await db.from('cases').select('id');
    final upcoming = await db
        .from('sessions')
        .select('*, cases(case_number, title)')
        .gte('session_at', nowIso)
        .order('session_at', ascending: true)
        .limit(20);
    final list = List<Map<String, dynamic>>.from(upcoming);
    return {
      'cases': (cases as List).length,
      'upcoming': list,
    };
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.name.trim().isEmpty ? '' : '، ${widget.name.trim()}';
    return RefreshIndicator(
      onRefresh: () async {
        _reload();
        try {
          await _future;
        } catch (_) {}
      },
      child: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          final data = snap.data;
          final upcoming = data == null
              ? <Map<String, dynamic>>[]
              : List<Map<String, dynamic>>.from(data['upcoming'] as List);
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/fareed_logo.png', width: 42, height: 42),
                  const SizedBox(width: 10),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('مكتب المحامي', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                    Text('فريد حسام عبدالهادي', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 16)),
                  ]),
                ],
              ),
              PageHeader(
                title: 'أهلًا$first',
                subtitle: 'تابع قضاياك وجلساتك مع مكتب فريد حسام عبدالهادي',
              ),
              const SectionTitle('خدماتنا القانونية'),
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, mainAxisSpacing: 10,
                childAspectRatio: 1.25,
                children: [
                  LegalServiceCard(icon: Icons.balance, title: 'القضايا التجارية', subtitle: 'شركات • منازعات', onTap: () => widget.onGo(1)),
                  LegalServiceCard(icon: Icons.verified_user_outlined, title: 'القضايا الجنائية', subtitle: 'جنايات • جنح', onTap: () => widget.onGo(1)),
                  LegalServiceCard(icon: Icons.description_outlined, title: 'القضايا المدنية', subtitle: 'عقود • تعويضات', onTap: () => widget.onGo(1)),
                  LegalServiceCard(icon: Icons.people_alt_outlined, title: 'الأحوال الشخصية', subtitle: 'زواج • طلاق • نفقة', onTap: () => widget.onGo(1)),
                ],
              ),
              if (snap.hasError)
                ErrorBox(error: snap.error!, onRetry: _reload)
              else
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: 'قضاياي',
                        value: data == null ? '-' : data['cases'].toString(),
                        onTap: () => widget.onGo(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatTile(
                        label: 'جلسات قادمة',
                        value: data == null ? '-' : upcoming.length.toString(),
                        onTap: () => widget.onGo(2),
                      ),
                    ),
                  ],
                ),
              const SectionTitle('أقرب جلسة'),
              if (data != null && upcoming.isEmpty)
                const EmptyState(icon: Icons.event_available, text: 'لا توجد جلسات قادمة حاليًا'),
              for (final s in upcoming.take(2))
                Panel(
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: AppColors.gold),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              relName(s['cases'], 'title').isEmpty
                                  ? (s['title'] ?? 'جلسة').toString()
                                  : relName(s['cases'], 'title'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              fmtDateTime(s['session_at']),
                              style: const TextStyle(fontSize: 12, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);
  runApp(const FareedApp());
}

class FareedApp extends StatelessWidget {
  const FareedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مكتب المحامي فريد حسام عبدالهادي',
      theme: buildTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: db.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = db.auth.currentSession;
        if (session == null) return const AuthPage();
        return RoleRouter(key: ValueKey(session.user.id));
      },
    );
  }
}

class RoleRouter extends StatefulWidget {
  const RoleRouter({super.key});

  @override
  State<RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<RoleRouter> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>> _load() async {
    final user = db.auth.currentUser!;
    final existing = await db.from('profiles').select().eq('id', user.id).maybeSingle();
    if (existing != null) return existing;
    final meta = user.userMetadata;
    final row = <String, dynamic>{
      'id': user.id,
      'email': user.email ?? '',
      'full_name': meta == null ? '' : (meta['full_name'] ?? '').toString(),
      'phone': meta == null ? '' : (meta['phone'] ?? '').toString(),
      'role': 'client',
    };
    await db.from('profiles').insert(row);
    return row;
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Backdrop(child: Center(child: CircularProgressIndicator())));
        }
        if (snap.hasError) {
          return Scaffold(
            body: Backdrop(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ErrorBox(error: snap.error!, onRetry: _retry),
                    TextButton(
                      onPressed: () => db.auth.signOut(),
                      child: const Text('تسجيل الخروج'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final p = snap.data!;
        final name = (p['full_name'] ?? '').toString();
        if (p['role'] == 'lawyer') return LawyerHome(name: name);
        return ClientHome(name: name);
      },
    );
  }
}
