FinalMeco-Allow-Arbitrary-Loads
Overview
This project is an iOS AR app built in Swift and ARKit, which dynamically downloads AR assets (such as image or video files) from a remote server using a number-based token authorization system. The client connects to the backend API, retrieves asset lists and URLs for a specific company, and caches/downloads these assets for AR presentation within the app.​​

Features
ARKit-driven views for displaying dynamic (remotely updated) AR assets.

Secure downloading of assets using a bearer token and company number.

Caching and file existence checks for optimal bandwidth use.

Modular Swift code with reusable UI components.

Project Structure
AppDelegate.swift, ViewController.swift, etc.: Main app bootstrap and navigation.

ShowLogoView.swift: Handles AR asset presentation and user interaction, including asset downloading and caching.

Authentication and utility files for handling server API requests and local cache.

Assets and configs in standard iOS folders (Assets.xcassets, Info.plist, etc.).​

Setup & Installation
Clone the Repository

bash
git clone https://github.com/danialkh/FinalMeco-Allow-Arbitrary-Loads.git
cd FinalMeco-Allow-Arbitrary-Loads/Jelva
Open the Xcode Project

Open Jelva.xcodeproj in Xcode (iOS 13.0+ recommended).

Configure Dependencies

Ensure you have ARKit, UIKit, and SwiftUI frameworks enabled in your project settings.

No custom external libraries are mandatory.

Set Your Bearer Token

The app expects API access via a bearerToken which must be securely obtained from your backend admin or developer console.

The number field refers to the token or identifier provided per company or session.

Usage Guide
1. Authentication & Token Setting
The app requires a valid bearer token and a company number (companyId) before downloading or displaying AR assets.

Set these in your ShowLogoView or entry point programmatically.

2. Asset Downloading Process
On launch or interaction, the app checks for locally cached AR assets using UserDefaults and file system checks.

If assets for the current company are missing, it makes a network request to your server (see endpoint in your code) by posting the bearer token:

Example API: http://<serveraddress>:6060/api/AdsElement/<companyId>?os=ios

The server response provides URLs for assets (images, video, trackers).

Each asset is downloaded, its progress shown in a modal, and is stored locally using identifiable keys in the filesystem and in UserDefaults for quick lookup.​

3. AR Presenting
Downloaded assets are then rendered in AR (image, video overlays, etc.) within the UI containers defined in your Swift files.

The user can tap and interact with these views as coded in ShowLogoView.swift and related controllers.

Example Snippet
swift
let companyId = "your_company_id"
let bearerToken = "your_bearer_token"
let url = URL(string: "http://<serveraddress>:6060/api/AdsElement/\(companyId)?os=ios")!
var request = URLRequest(url: url)
request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
Customization
Enable or disable asset types (image/video/tracker) by modifying how URLs and IDs are handled in your view controller logic.

Extend server API to accept additional parameters for asset filtering or user customization.

Troubleshooting
Invalid Bearer Token: Ensure your token is not expired and you have server permissions.

Asset Not Downloading: Check network permissions, Info.plist for network security settings, and your API endpoint availability.

ARKit Issues: Confirm device compatibility (iOS 13+, ARKit-capable device).

Contributing
Pull requests are welcome! For significant changes, please open an issue first to discuss what you would like to change.

Fork the repo and make your changes.

Submit a pull request for review.

License
Specify your license here (e.g., MIT, Apache 2.0, etc.).

References/Resources:

Basic README formatting: GitHub Docs
