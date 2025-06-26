# معاذ AI - دليل الخادم المستقل

## 🎯 نظرة عامة

هذا الدليل يوضح كيفية نشر معاذ AI كخادم مستقل يعمل 24/7 بدون الحاجة لتدخل يدوي أو اعتماد على منصات التطوير.

## 🚀 طرق النشر

### الطريقة الأولى: نشر مباشر على خادم Linux

#### المتطلبات
- خادم Ubuntu/Debian 20.04 أو أحدث
- ذاكرة وصول عشوائي: 2GB على الأقل
- مساحة تخزين: 10GB على الأقل
- اتصال إنترنت مستقر

#### خطوات التثبيت

1. **رفع الملفات للخادم**
```bash
# نسخ المشروع للخادم
scp -r . user@your-server:/home/user/moaaz-ai/
ssh user@your-server
cd /home/user/moaaz-ai/
```

2. **تشغيل سكريبت النشر التلقائي**
```bash
# إعطاء صلاحيات التنفيذ
chmod +x standalone-deploy.sh

# تشغيل النشر (يتطلب صلاحيات sudo)
sudo ./standalone-deploy.sh
```

3. **التحقق من التشغيل**
```bash
# فحص حالة الخدمة
systemctl status moaaz-ai

# فحص اللوقات
journalctl -u moaaz-ai -f

# فحص الاتصال
curl http://localhost:5000/health
```

#### إدارة الخدمة
```bash
# بدء الخدمة
sudo systemctl start moaaz-ai

# إيقاف الخدمة
sudo systemctl stop moaaz-ai

# إعادة تشغيل
sudo systemctl restart moaaz-ai

# تمكين التشغيل التلقائي
sudo systemctl enable moaaz-ai

# عرض الحالة
sudo systemctl status moaaz-ai
```

### الطريقة الثانية: نشر باستخدام Docker

#### المتطلبات
- Docker Engine 20.10 أو أحدث
- Docker Compose v2.0 أو أحدث
- ذاكرة وصول عشوائي: 4GB على الأقل

#### خطوات التثبيت

1. **إعداد Docker**
```bash
# تثبيت Docker (Ubuntu/Debian)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# تثبيت Docker Compose
sudo apt-get install docker-compose-plugin
```

2. **بناء وتشغيل الحاويات**
```bash
# بناء الصورة
docker-compose build

# تشغيل جميع الخدمات
docker-compose up -d

# مراقبة اللوقات
docker-compose logs -f moaaz-ai
```

3. **التحقق من التشغيل**
```bash
# فحص حالة الحاويات
docker-compose ps

# فحص صحة التطبيق
curl http://localhost/health

# الوصول لوحة المراقبة
curl http://localhost:9090
```

#### إدارة Docker
```bash
# إيقاف جميع الخدمات
docker-compose down

# إعادة تشغيل خدمة معينة
docker-compose restart moaaz-ai

# عرض استخدام الموارد
docker stats

# تنظيف النظام
docker system prune -a
```

## 🔧 الإعدادات المتقدمة

### متغيرات البيئة

قم بإنشاء ملف `.env` في الجذر:

```bash
# إعدادات التطبيق
NODE_ENV=production
PORT=5000
PERMANENT_SERVICE=true

# قاعدة البيانات
DATABASE_URL=postgresql://username:password@localhost:5432/moaazai

# Telegram Bot
TELEGRAM_BOT_TOKEN=your_bot_token_here

# مفتاح Google AI (اختياري)
GOOGLE_AI_API_KEY=your_google_ai_key_here

# كلمة مرور الحماية
ADMIN_PASSWORD=your_secure_password
```

### إعداد SSL/HTTPS

1. **الحصول على شهادة SSL**
```bash
# تثبيت Certbot
sudo apt install certbot

# الحصول على شهادة للدومين
sudo certbot certonly --standalone -d yourdomain.com
```

2. **تحديث إعدادات Nginx**
```bash
# نسخ الشهادات
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem nginx/ssl/key.pem

# إعادة تشغيل Nginx
docker-compose restart nginx
```

### إعداد النطاق المخصص

1. **في إعدادات DNS**
```
A Record: yourdomain.com → your_server_ip
CNAME: www.yourdomain.com → yourdomain.com
```

2. **تحديث Nginx config**
```nginx
server_name yourdomain.com www.yourdomain.com;
```

## 📊 المراقبة والصيانة

### وحة المراقبة
- **Prometheus**: http://your-domain:9090
- **System Status**: http://your-domain/api/system-status
- **Health Check**: http://your-domain/health

### النسخ الاحتياطية

النسخ الاحتياطية تتم تلقائياً كل يوم الساعة 2:00 صباحاً:

```bash
# مراجعة النسخ الاحتياطية
ls -la /var/backups/moaaz-ai/

# استرداد من نسخة احتياطية
sudo /usr/local/bin/moaaz-ai-backup.sh restore backup_file.tar.gz
```

### اللوقات والتشخيص

```bash
# لوقات التطبيق
sudo journalctl -u moaaz-ai -f

# لوقات المراقبة
sudo tail -f /var/log/moaaz-ai-monitor.log

# لوقات النسخ الاحتياطية
sudo tail -f /var/log/moaaz-ai-backup.log

# استخدام الموارد
htop
```

## 🔒 الأمان

### إعدادات جدار الحماية
```bash
# فحص حالة UFW
sudo ufw status

# إضافة قواعد جديدة
sudo ufw allow from trusted_ip to any port 22
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### تحديثات الأمان
```bash
# تحديث النظام
sudo apt update && sudo apt upgrade -y

# تحديث Docker images
docker-compose pull
docker-compose up -d
```

## 🚨 استكشاف الأخطاء

### مشاكل شائعة

1. **التطبيق لا يستجيب**
```bash
# فحص حالة الخدمة
systemctl status moaaz-ai

# إعادة تشغيل
sudo systemctl restart moaز-ai

# فحص اللوقات
journalctl -u moaaz-ai --no-pager
```

2. **قاعدة البيانات لا تعمل**
```bash
# فحص اتصال PostgreSQL
sudo -u postgres psql -c "SELECT version();"

# إعادة تشغيل PostgreSQL
sudo systemctl restart postgresql
```

3. **مساحة القرص ممتلئة**
```bash
# فحص المساحة
df -h

# تنظيف اللوقات القديمة
sudo journalctl --vacuum-time=7d

# تنظيف Docker
docker system prune -a
```

### اختبار الأداء

```bash
# اختبار الضغط
ab -n 1000 -c 10 http://localhost/health

# مراقبة استخدام الموارد
iostat -x 1
```

## 📞 الدعم التقني

### معلومات مهمة للدعم
- إصدار النظام: `cat /etc/os-release`
- إصدار Node.js: `node -v`
- إصدار Docker: `docker --version`
- لوقات الأخطاء: `/var/log/moaaz-ai-*.log`

### تجميع معلومات التشخيص
```bash
# سكريبت جمع المعلومات
curl -s http://localhost:5000/api/system-status | jq . > system-info.json
systemctl status moaaz-ai > service-status.txt
journalctl -u moaaz-ai --no-pager > service-logs.txt
```

## 🎉 الخلاصة

بعد اتباع هذا الدليل، ستحصل على:

✅ خادم معاذ AI يعمل 24/7 بشكل مستقل
✅ نظام مراقبة متقدم ومراقبة الأداء
✅ نسخ احتياطية تلقائية يومية
✅ نظام أمان متقدم مع جدار حماية
✅ إعادة تشغيل تلقائية عند الأخطاء
✅ واجهة مراقبة ويب
✅ دعم SSL/HTTPS
✅ نظام لوقات متقدم

الخادم الآن جاهز للعمل بشكل مستقل بدون الحاجة لأي تدخل يدوي!