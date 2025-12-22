import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import 'search_results_screen.dart';

/// Search screen - search for restaurants and food
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                child: Column(
                  children: [
                    // Top bar
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundGrey,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimensions.spacing16),
                        Expanded(
                          child: ArabicText(
                            text: 'بحث',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundGrey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: AppDimensions.iconLarge,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppDimensions.spacing24),
                    
                    // Search bar
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Icon(
                            Icons.search,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: AppDimensions.spacing12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'بيتزا',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Tajawal',
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  ref.read(searchProvider.notifier).addToHistory(value);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchResultsScreen(
                                        searchQuery: value,
                                      ),
                                    ),
                                  );
                                }
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: AppDimensions.spacing16),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recent searches
                        if (searchState.history.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ArabicText(
                                text: 'عمليات البحث الأخيرة',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(searchProvider.notifier).clearHistory();
                                },
                                child: ArabicText(
                                  text: 'مسح الكل',
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: AppDimensions.spacing16),
                          
                          ...searchState.history.map((item) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.history,
                                color: AppColors.textSecondary,
                              ),
                              title: ArabicText(
                                text: item.query,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  ref.read(searchProvider.notifier).removeFromHistory(item.id);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResultsScreen(
                                      searchQuery: item.query,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                          
                          SizedBox(height: AppDimensions.spacing24),
                        ],
                        
                        // Popular searches
                        ArabicText(
                          text: 'عمليات البحث الشائعة',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        
                        SizedBox(height: AppDimensions.spacing16),
                        
                        Wrap(
                          spacing: AppDimensions.spacing12,
                          runSpacing: AppDimensions.spacing12,
                          children: searchState.popularSearches.map((keyword) {
                            return GestureDetector(
                              onTap: () {
                                ref.read(searchProvider.notifier).addToHistory(keyword);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResultsScreen(
                                      searchQuery: keyword,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spacing16,
                                  vertical: AppDimensions.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundGrey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ArabicText(
                                  text: keyword,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        
                        SizedBox(height: AppDimensions.spacing24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
