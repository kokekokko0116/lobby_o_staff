import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../components/buttons/tile_button.dart';

class TrainingDocumentsBottomSheet extends StatefulWidget {
  const TrainingDocumentsBottomSheet({super.key, this.onPdfPressed});

  final Function(String)? onPdfPressed;

  @override
  State<TrainingDocumentsBottomSheet> createState() =>
      _TrainingDocumentsBottomSheetState();
}

class _TrainingDocumentsBottomSheetState
    extends State<TrainingDocumentsBottomSheet> {
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
      {'title': '実地研修', 'key': 'service_overview'},
      {'title': '座学研修', 'key': 'usage_guide'},
      {'title': '理念研修', 'key': 'price_list'},
      {'title': '待遇事務', 'key': 'contract'},
      {'title': '登録関連', 'key': 'important_matters'},
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
          icon: Icons.description,
          variant: TileButtonVariant.accent,
          onPressed: () => {},
        );
      },
    );
  }
}
