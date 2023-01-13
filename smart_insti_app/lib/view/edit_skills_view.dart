import 'package:flutter/material.dart';
import '../model/skill.dart';

class EditSkillView extends StatefulWidget {
  final List<Skill> skills;
  final Function updateSkills;
  const EditSkillView(this.skills, this.updateSkills, {super.key});
  @override
  EditSkillViewState createState() => EditSkillViewState();
}

class EditSkillViewState extends State<EditSkillView> {
  List<EditSkill> editComponents = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> profeciencyControllers = [];
  late Function updateSkills;

  removeComponent(skill){
    setState((){
      editComponents.remove(skill);
      titleControllers.remove(skill.titleController);
      profeciencyControllers.remove(skill.profeciencyController);
    });
  }
  @override
  void initState() {
    super.initState();
    updateSkills = widget.updateSkills;
    for(Skill skill in widget.skills){
      titleControllers.add(
        TextEditingController(
          text: skill.title,
        )
      );
      profeciencyControllers.add(
        TextEditingController(
          text: skill.profeciency.toString(),
        )
      );
      editComponents.add(
        EditSkill(
          removeComponent,
          titleControllers.last,
          profeciencyControllers.last,
        )
      );
    }
  }
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Skills')),
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
                    child: const Text('Add Skill'),
                    onPressed: () {
                      titleControllers.add(TextEditingController());
                      profeciencyControllers.add(TextEditingController());
                      setState(() {
                        editComponents.add(
                          EditSkill(
                            removeComponent,
                            titleControllers.last,
                            profeciencyControllers.last
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
                        List<Skill> updatedSkills = [];
                        for(int i = 0; i < editComponents.length; i++){
                          updatedSkills.add(
                            Skill(
                              title: titleControllers[i].text,
                              profeciency: int.parse(
                                profeciencyControllers[i].text
                              )
                            )
                          );
                        }
                        updateSkills(updatedSkills);
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

class EditSkill extends StatefulWidget {
  final Function removeComponent;
  final TextEditingController titleController;
  final TextEditingController profeciencyController;
  const EditSkill(
    this.removeComponent,
    this.titleController,
    this.profeciencyController,
    {
      super.key,
    }
  );
  @override
  EditSkillState createState() => EditSkillState();
}

class EditSkillState extends State<EditSkill> {
  late TextEditingController titleController;
  late TextEditingController profeciencyController;
  late Function removeComponent;
  int profeciency = 1;

  @override
  void initState() {
    super.initState();
    removeComponent = widget.removeComponent;
     titleController =
         widget.titleController;
     profeciencyController =
         widget.profeciencyController;
     if(profeciencyController.text != ''){
       profeciency = int.parse(profeciencyController.text);
     }
  }

  @override
  Widget build(BuildContext context) {

    var stars = <Widget>[];
    for(int i = 1; i <= 5; i++){
      stars.add(IconButton(
        icon: profeciency < i ? const Icon(Icons.star_border) : const Icon(Icons.star),
        onPressed: (){
          setState((){
            profeciency = i;
            profeciencyController.text = profeciency.toString();
          });
        },
      )
      );
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Skill",
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: stars,),
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

