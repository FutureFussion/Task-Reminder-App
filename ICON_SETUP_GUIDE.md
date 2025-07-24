# Complete Guide: Adding App Icon and Customizing App Name

## 📱 Step-by-Step Process

### 1. **Create Your App Icon**
- **Size**: Create a 1024x1024 pixel PNG image
- **Design**: Keep it simple, bold, and recognizable at small sizes
- **Tools you can use**:
  - **Canva**: Search "app icon" templates (free)
  - **Figma**: Free design tool with icon templates
  - **Adobe Illustrator**: Professional design tool
  - **Online generators**: Like app-icon-generator.com
  - **AI tools**: DALL-E, Midjourney, or Stable Diffusion

### 2. **For This Task Manager App, Consider These Icon Ideas**:
- ✅ Checkmark with clock
- 📋 Clipboard with checkboxes
- ⏰ Alarm clock with task list
- 🔔 Bell with checklist
- 📅 Calendar with notification dot

### 3. **Add Icon to Your Project**
```bash
# 1. Place your icon file in the assets/icon/ folder as 'app_icon.png'
# 2. Install the flutter_launcher_icons package (already added to pubspec.yaml)
flutter pub get

# 3. Generate icons for all platforms
flutter pub run flutter_launcher_icons:main
```

### 4. **What the Icon Generator Does**:
- **Android**: Creates multiple sizes (48x48 to 192x192) in `android/app/src/main/res/mipmap-*/`
- **iOS**: Generates all required sizes in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- **Web**: Creates favicon and web app icons
- **macOS**: Generates macOS app icons
- **Windows**: Creates Windows app icons

### 5. **App Name Changes Made**:
- **Android**: Updated in `AndroidManifest.xml`
- **iOS**: Updated in `Info.plist`
- **macOS**: Updated in `AppInfo.xcconfig`
- **Web**: Updated in `index.html` and `manifest.json`

### 6. **Testing Your Changes**:
```bash
# Clean and rebuild to see changes
flutter clean
flutter pub get

# Test on different platforms
flutter run -d android    # Android
flutter run -d ios        # iOS (requires Mac)
flutter run -d chrome     # Web
flutter run -d macos      # macOS (requires Mac)
```

### 7. **Verification Checklist**:
- [ ] Icon appears correctly on home screen
- [ ] Icon looks good at different sizes
- [ ] App name displays correctly
- [ ] Icon has proper contrast on light/dark backgrounds
- [ ] No pixelation or blurriness

## 🎨 Design Tips for Task Manager Icon

### Good Icon Characteristics:
- **Simple**: Recognizable even at 16x16 pixels
- **Unique**: Stands out from other apps
- **Relevant**: Clearly represents task management
- **Scalable**: Looks good at all sizes
- **Memorable**: Easy to remember and find

### Color Suggestions:
- **Primary**: Blue (#2196F3) - trust, productivity
- **Secondary**: Green (#4CAF50) - completion, success
- **Accent**: Orange (#FF9800) - urgency, attention
- **Background**: White or transparent

### Icon Elements to Consider:
1. **Checkmark** ✓ - completion
2. **Clock/Timer** ⏰ - time management
3. **List lines** ≡ - organization
4. **Bell** 🔔 - reminders
5. **Calendar** 📅 - scheduling

## 🔧 Troubleshooting

### Common Issues:
1. **Icon not updating**: Run `flutter clean` then rebuild
2. **Blurry icon**: Ensure source image is high resolution (1024x1024)
3. **Wrong colors**: Check if your PNG has transparency
4. **Name not changing**: Clean build and restart device/emulator

### Platform-Specific Notes:
- **Android**: May need to clear app data to see icon changes
- **iOS**: Simulator might cache old icons, try device testing
- **Web**: Clear browser cache to see favicon changes
- **macOS**: Restart Finder to refresh icon cache

## 📁 File Structure After Setup:
```
your_project/
├── assets/
│   └── icon/
│       ├── app_icon.png (your 1024x1024 source)
│       └── README.md
├── android/app/src/main/res/
│   ├── mipmap-hdpi/ic_launcher.png
│   ├── mipmap-mdpi/ic_launcher.png
│   └── ... (other sizes)
├── ios/Runner/Assets.xcassets/AppIcon.appiconset/
│   ├── Icon-App-20x20@1x.png
│   └── ... (all iOS sizes)
└── flutter_launcher_icons.yaml
```

## 🚀 Next Steps:
1. Create your 1024x1024 app icon
2. Save it as `assets/icon/app_icon.png`
3. Run `flutter pub get`
4. Run `flutter pub run flutter_launcher_icons:main`
5. Test on your target platforms!