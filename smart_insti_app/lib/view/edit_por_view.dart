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
  List<TextEditingController> positionControllers = [];
  List<TextEditingController> atControllers = [];
  late Function updatePors;

  removeComponent(por){
    setState((){
      por.positionController.text = "";
      por.atController.text = "";
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
    }
  }
  @override
 Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pors')),
      body: Padding(
        padding: EdgeInsets.all(width*0.025),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: positionControllers.length,
                itemBuilder: (context, index) {
                  return EditPor(
                    removeComponent, 
                    positionControllers[index], 
                    atControllers[index]
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    child: const Text('Add Por'),
                    onPressed: () {
                      setState(() {
                        positionControllers.add(TextEditingController());
                        atControllers.add(TextEditingController());
                      });
                    },
                  )
                ),

                SizedBox(width: width*0.015),

                Expanded(
                  child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      setState(() {
                        List<Por> updatedPors = [];
                        for(int i = 0; i < positionControllers.length; i++){
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
     atController =
         widget.atController;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: positionController,
                decoration: InputDecoration(
                  labelText: "Position",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                    borderSide: BorderSide(color: Colors.grey, width: width*0.001),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                  ),
                ),
              ),

              SizedBox(height: width*0.015),

              TextField(
                controller: atController,
                decoration: InputDecoration(
                  labelText: "At",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                    borderSide: BorderSide(color: Colors.grey, width: width*0.001),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                  ),
                ),
              ),
              SizedBox(height: width*0.03),
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
