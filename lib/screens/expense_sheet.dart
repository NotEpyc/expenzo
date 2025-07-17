import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'add_items_sheet.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/item_service.dart';
import '../utils/responsive_utils.dart';
import '../config/api_keys.dart';

class ExpenseSheet extends StatefulWidget {
  final String expenseId;
  
  const ExpenseSheet({super.key, required this.expenseId});

  @override
  State<ExpenseSheet> createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends State<ExpenseSheet> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _vendorController = TextEditingController();
  final TextEditingController _totalBillingController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _vendorFocusNode = FocusNode();
  final FocusNode _paidFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();
  final ExpenseService _expenseService = ExpenseService();
  final ItemService _itemService = ItemService();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMode = 'Please Select';
  bool _showVendorField = false;
  bool _isPaidEditable = false;
  bool _isSubmitting = false;
  bool _isExpenseCompleted = false;
  double _totalItemsAmount = 0.0;
  List<String> _uploadedImageUrls = [];
  bool _isImageUploading = false;
  final ImagePicker _picker = ImagePicker();

  bool get _isFormValid {
    return _categoryController.text.trim().isNotEmpty &&
           _selectedPaymentMode != 'Please Select' &&
           _paidController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _categoryController.addListener(_onCategoryChanged);
    _categoryController.addListener(_onFormChanged);
    _paidController.addListener(_onFormChanged);
    _totalBillingController.text = '0.00';
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTotalBillingFromItems();
    });
  }

  @override
  void dispose() {
    _categoryController.removeListener(_onCategoryChanged);
    _categoryController.removeListener(_onFormChanged);
    _paidController.removeListener(_onFormChanged);
    _categoryController.dispose();
    _vendorController.dispose();
    _totalBillingController.dispose();
    _paidController.dispose();
    _notesController.dispose();
    _categoryFocusNode.dispose();
    _vendorFocusNode.dispose();
    _paidFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  void _onCategoryChanged() {
    setState(() {
      _showVendorField = _categoryController.text.toLowerCase() == 'grocery';
    });
  }

  void _onFormChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      _buildDateField(),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                      _buildCategoryField(),
                      if (_showVendorField) ...[
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                        _buildVendorField(),
                      ],
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                      _buildAddItemButton(),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                      _buildTotalBillingField(),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                      _buildPaidField(),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                      _buildPaymentModeField(),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                      _buildUploadInvoiceField(),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
                      _buildNotesField(),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 40)),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New Expense',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE91E63),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Date',
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
        const SizedBox(height: 2),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: const Color(0xFF4CAF50),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Category Name',
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
          controller: _categoryController,
          focusNode: _categoryFocusNode,
          decoration: InputDecoration(
            hintText: 'Please type here',
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
      ],
    );
  }

  Widget _buildVendorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Vendor Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(optional)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _vendorController,
          focusNode: _vendorFocusNode,
          decoration: InputDecoration(
            hintText: 'Please type here',
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
      ],
    );
  }

  Widget _buildAddItemButton() {
    return GestureDetector(
      onTap: _openAddItemsSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4CAF50)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _totalItemsAmount > 0 ? Icons.edit : Icons.add,
                color: Color(0xFF4CAF50),
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _totalItemsAmount > 0 ? 'Edit/View/Add Item' : 'Add Items',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBillingField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              const Text(
                'Total Billing',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.info_outline,
                size: 18,
                color: const Color(0xFF4CAF50),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              const Text(
                '₹',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _totalBillingController,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: _totalItemsAmount > 0 ? Colors.green.shade700 : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaidField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: const Text(
            'Paid',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              const Text(
                '₹',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE91E63),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _paidController,
                  focusNode: _paidFocusNode,
                  keyboardType: TextInputType.number,
                  enabled: _isPaidEditable,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFE91E63)),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: _isPaidEditable ? const Color(0xFFE91E63) : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _togglePaidEditing,
                child: Icon(
                  _isPaidEditable ? Icons.check : Icons.edit,
                  size: 18,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentModeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Mode of Payment',
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
        GestureDetector(
          onTap: _showPaymentModeDropdown,
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
                Text(
                  _selectedPaymentMode,
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedPaymentMode == 'Please Select' 
                        ? const Color(0xFF4CAF50) 
                        : Colors.black87,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadInvoiceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Invoice/Images',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Display uploaded images on the left
            if (_uploadedImageUrls.isNotEmpty) ...[
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _uploadedImageUrls.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                _uploadedImageUrls[index],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.grey.shade600,
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Remove button
                          Positioned(
                            top: -4,
                            right: -4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _uploadedImageUrls.removeAt(index);
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            // Plus button (on the right)
            GestureDetector(
              onTap: _isImageUploading ? null : _openGallery,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _isImageUploading 
                      ? Colors.grey.shade300 
                      : const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isImageUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(if any)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          focusNode: _notesFocusNode,
          minLines: 1,
          maxLines: 6,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: 'Description',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
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
              borderSide: const BorderSide(color: Color(0xFF4CAF50)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignLabelWithHint: true,
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isSubmitting || _isExpenseCompleted || !_isFormValid) ? null : _submitExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: (_isSubmitting || _isExpenseCompleted || !_isFormValid)
                    ? Colors.grey.shade300 
                    : const Color(0xFF4CAF50),
                foregroundColor: (_isSubmitting || _isExpenseCompleted || !_isFormValid)
                    ? Colors.grey.shade600 
                    : Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: (_isSubmitting || _isExpenseCompleted || !_isFormValid) ? 0 : 2,
              ),
              child: _isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: ResponsiveUtils.getResponsiveIconSize(context, 16),
                          height: ResponsiveUtils.getResponsiveIconSize(context, 16),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.shade600,
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                        Text(
                          'Submitting...',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      _isExpenseCompleted ? 'Saved' : 'Submit',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _isSubmitting ? null : () {
                Navigator.pop(context, false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _isSubmitting 
                    ? Colors.grey.shade400 
                    : const Color(0xFF4CAF50),
                side: BorderSide(
                  color: _isSubmitting 
                      ? Colors.grey.shade400 
                      : const Color(0xFF4CAF50),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
        ],
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
              onSurfaceVariant: Colors.grey.shade600,
              outline: Colors.transparent,
              secondary: const Color(0xFF4CAF50),
              onSecondary: Colors.white,
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              titleMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              labelLarge: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            iconTheme: IconThemeData(
              color: const Color(0xFF4CAF50),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              elevation: 8,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              contentTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              actionsPadding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 8,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              headerForegroundColor: Colors.black87,
              dividerColor: Colors.transparent,
              weekdayStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              dayStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey.shade400;
                }
                return Colors.black87;
              }),
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFFE91E63);
                }
                return Colors.transparent;
              }),
              todayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return const Color(0xFFE91E63);
              }),
              todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFFE91E63);
                }
                return Colors.transparent;
              }),
              todayBorder: BorderSide(
                color: const Color(0xFFE91E63),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              rangeSelectionBackgroundColor: const Color(0xFFE91E63).withOpacity(0.1),
              rangeSelectionOverlayColor: MaterialStateProperty.all(
                const Color(0xFFE91E63).withOpacity(0.1),
              ),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.black.withOpacity(0.1),
              elevation: 8,
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')}-${months[date.month - 1]}-${date.year}';
  }

  void _showPaymentModeDropdown() {
    final paymentOptions = [
      'Cash',
      'UPI',
      'Debit/Credit Card',
      'NEFT/RTGS',
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
                'Select Payment Mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ...paymentOptions.map((option) => ListTile(
                title: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedPaymentMode = option;
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

  void _openGallery() {
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
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: const Color(0xFF4CAF50),
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: const Color(0xFF4CAF50),
                ),
                title: const Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _pickImageFromGallery() async {
    PermissionStatus permission = await Permission.photos.request();
    
    if (permission == PermissionStatus.granted) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        
        if (image != null) {
          await _uploadImageToImgBB(File(image.path));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (permission == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gallery permission denied'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (permission == PermissionStatus.permanentlyDenied) {
      _showPermissionDeniedDialog();
    }
  }

  void _pickImageFromCamera() async {
    PermissionStatus permission = await Permission.camera.request();
    
    if (permission == PermissionStatus.granted) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        
        if (image != null) {
          await _uploadImageToImgBB(File(image.path));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (permission == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission denied'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (permission == PermissionStatus.permanentlyDenied) {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _uploadImageToImgBB(File imageFile) async {
    setState(() {
      _isImageUploading = true;
    });

    try {
      final base64Image = base64Encode(imageFile.readAsBytesSync());
      final response = await http.post(
        Uri.parse(ApiKeys.getImgbbUploadUrl()),
        body: {
          'image': base64Image,
          'name': 'flutter_upload',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          final imageUrl = responseData['data']['url'];
          setState(() {
            _uploadedImageUrls.add(imageUrl);
            _isImageUploading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully!'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        } else {
          throw Exception('Upload failed: ${responseData['error']['message']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isImageUploading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Permission Required'),
        content: const Text(
          'This app needs access to your gallery and camera to upload invoice images. Please grant permission in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings', style: TextStyle(color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }

  void _openAddItemsSheet() async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: false,
      builder: (context) => AddItemsSheet(tempExpenseId: widget.expenseId),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    
    await _updateTotalBillingFromItems();
    
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Items updated successfully'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _openAddItemsSheetWithExpenseId(String expenseId) async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: false,
      builder: (context) => AddItemsSheet(tempExpenseId: expenseId),
    );

    await _updateTotalBillingFromItems();
    
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Items saved to database successfully'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }

  Future<void> _submitExpense() async {
    if (_isExpenseCompleted) {
      _showErrorSnackBar('This expense has already been saved');
      return;
    }

    if (_categoryController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a category name');
      return;
    }

    if (_selectedPaymentMode == 'Please Select') {
      _showErrorSnackBar('Please select a payment mode');
      return;
    }

    if (_paidController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter the paid amount');
      return;
    }

    await _updateTotalBillingFromItems();

    double totalBilling = _totalItemsAmount > 0 ? _totalItemsAmount : 
        (_totalBillingController.text.trim().isNotEmpty ? 
         double.tryParse(_totalBillingController.text.trim()) ?? 0.0 : 0.0);
    
    if (totalBilling <= 0) {
      _showErrorSnackBar('Please add items or enter a total billing amount');
      return;
    }

    double paid;

    try {
      paid = double.parse(_paidController.text.trim());
    } catch (e) {
      _showErrorSnackBar('Please enter valid numeric values for paid amount');
      return;
    }

    if (totalBilling < 0 || paid < 0) {
      _showErrorSnackBar('Billing amounts cannot be negative');
      return;
    }

    if (paid > totalBilling) {
      _showErrorSnackBar('Paid amount cannot be greater than total billing');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      List<String> itemIds = [];
      try {
        final items = await _itemService.getItemsByExpenseId(widget.expenseId);
        itemIds = items.map((item) => item.id).toList();
      } catch (e) {
        print('Could not fetch item IDs: $e');
      }

      final expense = Expense(
        id: widget.expenseId,
        date: _selectedDate,
        categoryName: _categoryController.text.trim(),
        vendorName: _vendorController.text.trim().isNotEmpty 
            ? _vendorController.text.trim() 
            : null,
        items: [],
        itemIds: itemIds,
        totalBilling: totalBilling,
        paid: paid,
        paymentMode: _selectedPaymentMode,
        notes: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
        imageUrls: _uploadedImageUrls,
      );

      await _expenseService.updateExpense(widget.expenseId, expense);

      setState(() {
        _isExpenseCompleted = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Expense saved successfully!'),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Add Items',
              textColor: Colors.white,
              onPressed: () {
                _openAddItemsSheetWithExpenseId(widget.expenseId);
              },
            ),
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to save expense: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _togglePaidEditing() {
    setState(() {
      _isPaidEditable = !_isPaidEditable;
    });
    
    if (_isPaidEditable) {
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_paidFocusNode);
        _paidController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _paidController.text.length,
        );
      });
    } else {
      _paidFocusNode.unfocus();
    }
  }

  Future<void> _updateTotalBillingFromItems() async {
    try {
      final totalPrice = await _itemService.getTotalItemPriceForExpense(widget.expenseId);
      if (mounted) {
        setState(() {
          _totalItemsAmount = totalPrice;
          _totalBillingController.text = totalPrice.toStringAsFixed(2);
        });
      }
    } catch (e) {
      print('Failed to calculate total items price: $e');
      if (mounted) {
        setState(() {
          _totalItemsAmount = 0.0;
          _totalBillingController.text = '0.00';
        });
      }
    }
  }
}
