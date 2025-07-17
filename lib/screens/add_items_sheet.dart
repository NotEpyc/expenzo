import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class AddItemsSheet extends StatefulWidget {
  final String? tempExpenseId;
  
  const AddItemsSheet({
    super.key,
    this.tempExpenseId,
  });

  @override
  State<AddItemsSheet> createState() => _AddItemsSheetState();
}

class _AddItemsSheetState extends State<AddItemsSheet> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();
  String _selectedQuantityType = 'Please Select';
  final ItemService _itemService = ItemService();
  bool _isLoading = false;

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _pricingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * ResponsiveUtils.getModalHeight(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
            topRight: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItemNameField(),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildQuantityField(),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                        Expanded(
                          flex: 3,
                          child: _buildQuantityTypeField(),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                    _buildPricingField(),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add Items',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () {
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsivePadding(context, 12), 
                vertical: ResponsiveUtils.getResponsivePadding(context, 6),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveBorderRadius(context, 6),
                ),
              ),
              child: Text(
                'View List',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: Row(
            children: [
              const Text(
                'Item Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            controller: _itemNameController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Please type the item name',
              hintStyle: TextStyle(
                color: const Color(0xFF4CAF50),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: const Color(0xFF4CAF50)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  'Total Quantity Purchased',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Please type the quantity',
              hintStyle: TextStyle(
                color: const Color(0xFF4CAF50),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: const Color(0xFF4CAF50)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  'Quantity Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: GestureDetector(
            onTap: _showQuantityTypeDropdown,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedQuantityType,
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedQuantityType == 'Please Select' 
                            ? const Color(0xFF4CAF50) 
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Total Item Pricing',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Text(
              '*',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _pricingController,
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Please type the total pricing',
            hintStyle: TextStyle(
              color: const Color(0xFF4CAF50),
              fontSize: 14,
            ),
            prefixIcon: _pricingController.text.isNotEmpty 
                ? Container(
                    width: 48,
                    alignment: Alignment.center,
                    child: Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFF4CAF50)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    final bool isFormValid = _itemNameController.text.trim().isNotEmpty &&
        _quantityController.text.trim().isNotEmpty &&
        _selectedQuantityType != 'Please Select' &&
        _pricingController.text.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (isFormValid && !_isLoading) ? _addItem : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (isFormValid && !_isLoading) ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                foregroundColor: (isFormValid && !_isLoading) ? Colors.white : Colors.grey.shade600,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                  ),
                ),
                elevation: (isFormValid && !_isLoading) ? 2 : 0,
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Save & New',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w500,
                        color: (isFormValid && !_isLoading) ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: (!_isLoading) ? _saveAndClose : null,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: (!_isLoading) ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                  ),
                ),
                side: BorderSide(
                  color: (!_isLoading) ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  fontWeight: FontWeight.w500,
                  color: isFormValid ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4CAF50),
                side: BorderSide(color: const Color(0xFF4CAF50)),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                  ),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuantityTypeDropdown() {
    final quantityTypes = [
      'Kg',
      'Litre',
      'Unit/Piece',
      'Gram'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Quantity Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ...quantityTypes.map((type) => ListTile(
                title: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedQuantityType = type;
                  });
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _addItem() async {
    final tempId = widget.tempExpenseId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';
    
    setState(() {
      _isLoading = true;
    });

    try {
      final item = Item(
        id: '',
        name: _itemNameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        quantityType: _selectedQuantityType,
        price: double.parse(_pricingController.text.trim()),
        expenseId: tempId,
        createdAt: DateTime.now(),
      );

      await _itemService.addItem(item);

      // Clear form after successful save
      setState(() {
        _itemNameController.clear();
        _quantityController.clear();
        _selectedQuantityType = 'Please Select';
        _pricingController.clear();
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item saved successfully! Will be linked when expense is created.'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveAndClose() async {
    // Save any current form data if filled and close
    if (_itemNameController.text.trim().isNotEmpty &&
        _quantityController.text.trim().isNotEmpty &&
        _selectedQuantityType != 'Please Select' &&
        _pricingController.text.trim().isNotEmpty) {
      
      // Generate a temporary expense ID if not provided
      final tempId = widget.tempExpenseId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';
      
      setState(() {
        _isLoading = true;
      });

      try {
        final item = Item(
          id: '', // Will be set by Firestore
          name: _itemNameController.text.trim(),
          quantity: int.parse(_quantityController.text.trim()),
          quantityType: _selectedQuantityType,
          price: double.parse(_pricingController.text.trim()),
          expenseId: tempId, // Use temporary ID for now
          createdAt: DateTime.now(),
        );

        await _itemService.addItem(item);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item saved successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
    
    // Return the temporary expense ID so expense sheet can use it
    Navigator.pop(context, widget.tempExpenseId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}'); 
  }
}
