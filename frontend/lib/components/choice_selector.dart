import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_choices/search_choices.dart';

import '../constants/constants.dart';
import 'borderless_button.dart';
import 'material_textformfield.dart';

class ChoiceSelector extends StatelessWidget {
  ChoiceSelector(
      {super.key,
      required this.hint,
      required this.onChanged,
      required this.items,
      this.value,
      this.addSelectableItem,
      this.addItemEnabled = true});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Function onChanged;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final void Function(String)? addSelectableItem;
  final String hint;
  final bool addItemEnabled;

  final TextEditingController _addController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Function globalCloseFunction = () {};
    bool isChanged = false;
    addItemDialog() async {
      return await showDialog(
        context: context,
        builder: (BuildContext alertContext) {
          return (AlertDialog(
            title: const Text("Add and select item"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MaterialTextFormField(
                    hintText: '',
                    controller: _addController,
                    validator: (value) => Validators.nonEmptyValidator(value),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      BorderlessButton(
                        onPressed: () => context.pop(),
                        backgroundColor: Colors.redAccent.shade100,
                        splashColor: Colors.red.shade900,
                        label: const Text("Cancel"),
                      ),
                      const Spacer(),
                      BorderlessButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            addSelectableItem!(_addController.text);
                            isChanged = true;
                            onChanged(_addController.text);
                            context.pop();
                            _addController.clear();
                            globalCloseFunction();
                          }
                        },
                        label: const Text("Add"),
                        backgroundColor: Colors.greenAccent,
                        splashColor: Colors.green.shade900,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        },
      );
    }

    if (addItemEnabled && addSelectableItem == null) {
      throw ArgumentError("addSelectableItem must be provided if addItemEnabled is true");
    }
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: SearchChoices.single(
        style: TextStyle(
          color: Colors.teal.shade900,
          fontSize: 15,
          fontFamily: "RobotoFlex",
        ),
        items: items,
        value: value,
        hint: hint,
        searchHint: null,
        onChanged: (value) {
          if (!isChanged) {
            onChanged(value);
          }
        },
        dialogBox: false,
        isExpanded: true,
        displayClearIcon: false,
        fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
          return InputDecorator(
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.teal.shade900,
                fontSize: 15,
                fontFamily: "RobotoFlex",
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              isDense: true,
              filled: true,
              fillColor: Colors.tealAccent.withOpacity(0.4),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            child: fieldWidget,
          );
        },
        closeButton: (values, closeContext, updateParent) {
          return Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              children: [
                addItemEnabled
                    ? BorderlessButton(
                        backgroundColor: Colors.tealAccent.shade400,
                        onPressed: () => addItemDialog(),
                        splashColor: Colors.orange.shade900,
                        label: Text("Add", style: TextStyle(color: Colors.teal.shade900, fontSize: 15)),
                      )
                    : const SizedBox.shrink(),
                const Spacer(),
                BorderlessButton(
                  backgroundColor: Colors.tealAccent.shade400,
                  onPressed: () {
                    globalCloseFunction();
                  },
                  splashColor: Colors.red.shade900,
                  label: Text("Close", style: TextStyle(color: Colors.teal.shade900, fontSize: 15)),
                ),
              ],
            ),
          );
        },
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
        giveMeThePop: (Function popFunction) {
          globalCloseFunction = popFunction;
        },
        validator: null,
        menuBackgroundColor: Colors.tealAccent.shade100,
      ),
    );
  }
}
