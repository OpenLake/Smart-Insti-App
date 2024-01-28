import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/components/rounded_chip.dart';
import 'package:smart_insti_app/constants/constants.dart';
import '../../components/text_divider.dart';
import '../../provider/menu_provider.dart';

class AddMessMenu extends StatelessWidget {
  AddMessMenu({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MenuProvider menuProvider = Provider.of<MenuProvider>(context, listen: false);
    menuProvider.initMenu();
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Mess Menu'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Spreadsheet Entry",
                    style: TextStyle(fontSize: 32, fontFamily: "RobotoFlex"),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Upload file here",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () => menuProvider.pickSpreadsheet(),
                        style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
                        child: const Text("Upload Spreadsheet"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const TextDivider(text: "OR"),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    "Single Entry",
                    style: TextStyle(fontSize: 32, fontFamily: "RobotoFlex"),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: MaterialTextFormField(
                      controller: menuProvider.kitchenNameController,
                      validator: (value) => Validators.nameValidator(value),
                      hintText: "Enter kitchen name",
                      hintColor: Colors.teal.shade900.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SlideSwitcher(
                    onSelect: (index) => menuProvider.selectMealType(index),
                    containerHeight: 65,
                    containerWight: 380,
                    containerBorderRadius: 20,
                    slidersColors: [Colors.tealAccent.shade700.withOpacity(0.7)],
                    containerColor: Colors.tealAccent.shade100,
                    children: MessMenuConstants.mealTypes,
                  ),
                ),
                const SizedBox(height: 30),
                Consumer<MenuProvider>(
                  builder: (_, menuProvider, ___) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SlideSwitcher(
                              onSelect: (index) => menuProvider.selectWeekday(index),
                              containerHeight: 550,
                              containerWight: 70,
                              containerBorderRadius: 20,
                              direction: Axis.vertical,
                              slidersColors: [Colors.tealAccent.shade700.withOpacity(0.7)],
                              containerColor: Colors.tealAccent.shade100,
                              children: MessMenuConstants.weekdays),
                          Container(
                            height: 550,
                            width: 285,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.transparent, width: 0),
                              color: Colors.grey[200],
                            ),
                            child: Column(
                              children: [
                                Consumer<MenuProvider>(
                                  builder: (_, menuProvider, __) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "${menuProvider.weekday}'s ${menuProvider.mealType}",
                                        style: const TextStyle(fontSize: 23, fontFamily: "GoogleSanaFlex"),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: MaterialTextFormField(
                                    controller: menuProvider.itemNameController,
                                    onSubmitted: (value) => menuProvider.addMenuItem(),
                                    validator: (value) => Validators.nameValidator(value),
                                    hintText: 'Enter Menu Item',
                                    hintColor: Colors.teal.shade900.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Consumer<MenuProvider>(
                                  builder: (_, menuProvider, __) {
                                    return Container(
                                      width: 250,
                                      height: 360,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.transparent, width: 0),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 20, top: 15),
                                            alignment: Alignment.topLeft,
                                            child: const Text(
                                              "Menu Item",
                                              style: TextStyle(fontSize: 18, fontFamily: "GoogleSanaFlex"),
                                            ),
                                          ),
                                          const Divider(height: 20),
                                          Expanded(
                                            child: Consumer<MenuProvider>(
                                              builder: (_, menuProvider, ___) {
                                                return ListView.builder(
                                                  itemCount: menuProvider.currentMenu
                                                      .messMenu![menuProvider.weekday]![menuProvider.mealType]!.length,
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      alignment: Alignment.centerLeft,
                                                      child: RoundedChip(
                                                        label: menuProvider.currentMenu.messMenu![
                                                            menuProvider.weekday]![menuProvider.mealType]![index],
                                                        color: Colors.tealAccent.shade100,
                                                        onDeleted: () => menuProvider.removeMenuItem(index),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          menuProvider.addMenu();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Menu added successfully"),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
                      child: const Text("Add Menu"),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
