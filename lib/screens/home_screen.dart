import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/expense_category.dart';
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
        icon: const Icon(Icons.arrow_back, color:  Color(0xFF4CAF50)),
        onPressed: () {},
      ),
      title: Row(
        children: [
          const Text(
            'Sales & Expense',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 18,
              color: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.grey, size: 30,),
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
      child: Row(
        children: [
          Expanded(
            child: _buildTab('Sales', 0),
          ),
          Expanded(
            child: _buildTab('Expense', 1),
          ),
          Expanded(
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
            padding: const EdgeInsets.symmetric(vertical: 16),
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
              style: TextStyle(
                color: isSelected ? const Color(0xFFE91E63) : Colors.grey.shade600,
                fontSize: 14,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildAddCategoryInput(),
              const SizedBox(height: 16),
              ..._controller.categories.map((category) => _buildCategoryItem(category)),
              const SizedBox(height: 60),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            if (_textController.text.isNotEmpty) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _addNewCategory,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF4CAF50),
                  size: 20,
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

  void _showOptionsMenu(BuildContext context, ExpenseCategory category) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + 120,
        position.dy + size.height + 100,
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      useRootNavigator: true,
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red.shade400,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _editCategory(category);
      } else if (value == 'delete') {
        _deleteCategory(category);
      }
    });
  }

  void _editCategory(ExpenseCategory category) {
    // TODO: Implement edit functionality
    debugPrint('Edit category: ${category.name}');
  }

  void _deleteCategory(ExpenseCategory category) {
    _controller.deleteCategory(category.id);
  }

  Widget _buildCategoryItem(ExpenseCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            _controller.onCategoryTap(category.id);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                if (category.hasIcon && category.isCompleted) ...[
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => _showOptionsMenu(context, category),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: const Color(0xFF4CAF50),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else if (category.hasIcon) ...[
                  const SizedBox(width: 36),
                ] else ...[
                  const SizedBox(width: 36),
                ],
                Expanded(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
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
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          enableDrag: true,
          isDismissible: true,
          builder: (context) => const ExpenseSheet(),
        );
      },
      backgroundColor: const Color(0xFFE91E63),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
