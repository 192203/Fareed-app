import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const String supabaseUrl = 'https://iwkhajjxybunfkaoapht.supabase.co';
const String supabasePublishableKey = 'sb_publishable_jhGme2oBxCchOfy-h4ALyA_1GYYuHs2';

const String officePhone = '01092790355';
const String officeWhatsapp = '01067095323';
const String officeEmail = 'fareedhosam983@gmail.com';
const String officeAddress = 'محافظة كفر الشيخ - الرياض - الوزارية الجديدة';

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
    textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue,
      secondary: AppColors.gold,
      surface: AppColors.navy,
      error: AppColors.danger,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xF2071A3A),
      indicatorColor: const Color(0x40D6B56A),
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.cairo(fontSize: 11, color: AppColors.text),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.navyDeep,
    ),
  );
}

import 'dart:math' as math;

class AuroraBackground extends StatefulWidget {
  final Widget child;
  const AuroraBackground({super.key, required this.child});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 16))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _orb(Alignment a, double size, Color color, double alpha) {
    return Align(
      alignment: a,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF071A3A), AppColors.navyDeep],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final t = _c.value * 2 * math.pi;
                return Stack(
                  children: [
                    _orb(Alignment(0.9 * math.sin(t), -0.8 + 0.1 * math.cos(t)), 340, AppColors.blue, 0.30),
                    _orb(Alignment(-0.9 + 0.2 * math.cos(t), 0.1 + 0.5 * math.sin(t)), 380, AppColors.blueDark, 0.28),
                    _orb(Alignment(0.8 * math.cos(t), 0.95), 300, AppColors.gold, 0.10),
                  ],
                );
              },
            ),
          ),
          Positioned.fill(child: RepaintBoundary(child: widget.child)),
        ],
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int charMs;
  final int startMs;
  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.charMs = 75,
    this.startMs = 600,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final int _total;

  @override
  void initState() {
    super.initState();
    _total = widget.startMs + widget.text.length * widget.charMs;
    _c = AnimationController(vsync: this, duration: Duration(milliseconds: _total))
      ..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final elapsed = _c.value * _total;
        var n = ((elapsed - widget.startMs) / widget.charMs).floor();
        if (n < 0) n = 0;
        if (n > widget.text.length) n = widget.text.length;
        final typed = widget.text.substring(0, n);
        final rest = widget.text.substring(n);
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: typed),
              TextSpan(
                text: rest,
                style: const TextStyle(color: Colors.transparent, shadows: []),
              ),
            ],
          ),
          style: widget.style,
          textAlign: widget.textAlign,
        );
      },
    );
  }
}

class FadeSlide extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final double dy;
  const FadeSlide({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.dy = 0.10,
  });

  @override
  State<FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<FadeSlide> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _t = Timer(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _a,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, widget.dy), end: Offset.zero).animate(_a),
        child: widget.child,
      ),
    );
  }
}

class ShimmerSweep extends StatefulWidget {
  final Widget child;
  final BorderRadius radius;
  const ShimmerSweep({super.key, required this.child, required this.radius});

  @override
  State<ShimmerSweep> createState() => _ShimmerSweepState();
}

class _ShimmerSweepState extends State<ShimmerSweep> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 3400))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.radius,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) {
                  var p = _c.value / 0.5;
                  if (p > 1) p = 1;
                  final x = -1.8 + p * 3.6;
                  return Align(
                    alignment: Alignment(x, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.3,
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.22),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class PulseScale extends StatefulWidget {
  final Widget child;
  final double amount;
  const PulseScale({super.key, required this.child, this.amount = 0.18});

  @override
  State<PulseScale> createState() => _PulseScaleState();
}

class _PulseScaleState extends State<PulseScale> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
    _a = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.0 + widget.amount).animate(_a),
      child: widget.child,
    );
  }
}

class BrandMark extends StatefulWidget {
  final double size;
  const BrandMark({super.key, this.size = 44});

  @override
  State<BrandMark> createState() => _BrandMarkState();
}

class _BrandMarkState extends State<BrandMark> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = widget.size * 1.9;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final v = Curves.easeInOut.transform(_c.value);
        return Transform.translate(
          offset: Offset(0, -6 * v),
          child: Transform.rotate(angle: (v - 0.5) * 0.08, child: child),
        );
      },
      child: Container(
        width: box,
        height: box,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.gold.withValues(alpha: 0.10),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.35),
              blurRadius: 28,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(Icons.balance, size: widget.size, color: AppColors.gold),
      ),
    );
  }
}

class SuccessCheck extends StatelessWidget {
  const SuccessCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, v, _) {
        return Transform.scale(
          scale: v,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.ok.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.ok, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ok.withValues(alpha: 0.4),
                  blurRadius: 34,
                ),
              ],
            ),
            child: const Icon(Icons.check_rounded, size: 70, color: AppColors.ok),
          ),
        );
      },
    );
  }
}

const List<String> caseStatuses = ['جارية', 'مؤجلة', 'محكوم فيها', 'منتهية'];
const List<String> caseTypes = [
  'أحوال شخصية',
  'مدني',
  'جنائي',
  'تجاري',
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
    return AuroraBackground(child: child);
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0x263A7BFF), Color(0x0DFFFFFF)],
          ),
          border: Border.all(color: const Color(0x405B9BFF)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
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
  final String? actionLabel;
  final VoidCallback? onAction;
  const SectionTitle(this.text, {super.key, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(fontSize: 12, color: AppColors.blue),
              ),
            ),
        ],
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0x263A7BFF), Color(0x0DFFFFFF)],
        ),
        border: Border.all(color: const Color(0x405B9BFF)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
      case 'جديد':
        return AppColors.blue;
      case 'مؤجلة':
      case 'قيد المراجعة':
        return AppColors.gold;
      case 'محكوم فيها':
      case 'منتهية':
      case 'تم الرد':
      case 'مؤكد':
        return AppColors.ok;
      case 'مرفوض':
        return AppColors.danger;
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
    final radius = BorderRadius.circular(16);
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ShimmerSweep(
        radius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [AppColors.blue, AppColors.blueDark],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: radius,
              onTap: loading ? null : onPressed,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) Icon(icon, size: 20, color: Colors.white),
                          if (icon != null) const SizedBox(width: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const GhostButton({super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.8)),
        color: AppColors.blue.withValues(alpha: 0.08),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, size: 20, color: AppColors.text),
              if (icon != null) const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
    border: b(const Color(0x335B9BFF)),
    enabledBorder: b(const Color(0x335B9BFF)),
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

class StandalonePage extends StatelessWidget {
  final String title;
  final Widget child;
  const StandalonePage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(title),
      ),
      body: Backdrop(child: SafeArea(child: child)),
    );
  }
}

class ServiceInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  const ServiceInfo(this.title, this.subtitle, this.icon);
}

const List<ServiceInfo> kMainServices = [
  ServiceInfo('القضايا المدنية', 'عقود - تعويضات', Icons.description_outlined),
  ServiceInfo('القضايا الجنائية', 'جنح - جنايات', Icons.shield_outlined),
  ServiceInfo('القضايا التجارية', 'شركات - منازعات', Icons.balance),
  ServiceInfo('الأحوال الشخصية', 'زواج - طلاق - نفقة', Icons.family_restroom),
];

const List<ServiceInfo> kMoreServices = [
  ServiceInfo('القضايا العمالية', 'عمال - فصل تعسفي - تأمينات', Icons.work_outline),
  ServiceInfo('القضايا الإدارية', 'قرارات - تظلمات - مجلس الدولة', Icons.account_balance_outlined),
  ServiceInfo('العقارات والإيجارات', 'ملكية - إيجار - إخلاء', Icons.home_work_outlined),
  ServiceInfo('العقود والتوكيلات', 'صياغة - مراجعة - توثيق', Icons.assignment_outlined),
  ServiceInfo('استشارة قانونية', 'رأي قانوني سريع', Icons.chat_bubble_outline),
];

List<String> allServiceTitles() {
  return [
    for (final s in kMainServices) s.title,
    for (final s in kMoreServices) s.title,
  ];
}

class ServiceCard extends StatelessWidget {
  final ServiceInfo service;
  final VoidCallback onTap;
  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0x263A7BFF), Color(0x0DFFFFFF)],
        ),
        border: Border.all(color: const Color(0x405B9BFF)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blue.withValues(alpha: 0.14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.30),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Icon(service.icon, color: AppColors.blue, size: 26),
                ),
                const SizedBox(height: 10),
                Text(
                  service.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  service.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  Widget _card(BuildContext context, ServiceInfo s, int delay) {
    return Expanded(
      child: FadeSlide(
        delayMs: delay,
        child: ServiceCard(
          service: s,
          onTap: () => openConsultationRequest(context, s.title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(context, kMainServices[0], 300),
            const SizedBox(width: 10),
            _card(context, kMainServices[1], 380),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card(context, kMainServices[2], 460),
            const SizedBox(width: 10),
            _card(context, kMainServices[3], 540),
          ],
        ),
      ],
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  Widget _tile(BuildContext context, ServiceInfo s) {
    return Panel(
      onTap: () => openConsultationRequest(context, s.title),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue.withValues(alpha: 0.14),
            ),
            child: Icon(s.icon, color: AppColors.blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(s.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        const PageHeader(
          title: 'الخدمات القانونية',
          subtitle: 'اختر الخدمة وأرسل استشارتك للمكتب',
        ),
        for (final s in kMainServices) _tile(context, s),
        for (final s in kMoreServices) _tile(context, s),
      ],
    );
  }
}

Future<int> fetchUnreadCount() async {
  try {
    final uid = db.auth.currentUser?.id;
    if (uid == null) return 0;
    final data = await db
        .from('notifications')
        .select('id')
        .eq('user_id', uid)
        .eq('read', false);
    return (data as List).length;
  } catch (_) {
    return 0;
  }
}

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final n = await fetchUnreadCount();
    if (mounted) setState(() => _count = n);
  }

  Future<void> _open() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _open,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_none, size: 28),
          if (_count > 0)
            Positioned(
              top: -5,
              right: -5,
              child: PulseScale(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _count > 9 ? '9+' : '$_count',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> row;
  final VoidCallback? onTap;
  const NotificationTile({super.key, required this.row, this.onTap});

  @override
  Widget build(BuildContext context) {
    final unread = row['read'] == false;
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue.withValues(alpha: 0.18),
            ),
            child: const Icon(Icons.notifications_active_outlined, color: AppColors.blue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (row['title'] ?? '').toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if ((row['body'] ?? '').toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      (row['body'] ?? '').toString(),
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  fmtDateTime(row['created_at']),
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
          if (unread)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final uid = db.auth.currentUser!.id;
    final data = await db
        .from('notifications')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(100);
    return List<Map<String, dynamic>>.from(data);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _markRead(Map<String, dynamic> r) async {
    if (r['read'] != false) return;
    try {
      await db.from('notifications').update({'read': true}).eq('id', r['id']);
      _reload();
    } catch (_) {}
  }

  Future<void> _markAll() async {
    try {
      final uid = db.auth.currentUser!.id;
      await db.from('notifications').update({'read': true}).eq('user_id', uid).eq('read', false);
      _reload();
    } catch (_) {
      if (mounted) toast(context, 'تعذّر التحديث');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('الإشعارات'),
        actions: [
          TextButton(
            onPressed: _markAll,
            child: const Text('قراءة الكل', style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
      body: Backdrop(
        child: SafeArea(
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
                      EmptyState(icon: Icons.notifications_off_outlined, text: 'لا توجد إشعارات بعد'),
                    ],
                  );
                }
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final r in rows) NotificationTile(row: r, onTap: () => _markRead(r)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> openLink(BuildContext context, String url) async {
  try {
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) toast(context, 'تعذّر فتح الرابط');
  } catch (_) {
    if (context.mounted) toast(context, 'تعذّر فتح الرابط');
  }
}

class OfficeHeader extends StatelessWidget {
  final VoidCallback onMenu;
  const OfficeHeader({super.key, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Row(
        children: [
          IconButton(onPressed: onMenu, icon: const Icon(Icons.menu, size: 28)),
          const Expanded(
            child: Column(
              children: [
                BrandMark(size: 22),
                SizedBox(height: 2),
                Text(
                  'ميزان',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
          const NotificationBell(),
        ],
      ),
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0B3A82), Color(0xFF071A3A), Color(0xFF040C1C)],
        ),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned(
              left: -24,
              bottom: -26,
              child: Transform.rotate(
                angle: -0.35,
                child: Icon(Icons.gavel, size: 190, color: AppColors.gold.withValues(alpha: 0.10)),
              ),
            ),
            Positioned(
              left: 26,
              top: 16,
              child: Icon(Icons.balance, size: 96, color: AppColors.blue.withValues(alpha: 0.20)),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TypewriterText(
                    text: 'مكتب المستشار\nفريد حسام عبدالهادي',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      height: 1.45,
                      color: AppColors.text,
                      shadows: [
                        Shadow(color: AppColors.gold.withValues(alpha: 0.40), blurRadius: 14),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const FadeSlide(
                    delayMs: 3200,
                    child: Text(
                      'للمحاماة والاستشارات القانونية',
                      style: TextStyle(fontSize: 14, color: AppColors.muted),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const FadeSlide(
                    delayMs: 3600,
                    child: Text(
                      '«نحن معك في كل خطوة نحو حقك»',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  const ActionPill({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: filled
            ? const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [AppColors.blue, AppColors.blueDark],
              )
            : null,
        color: filled ? null : AppColors.blue.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.85)),
        boxShadow: filled
            ? [
                BoxShadow(
                  color: AppColors.blue.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 11, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final VoidCallback onTap;
  const ContactItem({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تواصل معنا مباشرة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ContactItem(
                  icon: Icons.phone,
                  color: AppColors.blue,
                  label: 'اتصال',
                  value: officePhone,
                  onTap: () => openLink(context, 'tel:$officePhone'),
                ),
              ),
              Expanded(
                child: ContactItem(
                  icon: Icons.chat,
                  color: const Color(0xFF1FA855),
                  label: 'واتساب',
                  value: officeWhatsapp,
                  onTap: () => openLink(context, 'https://wa.me/2$officeWhatsapp'),
                ),
              ),
            ],
          ),
          ContactItem(
            icon: Icons.mail_outline,
            color: AppColors.blueDark,
            label: 'البريد الإلكتروني',
            value: officeEmail,
            onTap: () => openLink(context, 'mailto:$officeEmail'),
          ),
          ContactItem(
            icon: Icons.place_outlined,
            color: AppColors.blueDark,
            label: 'الموقع',
            value: officeAddress,
            onTap: () => openLink(
              context,
              'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(officeAddress)}',
            ),
          ),
        ],
      ),
    );
  }
}

class LatestNotifications extends StatefulWidget {
  const LatestNotifications({super.key});

  @override
  State<LatestNotifications> createState() => _LatestNotificationsState();
}

class _LatestNotificationsState extends State<LatestNotifications> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final uid = db.auth.currentUser!.id;
    final data = await db
        .from('notifications')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(2);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> _openAll() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );
    if (mounted) {
      setState(() {
        _future = _load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('أحدث الإشعارات', actionLabel: 'عرض الكل', onAction: _openAll),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final rows = snap.data ?? [];
            if (rows.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('لا توجد إشعارات حتى الآن', style: TextStyle(color: AppColors.muted)),
              );
            }
            return Column(
              children: [for (final r in rows) NotificationTile(row: r, onTap: _openAll)],
            );
          },
        ),
      ],
    );
  }
}

class DrawerEntry {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const DrawerEntry(this.icon, this.label, this.onTap);
}

class AppDrawer extends StatelessWidget {
  final String name;
  final String email;
  final List<DrawerEntry> entries;
  final VoidCallback onLogout;
  const AppDrawer({
    super.key,
    required this.name,
    required this.email,
    required this.entries,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '؟' : name.trim().substring(0, 1);
    return Drawer(
      backgroundColor: AppColors.navy,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.blue,
              child: Text(
                initial,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name.trim().isEmpty ? 'مرحبًا بك' : name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(email, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 14),
            const Divider(color: Color(0x24FFFFFF)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final e in entries)
                    ListTile(
                      leading: Icon(e.icon, color: AppColors.gold),
                      title: Text(e.label),
                      onTap: () {
                        Navigator.pop(context);
                        e.onTap();
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.danger),
                    title: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.danger)),
                    onTap: () {
                      Navigator.pop(context);
                      onLogout();
                    },
                  ),
                ],
              ),
            ),
            const BrandMark(size: 20),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'مكتب المستشار فريد حسام عبدالهادي\nللمحاماة والاستشارات القانونية',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  final String title;
  final String message;
  const SuccessPage({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SuccessCheck(),
                  const SizedBox(height: 28),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted, height: 1.7),
                  ),
                  const SizedBox(height: 36),
                  PrimaryButton(
                    label: 'العودة للرئيسية',
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
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

Future<void> openConsultationRequest(BuildContext context, String? category) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    builder: (_) => ConsultationForm(preset: category),
  );
  if (ok == true && context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SuccessPage(
          title: 'تم إرسال طلبك بنجاح',
          message: 'سيتم التواصل معك في أقرب وقت من قبل فريق المكتب',
        ),
      ),
    );
  }
}

Future<void> openBookingRequest(BuildContext context) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    builder: (_) => const AppointmentForm(),
  );
  if (ok == true && context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SuccessPage(
          title: 'تم إرسال طلب الحجز',
          message: 'سيؤكد المكتب موعدك قريبًا، وستصلك رسالة داخل التطبيق',
        ),
      ),
    );
  }
}

class ConsultationForm extends StatefulWidget {
  final String? preset;
  const ConsultationForm({super.key, this.preset});

  @override
  State<ConsultationForm> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationForm> {
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _details = TextEditingController();
  late String _category;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _category = widget.preset ?? 'استشارة قانونية';
  }

  @override
  void dispose() {
    _subject.dispose();
    _details.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final v = await pickFromList(
      context,
      'نوع الخدمة',
      [for (final t in allServiceTitles()) MapEntry<String, String>(t, t)],
    );
    if (v != null) setState(() => _category = v);
  }

  Future<void> _save() async {
    if (_subject.text.trim().isEmpty) {
      toast(context, 'اكتب موضوع الاستشارة');
      return;
    }
    setState(() => _saving = true);
    try {
      await db.from('consultations').insert({
        'client_id': db.auth.currentUser!.id,
        'category': _category,
        'subject': _subject.text.trim(),
        'details': _details.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        toast(context, 'تعذّر الإرسال: $e');
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
              'طلب استشارة',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.gold),
            ),
            const SizedBox(height: 16),
            PickerField(label: 'نوع الخدمة', value: _category, onTap: _pickCategory),
            AppField(controller: _subject, label: 'موضوع الاستشارة', icon: Icons.title),
            AppField(controller: _details, label: 'اشرح استفسارك بالتفصيل', maxLines: 5),
            const SizedBox(height: 4),
            PrimaryButton(label: 'إرسال الطلب', icon: Icons.send, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final TextEditingController _topic = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  bool _saving = false;

  @override
  void dispose() {
    _topic.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 11, minute: 0),
    );
    if (t != null) setState(() => _time = t);
  }

  Future<void> _save() async {
    if (_date == null || _time == null) {
      toast(context, 'اختر التاريخ والوقت المناسبين');
      return;
    }
    final dt = DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
    setState(() => _saving = true);
    try {
      await db.from('appointments').insert({
        'client_id': db.auth.currentUser!.id,
        'requested_at': dt.toUtc().toIso8601String(),
        'topic': _topic.text.trim(),
        'notes': _notes.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        toast(context, 'تعذّر الإرسال: $e');
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
              'حجز موعد مع المحامي',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.gold),
            ),
            const SizedBox(height: 16),
            PickerField(
              label: 'التاريخ المقترح',
              value: _date == null ? 'اختر التاريخ' : fmtDate(_date!),
              onTap: _pickDate,
            ),
            PickerField(
              label: 'الوقت المقترح',
              value: _time == null ? 'اختر الوقت' : _time!.format(context),
              onTap: _pickTime,
            ),
            AppField(controller: _topic, label: 'موضوع الموعد', icon: Icons.title),
            AppField(controller: _notes, label: 'ملاحظات', maxLines: 3),
            const SizedBox(height: 4),
            PrimaryButton(label: 'إرسال طلب الحجز', icon: Icons.event_available, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class ConsultationDetail extends StatefulWidget {
  final Map<String, dynamic> row;
  final bool lawyer;
  const ConsultationDetail({super.key, required this.row, required this.lawyer});

  @override
  State<ConsultationDetail> createState() => _ConsultationDetailState();
}

class _ConsultationDetailState extends State<ConsultationDetail> {
  late final TextEditingController _reply;
  late String _status;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _reply = TextEditingController(text: (widget.row['reply'] ?? '').toString());
    _status = (widget.row['status'] ?? 'جديد').toString();
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _pickStatus() async {
    final v = await pickFromList(
      context,
      'حالة الاستشارة',
      [for (final t in ['جديد', 'قيد المراجعة', 'تم الرد', 'مغلق']) MapEntry<String, String>(t, t)],
    );
    if (v != null) setState(() => _status = v);
  }

  Future<void> _save() async {
    final text = _reply.text.trim();
    var status = _status;
    if (text.isNotEmpty && (status == 'جديد' || status == 'قيد المراجعة')) {
      status = 'تم الرد';
    }
    setState(() => _saving = true);
    try {
      await db
          .from('consultations')
          .update({'reply': text, 'status': status})
          .eq('id', widget.row['id']);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        toast(context, 'تعذّر الحفظ');
      }
    }
  }

  Widget _block(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(height: 1.6)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.row;
    final client = relName(r['profiles'], 'full_name');
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    (r['subject'] ?? '').toString(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                StatusChip(_status),
              ],
            ),
            const SizedBox(height: 14),
            _block('الخدمة', (r['category'] ?? '').toString()),
            if (widget.lawyer) _block('العميل', client),
            _block('التفاصيل', (r['details'] ?? '').toString()),
            if (widget.lawyer) ...[
              AppField(controller: _reply, label: 'ردّك على العميل', maxLines: 4),
              PickerField(label: 'الحالة', value: _status, onTap: _pickStatus),
              PrimaryButton(label: 'حفظ الرد', icon: Icons.check, loading: _saving, onPressed: _save),
            ] else
              _block('رد المكتب', (r['reply'] ?? '').toString().isEmpty ? 'لم يتم الرد بعد' : (r['reply']).toString()),
          ],
        ),
      ),
    );
  }
}

class ConsultationsPage extends StatefulWidget {
  final bool lawyer;
  const ConsultationsPage({super.key, required this.lawyer});

  @override
  State<ConsultationsPage> createState() => _ConsultationsPageState();
}

class _ConsultationsPageState extends State<ConsultationsPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final data = await db
        .from('consultations')
        .select('*, profiles(full_name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _open(Map<String, dynamic> r) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      builder: (_) => ConsultationDetail(row: r, lawyer: widget.lawyer),
    );
    if (ok == true) _reload();
  }

  Future<void> _new() async {
    await openConsultationRequest(context, null);
    _reload();
  }

  Widget _tile(Map<String, dynamic> r) {
    final client = relName(r['profiles'], 'full_name');
    final parts = <String>[
      (r['category'] ?? '').toString(),
      if (widget.lawyer && client.isNotEmpty) client,
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
            child: const Icon(Icons.chat_bubble_outline, color: AppColors.blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (r['subject'] ?? '').toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 3),
                Text(
                  parts.join(' • '),
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                Text(
                  fmtDateTime(r['created_at']),
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
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
          ? null
          : FloatingActionButton.extended(
              onPressed: _new,
              icon: const Icon(Icons.add),
              label: const Text('طلب استشارة'),
            ),
      body: RefreshIndicator(
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
                    icon: Icons.chat_bubble_outline,
                    text: widget.lawyer
                        ? 'لا توجد استشارات واردة بعد'
                        : 'لم ترسل أي استشارة بعد.\nاضغط «طلب استشارة» لإرسال أول استفسار.',
                  ),
                ],
              );
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [for (final r in rows) _tile(r)],
            );
          },
        ),
      ),
    );
  }
}

class BookingsPage extends StatefulWidget {
  final bool lawyer;
  const BookingsPage({super.key, required this.lawyer});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final data = await db
        .from('appointments')
        .select('*, profiles(full_name)')
        .order('requested_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _book() async {
    await openBookingRequest(context);
    _reload();
  }

  Future<void> _changeStatus(Map<String, dynamic> r) async {
    if (!widget.lawyer) return;
    final v = await pickFromList(
      context,
      'حالة طلب الموعد',
      [for (final t in ['قيد المراجعة', 'مؤكد', 'مرفوض', 'منتهي']) MapEntry<String, String>(t, t)],
    );
    if (v == null) return;
    try {
      await db.from('appointments').update({'status': v}).eq('id', r['id']);
      _reload();
    } catch (_) {
      if (mounted) toast(context, 'تعذّر التحديث');
    }
  }

  Widget _tile(Map<String, dynamic> r) {
    final client = relName(r['profiles'], 'full_name');
    final topic = (r['topic'] ?? '').toString();
    return Panel(
      onTap: widget.lawyer ? () => _changeStatus(r) : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.event_available, color: AppColors.gold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.isEmpty ? 'طلب حجز موعد' : topic,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 3),
                Text(
                  fmtDateTime(r['requested_at']),
                  style: const TextStyle(fontSize: 12, color: AppColors.gold),
                ),
                if (widget.lawyer && client.isNotEmpty)
                  Text(client, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
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
          ? null
          : FloatingActionButton.extended(
              onPressed: _book,
              icon: const Icon(Icons.add),
              label: const Text('حجز موعد'),
            ),
      body: RefreshIndicator(
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
                    icon: Icons.event_busy,
                    text: widget.lawyer
                        ? 'لا توجد طلبات حجز بعد'
                        : 'لا توجد طلبات حجز.\nاضغط «حجز موعد» لتحديد موعد مع المحامي.',
                  ),
                ],
              );
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [for (final r in rows) _tile(r)],
            );
          },
        ),
      ),
    );
  }
}

class ClientAppointmentsPage extends StatelessWidget {
  const ClientAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          PageHeader(title: 'المواعيد', subtitle: 'جلسات قضاياك وطلبات الحجز'),
          TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.muted,
            dividerColor: Colors.transparent,
            tabs: [Tab(text: 'الجلسات'), Tab(text: 'طلبات الحجز')],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SessionsPage(lawyer: false, showHeader: false),
                BookingsPage(lawyer: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestsPage extends StatelessWidget {
  final int initialTab;
  const RequestsPage({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('الطلبات الواردة'),
      ),
      body: Backdrop(
        child: SafeArea(
          child: DefaultTabController(
            length: 2,
            initialIndex: initialTab,
            child: const Column(
              children: [
                TabBar(
                  indicatorColor: AppColors.gold,
                  labelColor: AppColors.gold,
                  unselectedLabelColor: AppColors.muted,
                  dividerColor: Colors.transparent,
                  tabs: [Tab(text: 'الاستشارات'), Tab(text: 'طلبات المواعيد')],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ConsultationsPage(lawyer: true),
                      BookingsPage(lawyer: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _go(BuildContext context, bool signup) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AuthPage(signup: signup)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const FadeSlide(child: BrandMark(size: 56)),
                const SizedBox(height: 16),
                const FadeSlide(
                  delayMs: 250,
                  child: Text(
                    'ميزان',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.gold),
                  ),
                ),
                const SizedBox(height: 28),
                TypewriterText(
                  text: 'مكتب المستشار\nفريد حسام عبدالهادي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w900,
                    height: 1.5,
                    color: AppColors.text,
                    shadows: [
                      Shadow(color: AppColors.gold.withValues(alpha: 0.45), blurRadius: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const FadeSlide(
                  delayMs: 3300,
                  child: Text(
                    'للمحاماة والاستشارات القانونية',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 18),
                const FadeSlide(
                  delayMs: 3700,
                  child: Text(
                    '«نحن معك في كل خطوة نحو حقك»',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.gold),
                  ),
                ),
                const Spacer(flex: 3),
                FadeSlide(
                  delayMs: 1200,
                  child: PrimaryButton(
                    label: 'تسجيل الدخول',
                    icon: Icons.login,
                    onPressed: () => _go(context, false),
                  ),
                ),
                const SizedBox(height: 12),
                FadeSlide(
                  delayMs: 1400,
                  child: GhostButton(
                    label: 'إنشاء حساب جديد',
                    icon: Icons.person_add_alt,
                    onPressed: () => _go(context, true),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  final bool signup;
  const AuthPage({super.key, this.signup = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  late bool _signup;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _signup = widget.signup;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    _pass2.dispose();
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
    if (_signup) {
      if (_name.text.trim().isEmpty) {
        toast(context, 'اكتب الاسم الكامل');
        return;
      }
      if (pass != _pass2.text) {
        toast(context, 'كلمتا المرور غير متطابقتين');
        return;
      }
    }
    setState(() => _loading = true);
    try {
      if (_signup) {
        final res = await db.auth.signUp(
          email: email,
          password: pass,
          data: {'full_name': _name.text.trim(), 'phone': _phone.text.trim()},
        );
        if (!mounted) return;
        if (res.session == null) {
          toast(context, 'تم إنشاء الحساب. أكّد بريدك الإلكتروني ثم سجّل الدخول');
          setState(() => _signup = false);
        } else {
          Navigator.of(context).popUntil((r) => r.isFirst);
        }
      } else {
        await db.auth.signInWithPassword(email: email, password: pass);
        if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
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
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      const BrandMark(size: 38),
                      const SizedBox(height: 14),
                      Text(
                        _signup ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _signup
                            ? 'انضم إلى عملائنا واحصل على خدماتنا القانونية'
                            : 'سجّل دخولك للوصول إلى حسابك',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                      const SizedBox(height: 26),
                      if (_signup)
                        AppField(controller: _name, label: 'الاسم الكامل', icon: Icons.person_outline),
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
                      if (_signup)
                        AppField(
                          controller: _pass2,
                          label: 'تأكيد كلمة المرور',
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                      const SizedBox(height: 8),
                      PrimaryButton(
                        label: _signup ? 'إنشاء الحساب' : 'تسجيل الدخول',
                        icon: _signup ? Icons.person_add_alt : Icons.login,
                        loading: _loading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _loading ? null : () => setState(() => _signup = !_signup),
                        child: Text(
                          _signup ? 'لديك حساب بالفعل؟ تسجيل الدخول' : 'ليس لديك حساب؟ إنشاء حساب جديد',
                          style: const TextStyle(color: AppColors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionsPage extends StatefulWidget {
  final bool lawyer;
  final bool showHeader;
  const SessionsPage({super.key, required this.lawyer, this.showHeader = true});

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
          if (widget.showHeader)
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
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _index = 0;

  void _go(int i) {
    setState(() => _index = i);
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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
        return LawyerDashboard(
          name: widget.name,
          onGo: _go,
          onMenu: () => _key.currentState?.openDrawer(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: AppDrawer(
        name: widget.name,
        email: db.auth.currentUser?.email ?? '',
        onLogout: () => db.auth.signOut(),
        entries: [
          DrawerEntry(Icons.dashboard_outlined, 'لوحة المكتب', () => _go(0)),
          DrawerEntry(Icons.people_outline, 'العملاء', () => _go(1)),
          DrawerEntry(Icons.folder_outlined, 'القضايا', () => _go(2)),
          DrawerEntry(Icons.event_outlined, 'الجلسات', () => _go(3)),
          DrawerEntry(Icons.inbox_outlined, 'الطلبات الواردة', () => _push(const RequestsPage())),
          DrawerEntry(Icons.notifications_none, 'الإشعارات', () => _push(const NotificationsPage())),
          DrawerEntry(Icons.person_outline, 'حسابي', () => _go(4)),
        ],
      ),
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

class LawyerDashboard extends StatefulWidget {
  final String name;
  final void Function(int) onGo;
  final VoidCallback onMenu;
  const LawyerDashboard({
    super.key,
    required this.name,
    required this.onGo,
    required this.onMenu,
  });

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
    final newConsults = await db.from('consultations').select('id').eq('status', 'جديد');
    final pendingBookings = await db.from('appointments').select('id').eq('status', 'قيد المراجعة');
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
      'consults': (newConsults as List).length,
      'bookings': (pendingBookings as List).length,
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

  Future<void> _openRequests(int tab) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RequestsPage(initialTab: tab)),
    );
    _reload();
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
              OfficeHeader(onMenu: widget.onMenu),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  'مرحبًا$first',
                  style: const TextStyle(fontSize: 16, color: AppColors.muted),
                ),
              ),
              const FadeSlide(child: HeroBanner()),
              const SizedBox(height: 14),
              if (snap.hasError)
                ErrorBox(error: snap.error!, onRetry: _reload)
              else
                FadeSlide(
                  delayMs: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: 'العملاء',
                          value: data == null ? '-' : data['clients'].toString(),
                          onTap: () => widget.onGo(1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatTile(
                          label: 'القضايا',
                          value: data == null ? '-' : data['cases'].toString(),
                          onTap: () => widget.onGo(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatTile(
                          label: 'جلسات قادمة',
                          value: data == null ? '-' : upcoming.length.toString(),
                          onTap: () => widget.onGo(3),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              FadeSlide(
                delayMs: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: ActionPill(
                        title: 'استشارات جديدة',
                        subtitle: data == null ? '...' : '${data['consults']} بانتظار الرد',
                        icon: Icons.chat_bubble_outline,
                        filled: true,
                        onTap: () => _openRequests(0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ActionPill(
                        title: 'طلبات المواعيد',
                        subtitle: data == null ? '...' : '${data['bookings']} قيد المراجعة',
                        icon: Icons.event_available,
                        filled: false,
                        onTap: () => _openRequests(1),
                      ),
                    ),
                  ],
                ),
              ),
              const SectionTitle('إجراءات سريعة'),
              _action(Icons.create_new_folder_outlined, 'إضافة قضية جديدة', _addCase),
              _action(Icons.event_note_outlined, 'إضافة جلسة', _addSession),
              const SectionTitle('أقرب الجلسات'),
              if (data != null && upcoming.isEmpty)
                const EmptyState(icon: Icons.event_available, text: 'لا توجد جلسات قادمة'),
              for (final s in upcoming.take(3))
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
              const LatestNotifications(),
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
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _index = 0;

  void _go(int i) {
    setState(() => _index = i);
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _page() {
    switch (_index) {
      case 1:
        return const ClientAppointmentsPage();
      case 2:
        return const CasesPage(lawyer: false);
      case 3:
        return const ServicesPage();
      case 4:
        return const AccountPage(lawyer: false);
      default:
        return ClientDashboard(
          name: widget.name,
          onGo: _go,
          onMenu: () => _key.currentState?.openDrawer(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: AppDrawer(
        name: widget.name,
        email: db.auth.currentUser?.email ?? '',
        onLogout: () => db.auth.signOut(),
        entries: [
          DrawerEntry(Icons.person_outline, 'الملف الشخصي', () => _go(4)),
          DrawerEntry(Icons.folder_outlined, 'قضاياي', () => _go(2)),
          DrawerEntry(Icons.event_outlined, 'المواعيد', () => _go(1)),
          DrawerEntry(
            Icons.chat_bubble_outline,
            'الاستشارات',
            () => _push(const StandalonePage(title: 'استشاراتي', child: ConsultationsPage(lawyer: false))),
          ),
          DrawerEntry(Icons.notifications_none, 'الإشعارات', () => _push(const NotificationsPage())),
          DrawerEntry(
            Icons.phone_outlined,
            'تواصل معنا',
            () => _push(
              StandalonePage(
                title: 'تواصل معنا',
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [ContactCard()],
                ),
              ),
            ),
          ),
        ],
      ),
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
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule, color: AppColors.gold),
            label: 'المواعيد',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder, color: AppColors.gold),
            label: 'القضايا',
          ),
          NavigationDestination(
            icon: Icon(Icons.balance_outlined),
            selectedIcon: Icon(Icons.balance, color: AppColors.gold),
            label: 'الخدمات',
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
  final VoidCallback onMenu;
  const ClientDashboard({
    super.key,
    required this.name,
    required this.onGo,
    required this.onMenu,
  });

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  late Future<int> _count;

  @override
  void initState() {
    super.initState();
    _count = _loadCount();
  }

  Future<int> _loadCount() async {
    final data = await db.from('cases').select('id');
    return (data as List).length;
  }

  void _reload() {
    setState(() {
      _count = _loadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.name.trim().isEmpty ? '' : '، ${widget.name.trim()}';
    return RefreshIndicator(
      onRefresh: () async {
        _reload();
        try {
          await _count;
        } catch (_) {}
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          OfficeHeader(onMenu: widget.onMenu),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              'مرحبًا$first',
              style: const TextStyle(fontSize: 16, color: AppColors.muted),
            ),
          ),
          const FadeSlide(child: HeroBanner()),
          const SizedBox(height: 14),
          FadeSlide(
            delayMs: 200,
            child: Row(
              children: [
                Expanded(
                  child: ActionPill(
                    title: 'طلب استشارة',
                    subtitle: 'أرسل استفسارك الآن',
                    icon: Icons.chat_bubble_outline,
                    filled: true,
                    onTap: () => openConsultationRequest(context, null),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ActionPill(
                    title: 'حجز موعد',
                    subtitle: 'لتحديد موعد مع المحامي',
                    icon: Icons.calendar_month_outlined,
                    filled: false,
                    onTap: () => openBookingRequest(context),
                  ),
                ),
              ],
            ),
          ),
          SectionTitle('خدماتنا القانونية', actionLabel: 'جميع الخدمات', onAction: () => widget.onGo(3)),
          const ServicesGrid(),
          const SizedBox(height: 14),
          FadeSlide(
            delayMs: 600,
            child: Panel(
              onTap: () => widget.onGo(2),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.18),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.6)),
                    ),
                    child: const Icon(Icons.folder_open, color: AppColors.gold),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('قضاياي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 2),
                        Text(
                          'تابع حالة جميع قضاياك ومواعيدها',
                          style: TextStyle(fontSize: 12, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<int>(
                    future: _count,
                    builder: (context, snap) {
                      final v = snap.hasData ? snap.data.toString() : '-';
                      return Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blueDark,
                            ),
                            child: Text(v, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                          ),
                          const SizedBox(height: 2),
                          const Text('عدد القضايا', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const LatestNotifications(),
          const SizedBox(height: 10),
          const FadeSlide(delayMs: 700, child: ContactCard()),
        ],
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
      title: 'ميزان',
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
        if (session == null) return const WelcomePage();
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
          return const Scaffold(
            body: Backdrop(child: Center(child: BrandMark(size: 48))),
          );
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
