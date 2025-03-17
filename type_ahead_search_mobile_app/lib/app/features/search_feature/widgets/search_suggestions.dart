


// lib/app/modules/search/views/widgets/search_suggestions.dart
import 'package:flutter/material.dart';

class SearchSuggestions extends StatefulWidget {
  final List<String> searchHistory;
  final Function(String) onSuggestionSelected;
  final String currentQuery;

  const SearchSuggestions({
    Key? key,
    required this.searchHistory,
    required this.onSuggestionSelected,
    required this.currentQuery,
  }) : super(key: key);

  @override
  State<SearchSuggestions> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<String> _filteredSuggestions = [];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _updateFilteredSuggestions();
  }
  
  @override
  void didUpdateWidget(SearchSuggestions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuery != widget.currentQuery || 
        oldWidget.searchHistory != widget.searchHistory) {
      _updateFilteredSuggestions();
    }
  }
  
  void _updateFilteredSuggestions() {
    if (widget.currentQuery.isEmpty) {
      _filteredSuggestions = widget.searchHistory.take(5).toList();
    } else {
      _filteredSuggestions = widget.searchHistory
        .where((suggestion) => 
          suggestion.toLowerCase().contains(widget.currentQuery.toLowerCase())
        )
        .take(5)
        .toList();
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_filteredSuggestions.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Suggestions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 250,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredSuggestions.length,
                    itemBuilder: (context, index) {
                      return _buildSuggestionItem(
                        _filteredSuggestions[index],
                        highlight: widget.currentQuery.isNotEmpty ? widget.currentQuery : null,
                      );
                    },
                  ),
                ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No matching suggestions',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion, {String? highlight}) {
    if (highlight != null && highlight.isNotEmpty) {
      // Highlight the matching part
      final lowercaseSuggestion = suggestion.toLowerCase();
      final lowercaseHighlight = highlight.toLowerCase();
      final int startIndex = lowercaseSuggestion.indexOf(lowercaseHighlight);
      
      if (startIndex != -1) {
        final int endIndex = startIndex + lowercaseHighlight.length;
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: suggestion.substring(0, startIndex),
                  style: const TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: suggestion.substring(startIndex, endIndex),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.yellow.shade100,
                  ),
                ),
                TextSpan(
                  text: suggestion.substring(endIndex),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          onTap: () => widget.onSuggestionSelected(suggestion),
        );
      }
    }
    
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(suggestion),
      onTap: () => widget.onSuggestionSelected(suggestion),
    );
  }
}