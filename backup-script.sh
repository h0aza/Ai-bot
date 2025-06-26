#!/bin/bash

# سكريبت النسخ الاحتياطي لمعاذ AI
# ينفذ نسخة احتياطية كاملة للبيانات والإعدادات

set -e

# متغيرات الإعداد
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DATABASE_BACKUP="moaaz-ai-db-$DATE.sql"
APP_BACKUP="moaaz-ai-app-$DATE.tar.gz"
LOG_FILE="/backups/backup.log"

# دالة كتابة اللوقات
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# دالة نسخ قاعدة البيانات
backup_database() {
    log "🗄️ بدء نسخ قاعدة البيانات..."
    
    # نسخ احتياطية من PostgreSQL
    PGPASSWORD=moaaz123 pg_dump \
        -h postgres \
        -U moaaz \
        -d moaazai \
        --no-password \
        --clean \
        --if-exists \
        --create \
        --verbose \
        > "$BACKUP_DIR/$DATABASE_BACKUP" 2>> "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        log "✅ تم إنشاء نسخة قاعدة البيانات: $DATABASE_BACKUP"
        
        # ضغط النسخة الاحتياطية
        gzip "$BACKUP_DIR/$DATABASE_BACKUP"
        log "✅ تم ضغط النسخة الاحتياطية: $DATABASE_BACKUP.gz"
    else
        log "❌ فشل في نسخ قاعدة البيانات"
        return 1
    fi
}

# دالة نسخ ملفات التطبيق
backup_application() {
    log "📁 بدء نسخ ملفات التطبيق..."
    
    # نسخ ملفات التطبيق المهمة
    tar -czf "$BACKUP_DIR/$APP_BACKUP" \
        -C /source_data \
        --exclude='node_modules' \
        --exclude='dist' \
        --exclude='*.log' \
        --exclude='.git' \
        . 2>> "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        log "✅ تم إنشاء نسخة ملفات التطبيق: $APP_BACKUP"
    else
        log "❌ فشل في نسخ ملفات التطبيق"
        return 1
    fi
}

# دالة تنظيف النسخ القديمة
cleanup_old_backups() {
    log "🧹 تنظيف النسخ الاحتياطية القديمة..."
    
    # حذف النسخ الأقدم من 7 أيام
    find "$BACKUP_DIR" -name "moaaz-ai-db-*.sql.gz" -mtime +7 -delete
    find "$BACKUP_DIR" -name "moaaz-ai-app-*.tar.gz" -mtime +7 -delete
    
    # عرض النسخ المتبقية
    local remaining_count=$(find "$BACKUP_DIR" -name "moaaz-ai-*" | wc -l)
    log "📊 عدد النسخ الاحتياطية المتبقية: $remaining_count"
}

# دالة فحص مساحة التخزين
check_storage_space() {
    log "💾 فحص مساحة التخزين..."
    
    local available_space=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')
    local required_space=1048576  # 1GB in KB
    
    if [ "$available_space" -lt "$required_space" ]; then
        log "⚠️ تحذير: مساحة التخزين منخفضة ($available_space KB متاح)"
        # تنظيف إضافي إذا كانت المساحة قليلة
        find "$BACKUP_DIR" -name "moaaz-ai-*" -mtime +3 -delete
        log "🧹 تم تنظيف النسخ الأقدم من 3 أيام"
    else
        log "✅ مساحة التخزين كافية ($available_space KB متاح)"
    fi
}

# دالة إنشاء ملخص النسخة الاحتياطية
create_backup_summary() {
    local summary_file="$BACKUP_DIR/backup-summary-$DATE.txt"
    
    cat > "$summary_file" << EOF
=== ملخص النسخة الاحتياطية ===
التاريخ: $(date '+%Y-%m-%d %H:%M:%S')
الإصدار: معاذ AI v2.0

الملفات المنشأة:
- قاعدة البيانات: $DATABASE_BACKUP.gz
- ملفات التطبيق: $APP_BACKUP

أحجام الملفات:
$(ls -lh "$BACKUP_DIR"/*$DATE* | awk '{print "- " $9 ": " $5}')

حالة النظام:
- حالة التطبيق: $(curl -s http://moaaz-ai:5000/health | jq -r '.status' 2>/dev/null || echo "غير متاح")
- استخدام الذاكرة: $(free -h | awk 'NR==2{printf "%.1f%%", $3/$2*100}')
- مساحة القرص: $(df -h "$BACKUP_DIR" | awk 'NR==2{print $5}')

الملاحظات:
- النسخة الاحتياطية مكتملة بنجاح
- جميع الملفات مضغوطة ومحفوظة
- النسخ القديمة تم تنظيفها تلقائياً
EOF

    log "📋 تم إنشاء ملخص النسخة الاحتياطية: backup-summary-$DATE.txt"
}

# الدالة الرئيسية
main() {
    log "🚀 بدء عملية النسخ الاحتياطي..."
    
    # إنشاء مجلد النسخ الاحتياطية
    mkdir -p "$BACKUP_DIR"
    
    # فحص مساحة التخزين
    check_storage_space
    
    # تنفيذ النسخ الاحتياطية
    backup_database
    backup_application
    
    # تنظيف النسخ القديمة
    cleanup_old_backups
    
    # إنشاء ملخص
    create_backup_summary
    
    log "✅ اكتملت عملية النسخ الاحتياطي بنجاح"
    
    # إحصائيات النهائية
    local total_size=$(du -sh "$BACKUP_DIR" | cut -f1)
    log "📊 إجمالي حجم النسخ الاحتياطية: $total_size"
}

# تنفيذ النسخ الاحتياطي
main "$@"