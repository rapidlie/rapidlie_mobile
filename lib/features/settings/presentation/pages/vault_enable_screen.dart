import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VaultEnableScreen extends StatefulWidget {
  const VaultEnableScreen({Key? key}) : super(key: key);

  @override
  State<VaultEnableScreen> createState() => _VaultEnableScreenState();
}

class _VaultEnableScreenState extends State<VaultEnableScreen> {
  final _auth = LocalAuthentication();
  bool _checking = false;
  bool _canBiometric = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isAvailable = await _auth.isDeviceSupported();
    setState(() => _canBiometric = canCheck && isAvailable);
  }

  Future<void> _enable() async {
    setState(() {
      _checking = true;
      _error = null;
    });

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Confirm your identity to enable biometric login',
      );

      if (!authenticated) {
        setState(() {
          _checking = false;
          _error = 'Authentication cancelled';
        });
        return;
      }

      // Call backend to register device token
      final token = await UserPreferences().getBearerToken();
      final dio = Dio();
      final response = await dio.post(
        '$flockrAPIBaseUrl/auth/biometric/enable',
        data: {'device_name': 'mobile'},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      final deviceToken =
          response.data['device_token'] as String?;
      if (deviceToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('biometric_token', deviceToken);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric login enabled!')),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _error = 'Failed to enable biometric. Please try again.');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Enable Biometric Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.fingerprint, size: 52, color: primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'VAULT',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700,
                  letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use Face ID or Touch ID to log in instantly without entering your password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            const SizedBox(height: 40),
            if (!_canBiometric)
              const Text(
                'Biometric authentication is not available on this device. Please enable it in your device settings.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange, fontSize: 13),
              )
            else
              ButtonTemplate(
                buttonName: 'Enable Biometric Login',
                buttonAction: _enable,
                loading: _checking,
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
