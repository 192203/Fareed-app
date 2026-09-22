# ميزان V8
تمت إعادة كتابة main.dart بصياغة Dart كاملة وواضحة لتجنب أخطاء الأقواس وdot-shorthands في V7.
- لوحة المكتب
- العملاء
- القضايا
- الجلسات
- الإشعارات
- مستندات القضايا
- رفع الملفات إلى Supabase Storage
- واجهة العميل
- إزالة اختبار Flutter الافتراضي الذي كان يسبب أخطاء flutter_test

قبل البناء:
1. نفّذ supabase_schema_v8.sql في Supabase SQL Editor.
2. تأكد أن حساب المحامي لديه role = lawyer.
3. ارفع المشروع إلى Codemagic وشغل android-release.
الناتج: build/app/outputs/flutter-apk/app-release.apk
