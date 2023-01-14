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
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> profeciencyControllers = [];
  late Function updateSkills;

  removeComponent(skill){
    setState((){
      skill.titleController.text = "";
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
    }
  }
  @override
 Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Skills')),
      body: Padding(
        padding: EdgeInsets.all(width*0.015),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: titleControllers.length,
                itemBuilder: (context, index) {
                  return EditSkill(removeComponent,
                    titleControllers[index],
                    profeciencyControllers[index]
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    child: const Text('Add Skill'),
                    onPressed: () {
                      setState(() {
                        titleControllers.add(TextEditingController());
                        profeciencyControllers.add(TextEditingController());
                      });
                    },
                  )
                ),

                SizedBox(width: width*0.01),

                Expanded(
                  child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      setState(() {
                        List<Skill> updatedSkills = [];
                        for(int i = 0; i < titleControllers.length; i++){
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
    final double width = MediaQuery.of(context).size.width;

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
                decoration: InputDecoration(
                  labelText: "Skill",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                    borderSide: BorderSide(color: Colors.grey, width: width*0.001),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(width*0.005)),
                  ),
                ),
              ),

              SizedBox(height: width*0.005),

              Padding(
                padding: EdgeInsets.symmetric(vertical: width*0.005),
                child: Row(children: stars,),
              ),

              SizedBox(height: width*0.01),
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

