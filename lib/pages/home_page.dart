// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/databases/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/service/noti_service.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    // read the existing habits on app starup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

    // text controller
    final TextEditingController textController = TextEditingController();

    // check habit on or off
    void checkHabitOnOrOff(bool? value , Habit habit){
      // update habit completion status
      if(value !=  null){
        context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
      }
    }
    
     
  
  
  //  create new habit
  void createNewHabit(){
  
   showDialog(
    context: context,
     builder: (context) =>AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const  InputDecoration(
              hintText: "Create a new habit",
            ),
          ),
          actions: [
            // save button
            MaterialButton(onPressed: (){
              // get the new habit name
              String newHabitName= textController.text;
              // save to db
              context.read<HabitDatabase>().addHabit(newHabitName);
              // pop box
              Navigator.pop(context);
              // clean controller
              textController.clear();
            },
            child: const Text("save"),
            ),

            // cencel button

          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
              // clear controller

              textController.clear();
            },
            child: const Text("cancel"),
            ),

          ],
     )
     );
  }

   //edit habit box
   void editHabitBox(Habit habit){
    textController.text = habit.name;
    
    showDialog(context: context, builder: (context) => AlertDialog(
           content: TextField(controller: textController,),
           actions: [
              // save button
            MaterialButton(onPressed: (){
              // get the new habit name
              String newHabitName= textController.text;
              // save to db
              context.read<HabitDatabase>().updateHabitName(habit.id ,newHabitName);
              // pop box
              Navigator.pop(context);
              // clean controller
              textController.clear();
            },
            child: const Text("save"),
            ),

            // cencel button

          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
              // clear controller

              textController.clear();
            },
            child: const Text("cancel"),
            ),

           ],
    ));
   }

   // delete habit  box
     void deleteHabitBox(Habit habit){
          showDialog(
            context: context,
             builder: (context) => AlertDialog(
             title: const Text("Are you sure you want to delete?"),
           actions: [
              // delete button
            MaterialButton(onPressed: (){
             
              // save to db
              context.read<HabitDatabase>().deleteHabit(habit.id );
              // pop box
              Navigator.pop(context);
              
            },
            child: const Text("Delete"),
            ),

            // cencel button

          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
              
            },
            child: const Text("cancel"),
            ),

           ],
    ));

     }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
       // backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),),
        body: ListView(
          children: [
             _buildHeatMap(),
            _buildHabitList(),
        
            SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async{
                   await NotiService().showNotification(
                    title: "Habit Tracker",
                    body: "Your habit is done",
                  );
                }, 
              
                child: Icon(Icons.access_alarm,
                size: 30,),),
            )
          ],
          
        ),
      
    );
  }

  // build heatmap
  Widget _buildHeatMap(){

    // habit db
    final habitDatabase = context.watch<HabitDatabase>();
    // current db
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // reaturn heat map ui
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
       builder:(context ,snapshot) {

     // once the data is available  -> build heatmap
        if(snapshot.hasData){
          return MyHeatMap(
            startDate: snapshot.data!,
               datasets:prepareHeatMapDataSet(currentHabits));
        }
            else{
              return Container();
            }

     // handle the case where no data is returned
       });
  }

  // build habit list
  Widget  _buildHabitList(){
    // habit db
    final habitDatabase= context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
          // get each individual habit
          final habit = currentHabits[index];
          // check if the habit is completed today
          bool isCompletedToday = isHabitComepletedToday(habit.completedDays );

          // return the habit
          return MyHabitTile(
            text: habit.name,
            deleteHabit: (context) => deleteHabitBox(habit) ,
            editHabit: (context) => editHabitBox(habit),
            onChanged: (value) => checkHabitOnOrOff(value, habit),
           isCompleted: isCompletedToday,
           );
        
      },
      );
  }
}

