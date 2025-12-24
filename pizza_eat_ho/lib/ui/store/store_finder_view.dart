import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:url_launcher/url_launcher.dart';

const Color _christmasGreen = Color(0xFF0F6B3E);
const Color _snowBackground = Color(0xFFF9F6F1);

class StoreFinderView extends StatefulWidget {
  const StoreFinderView({super.key});

  @override
  State<StoreFinderView> createState() => _StoreFinderViewState();
}

class _StoreFinderViewState extends State<StoreFinderView> {
  static const LatLng _storeLatLng =
      LatLng(36.10746037637633, 128.41975271701813);
  static const String _storeName = '피짜잇호 매장';
  static const String _storePhone = '054-000-0000';

  Future<void> _openDirections() async {
    try {
      final appUri = Uri.parse(
        'nmap://route/public?dlat=${_storeLatLng.latitude}&dlng=${_storeLatLng.longitude}&dname=${Uri.encodeComponent(_storeName)}&appname=pizzaeatho',
      );
      final launched =
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
      if (!launched) {
        final webUri = Uri.parse(
          'https://map.naver.com/v5/search/${Uri.encodeComponent(_storeName)}',
        );
        final webLaunched =
            await launchUrl(webUri, mode: LaunchMode.externalApplication);
        if (!webLaunched && mounted) {
          _showSnack('길찾기를 열 수 없습니다.');
        }
      }
    } on PlatformException {
      if (mounted) {
        _showSnack('앱을 재시작한 뒤 다시 시도해주세요.');
      }
    }
  }

  Future<void> _callStore() async {
    try {
      final uri = Uri(scheme: 'tel', path: _storePhone);
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        _showSnack('전화 앱을 열 수 없습니다.');
      }
    } on PlatformException {
      if (mounted) {
        _showSnack('앱을 재시작한 뒤 다시 시도해주세요.');
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showStoreDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: redBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.store, color: Colors.white),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          '피짜잇호 매장',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.schedule,
                  label: '영업시간',
                  value: '11:00 - 22:00',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.room_service_outlined,
                  label: '라스트오더',
                  value: '21:30',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.delivery_dining,
                  label: '이용',
                  value: '매장 / 배달',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.call,
                  label: '전화',
                  value: _storePhone,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _openDirections,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: redBackground,
                          side: const BorderSide(
                            color: redBackground,
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('길찾기'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _callStore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redBackground,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('전화하기'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                    child: const Text('닫기'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: redBackground.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: redBackground, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = {
      Marker(
        markerId: const MarkerId('pizzaeatho'),
        position: _storeLatLng,
        infoWindow: const InfoWindow(
          title: '피짜잇호 매장',
          snippet: '매장 정보 보기',
        ),
        onTap: _showStoreDialog,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('매장 찾기', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB91D2A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _storeLatLng,
              zoom: 16,
            ),
            markers: markers,
            onTap: (_) {},
            onMapCreated: (_) {},
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _snowBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: _christmasGreen, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _christmasGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store, color: _christmasGreen),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '피짜잇호 매장 운영 안내',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: _showStoreDialog,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}