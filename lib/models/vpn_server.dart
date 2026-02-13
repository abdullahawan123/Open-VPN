class VpnServer {
  final String country;
  final String countryCode; // For flags
  final String ovpnConfig;
  final String? username;
  final String? password;

  VpnServer({
    required this.country,
    required this.countryCode,
    required this.ovpnConfig,
    this.username,
    this.password,
  });
}
