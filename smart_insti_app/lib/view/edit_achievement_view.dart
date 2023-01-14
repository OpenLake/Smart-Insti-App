import 'package:flutter/material.dart';
import '../model/achievement.dart';

class EditAchievementView extends StatefulWidget {
  final List<Achievement> achievements;
  final Function updateAchievements;
  const EditAchievementView(this.achievements, this.updateAchievements, {super.key});
  @override
  EditAchievementViewState createState() => EditAchievementViewState();
}

class EditAchievementViewState extends State<EditAchievementView> {
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> descriptionControllers = [];
  late Function updateAchievements;

  removeComponent(achievement){
    setState((){
      achievement.titleController.text = "";
      achievement.descriptionController.text = "";
    });
  }
  @override
  void initState() {
    super.initState();
    updateAchievements = widget.updateAchievements;
    for(Achievement achievement in widget.achievements){
      titleControllers.add(
        TextEditingController(
          text: achievement.title,
        )
      );
      descriptionControllers.add(
        TextEditingController(
          text: achievement.description,
        )
      );
    }
  }
  @override
 Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Achievements')),
      body: Padding(
        padding: EdgeInsets.all(width*0.025),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: titleControllers.length,
                itemBuilder: (context, index) {
                  return EditAchievement(
                    removeComponent,
                    titleControllers[index],
                    descriptionControllers[index]
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
                        titleControllers.add(TextEditingController());
                        descriptionControllers.add(TextEditingController());
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
                        List<Achievement> updatedPors = [];
                        for(int i = 0; i < titleControllers.length; i++){
                            updatedPors.add(
                            Achievement(
                              title: titleControllers[i].text,
                              description: descriptionControllers[i].text
                            )
                          );
                        }
                        updateAchievements(updatedPors);
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

class EditAchievement extends StatefulWidget {
  final Function removeComponent;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  const EditAchievement(
    this.removeComponent,
    this.titleController,
    this.descriptionController,
    {
      super.key,
    }
  );
  @override
  EditAchievementState createState() => EditAchievementState();
}

class EditAchievementState extends State<EditAchievement> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late Function removeComponent;

  @override
  void initState() {
    super.initState();
    removeComponent = widget.removeComponent;
     titleController =
         widget.titleController;
        // TextEditingController(text: widget.title);
     descriptionController =
         widget.descriptionController;
        // TextEditingController(text: widget.description);
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
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
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
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Description",
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
