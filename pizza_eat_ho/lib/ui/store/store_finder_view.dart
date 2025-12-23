import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pizzaeatho/util/common.dart';

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

  void _showStoreDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('피자잇호 매장'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('영업시간: 11:00 - 22:00'),
              SizedBox(height: 8),
              Text('라스트오더: 21:30'),
              SizedBox(height: 8),
              Text('포장 / 배달'),
              SizedBox(height: 8),
              Text('전화: 054-000-0000'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = {
      Marker(
        markerId: const MarkerId('pizzaeatho'),
        position: _storeLatLng,
        infoWindow: const InfoWindow(
          title: '피자잇호 매장',
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
            bottom: 24,
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
                      "피자잇호 매장\n크리스마스 영업 안내",
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
