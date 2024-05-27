import 'package:flutter/material.dart';

class SuggestibleTextField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> suggestions;

  const SuggestibleTextField({Key? key, required this.controller, required this.suggestions}) : super(key: key);

  @override
  _SuggestibleTextFieldState createState() => _SuggestibleTextFieldState();
}

class _SuggestibleTextFieldState extends State<SuggestibleTextField> {
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_filterSuggestions);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_filterSuggestions);
    super.dispose();
  }

  void _filterSuggestions() {
    final input = widget.controller.text;
    setState(() {
      if (input.isEmpty) {
        _filteredSuggestions = [];
      } else {
        _filteredSuggestions = widget.suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(input.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter text',
          ),
        ),
        if (_filteredSuggestions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredSuggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredSuggestions[index]),
                onTap: () {
                  setState(() {
                    widget.controller.text = _filteredSuggestions[index];
                    _filteredSuggestions = [];
                  });
                },
              );
            },
          ),
      ],
    );
  }
}