import 'dart:async';
import 'dart:math';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BeaconService {
  BeaconService({
    required this.uuid,
    required this.major,
    required this.minor,
    required this.enterDistanceMeters,
    required this.onEnter,
    required this.onExit,
  });

  final String? uuid;
  final int major;
  final int minor;
  final double enterDistanceMeters;
  final void Function() onEnter;
  final void Function() onExit;

  StreamSubscription<List<ScanResult>>? _scanSub;
  Timer? _scanTimer;
  bool _isNear = false;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    final granted = await _ensurePermissions();
    if (!granted) return;

    _scanSub = FlutterBluePlus.scanResults.listen(_handleScanResults);

    await _startScanOnce();
    _scanTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _startScanOnce();
    });
  }

  Future<void> dispose() async {
    await _scanSub?.cancel();
    _scanSub = null;
    _scanTimer?.cancel();
    _scanTimer = null;
    await FlutterBluePlus.stopScan();
  }

  Future<void> _startScanOnce() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
  }

  void _handleScanResults(List<ScanResult> results) {
    double? nearestDistance;

    for (final result in results) {
      final distance = _parseIBeaconDistance(result);
      if (distance == null) continue;

      if (nearestDistance == null || distance < nearestDistance) {
        nearestDistance = distance;
      }
    }

    if (nearestDistance == null) return;

    final isNear = nearestDistance <= enterDistanceMeters;
    if (isNear && !_isNear) {
      _isNear = true;
      onEnter();
    } else if (!isNear && _isNear) {
      _isNear = false;
      onExit();
    }
  }

  double? _parseIBeaconDistance(ScanResult result) {
    final manufacturerData =
        result.advertisementData.manufacturerData; // key: company id
    final data = manufacturerData[0x004C];
    if (data == null || data.length < 23) {
      return null;
    }

    if (data[0] != 0x02 || data[1] != 0x15) {
      return null;
    }

    final beaconUuid = _formatUuid(data.sublist(2, 18));
    final matchUuid = (uuid == null || uuid!.isEmpty)
        ? true
        : beaconUuid.toLowerCase() == uuid!.toLowerCase();
    if (!matchUuid) return null;

    final majorValue = (data[18] << 8) + data[19];
    final minorValue = (data[20] << 8) + data[21];
    if (majorValue != major || minorValue != minor) {
      return null;
    }

    final txPowerRaw = data[22];
    final txPower = txPowerRaw > 127 ? txPowerRaw - 256 : txPowerRaw;
    final rssi = result.rssi;
    if (rssi == 0) return null;

    // Basic distance estimation using RSSI + measured power.
    final ratio = (txPower - rssi) / (10 * 2.0);
    return pow(10, ratio).toDouble();
  }

  String _formatUuid(List<int> bytes) {
    final hex = bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  Future<bool> _ensurePermissions() async {
    final statuses = await [
      Permission.locationWhenInUse,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    return statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );
  }
}
