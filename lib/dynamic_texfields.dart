import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppState extends ChangeNotifier {
  List<TextEditingController> _controllers = [];
  List<TextField> _textFields = [];

  List<TextEditingController> get getTextEditingController => _controllers;
  List<TextField> get getTextField => _textFields;

  set setTextEditingControllers(value) {
    _controllers = value;
    notifyListeners();
  }

  set setTextField(value) {
    _textFields = value;
    notifyListeners();
  }
}

class DynamicTextFieldSample extends StatefulWidget {
  const DynamicTextFieldSample({Key? key}) : super(key: key);

  @override
  State<DynamicTextFieldSample> createState() => _DynamicTextFieldSampleState();
}

class _DynamicTextFieldSampleState extends State<DynamicTextFieldSample> {
  final TextEditingController _titleController = TextEditingController();

  final List<TextEditingController> _controllers =
      AppState().getTextEditingController;

  final List<TextField> _textFields = AppState().getTextField;

  Widget _listView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _textFields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          child: _textFields[index],
        );
      },
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Sample Page'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OptionTile(
                    controllers: _controllers,
                    textFields: _textFields,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 30, left: 8, bottom: 15, right: 8),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
            ),
            Expanded(
              child: _listView(),
            ),
            SubmitButtonWidget(
              optionsControllers: _controllers,
              titleController: _titleController,
            ),
          ]),
        ),
      );
    });
  }
}

class SubmitButtonWidget extends StatelessWidget {
  final TextEditingController titleController;
  final List<TextEditingController> optionsControllers;

  const SubmitButtonWidget(
      {Key? key,
      required this.optionsControllers,
      required this.titleController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 60,
        width: 180,
        child: TextButton(
          onPressed: () async {
            String text = (titleController.text.isNotEmpty)
                ? '${titleController.text}\n'
                : 'No title provided\n';
            for (var element in optionsControllers) {
              if (element.text.isNotEmpty) {
                text += '${element.text}\n';
              }
            }
            final alert = AlertDialog(
              title: Text(
                "Total Field Count: ${optionsControllers.length + 1}",
              ),
              content: Text(text.trim()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
            await showDialog(
              context: context,
              builder: (BuildContext context) => alert,
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
          child: const Text(
            "Submit",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<TextField> textFields;

  const OptionTile(
      {Key? key, required this.controllers, required this.textFields})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 50,
        width: 115,
        child: TextButton.icon(
          onPressed: (controllers.length < 3)
              ? () {
                  {
                    final controller = TextEditingController();
                    final field = TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Option ${controllers.length + 1}',
                      ),
                    );
                    controllers.add(controller);
                    textFields.add(field);
                    provider.setTextEditingControllers = controllers;
                    provider.setTextField = textFields;
                  }
                }
              : null,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                (controllers.length < 3) ? Colors.blue : Colors.grey.shade400,
            disabledForegroundColor: Colors.black.withOpacity(0.38),
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
          label: const Text('ADD'),
          icon: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }
}
