
# تشغيل السكربت — How to Run FileMon GUI

## ملخص سريع (Arabic) / Quick summary (English)
هذا الملف يشرح خطوة بخطوة طريقة تشغيل سكربت **FileMon GUI** على توزيعات Debian/Ubuntu وما شابهها.  
This file explains step-by-step how to run the **FileMon GUI** script on Debian/Ubuntu-based systems.

---

## 1. المتطلبات الأساسية / Prerequisites
1. توزيعة Debian/Ubuntu أو أي توزيعة تدعم `zenity` و `tar`.  
   Debian/Ubuntu or any distro that supports `zenity` and `tar`.
2. الوصول إلى الطرفية (Terminal) وصلاحيات لإدخال أوامر `sudo` عند الحاجة.  
   Terminal access and sudo privileges when required.

### تثبيت المتطلبات / Install dependencies
افتح الطرفية ونفّذ:
```bash
sudo apt update
sudo apt install -y zenity tar
```
(على توزيعات أخرى: استخدم `dnf` أو `pacman` أو مدير الحزم المناسب.)

---

## 2. نسخ المشروع / Clone the repository
إذا لديك مستودع على GitHub، انسخه محليًا:
```bash
git clone https://github.com/your-username/filemon-gui.git
cd filemon-gui
```
أو انسخ/ألصق ملف `filemon_gui.sh` و`README.md` داخل مجلد جديد.

---

## 3. إعطاء صلاحيات التنفيذ / Make the script executable
```bash
chmod +x filemon_gui.sh
```

> ملاحظة: إذا كتبت السكربت بنفسك داخل محرر، تأكّد من أن السطر الأول (shebang) موجود في أعلى الملف:  
> `#!/usr/bin/env bash`

---

## 4. تشغيل السكربت / Run the script
نفّذ الأمر التالي لتشغيل الواجهة الرسومية:
```bash
./filemon_gui.sh
```
- ستفتح نافذة Zenity تعرض قائمة الخيارات. اختر العملية المطلوبة من القائمة.  
- The Zenity GUI will open showing the menu. Choose the desired operation.

---

## 5. تشغيل بصلاحيات root (اختياري) / Running as root (optional)
بعض العمليات (مثل `chown`) قد تتطلب صلاحيات مرتفعة. يمكنك تشغيل السكربت باستخدام `sudo`:
```bash
sudo ./filemon_gui.sh
```
لكن يُفضّل تشغيل السكربت كمستخدم عادي واستخدام خاصية sudo داخل الدوال فقط عند الحاجة.

---

## 6. مكان سجلات التشغيل والتقارير / Logs and reports location
- السجلات التقنية محفوظة في: `~/.filemon/logs/filemon.log`  
- تقارير النظام تحفظ في: `~/.filemon/reports/`  
- Logs are saved at: `~/.filemon/logs/filemon.log`  
- Reports are saved at: `~/.filemon/reports/`

---

## 7. تشغيل السكربت تلقائيًا عند الإقلاع (اختياري) / Run at startup (optional)
يمكنك إنشاء خدمة systemd بسيطة لتشغيل السكربت (مثال **غير موصى به** لواجهة رسومية؛ مفيد لو كان جزءًا من daemon):
**إنشاء ملف خدمة (مثال):**
```ini
# /etc/systemd/system/filemon.service
[Unit]
Description=FileMon GUI (example service)
After=network.target

[Service]
Type=simple
ExecStart=/home/youruser/filemon-gui/filemon_gui.sh
User=youruser
Environment=DISPLAY=:0
WorkingDirectory=/home/youruser/filemon-gui
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
ثم نفّذ:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now filemon.service
```
> ملاحظة: تشغيل تطبيقات GUI عبر systemd يحتاج إعداد DISPLAY وبيئة سطح المكتب؛ لذلك هذه الطريقة عادةً غير مناسبة للواجهات الرسومية في جلسات المستخدم العادية.

---

## 8. استكشاف الأخطاء وإصلاحها / Troubleshooting
- إذا ظهر خطأ: `zenity: command not found`  
  نفّذ: `sudo apt install zenity`  
- إذا لم يعمل عرض النوافذ (عند الاتصال عبر SSH بدون X forwarding): افتح جلسة على سطح المكتب أو استخدم X11 forwarding:  
  ```bash
  ssh -X user@host
  ```
- لو ظهرت أخطاء خاصة بالصلاحيات عند كتابة السجلات: تأكد من صلاحيات المجلد `~/.filemon`:
  ```bash
  mkdir -p ~/.filemon/logs ~/.filemon/reports
  chmod 700 ~/.filemon
  chmod 600 ~/.filemon/logs/filemon.log || true
  ```

---

## 9. إزالة السكربت / Uninstall / Cleanup
لحذف السكربت والملفات المساعدة (سجلات/تقارير):
```bash
# داخل مجلد المشروع
rm -f filemon_gui.sh
rm -rf ~/.filemon
```
> كن حذرًا — هذا يحذف السجلات والتقارير نهائيًا.

---

## 10. رفع التعديلات إلى GitHub / Commit & Push
بعد إضافة أو تعديل الملفات قم بالخطوات التالية لرفعها إلى GitHub:
```bash
git add filemon_gui.sh README.md RUN.md
git commit -m "Add run instructions and README"
git push origin main
```

---

## 11. مثال عملي سريع / Quick example
```bash
# تثبيت المتطلبات
sudo apt update && sudo apt install -y zenity tar

# تشغيل
chmod +x filemon_gui.sh
./filemon_gui.sh
```

---

إذا تحب، أجهز لك نفس الملف بصيغة Word (.docx) جاهز للرفع أو أضيفه داخل المستودع مباشرة.  
If you want, I can produce the same file in Word (.docx) or add it directly to the repository.
