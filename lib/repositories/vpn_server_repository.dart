import '../models/vpn_server.dart';

class VpnServerRepository {
  static List<VpnServer> getServers() {
    return [
      VpnServer(
        country: "United States",
        countryCode: "🇺🇸",
        ovpnConfig: _usaConfig,
      ),
      VpnServer(
        country: "Japan",
        countryCode: "🇯🇵",
        ovpnConfig: _japanConfig,
      ),
      VpnServer(
        country: "Germany",
        countryCode: "🇩🇪",
        ovpnConfig: _germanyConfig,
      ),
    ];
  }

  // Sample configurations (These are templates, normally you'd fetch real ones from an API)
  static const String _usaConfig = """
client
dev tun
proto udp
remote 127.0.0.1 1194
resolv-retry infinite
nobind
persist-key
persist-tun
verb 3
auth-user-pass
<ca>
-----BEGIN CERTIFICATE-----
MIIB/TCCAWigAwIBAgIJAK9pW6Bsh77zMA0GCSqGSIb3DQEBCwUAMBAxDjAMBgNV
BAMMBW15LWNhMB4XDTIzMDUxMDIwMTIzMFoXDTMzMDUwNzIwMTIzMFowEDEOMAwG
A1UEAwwFbXktY2EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC5A5Fj
...
-----END CERTIFICATE-----
</ca>
""";

  static const String _japanConfig = """
client
dev tun
proto udp
remote 127.0.0.1 1194
resolv-retry infinite
nobind
persist-key
persist-tun
verb 3
auth-user-pass
<ca>
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
</ca>
""";

  static const String _germanyConfig = """
client
dev tun
proto udp
remote 127.0.0.1 1194
resolv-retry infinite
nobind
persist-key
persist-tun
verb 3
auth-user-pass
<ca>
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
</ca>
""";
}
