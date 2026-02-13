import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../models/vpn_server.dart';

class VpnService {
  late OpenVPN _openVPN;
  bool _initialized = false;

  // Single instance pattern
  static final VpnService _instance = VpnService._internal();
  factory VpnService() => _instance;
  VpnService._internal();

  /// Initialize VPN Engine
  Future<void> initialize({
    required Function(VPNStage stage, String msg) onStageChanged,
    required Function(VpnStatus? status) onStatusChanged,
  }) async {
    if (_initialized) return;

    _openVPN = OpenVPN(
      onVpnStageChanged: onStageChanged,
      onVpnStatusChanged: onStatusChanged,
    );

    await _openVPN.initialize(
      groupIdentifier: "group.com.merik.vpn",
      providerBundleIdentifier: "com.merik.vpn.OpenVPN",
      localizedDescription: "VPN Master Connection",
      lastStage: (stage) {
        onStageChanged(stage, "");
      },
    );

    _initialized = true;
  }

  /// Connect VPN to a specific server
  Future<void> connect(VpnServer server) async {
    if (!_initialized) {
      throw Exception("VPN not initialized.");
    }

    await _openVPN.connect(
      server.ovpnConfig,
      server.country,
      username: server.username ?? "",
      password: server.password ?? "",
      certIsRequired: false,
    );
  }

  /// Disconnect VPN
  void disconnect() {
    if (_initialized) {
      _openVPN.disconnect();
    }
  }

  /// Get Current Stage
  Future<VPNStage> getCurrentStage() async {
    // This is a bit of a hack as the plugin doesn't expose current stage directly
    // but usually, we track it via the listener.
    return VPNStage.disconnected;
  }
}
