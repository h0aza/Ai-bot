#!/bin/bash

# معاذ AI - نشر تلقائي على Vercel
# هذا السكريبت ينشر المشروع على Vercel مع جميع الإعدادات المطلوبة

set -e

echo "🚀 بدء نشر معاذ AI على Vercel..."

# التحقق من تثبيت Vercel CLI
check_vercel_cli() {
    if ! command -v vercel &> /dev/null; then
        echo "📦 تثبيت Vercel CLI..."
        npm install -g vercel
    else
        echo "✅ Vercel CLI مثبت"
    fi
}

# دالة تسجيل الدخول
login_vercel() {
    echo "🔐 تسجيل الدخول إلى Vercel..."
    if ! vercel whoami &> /dev/null; then
        echo "يرجى تسجيل الدخول إلى Vercel:"
        vercel login
    else
        echo "✅ مسجل دخول في Vercel"
    fi
}

# دالة إعداد متغيرات البيئة
setup_env_vars() {
    echo "⚙️ إعداد متغيرات البيئة..."
    
    # إنشاء ملف .env.production
    cat > .env.production << EOF
NODE_ENV=production
PERMANENT_SERVICE=true
TELEGRAM_BOT_TOKEN=7046260843:AAHbjuQUa5ONKdcZxaX-CxJyYvBT5Jtar4Y
ADMIN_PASSWORD=moaaz-ai-2025
EOF

    echo "✅ تم إنشاء ملف .env.production"
}

# دالة بناء المشروع
build_project() {
    echo "🔨 بناء المشروع..."
    
    # تنظيف البناء السابق
    rm -rf dist/
    
    # بناء المشروع
    npm run build
    
    if [ $? -eq 0 ]; then
        echo "✅ تم بناء المشروع بنجاح"
    else
        echo "❌ فشل في بناء المشروع"
        exit 1
    fi
}

# دالة النشر على Vercel
deploy_to_vercel() {
    echo "🌐 نشر على Vercel..."
    
    # نشر المشروع
    vercel --prod --yes
    
    if [ $? -eq 0 ]; then
        echo "✅ تم النشر بنجاح على Vercel!"
        
        # الحصول على رابط المشروع
        PROJECT_URL=$(vercel inspect --scope=default 2>/dev/null | grep "URL:" | awk '{print $2}' | head -1)
        if [ -n "$PROJECT_URL" ]; then
            echo "🌐 رابط المشروع: $PROJECT_URL"
            echo "💚 فحص الصحة: $PROJECT_URL/api/health"
        fi
    else
        echo "❌ فشل في النشر على Vercel"
        exit 1
    fi
}

# دالة إعداد الدومين المخصص (اختياري)
setup_custom_domain() {
    read -p "هل تريد إعداد دومين مخصص؟ (y/N): " setup_domain
    
    if [[ $setup_domain =~ ^[Yy]$ ]]; then
        read -p "أدخل الدومين (مثال: moaaz-ai.com): " domain_name
        
        if [ -n "$domain_name" ]; then
            echo "🔗 إضافة الدومين المخصص..."
            vercel domains add "$domain_name"
            echo "✅ تم إضافة الدومين: $domain_name"
            echo "📝 لا تنس تحديث DNS records للدومين"
        fi
    fi
}

# دالة فحص حالة النشر
verify_deployment() {
    echo "🔍 فحص حالة النشر..."
    
    # الحصول على رابط المشروع
    PROJECT_URL=$(vercel ls | grep "moaaz-ai" | awk '{print $2}' | head -1)
    
    if [ -n "$PROJECT_URL" ]; then
        # فحص صحة التطبيق
        HEALTH_URL="https://$PROJECT_URL/api/health"
        
        echo "⏳ انتظار تشغيل الخدمة..."
        sleep 10
        
        if curl -f -s "$HEALTH_URL" > /dev/null; then
            echo "✅ التطبيق يعمل بنجاح!"
            echo "🌐 الرابط الرئيسي: https://$PROJECT_URL"
            echo "💚 فحص الصحة: $HEALTH_URL"
            
            # عرض معلومات إضافية
            echo ""
            echo "📊 معلومات النشر:"
            vercel ls --limit 1
            
        else
            echo "❌ التطبيق لا يستجيب"
            echo "🔍 مراجعة اللوقات:"
            vercel logs
        fi
    else
        echo "❌ لم يتم العثور على رابط المشروع"
    fi
}

# دالة عرض معلومات مفيدة
show_useful_info() {
    echo ""
    echo "🎉 تم نشر معاذ AI على Vercel بنجاح!"
    echo ""
    echo "🛠️ أوامر إدارة مفيدة:"
    echo "  عرض المشاريع: vercel ls"
    echo "  عرض اللوقات: vercel logs"
    echo "  إعادة النشر: vercel --prod"
    echo "  حذف المشروع: vercel remove"
    echo ""
    echo "📝 ملاحظات:"
    echo "  - التطبيق يعمل على Vercel Serverless Functions"
    echo "  - البيانات محفوظة في الذاكرة (تفقد عند إعادة التشغيل)"
    echo "  - لاستخدام قاعدة بيانات دائمة، قم بإعداد Neon أو PlanetScale"
    echo ""
}

# دالة إعداد قاعدة البيانات السحابية (اختياري)
setup_cloud_database() {
    read -p "هل تريد إعداد قاعدة بيانات سحابية؟ (y/N): " setup_db
    
    if [[ $setup_db =~ ^[Yy]$ ]]; then
        echo ""
        echo "📋 خيارات قاعدة البيانات:"
        echo "1) Neon (PostgreSQL مجاني)"
        echo "2) PlanetScale (MySQL مجاني)"
        echo "3) إعداد يدوي لاحقاً"
        echo ""
        read -p "اختيارك (1-3): " db_choice
        
        case $db_choice in
            1)
                echo "🔗 افتح: https://neon.tech"
                echo "📝 أنشئ مشروع جديد واحصل على DATABASE_URL"
                read -p "أدخل DATABASE_URL: " database_url
                if [ -n "$database_url" ]; then
                    vercel env add DATABASE_URL production
                    echo "$database_url" | vercel env add DATABASE_URL production --stdin
                    echo "✅ تم إعداد قاعدة بيانات Neon"
                fi
                ;;
            2)
                echo "🔗 افتح: https://planetscale.com"
                echo "📝 أنشئ قاعدة بيانات جديدة واحصل على DATABASE_URL"
                read -p "أدخل DATABASE_URL: " database_url
                if [ -n "$database_url" ]; then
                    echo "$database_url" | vercel env add DATABASE_URL production --stdin
                    echo "✅ تم إعداد قاعدة بيانات PlanetScale"
                fi
                ;;
            3)
                echo "ℹ️ يمكنك إعداد قاعدة البيانات لاحقاً من لوحة Vercel"
                ;;
        esac
    fi
}

# الدالة الرئيسية
main() {
    echo "🎯 معاذ AI - نشر تلقائي على Vercel"
    echo "================================"
    
    # التحقق من متطلبات النشر
    check_vercel_cli
    login_vercel
    
    # إعداد المشروع
    setup_env_vars
    build_project
    
    # النشر
    deploy_to_vercel
    
    # فحص النشر
    verify_deployment
    
    # إعدادات إضافية
    setup_custom_domain
    setup_cloud_database
    
    # عرض المعلومات النهائية
    show_useful_info
}

# تشغيل السكريبت
main "$@"