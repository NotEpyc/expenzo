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
  bool _isSaveLoading = false;
  List<Item> _items = [];
  late String _currentTempId;

  @override
  void initState() {
    super.initState();
    _currentTempId = widget.tempExpenseId ?? '';
    _loadItems();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _pricingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: _items.isNotEmpty ? () {
              _showItemsList();
            } : null,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsivePadding(context, 12), 
                vertical: ResponsiveUtils.getResponsivePadding(context, 6),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _items.isNotEmpty ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveBorderRadius(context, 20),
                ),
              ),
              child: Text(
                'View List',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  color: _items.isNotEmpty ? const Color(0xFF4CAF50) : Colors.grey.shade600,
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
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(16),
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
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
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
              onPressed: (isFormValid && !_isLoading && !_isSaveLoading) ? _addItem : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (isFormValid && !_isLoading && !_isSaveLoading) ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                foregroundColor: (isFormValid && !_isLoading && !_isSaveLoading) ? Colors.white : Colors.grey.shade600,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getResponsiveBorderRadius(context, 16),
                  ),
                ),
                elevation: (isFormValid && !_isLoading && !_isSaveLoading) ? 2 : 0,
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
                        color: (isFormValid && !_isLoading && !_isSaveLoading) ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: (isFormValid && !_isLoading && !_isSaveLoading) ? _saveAndClose : null,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: (isFormValid && !_isLoading && !_isSaveLoading) ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getResponsiveBorderRadius(context, 16),
                  ),
                ),
                side: BorderSide(
                  color: (isFormValid && !_isLoading && !_isSaveLoading) ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                ),
              ),
              child: _isSaveLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF4CAF50)),
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w500,
                        color: (isFormValid && !_isLoading && !_isSaveLoading) ? const Color(0xFF4CAF50) : Colors.grey.shade400,
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
                    ResponsiveUtils.getResponsiveBorderRadius(context, 16),
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
        expenseId: _currentTempId,
        createdAt: DateTime.now(),
      );

      await _itemService.addItem(item);

      setState(() {
        _itemNameController.clear();
        _quantityController.clear();
        _selectedQuantityType = 'Please Select';
        _pricingController.clear();
        _isLoading = false;
      });

      await _loadItems();

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
    if (_itemNameController.text.trim().isEmpty ||
        _quantityController.text.trim().isEmpty ||
        _selectedQuantityType == 'Please Select' ||
        _pricingController.text.trim().isEmpty) {
      Navigator.pop(context, _currentTempId);
      return;
    }
    
    setState(() {
      _isSaveLoading = true;
    });

    try {
      final item = Item(
        id: '',
        name: _itemNameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        quantityType: _selectedQuantityType,
        price: double.parse(_pricingController.text.trim()),
        expenseId: _currentTempId,
        createdAt: DateTime.now(),
      );

      await _itemService.addItem(item);
      
      await _loadItems();
      
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
      _isSaveLoading = false;
    });
    
    Navigator.pop(context, _currentTempId); 
  }

  Future<void> _loadItems() async {
    if (_currentTempId.isEmpty) {
      setState(() {
        _items = [];
      });
      return;
    }
    
    try {
      final items = await _itemService.getItemsByExpenseId(_currentTempId);
      setState(() {
        _items = items;
      });
    } catch (e) {
      print('Failed to load items: $e');
    }
  }

  void _showItemsList() async {
    await _loadItems();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => _buildItemsListModal(setModalState),
      ),
    );
  }

  Widget _buildItemsListModal(StateSetter setModalState) {
    double totalBilling = _items.fold(0.0, (sum, item) => sum + item.price);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
          topRight: Radius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Item Name',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Rate',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 40)),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: ResponsiveUtils.getResponsiveIconSize(context, 64),
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                        Text(
                          'No items added yet',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _items.length,
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Colors.black,
                      margin: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getResponsivePadding(context, 20),
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Container(
                        padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${item.quantity} ${item.quantityType}',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '₹ ${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                            GestureDetector(
                              onTap: () => _deleteItem(item.id, index, setModalState),
                              child: Container(
                                padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 4)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.getResponsiveBorderRadius(context, 4),
                                  ),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Billing',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '₹ ${totalBilling.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _items.isNotEmpty ? () {
                      Navigator.pop(context);
                      Navigator.pop(context, _currentTempId);
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _items.isNotEmpty ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                      foregroundColor: _items.isNotEmpty ? Colors.white : Colors.grey.shade600,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(context, 16),
                        ),
                      ),
                      elevation: _items.isNotEmpty ? 2 : 0,
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w500,
                        color: _items.isNotEmpty ? Colors.white : Colors.grey.shade600,
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
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4CAF50),
                      side: BorderSide(color: const Color(0xFF4CAF50)),
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(context, 16),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 4)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF4CAF50)),
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.getResponsiveBorderRadius(context, 4),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                        Text(
                          'Add Items',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _items.isNotEmpty ? () => _deleteAllItems(setModalState) : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _items.isNotEmpty ? Colors.red : Colors.grey.shade400,
                      side: BorderSide(color: _items.isNotEmpty ? Colors.red : Colors.grey.shade300),
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(context, 16),
                        ),
                      ),
                    ),
                    child: Text(
                      'Delete All',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w500,
                        color: _items.isNotEmpty ? Colors.red : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(String itemId, int index, [StateSetter? setModalState]) async {
    final Item removedItem = _items[index];
    
    setState(() {
      _items.removeAt(index);
    });
    
    if (setModalState != null) {
      setModalState(() {});
    }
    
    try {
      await _itemService.deleteItem(itemId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item deleted successfully'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _items.insert(index, removedItem);
      });
      
      if (setModalState != null) {
        setModalState(() {});
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAllItems([StateSetter? setModalState]) async {
    if (_items.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Delete All Items'),
        content: Text('Are you sure you want to delete all items? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                for (final item in _items) {
                  await _itemService.deleteItem(item.id);
                }
                setState(() {
                  _items.clear();
                });
                
                if (setModalState != null) {
                  setModalState(() {});
                }
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All items deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete items: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
