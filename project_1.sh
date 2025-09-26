#!/usr/bin/env bash
# File: filemon_gui.sh
# Purpose: GUI File Management & System Monitoring tool using zenity
# Author: Generated for user
# Locale: Arabic/English bilingual comments and help included
# ------------------------------------------------------------------
# Short description (EN):
# This script provides a graphical front-end (Zenity) for file & directory
# management operations and lightweight system monitoring (CPU, memory, disk).
# It stores user-facing messages in dialogs and logs technical details to
# a hidden log folder (~/.filemon/) with restricted permissions.
#
# Short description (AR):
# هذا السكربت يوفر واجهة رسومية (Zenity) لإدارة الملفات والمجلدات
# ومراقبة النظام (المعالج، الذاكرة، القرص). يعرض رسائل للمستخدم ويخزن
# تفاصيل الأخطاء داخل مجلد مخفي (~/.filemon/) بصلاحيات مقيدة.
# ------------------------------------------------------------------

# ----------------------------- CONFIG -------------------------------
APP_DIR="$HOME/.filemon"
LOG_DIR="$APP_DIR/logs"
LOG_FILE="$LOG_DIR/filemon.log"
REPORT_DIR="$APP_DIR/reports"
DATE_CMD="$(date +'%Y-%m-%d_%H-%M-%S')"

# Ensure directories exist with safe permissions
mkdir -p "$LOG_DIR" "$REPORT_DIR"
chmod 700 "$APP_DIR" "$LOG_DIR" "$REPORT_DIR"
[[ -f "$LOG_FILE" ]] || touch "$LOG_FILE"
chmod 600 "$LOG_FILE"

# --------------------------- UTILITIES ------------------------------
log(){
  # log technical details to hidden log file (not shown to user)
  local level="$1"; shift
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $*" >> "$LOG_FILE"
}

safe_error(){
  # show friendly message; log details
  local user_msg="$1"; shift
  local detail="$*"
  zenity --error --title="FileMon - Error" --text="$user_msg"
  log "ERROR" "$detail"
}

check_zenity(){
  if ! command -v zenity >/dev/null 2>&1; then
    echo "Zenity is required. Install it with your package manager (e.g. sudo apt install zenity)."
    exit 1
  fi
}

# ------------------------- FILE OPERATIONS --------------------------
create_file(){
  local name
  name=$(zenity --entry --title="Create File" --text="Enter filename (path accepted):") || return
  if [[ -z "$name" ]]; then
    zenity --info --text="Creation cancelled."; return
  fi
  if [[ -e "$name" ]]; then
    safe_error "File already exists." "create_file: target exists: $name"
    return
  fi
  touch -- "$name" 2>/dev/null || { safe_error "Failed to create file." "touch failed for $name"; return; }
  zenity --info --text="File created: $name"
  log "INFO" "create_file: created $name"
}

create_directory(){
  local name
  name=$(zenity --entry --title="Create Directory" --text="Enter directory name (path accepted):") || return
  [[ -z "$name" ]] && { zenity --info --text="Creation cancelled."; return; }
  if [[ -d "$name" ]]; then
    safe_error "Directory already exists." "create_directory: exists: $name"; return
  fi
  mkdir -p -- "$name" 2>/dev/null || { safe_error "Failed to create directory." "mkdir failed for $name"; return; }
  zenity --info --text="Directory created: $name"
  log "INFO" "create_directory: created $name"
}

copy_item(){
  local src dst
  src=$(zenity --file-selection --title="Select source file or directory to copy") || return
  dst=$(zenity --entry --title="Copy To" --text="Enter destination path (folder):") || return
  [[ -z "$dst" ]] && { zenity --info --text="Copy cancelled."; return; }
  cp -a -- "$src" "$dst" 2>/dev/null || { safe_error "Copy failed." "cp failed from $src to $dst"; return; }
  zenity --info --text="Copied to $dst"
  log "INFO" "copy_item: $src -> $dst"
}

move_item(){
  local src dst
  src=$(zenity --file-selection --title="Select source to move") || return
  dst=$(zenity --entry --title="Move To" --text="Enter destination path (folder):") || return
  [[ -z "$dst" ]] && { zenity --info --text="Move cancelled."; return; }
  mv -- "$src" "$dst" 2>/dev/null || { safe_error "Move failed." "mv failed from $src to $dst"; return; }
  zenity --info --text="Moved to $dst"
  log "INFO" "move_item: $src -> $dst"
}

rename_item(){
  local src dst
  src=$(zenity --file-selection --title="Select file or directory to rename") || return
  dst=$(zenity --entry --title="New Name" --text="Enter new path/name:") || return
  [[ -z "$dst" ]] && { zenity --info --text="Rename cancelled."; return; }
  if ! zenity --question --text="Are you sure you want to rename?\n$src -> $dst"; then
    zenity --info --text="Rename cancelled."; return
  fi
  mv -- "$src" "$dst" 2>/dev/null || { safe_error "Rename failed." "mv (rename) failed $src -> $dst"; return; }
  zenity --info --text="Renamed."
  log "INFO" "rename_item: $src -> $dst"
}

delete_item(){
  local target
  target=$(zenity --file-selection --title="Select file or directory to DELETE") || return
  if ! zenity --question --title="Confirm Delete" --text="Permanently delete:\n$target ?"; then
    zenity --info --text="Deletion cancelled."; return
  fi
  rm -rf -- "$target" 2>/dev/null || { safe_error "Delete failed." "rm failed for $target"; return; }
  zenity --info --text="Deleted: $target"
  log "WARN" "delete_item: removed $target"
}

# --------------------------- SEARCH ---------------------------------
search_files(){
  # Criteria form: name, type, size, mtime
  local name type size mtime base cmd result
  base=$(zenity --entry --title="Search base path" --text="Enter directory to search in (default: /):" )
  [[ -z "$base" ]] && base="/"
  name=$(zenity --entry --title="Search filename (pattern)" --text="Use wildcard or leave empty for any:") || return
  type=$(zenity --list --radiolist --title="Type filter" --text="Choose file type:" --column="Pick" --column="Type" TRUE "any" FALSE "file" FALSE "dir" ) || return
  size=$(zenity --entry --title="Size filter" --text="Enter size filter (e.g. +1M for >1MB, -100k for <100KB) or leave empty:") || return
  mtime=$(zenity --entry --title="Modified time" --text="Modify time filter (e.g. -7 for within 7 days) or leave empty:") || return

  cmd=(find "$base" -xdev)
  [[ -n "$name" ]] && cmd+=(-iname "$name")
  if [[ "$type" == "file" ]]; then cmd+=(-type f); elif [[ "$type" == "dir" ]]; then cmd+=(-type d); fi
  [[ -n "$size" ]] && cmd+=(-size "$size")
  [[ -n "$mtime" ]] && cmd+=(-mtime "$mtime")

  # Run command and show results
  result=$( "${cmd[@]}" 2>/dev/null | zenity --text-info --title="Search Results" --width=700 --height=400 ) || true
  log "INFO" "search_files: base=$base name=$name type=$type size=$size mtime=$mtime"
}

# ---------------------- PERMISSIONS & OWNERSHIP ---------------------
change_permissions(){
  local target mode
  target=$(zenity --file-selection --title="Select target to change permissions") || return
  mode=$(zenity --entry --title="Permissions (chmod)" --text="Enter permission mode (e.g. 644 or u+rwx):") || return
  chmod "$mode" "$target" 2>/dev/null || { safe_error "chmod failed." "chmod $mode $target failed"; return; }
  zenity --info --text="Permissions updated."
  log "INFO" "change_permissions: $target -> $mode"
}

change_ownership(){
  local target owner
  target=$(zenity --file-selection --title="Select target to change ownership") || return
  owner=$(zenity --entry --title="chown" --text="Enter owner[:group] (e.g. user:group):") || return
  if ! command -v sudo >/dev/null 2>&1; then safe_error "sudo not available" "chown needs sudo"; return; fi
  sudo chown "$owner" "$target" 2>/dev/null || { safe_error "chown failed." "chown $owner $target failed"; return; }
  zenity --info --text="Ownership changed."
  log "INFO" "change_ownership: $target -> $owner"
}

# ------------------------- BACKUP / RESTORE -------------------------
create_backup(){
  local src dest
  src=$(zenity --file-selection --directory --title="Choose folder to backup") || return
  dest="$REPORT_DIR/backup_${DATE_CMD}.tar.gz"
  tar -czf "$dest" -C "$src" . 2>/dev/null || { safe_error "Backup failed." "tar failed for $src -> $dest"; return; }
  zenity --info --text="Backup created: $dest"
  log "INFO" "create_backup: $src -> $dest"
}

restore_backup(){
  local archive dst
  archive=$(zenity --file-selection --title="Select backup archive (.tar.gz)") || return
  dst=$(zenity --entry --title="Restore To" --text="Enter destination folder (must exist):") || return
  if [[ ! -d "$dst" ]]; then safe_error "Destination does not exist." "restore: dst missing: $dst"; return; fi
  tar -xzf "$archive" -C "$dst" 2>/dev/null || { safe_error "Restore failed." "tar xzf $archive to $dst failed"; return; }
  zenity --info --text="Restore completed."
  log "INFO" "restore_backup: $archive -> $dst"
}

# ------------------------- SYSTEM METRICS ---------------------------
system_info(){
  local info
  info="OS: $(uname -s) $(uname -r)\nHost: $(hostname)\nUptime: $(uptime -p)\nDate: $(date)"
  zenity --info --title="System Info" --text="$info"
  log "INFO" "system_info displayed"
}

cpu_monitor(){
  # Quick snapshot of CPU usage (percentage) using /proc/stat
  local cpu user nice system idle iowait irq softirq steal total idle_delta total_delta usage
  read -r cpu user nice system idle iowait irq softirq steal guest <<< $(awk '/^cpu / {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat)
  total=$((user+nice+system+idle+iowait+irq+softirq+steal))
  idle_total=$((idle+iowait))
  # take two samples for delta
  sleep 1
  read -r cpu2 user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 guest2 <<< $(awk '/^cpu / {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat)
  total2=$((user2+nice2+system2+idle2+iowait2+irq2+softirq2+steal2))
  idle_total2=$((idle2+iowait2))
  total_delta=$((total2-total))
  idle_delta=$((idle_total2-idle_total))
  if [[ $total_delta -eq 0 ]]; then usage=0; else usage=$(( (100*(total_delta-idle_delta))/total_delta )); fi
  zenity --info --title="CPU Usage" --text="CPU usage: $usage%"
  log "INFO" "cpu_monitor: ${usage}%"
}

mem_monitor(){
  # Using /proc/meminfo
  local total free available used
  total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  available=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
  used=$((total-available))
  # convert to MB
  total_mb=$((total/1024))
  used_mb=$((used/1024))
  available_mb=$((available/1024))
  zenity --info --title="Memory Usage" --text="Total: ${total_mb}MB\nUsed: ${used_mb}MB\nAvailable: ${available_mb}MB"
  log "INFO" "mem_monitor: total=${total_mb} used=${used_mb} available=${available_mb}"
}

disk_monitor(){
  df -h --output=source,size,used,avail,pcent,target | zenity --text-info --title="Disk Usage" --width=700 --height=400
  log "INFO" "disk_monitor displayed"
}

generate_report(){
  local out="$REPORT_DIR/system_report_${DATE_CMD}.txt"
  {
    echo "System Report - $DATE_CMD"
    echo "$(uname -a)"
    echo "Uptime: $(uptime -p)"
    echo
    echo "CPU:"; top -bn1 | head -n5
    echo; echo "Memory:"; free -h
    echo; echo "Disk:"; df -h
  } > "$out"
  zenity --info --text="Report saved: $out"
  log "INFO" "generate_report: $out"
}

# -------------------------- MAIN MENU -------------------------------
main_menu(){
  while true; do
    choice=$(zenity --list --title="FileMon - Main Menu" --column="Option" --width=700 --height=450 \
      "File operations: Create file" \
      "File operations: Create directory" \
      "File operations: Copy" \
      "File operations: Move" \
      "File operations: Rename" \
      "File operations: Delete" \
      "Search files" \
      "Permissions: chmod" \
      "Permissions: chown" \
      "Backup: create" \
      "Backup: restore" \
      "System: info" \
      "System: CPU" \
      "System: Memory" \
      "System: Disk" \
      "System: Generate report" \
      "Exit")

    case "$choice" in
      "File operations: Create file") create_file;;
      "File operations: Create directory") create_directory;;
      "File operations: Copy") copy_item;;
      "File operations: Move") move_item;;
      "File operations: Rename") rename_item;;
      "File operations: Delete") delete_item;;
      "Search files") search_files;;
      "Permissions: chmod") change_permissions;;
      "Permissions: chown") change_ownership;;
      "Backup: create") create_backup;;
      "Backup: restore") restore_backup;;
      "System: info") system_info;;
      "System: CPU") cpu_monitor;;
      "System: Memory") mem_monitor;;
      "System: Disk") disk_monitor;;
      "System: Generate report") generate_report;;
      "Exit") zenity --info --text="Goodbye"; break;;
      *) break;;
    esac
  done
}

# --------------------------- STARTUP --------------------------------
check_zenity
main_menu

# End of script
# -------------------------------------------------------------------
# Notes (EN):
# - This script requires zenity. On Debian/Ubuntu: sudo apt install zenity
# - The script keeps technical logs at ~/.filemon/logs/filemon.log (permissions 600)
# - Running chown requires sudo; script will call sudo for that operation.
# - Test carefully on non-critical data first. No script can guarantee zero errors in all environments.
#
# ملاحظات (AR):
# - يحتاج السكربت إلى zenity. على أوبونتو/ديبيان: sudo apt install zenity
# - يسجل السجلات التقنية في المجلد: ~/.filemon/logs/filemon.log (صلاحيات 600)
# - تغيير الملكية يحتاج إلى sudo; سيستخدمه السكربت عند الحاجة.
# - اختبر على بيانات غير حرجة أولاً. لا يوجد ضمان مطلق لعدم حدوث أخطاء في كل بيئة.
