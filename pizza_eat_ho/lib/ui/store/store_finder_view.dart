import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pizzaeatho/util/common.dart';

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
          title: const Text('피짜잇호 매장 안내'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('운영 시간: 매일 11:00 - 22:00'),
              SizedBox(height: 8),
              Text('라스트 오더: 21:30'),
              SizedBox(height: 8),
              Text('포장/배달 가능'),
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
          title: '피짜잇호 매장',
          snippet: '탭해서 매장 정보를 확인하세요',
        ),
        onTap: _showStoreDialog,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('매장 찾기', style: TextStyle(color: Colors.white)),
        backgroundColor: redBackground,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
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
    );
  }
}
