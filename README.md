# Food Delivery App (Flutter)

මෙම ව්‍යාපෘතිය Flutter භාවිතයෙන් නිර්මාණය කරන ලද Premium Food Delivery Application එකකි. 

This project is a premium Food Delivery Application built using Flutter. Since Flutter is not currently configured in your system environment, we have written the core application code in the `lib/` directory.

---

## 🚀 How to Run the App / ක්‍රියාත්මක කරන ආකාරය

### 1. Flutter Install කිරීම (Setup Flutter SDK)
1. Official Flutter SDK එක [මෙහි ලින්ක් එකෙන්](https://docs.flutter.dev/get-started/install/windows) බාගත (Download) කරගන්න.
2. බාගත කරගත් Zip ෆයිල් එක ඔයාගේ පරිගණකයේ සුදුසු තැනක (उदा. `C:\src\flutter`) Extract කරන්න.
3. ඔයාගේ Windows System Environment Variable එකෙහි **Path** එකට `C:\src\flutter\bin` ඇතුලත් කරන්න.
4. නව Terminal එකක් විවෘත කර පහත විධානය මඟින් එය සාර්ථක දැයි පරීක්ෂා කරන්න:
   ```bash
   flutter doctor
   ```

### 2. Project එක සකස් කිරීම (Scaffold Platform Files)
මෙම ෆෝල්ඩරය (`e:\Food Dilivery App`) ඇතුලත Terminal එකක් open කර පහත විධානය ක්‍රියාත්මක කරන්න. එමඟින් අවශ්‍ය Android, iOS සහ Web settings files ස්වයංක්‍රීයව නිර්මාණය වේ:
```bash
flutter create --platforms=android,ios,web .
```

### 3. Application එක Run කිරීම
1. Android Emulator එකක් හෝ Chrome Browser එකක් open කරගන්න.
2. Terminal එකෙහි පහත විධානය ලබාදී Run කරන්න:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure (ව්‍යාපෘති ව්‍යුහය)

- **`lib/main.dart`**: Application entry point & State Provider management.
- **`lib/theme/app_theme.dart`**: Premium dark and light theme settings.
- **`lib/models/`**: Data models for food items and the shopping cart.
- **`lib/providers/`**: State management logic for cart operations.
- **`lib/screens/`**: UI screens (Welcome/Onboarding, Home, Details, Cart, Order Success).
- **`lib/widgets/`**: Reusable custom components (Food Card, Category Selector, Cart item list tile).
