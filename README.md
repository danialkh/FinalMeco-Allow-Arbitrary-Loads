# FinalMeco-Allow-Arbitrary-Loads 🚀✨

Welcome to **FinalMeco-Allow-Arbitrary-Loads**!  
An iOS ARKit app for securely downloading and presenting server-managed AR assets using number-based tokens.  
Get started and bring remote AR content to your users—anytime! 🛰️📲

---

## 📦 Features

- 🕶️ ARKit-powered rendering of server-provided assets
- 🔒 Token-based secure API authentication
- 📥 Downloads and caches assets dynamically (image, video, trackers)
- ⚡ Responsive SwiftUI/UIView modular code
- 🗂️ Fast lookups via caching and UserDefaults

---

## 🗂️ Project Structure

| File / Folder                 | Purpose                                      |
| :---------------------------: | :------------------------------------------- |
| `AppDelegate.swift`           | App setup and lifecycle                      |
| `ShowLogoView.swift`          | Main AR/showcase logic and asset handler     |
| `ViewController.swift`        | Navigation/controller for AR flows           |
| `Assets.xcassets`, `Info.plist` | iOS resources and metadata                 |
| ...                           | Additional supporting Swift files            |

---

## 🚀 Getting Started

### 1. Clone this repo





### 2. Open in Xcode
Open `Jelva.xcodeproj` in Xcode (iOS 13.0+ recommended).

### 3. Configure
- Enable `ARKit`, `SwiftUI`, and `UIKit` in your project.
- **Set your credentials!**  
  Obtain your `bearerToken` (from your admin/dev panel) and set your company’s `number` (companyId) in code.

---

## 🤖 How It Works

1. **Authentication**  
   The app requires a valid number-based token (`bearerToken`) tied to your organization.  
   Update this in the relevant code sections.

2. **Asset Downloading**  
   - Checks cache for previously-downloaded AR assets.
   - If not found, makes a POST request to your server:  
     ```
     http://<serveraddress>:6060/api/AdsElement/<companyId>?os=ios
     ```
   - Adds `Authorization: Bearer <your_token>` header for security.
   - Downloads image/video/marker URLs received from the server.
   - Assets are stored locally and mapped via UserDefaults.

3. **Present in AR**  
   - Assets are rendered in ARKit overlays or views.
   - Users may interact as defined in your controller (tap, swipe, etc.).

---

## 🛠️ Example


---

## ⚠️ Troubleshooting

- `401 Unauthorized`: Token may be expired/invalid.
- Connection errors: Check iOS Network permissions & Info.plist security settings.
- ARKit issues: Make sure you’re using an ARKit-supported device.

---

## 🤝 Contributing

Pull requests are welcome! For major changes, open an issue to discuss ideas first.

---

## 📄 License

[Add your license here]

---

> Built with ❤️ for AR and remote asset magic!  
>  
> _Inspired by GitHub ARKit samples and standard ARKit patterns._  
