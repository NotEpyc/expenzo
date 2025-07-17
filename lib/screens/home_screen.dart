import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/expense_category.dart';
import '../services/expense_service.dart';
import '../services/item_service.dart';
import '../utils/responsive_utils.dart';
import 'expense_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final ExpenseService _expenseService = ExpenseService();
  final ItemService _itemService = ItemService();

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _textFieldFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back, 
          color: const Color(0xFF4CAF50),
          size: ResponsiveUtils.getResponsiveIconSize(context, 24),
        ),
        onPressed: () {},
      ),
      title: Row(
        children: [
          Text(
            'Sales & Expense',
            style: TextStyle(
              color: Colors.black87,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 2)),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              size: ResponsiveUtils.getResponsiveIconSize(context, 18),
              color: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search, 
            color: Colors.grey, 
            size: ResponsiveUtils.getResponsiveIconSize(context, 30),
          ),
          onPressed: () {
            _controller.onSearch('');
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsivePadding(context, 8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildTab('Sales', 0),
          ),
          Expanded(
            flex: 2,
            child: _buildTab('Expense', 1),
          ),
          Expanded(
            flex: 3,
            child: _buildTab('Money Management', 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final isSelected = _controller.selectedTabIndex == index;
        return GestureDetector(
          onTap: () {
            _controller.changeTab(index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.getResponsivePadding(context, 16), 
              horizontal: ResponsiveUtils.getResponsivePadding(context, 4),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? const Color(0xFFE91E63) : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: ResponsiveUtils.isSmallPhone(context) ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? const Color(0xFFE91E63) : Colors.grey.shade600,
                fontSize: index == 2 
                    ? ResponsiveUtils.getResponsiveFontSize(context, 12)
                    : ResponsiveUtils.getResponsiveFontSize(context, 14),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 16)),
          child: Column(
            children: [
              _buildAddCategoryInput(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              ..._controller.categories.map((category) => _buildCategoryItem(category)),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 60)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddCategoryInput() {
    return GestureDetector(
      onTap: () {
        _textFieldFocusNode.requestFocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsivePadding(context, 16), 
          vertical: ResponsiveUtils.getResponsivePadding(context, 8),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 8),
          ),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _textFieldFocusNode,
                enableInteractiveSelection: true,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Type here to add more category',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  color: Colors.black87,
                ),
              ),
            ),
            if (_textController.text.isNotEmpty) ...[
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              GestureDetector(
                onTap: _addNewCategory,
                child: Icon(
                  Icons.arrow_forward,
                  color: const Color(0xFF4CAF50),
                  size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _addNewCategory() {
    if (_textController.text.trim().isNotEmpty) {
      _controller.addCategory(_textController.text.trim());
      _textController.clear();
      setState(() {});
      FocusScope.of(context).unfocus();
    }
  }

  Widget _buildCategoryItem(ExpenseCategory category) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 8),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 8),
          ),
          onTap: () {
            _controller.onCategoryTap(category.id);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsivePadding(context, 16), 
              vertical: ResponsiveUtils.getResponsivePadding(context, 16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getResponsiveBorderRadius(context, 8),
              ),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                if (category.hasIcon && category.isCompleted) ...[
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        // Options button - no functionality
                      },
                      child: Container(
                        width: ResponsiveUtils.getResponsiveIconSize(context, 24),
                        height: ResponsiveUtils.getResponsiveIconSize(context, 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                          ),
                          border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: const Color(0xFF4CAF50),
                          size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                ] else if (category.hasIcon) ...[
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 36)),
                ] else ...[
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 36)),
                ],
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        try {
          final expenseId = await _expenseService.createMinimalExpense();
          
          final result = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            enableDrag: true,
            isDismissible: true,
            builder: (context) => ExpenseSheet(expenseId: expenseId),
          );
          
          if (result != true) {
            await _expenseService.deleteExpense(expenseId);
            await _itemService.deleteItemsByExpenseId(expenseId);
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating expense: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      backgroundColor: const Color(0xFFE91E63),
      child: Icon(
        Icons.add, 
        color: Colors.white,
        size: ResponsiveUtils.getResponsiveIconSize(context, 24),
      ),
    );
  }
}
