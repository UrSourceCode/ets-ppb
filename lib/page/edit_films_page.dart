import 'package:flutter/material.dart';
import '../db/films_database.dart';
import '../model/film.dart';
import '../widget/film_form_widget.dart';

class AddEditFilmPage extends StatefulWidget {
  final Film? film;

  const AddEditFilmPage({
    Key? key,
    this.film,
  }) : super(key: key);

  @override
  State<AddEditFilmPage> createState() => _AddEditFilmPageState();
}

class _AddEditFilmPageState extends State<AddEditFilmPage> {
  final _formKey = GlobalKey<FormState>();
  late int number;
  late String title;
  late String description;
  late String coverLink;

  @override
  void initState() {
    super.initState();
    number = widget.film?.number ?? 0;
    title = widget.film?.title ?? '';
    description = widget.film?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: FilmFormWidget(
        number: number,
        title: title,
        description: description,
        onChangedNumber: (number) => setState(() => this.number = number),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
        onChangedCoverLink: (coverLink) =>
            setState(() => this.coverLink = coverLink)
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdatefilm,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdatefilm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.film != null;

      if (isUpdating) {
        await updatefilm();
      } else {
        await addfilm();
      }

      Navigator.of(context).pop();
    }
  }

  Future updatefilm() async {
    final film = widget.film!.copy(
      title: title,
      description: description,
    );

    await FilmsDatabase.instance.update(film);
  }

  Future addfilm() async {
    final film = Film(
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
      coverLink: coverLink,
    );

    await FilmsDatabase.instance.create(film);
  }
}