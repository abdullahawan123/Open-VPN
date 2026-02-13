import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../services/vpn_service.dart';
import '../models/vpn_server.dart';
import '../repositories/vpn_server_repository.dart';

class VpnScreen extends StatefulWidget {
  const VpnScreen({super.key});

  @override
  State<VpnScreen> createState() => _VpnScreenState();
}

class _VpnScreenState extends State<VpnScreen>
    with SingleTickerProviderStateMixin {
  final VpnService _vpnService = VpnService();
  final List<VpnServer> _servers = VpnServerRepository.getServers();
  late VpnServer _selectedServer;

  VPNStage _stage = VPNStage.disconnected;
  VpnStatus? _status;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _selectedServer = _servers.first;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _vpnService.initialize(
      onStageChanged: (stage, msg) {
        setState(() {
          _stage = stage;
          if (stage == VPNStage.connected) {
            _pulseController.repeat();
          } else if (stage == VPNStage.disconnected) {
            _pulseController.stop();
            _pulseController.reset();
          }
        });
      },
      onStatusChanged: (status) {
        setState(() {
          _status = status;
        });
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleVPN() {
    if (_stage == VPNStage.connected) {
      _vpnService.disconnect();
    } else {
      _vpnService.connect(_selectedServer);
    }
  }

  void _showServerSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Location",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _servers.length,
                  itemBuilder: (context, index) {
                    final server = _servers[index];
                    return ListTile(
                      leading: Text(
                        server.countryCode,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        server.country,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: _selectedServer == server
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.blueAccent,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedServer = server;
                        });
                        Navigator.pop(context);
                        if (_stage == VPNStage.connected) {
                          _vpnService.disconnect();
                          _vpnService.connect(_selectedServer);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          "VPN MASTER",
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Colors.blueAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildStatusHeader(),
            const Spacer(),
            _buildConnectButton(),
            const Spacer(),
            _buildStatsRow(),
            const SizedBox(height: 40),
            _buildLocationCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    String statusText = _stage.name.toUpperCase();
    Color statusColor = Colors.grey;

    if (_stage == VPNStage.connected) {
      statusText = "PROTECTED";
      statusColor = Colors.greenAccent;
    } else if (_stage == VPNStage.connecting) {
      statusText = "CONNECTING...";
      statusColor = Colors.orangeAccent;
    } else if (_stage == VPNStage.disconnected) {
      statusText = "UNPROTECTED";
      statusColor = Colors.redAccent;
    }

    return Column(
      children: [
        Text(
          statusText,
          style: TextStyle(
            color: statusColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _stage == VPNStage.connected
              ? "Your IP is concealed"
              : "Your connection is not secure",
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildConnectButton() {
    bool isConnected = _stage == VPNStage.connected;
    bool isConnecting = _stage == VPNStage.connecting;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulse Effect
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 180 + (_pulseController.value * 40),
              height: 180 + (_pulseController.value * 40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isConnected ? Colors.blueAccent : Colors.white10)
                    .withOpacity(0.15 * (1 - _pulseController.value)),
              ),
            );
          },
        ),
        // Outer Border
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isConnected ? Colors.blueAccent : Colors.white24,
              width: 2,
            ),
          ),
        ),
        // Main Button
        GestureDetector(
          onTap: isConnecting ? null : _toggleVPN,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isConnected
                    ? [Colors.blueAccent, Colors.blue.shade900]
                    : [Colors.white10, Colors.white24],
              ),
              boxShadow: isConnected
                  ? [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              Icons.power_settings_new,
              size: 60,
              color: isConnected ? Colors.white : Colors.white38,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          Icons.arrow_downward,
          "DOWNLOAD",
          _status?.byteIn ?? "0.0",
          Colors.greenAccent,
        ),
        _buildStatItem(
          Icons.arrow_upward,
          "UPLOAD",
          _status?.byteOut ?? "0.0",
          Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return GestureDetector(
      onTap: _showServerSelection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Text(
              _selectedServer.countryCode,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selected Location",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    _selectedServer.country,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
