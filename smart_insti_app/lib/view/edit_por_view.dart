import 'package:flutter/material.dart';
import '../model/por.dart';

class EditPorView extends StatefulWidget {
  final List<Por> pors;
  final Function updatePors;
  const EditPorView(this.pors, this.updatePors, {super.key});
  @override
  EditPorViewState createState() => EditPorViewState();
}

class EditPorViewState extends State<EditPorView> {
  List<EditPor> editComponents = [];
  List<TextEditingController> positionControllers = [];
  List<TextEditingController> atControllers = [];
  late Function updatePors;

  removeComponent(por){
    setState((){
      editComponents.remove(por);
      positionControllers.remove(por.positionController);
      atControllers.remove(por.atController);
    });
  }
  @override
  void initState() {
    super.initState();
    updatePors = widget.updatePors;
    for(Por por in widget.pors){
      positionControllers.add(
        TextEditingController(
          text: por.position,
        )
      );
      atControllers.add(
        TextEditingController(
          text: por.at,
        )
      );
      editComponents.add(
        EditPor(
          removeComponent,
          positionControllers.last,
          atControllers.last,
        )
      );
    }
  }
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pors')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: editComponents.length,
                itemBuilder: (context, index) {
                  return editComponents[index];
                },
              ),
            ),
            Row(
              children: <Widget>[

                Expanded(
                  child: OutlinedButton(
                    child: const Text('Add Por'),
                    onPressed: () {
                      positionControllers.add(TextEditingController());
                      atControllers.add(TextEditingController());
                      setState(() {
                        editComponents.add(
                          EditPor(
                            removeComponent,
                            positionControllers.last,
                            atControllers.last
                          )
                        );
                      });
                    },
                  )
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      setState(() {
                        List<Por> updatedPors = [];
                        for(int i = 0; i < editComponents.length; i++){
                          updatedPors.add(
                            Por(
                              position: positionControllers[i].text,
                              at: atControllers[i].text
                            )
                          );
                        }
                        updatePors(updatedPors);
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}

class EditPor extends StatefulWidget {
  final Function removeComponent;
  final TextEditingController positionController;
  final TextEditingController atController;
  const EditPor(
    this.removeComponent,
    this.positionController,
    this.atController,
    {
      super.key,
    }
  );
  @override
  EditPorState createState() => EditPorState();
}

class EditPorState extends State<EditPor> {
  late TextEditingController positionController;
  late TextEditingController atController;
  late Function removeComponent;

  @override
  void initState() {
    super.initState();
    removeComponent = widget.removeComponent;
     positionController =
         widget.positionController;
        // TextEditingController(text: widget.title);
     atController =
         widget.atController;
        // TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: "Position",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              TextField(
                controller: atController,
                decoration: const InputDecoration(
                  labelText: "At",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ]
          ),
        ),

        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: (){
            removeComponent(widget);
          },
        ),
      ],
    );
  }
}
