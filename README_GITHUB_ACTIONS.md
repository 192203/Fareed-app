# ميزان V9 — GitHub Actions

هذه النسخة مجهزة لبناء APK من GitHub Actions بدل Codemagic.

## الخطوات

1. ارفع محتويات هذا المشروع إلى Repository جديد على GitHub.
2. اجعل اسم الفرع `main`.
3. افتح تبويب **Actions**.
4. اختر **Mizan Android APK**.
5. اضغط **Run workflow**.
6. بعد نجاح البناء افتح الـworkflow ثم قسم **Artifacts**.
7. نزّل `mizan-release-apk` وستجد داخله `app-release.apk`.

## Supabase
قبل استخدام التطبيق، نفّذ `supabase_schema_v8.sql` في Supabase SQL Editor، وتأكد أن حساب المحامي لديه role = lawyer.

## ملاحظة
GitHub Actions يبني APK فقط؛ لا يحتاج إلى Codemagic.
