import 'package:flutter/material.dart';

class AnnotationScreen extends StatefulWidget {
  @override
  _AnnotationScreenState createState() => _AnnotationScreenState();
}

class _AnnotationScreenState extends State<AnnotationScreen> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _entityNametextEditingController =
      TextEditingController();
  String _selectedText = "", _beforeSelectedText = "", _afterSelectedText = "";
  String _annotatedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rasa Arabic Entity Annotator"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 50),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  style: TextStyle(fontSize: 20, height: 1.5),
                  controller: _textEditingController,
                  textDirection: TextDirection.rtl,
                  maxLines: 3,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                      labelText:
                          'Enter your arabic string and select/highlight the entity',
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      errorText: _getErrorText(),
                      hintText:
                          "Enter your arabic string and select/highlight the entity",
                      fillColor: Colors.white70),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                      style: TextStyle(fontSize: 15, height: 1.5),
                      controller: _entityNametextEditingController,
                      textDirection: TextDirection.rtl,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Entity name",
                          labelText: 'Entity name',
                          fillColor: Colors.white70),
                      maxLines: 1),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: RaisedButton(
                        child: Text("Process"),
                        onPressed: _onProcessButtonPressedAction,
                      ),
                    ),
                    SizedBox(width: 5),
                    FlatButton(
                      child: Text("Clear"),
                      onPressed: _onClearButtonPressedAction,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Selection:"),
              Text(
                "$_selectedText",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
                textAlign: TextAlign.end,
              ),
              SizedBox(height: 20),
              Text("Output:"),
              SelectableText(
                "$_annotatedText",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
                textAlign: TextAlign.end,
              ),
              _getErrorText() != null
                  ? Text(
                      "${_getErrorText()}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.end,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Action for process button
  ///
  _onProcessButtonPressedAction() {
    if (_textEditingController.text.length == 0) {
      setState(() {
        _selectedText = "Enter a valid string";
      });
      return;
    }

    if (!_textEditingController.selection.isValid) {
      setState(() {
        _selectedText = "Select the entity in the string";
      });
      return;
    }

    if (_entityNametextEditingController.text.length == 0) {
      setState(() {
        _selectedText = "Enter a entity name";
      });
      return;
    }

    String entityName = _entityNametextEditingController.text;
    entityName = entityName.trim();

    int selectionTextStart = _textEditingController.selection.baseOffset;
    int selectionTextEnd = _textEditingController.selection.extentOffset;

    int arabicTextStart = _textEditingController.text.length - selectionTextEnd;
    int arabicTextEnd = _textEditingController.text.length - selectionTextStart;

    _selectedText =
        _textEditingController.text.substring(arabicTextStart, arabicTextEnd);
    _beforeSelectedText =
        _textEditingController.text.substring(0, arabicTextStart);
    _afterSelectedText = _textEditingController.text
        .substring(arabicTextEnd, _textEditingController.text.length);

    _selectedText = _selectedText.trim();
    _beforeSelectedText = _beforeSelectedText.trim();
    _afterSelectedText = _afterSelectedText.trim();

    _annotatedText =
        "- $_beforeSelectedText [$_selectedText]($entityName) $_afterSelectedText";
    setState(() {});
  }

  ///
  /// Action for clear button
  ///
  _onClearButtonPressedAction() {
    _textEditingController.text = "";
    _entityNametextEditingController.text = "";
    setState(() {
      _selectedText = "";
      _beforeSelectedText = "";
      _afterSelectedText = "";
      _annotatedText = "";
    });
  }

  ///
  /// The error text for text field
  ///
  _getErrorText() {
    if (_textEditingController.text.length == 0) {
      return "Enter a string";
    }
    if (!_textEditingController.selection.isValid) {
      return "Select/highlight the entity";
    }
    return null;
  }
}
