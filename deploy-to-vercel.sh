#!/bin/bash

# نشر معاذ AI على Vercel - نقل كامل
echo "🚀 بدء النقل الكامل لمعاذ AI إلى Vercel..."

# التحقق من Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "📦 تثبيت Vercel CLI..."
    npm install -g vercel
fi

echo "✅ جميع الملفات جاهزة للنشر:"
echo "  - vercel.json محسن"
echo "  - API functions في مجلد api/"
echo "  - لوحة إدارة البوت جاهزة"
echo "  - الواجهة مبنية ومحسنة"

echo ""
echo "📋 خطوات النشر:"
echo "1. vercel login (تسجيل دخول)"
echo "2. vercel --prod (النشر)"
echo "3. إعداد متغيرات البيئة في Vercel"
echo "4. إضافة دومين مخصص (اختياري)"

echo ""
echo "🔧 متغيرات البيئة المطلوبة في Vercel:"
echo "NODE_ENV=production"
echo "PERMANENT_SERVICE=true"
echo "TELEGRAM_BOT_TOKEN=7046260843:AAHbjuQUa5ONKdcZxaX-CxJyYvBT5Jtar4Y"
echo "ADMIN_PASSWORD=moaaz-ai-2025"

echo ""
echo "🌐 بعد النشر ستحصل على:"
echo "  - رابط .vercel.app فوري"
echo "  - خادم سحابي مستقل"
echo "  - لوحة إدارة البوت على /admin"
echo "  - عمل 24/7 بدون توقف"

echo ""
echo "المشروع جاهز للنقل الكامل! 🎉"