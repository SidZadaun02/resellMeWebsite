import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/product_model.dart';

class SizeSelectionWidget extends StatefulWidget {
  final List<StockInfo> stockInfo;
  final bool canOrder;
  final Function(StockInfo) onSizeSelected; // Callback to send selected size
  const SizeSelectionWidget({Key? key, required this.stockInfo,required this.canOrder, required this.onSizeSelected}) : super(key: key);

  @override
  _SizeSelectionWidgetState createState() => _SizeSelectionWidgetState();
}

class _SizeSelectionWidgetState extends State<SizeSelectionWidget> {
  String selectedSize = ''; // To store the selected size

  @override
  void initState() {
    super.initState();

    // Set the initial selected size
    if (widget.stockInfo.any((stock) => stock.sizeQuantity > 0)) {
      selectedSize = widget.stockInfo.firstWhere((stock) => stock.sizeQuantity > 0).sizeText;
    } else {
      selectedSize = ''; // Default to empty if all sizes are out of stock
    }
  }


  @override
  Widget build(BuildContext context) {
    // Check if all sizes have sizeQuantity = 0
    bool isOutOfStock = false;
    String text = "";

    if(!widget.canOrder){
      isOutOfStock = true;
      text = 'This item is not Orderable';
    }else{
      text = 'Item is Out of Stock';
      isOutOfStock = widget.stockInfo.every((stock) => stock.sizeQuantity == 0);
    }

    if (isOutOfStock) {
      return  Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 10.0, // Space between chips horizontally
          runSpacing: 10.0, // Space between chips vertically
          children: widget.stockInfo.map((stock) {


            print(selectedSize);
            print(stock.sizeQuantity);
            print(stock.sizeText);
            print(stock.sizeString);
            final isSelectable = stock.sizeQuantity > 0; // Check if size is available

            return GestureDetector(
              behavior: HitTestBehavior.translucent, // Ensures gesture detection for all items
              child: ChoiceChip(
                label: Text(stock.sizeText),
                selected: selectedSize == stock.sizeText,
                onSelected: isSelectable
                    ? (bool selected) {
                  widget.onSizeSelected(stock); // Notify parent widget of selection
                  setState(() {
                    selectedSize = selected ? stock.sizeText : ''; // Update selected size
                  });
                }
                    : null, // Disable interaction if size is not selectable
                selectedColor: Colors.pink,
                backgroundColor: isSelectable ? Colors.grey[200] : Colors.grey[400], // Dim non-selectable chips
                labelStyle: TextStyle(
                  color: isSelectable ? Colors.black : Colors.grey[600], // Dim label color for non-selectable chips
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
