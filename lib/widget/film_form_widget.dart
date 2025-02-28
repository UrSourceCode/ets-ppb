import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/film.dart';

class FilmFormWidget extends StatelessWidget {
  final int? number;
  final String? title;
  final String? description;
  final String? coverLink;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<String> onChangedCoverLink;

  const FilmFormWidget({
    Key? key,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription, this.coverLink, required this.onChangedCoverLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: (number ?? 0).toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  onChanged: (number) => onChangedNumber(number.toInt()),
                ),
              )
            ],
          ),
          buildTitle(),
          const SizedBox(height: 8),
          buildDescription(),
          const SizedBox(height: 16),
          buildCoverLink(),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );

  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue: title,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (title) =>
    title != null && title.isEmpty ? 'The title cannot be empty' : null,
    onChanged: onChangedTitle,
  );

  Widget buildDescription() => TextFormField(
    maxLines: 5,
    initialValue: description,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The description cannot be empty'
        : null,
    onChanged: onChangedDescription,
  );

  Widget buildCoverLink() => TextFormField(
    maxLines: 1,
    initialValue: coverLink,
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 16,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Cover Link (URL)',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (coverLink) =>
    coverLink != null && coverLink.isEmpty ? 'The cover link cannot be empty' : null,
    onChanged: onChangedCoverLink,
  );
}