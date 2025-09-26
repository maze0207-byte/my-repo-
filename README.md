
# FileMon GUI – Bash File Management & System Monitoring Tool

## 📖 Introduction / المقدمة
**English:**  
FileMon GUI is a comprehensive **Bash script** with a graphical user interface built using **Zenity**.  
It provides powerful tools for **file management** and **system monitoring** in Linux systems.  
With FileMon GUI, you can easily create, copy, move, rename, and delete files and directories, manage permissions, back up data, and monitor system performance in real-time.  
The project is designed to be **beginner-friendly** while covering essential system administration tasks.

**العربية:**  
FileMon GUI هو **سكريبت Bash متكامل** بواجهة رسومية تم بناؤها باستخدام **Zenity**.  
يوفر أدوات قوية لإدارة **الملفات والمجلدات** ومراقبة **أداء النظام** على أنظمة Linux.  
من خلال FileMon GUI يمكنك بسهولة إنشاء ونسخ ونقل وإعادة تسمية وحذف الملفات والمجلدات، إدارة صلاحيات الملفات، إنشاء نسخ احتياطية، ومراقبة أداء النظام بشكل لحظي.  
تم تصميم المشروع ليكون **سهل الاستخدام للمبتدئين** مع تغطية المهام الأساسية لمسؤول النظام.

---

## 📝 Quick Summary / ملخص سريع
This tool combines **two main modules**:
1. **File Management Module** – Create, organize, search, and back up your files securely.
2. **System Monitoring Module** – View CPU, memory, and disk statistics, and generate reports.

**البرنامج يتكون من قسمين أساسيين:**
1. **وحدة إدارة الملفات** – لإنشاء وتنظيم الملفات والبحث فيها وأخذ نسخ احتياطية بأمان.
2. **وحدة مراقبة النظام** – لعرض حالة المعالج، الذاكرة، والتخزين مع إمكانية إنشاء تقارير.

---

## ⚙️ Features / المميزات
- **File Operations / عمليات الملفات:**
  - Create, Copy, Move, Rename, and Delete files & directories.
  - إنشاء، نسخ، نقل، إعادة تسمية، وحذف الملفات والمجلدات.

- **Search / البحث:**
  - Search files by **name, type, size, or modification date**.
  - البحث عن الملفات حسب **الاسم، النوع، الحجم، أو تاريخ التعديل**.

- **Permissions Management / إدارة الصلاحيات:**
  - Change file permissions (`chmod`).
  - تغيير صلاحيات الملفات.
  - Change file ownership (`chown`).
  - تغيير ملكية الملفات.

- **Backup & Restore / النسخ الاحتياطي والاسترجاع:**
  - Create backups using `tar`.
  - إنشاء نسخ احتياطية باستخدام tar.
  - Restore backups easily.
  - استرجاع النسخ الاحتياطية بسهولة.

- **System Monitoring / مراقبة النظام:**
  - View **CPU**, **Memory**, and **Disk usage**.
  - عرض **المعالج، الذاكرة، والمساحة التخزينية**.
  - Generate and save a detailed **system report**.
  - إنشاء وحفظ تقرير شامل عن النظام.

---

## 🖥️ Requirements / المتطلبات
Install dependencies before running the program:
```
sudo apt update && sudo apt install zenity tar
```

---

## 🚀 How to Run / كيفية التشغيل
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/filemon-gui.git
   cd filemon-gui
   ```
2. Make the script executable:
   ```bash
   chmod +x filemon_gui.sh
   ```
3. Run the script:
   ```bash
   ./filemon_gui.sh
   ```

---

## 📂 Project Structure / هيكلة المشروع
```
filemon-gui/
│
├── filemon_gui.sh     # Main Bash script / السكربت الرئيسي
├── README.md          # Documentation / ملف التوثيق
└── logs/              # Hidden folder for logs / مجلد السجلات المخفي
```

---

## 🔍 Functions Explanation / شرح الدوال
### 1. `create_file`
**English:**  
Creates a new file in a specified directory.  
**Usage:** Prompts the user to input a file name and location.

**العربية:**  
تقوم هذه الدالة بإنشاء ملف جديد في مجلد يحدده المستخدم.  
**الاستخدام:** تطلب من المستخدم إدخال اسم الملف ومكان إنشائه.

---

### 2. `create_directory`
**English:**  
Creates a new directory at the specified location.

**العربية:**  
تنشئ مجلد جديد في الموقع الذي يختاره المستخدم.

---

### 3. `copy_item`
**English:**  
Copies files or directories from one location to another.

**العربية:**  
تنسخ ملف أو مجلد من موقع إلى آخر.

---

### 4. `move_item`
**English:**  
Moves files or directories to a new location.

**العربية:**  
تنقل ملف أو مجلد من مكان إلى آخر.

---

### 5. `rename_item`
**English:**  
Renames a file or directory safely, with confirmation.

**العربية:**  
تقوم بإعادة تسمية ملف أو مجلد مع تأكيد العملية لتجنب الأخطاء.

---

### 6. `delete_item`
**English:**  
Deletes a file or directory permanently.  
**Includes a confirmation prompt.**

**العربية:**  
تحذف ملف أو مجلد بشكل نهائي.  
**تحتوي على طلب تأكيد قبل الحذف.**

---

### 7. `search_files`
**English:**  
Searches for files based on criteria like name, type, size, or modification date.

**العربية:**  
تبحث عن الملفات بناءً على معايير مثل الاسم، النوع، الحجم، أو تاريخ التعديل.

---

### 8. `change_permissions`
**English:**  
Updates file permissions using `chmod`.

**العربية:**  
تقوم بتغيير صلاحيات الملفات باستخدام أمر `chmod`.

---

### 9. `change_ownership`
**English:**  
Updates file ownership (user/group) using `chown`.  
Requires `sudo` permissions.

**العربية:**  
تغيير ملكية الملفات (مستخدم/مجموعة) باستخدام أمر `chown`.  
تحتاج إلى صلاحيات `sudo`.

---

### 10. `create_backup`
**English:**  
Creates a compressed backup of selected files or directories using `tar`.

**العربية:**  
إنشاء نسخة احتياطية مضغوطة للملفات أو المجلدات باستخدام `tar`.

---

### 11. `restore_backup`
**English:**  
Restores a backup to its original location.

**العربية:**  
استرجاع النسخة الاحتياطية إلى مكانها الأصلي.

---

### 12. `system_info`
**English:**  
Displays basic system information like hostname, uptime, and OS version.

**العربية:**  
تعرض معلومات أساسية عن النظام مثل اسم الجهاز، مدة التشغيل، ونوع نظام التشغيل.

---

### 13. `cpu_monitor`
**English:**  
Shows current CPU usage in real-time.

**العربية:**  
تظهر استخدام المعالج بشكل لحظي.

---

### 14. `mem_monitor`
**English:**  
Displays memory usage (total, used, free).

**العربية:**  
تعرض حالة الذاكرة (الإجمالي، المستخدم، المتاح).

---

### 15. `disk_monitor`
**English:**  
Shows disk usage for all mounted filesystems.

**العربية:**  
تعرض حالة المساحة التخزينية للأقراص.

---

### 16. `generate_report`
**English:**  
Generates a full report of system performance and saves it as a file.

**العربية:**  
إنشاء تقرير شامل عن أداء النظام وحفظه كملف.

---

## 🔒 Security Notes / ملاحظات الأمان
- Logs are stored in a hidden folder (`~/.filemon/logs`) with **strict permissions (600)**.
- السجلات تحفظ في مجلد مخفي بصلاحيات مقيدة لحماية البيانات.
- Critical operations like file deletion require **confirmation prompts**.
- عمليات خطيرة مثل الحذف تتطلب تأكيد المستخدم قبل التنفيذ.

---

## ✍️ Author / المؤلف
Written by **Mazen Ahmed** – A system administrator passionate about automation and Linux administration.  
مكتوب بواسطة **مازن أحمد** – مسؤول أنظمة شغوف بأتمتة المهام وإدارة أنظمة Linux.
