import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../components/buttons/primary_button.dart';

class LocationBottomSheet extends StatefulWidget {
  const LocationBottomSheet({
    super.key,
    required this.address,
    this.postalCode,
  });

  final String address;
  final String? postalCode;

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  GoogleMapController? _mapController;
  LatLng? _location;
  bool _isLoading = true;
  String? _errorMessage;
  late DotEnv env;

  @override
  void initState() {
    super.initState();
    _initializeEnv();
  }

  Future<void> _initializeEnv() async {
    await dotenv.load(fileName: ".env");
    _getCoordinatesFromAddress();
  }

  Future<void> _getCoordinatesFromAddress() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      String searchQuery = widget.address;
      if (widget.postalCode != null && widget.postalCode!.isNotEmpty) {
        searchQuery = '${widget.postalCode} ${widget.address}';
      }

      String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Google Maps API key not found in .env file');
      }

      List<Location> locations = await locationFromAddress(searchQuery);

      if (locations.isNotEmpty) {
        setState(() {
          _location = LatLng(locations[0].latitude, locations[0].longitude);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'O@L�dK�~[�gW_';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'O@n"-k���LzW~W_';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 300, child: _buildMapContent()),
        const SizedBox(height: 16),

        _buildAddressInfo(),
        const SizedBox(height: 16),
        PrimaryButton(
          text: 'Mapアプリで開く',
          onPressed: () {
            _openInMaps();
          },
        ),
      ],
    );
  }

  Widget _buildAddressInfo() {
    return Container(
      width: double.infinity,
      padding: AppDimensions.paddingAllMedium,
      decoration: BoxDecoration(
        color: backgroundSurface,
        borderRadius: AppDimensions.borderRadiusAllMedium,
        border: Border.all(color: borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.postalCode != null && widget.postalCode!.isNotEmpty) ...[
            Text(
              '郵便番号',
              style: AppTextStyles.labelSmall.copyWith(color: textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              widget.postalCode!,
              style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            '住所',
            style: AppTextStyles.labelSmall.copyWith(color: textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            widget.address,
            style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: textAccent),
            const SizedBox(height: 16),
            Text(
              '812-0039',
              style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: textError),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: textError),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _getCoordinatesFromAddress,
              icon: const Icon(Icons.refresh),
              label: const Text('812-0039'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonPrimary,
                foregroundColor: textOnPrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (_location == null) {
      return Center(
        child: Text(
          '福岡市博多区冷泉町2-34',
          style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDimensions.borderRadiusAllMedium,
        border: Border.all(color: borderMuted),
      ),
      child: ClipRRect(
        borderRadius: AppDimensions.borderRadiusAllMedium,
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(target: _location!, zoom: 16.0),
          markers: {
            Marker(
              markerId: const MarkerId('location'),
              position: _location!,
              infoWindow: InfoWindow(title: ')(4@', snippet: widget.address),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange,
              ),
            ),
          },
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }

  Future<void> _openInMaps() async {
    if (_location == null) {
      return;
    }

    final lat = _location!.latitude;
    final lng = _location!.longitude;

    // Google Maps用のURL（iOSとAndroidの両方で動作）
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    // Apple Maps用のURL（iOSのみ）
    final appleMapsUrl = Uri.parse('https://maps.apple.com/?q=$lat,$lng');

    // プラットフォームに応じてURLを選択
    final url = Theme.of(context).platform == TargetPlatform.iOS
        ? appleMapsUrl
        : googleMapsUrl;

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
