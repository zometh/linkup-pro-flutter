import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class PostsTagsView extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;
  final int maxTags;

  const PostsTagsView({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
    this.maxTags = 5,
  });

  @override
  State<PostsTagsView> createState() => _PostsTagsViewState();
}

class _PostsTagsViewState extends State<PostsTagsView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _suggestedTags = [];
  bool _showSuggestions = false;

  // Tags populaires suggérés (remplacer par un appel API)
  final List<String> _popularTags = [
    'flutter',
    'dart',
    'mobile',
    'dev',
    'coding',
    'tech',
    'tutorial',
    'app',
    'design',
    'ui',
    'ux',
    'animation',
    'tips',
    'tricks',
    'news',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _suggestedTags = [];
      });
      return;
    }

    setState(() {
      _suggestedTags = _popularTags
          .where((tag) =>
              tag.toLowerCase().contains(query) &&
              !widget.selectedTags.contains(tag))
          .take(10)
          .toList();
    });
  }

  void _addTag(String tag) {
    if (widget.selectedTags.length >= widget.maxTags) {

      return;
    }
    final formatedTag = tag.startsWith('#') ? tag.substring(1) : tag;
    if (!widget.selectedTags.contains(formatedTag)) {
      widget.onTagsChanged([...widget.selectedTags, formatedTag]);
      _searchController.clear();
      _focusNode.unfocus();
    }
  }

  void _removeTag(String tag) {
    widget.onTagsChanged(
        widget.selectedTags.where((t) => t != tag).toList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Champ de recherche
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                _addTag(value.trim());
              }
            },
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: '${"add_tags".tr()}...',
              prefixIcon: const Icon(Icons.tag, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _focusNode.unfocus();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Tags sélectionnés
        if (widget.selectedTags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedTags.map((tag) {
              return GestureDetector(
                onTap: () => _removeTag(tag),
                child :Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#$tag',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),

                       const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,

                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

        const SizedBox(height: 8),

        // Suggestions
        if (_showSuggestions && _suggestedTags.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestedTags.length,
              itemBuilder: (context, index) {
                final tag = _suggestedTags[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.tag, size: 20, color: Colors.grey),
                  title: Text(
                    '#$tag',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => _addTag(tag),
                );
              },
            ),
          ),

        // Tags populaires (quand pas de recherche active)
        if (!_showSuggestions && widget.selectedTags.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tags populaires',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _popularTags.take(8).map((tag) {
                  return GestureDetector(
                    onTap: () => _addTag(tag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

        // Compteur de tags
        if (widget.selectedTags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${widget.selectedTags.length}/${widget.maxTags} tags',
              style: TextStyle(
                fontSize: 12,
                color: widget.selectedTags.length >= widget.maxTags
                    ? Colors.red
                    : Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
