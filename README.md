# macOSAppCloser

A macOS SwiftUI utility that displays all currently open applications and allows you to selectively quit them — perfect for cleaning up before logging out or ending your day.

---

## 🚀 Features

- ✅ Lists all running user-facing apps with icons
- ✅ Quit selected apps with a single click
- ✅ Optional toggle to show **accessory/menu bar apps**
- ✅ Pre-checks regular apps, leaves accessory apps unchecked by default
- ✅ Clean SwiftUI GUI
- ✅ AppleScript-based quitting with unsaved document prompts
- ✅ Fully offline, native macOS tool

---

## 🔧 Building from Source

### Requirements

- macOS 12+
- Swift 5.7+
- No Xcode required

### Build and Install

```bash
./build_release.sh
cp -R macOSAppCloser.app /Applications/
