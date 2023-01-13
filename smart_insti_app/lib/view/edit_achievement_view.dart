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
  List<EditAchievement> editComponents = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> descriptionControllers = [];
  late Function updateAchievements;

  removeComponent(achievement){
    setState((){
      editComponents.remove(achievement);
      titleControllers.remove(achievement.titleController);
      descriptionControllers.remove(achievement.descriptionController);
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
      editComponents.add(
        EditAchievement(
          removeComponent,
          titleControllers.last,
          descriptionControllers.last,
        )
      );
    }
  }
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Achievements')),
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
            OutlinedButton(
              child: const Text('Add Achievement'),
              onPressed: () {
                titleControllers.add(TextEditingController());
                descriptionControllers.add(TextEditingController());
                setState(() {
                  editComponents.add(
                    EditAchievement(
                      removeComponent, 
                      titleControllers.last, 
                      descriptionControllers.last
                    )
                  );
                });
              },
            ),
            OutlinedButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  List<Achievement> updatedAchievements = [];
                  for(int i = 0; i < editComponents.length; i++){
                    updatedAchievements.add(
                      Achievement(
                        title: titleControllers[i].text, 
                        description: descriptionControllers[i].text
                      )
                    );
                  }
                  updateAchievements(updatedAchievements);
                });
                Navigator.of(context).pop();
              },
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
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
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
                controller: descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Description",
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
