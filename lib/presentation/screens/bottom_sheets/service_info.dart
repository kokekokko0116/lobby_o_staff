import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../components/buttons/tile_button.dart';

class ServiceInfoBottomSheet extends StatefulWidget {
  const ServiceInfoBottomSheet({super.key, this.onPdfPressed});

  final Function(String)? onPdfPressed;

  @override
  State<ServiceInfoBottomSheet> createState() => _ServiceInfoBottomSheetState();
}

class _ServiceInfoBottomSheetState extends State<ServiceInfoBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 400,
      ),
      child: _buildPdfTileButtonsGrid(),
    );
  }

  Widget _buildPdfTileButtonsGrid() {
    final pdfTiles = [
      {
        'title': 'About Service',
        'subtitle': 'サービス内容の詳細説明',
        'key': 'service_overview',
      },
      {'title': 'About Service', 'subtitle': 'ご利用方法とマナー', 'key': 'usage_guide'},
      {'title': 'About Service', 'subtitle': 'サービス料金一覧', 'key': 'price_list'},
      {'title': 'About Service', 'subtitle': 'サービス利用契約書', 'key': 'contract'},
      {
        'title': 'About Service',
        'subtitle': '重要事項の詳細説明',
        'key': 'important_matters',
      },
    ];

    return MasonryGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: pdfTiles.length,
      itemBuilder: (context, index) {
        final tile = pdfTiles[index];
        return TileButton(
          title: tile['title'] as String,
          subtitle: tile['subtitle'] as String,
          icon: Icons.picture_as_pdf,
          variant: TileButtonVariant.accent,
          onPressed: () => {},
        );
      },
    );
  }
}
