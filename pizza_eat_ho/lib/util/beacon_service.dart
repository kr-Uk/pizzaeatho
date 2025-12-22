import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
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

  final String uuid;
  final int major;
  final int minor;
  final double enterDistanceMeters;
  final void Function() onEnter;
  final void Function() onExit;

  StreamSubscription<RangingResult>? _subscription;
  bool _isNear = false;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    final granted = await _ensurePermissions();
    if (!granted) return;

    await flutterBeacon.initializeAndCheckScanning;

    final region = Region(
      identifier: 'pizzaeatho',
      proximityUUID: uuid,
      major: major,
      minor: minor,
    );

    _subscription = flutterBeacon.ranging([region]).listen((result) {
      if (result.beacons.isEmpty) {
        return;
      }

      final nearest = result.beacons.reduce((a, b) {
        return a.accuracy < b.accuracy ? a : b;
      });

      final distance = nearest.accuracy;
      if (distance == null || distance <= 0) {
        return;
      }

      final isNear = distance <= enterDistanceMeters;
      if (isNear && !_isNear) {
        _isNear = true;
        onEnter();
      } else if (!isNear && _isNear) {
        _isNear = false;
        onExit();
      }
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
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
