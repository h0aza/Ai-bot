# معاذ AI - Docker Image للخادم المستقل
FROM node:20-alpine

# تثبيت الأدوات الأساسية
RUN apk add --no-cache \
    curl \
    bash \
    sqlite \
    && rm -rf /var/cache/apk/*

# إنشاء مستخدم غير جذر
RUN addgroup -g 1001 -S moaaz && \
    adduser -S moaaz -u 1001 -G moaaz

# إعداد دليل العمل
WORKDIR /app

# نسخ ملفات package
COPY package*.json ./
COPY tsconfig.json ./

# تثبيت التبعيات
RUN npm ci --only=production && npm cache clean --force

# نسخ ملفات المشروع
COPY shared/ ./shared/
COPY server/ ./server/
COPY client/ ./client/

# بناء المشروع
RUN npm run build

# إنشاء مجلد البيانات
RUN mkdir -p /app/data && chown -R moaaz:moaaz /app/data

# تعديل الصلاحيات
RUN chown -R moaaz:moaaz /app

# التبديل للمستخدم غير الجذر
USER moaaz

# إعداد متغيرات البيئة
ENV NODE_ENV=production
ENV PORT=5000
ENV PERMANENT_SERVICE=true
ENV DATABASE_URL=file:./data/app.db

# كشف المنفذ
EXPOSE 5000

# فحص الصحة
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# أمر التشغيل
CMD ["node", "dist/index.js"]