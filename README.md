# Open-VPN

A Flutter application that demonstrates basic **OpenVPN integration** and secure connection handling. This project provides a foundation for building a VPN client interface with connection controls, status display, and error handling.

## Features

- Connect / Disconnect to VPN servers
- Display connection status (Connected / Disconnected / Connecting)
- Basic UI for server selection and connection controls
- Works on Android (iOS support depends on native VPN SDK)
- Built with Flutter for responsive cross-platform UI

## Tech Stack

- Flutter
- Dart
- VPN integration library (OpenVPN-based SDK)

## Screenshots

*(Add screenshots or GIFs of your app here)*

assets/screenshots/home.png
assets/screenshots/connected.png


## Getting Started

### Prerequisites

Make sure you have:

- Flutter SDK installed
- Android Studio or Visual Studio Code
- Android device or emulator (iOS support may require native setup)
- OpenVPN config files (`*.ovpn`) or server list

### Installation

1. Clone the repository:

```bash
git clone https://github.com/abdullahawan123/Open-VPN.git
Navigate to the project directory:

cd Open-VPN
Install dependencies:

flutter pub get
Add your OpenVPN config files

Place your .ovpn files or connection config within your assets folder and update pubspec.yaml.

Run the application:

flutter run
How It Works
The app connects to VPN using configuration files (*.ovpn) and updates the UI based on connection state. Depending on the plugin or native approach you choose, connection logic might be handled using a dedicated OpenVPN library or native channels.

Supported Platforms
Android: Fully supported

iOS: Partial — may require additional native setup

Use Cases
Secure internet browsing

Access region-restricted content

Protect user privacy

Build a custom VPN client

Future Enhancements
Add server list and favourites

Save user preferences

Add kill switch and DNS leak protection

Include auto-connect features

Add in-app notifications for connection changes

Author
Abdullah Awan
