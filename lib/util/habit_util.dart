import 'package:habit_tracker/models/habit.dart';

bool isHabitComepletedToday(List<DateTime> completedDays){
  final today  = DateTime.now();
  return  completedDays.any(
    (date) =>
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day,
  );
}

// prepare heatmap dataset
Map<DateTime,int> prepareHeatMapDataSet(List<Habit> habits){
          
          Map<DateTime,int> dataset= {};

          for(var habit in habits){
            for(var date in habit.completedDays){
               // normalize date to avoid time mismatch
               final normalizedDate = DateTime(date.year, date.month, date.day);

               // if date is already exists in the dataset , increament it's count

               if(dataset.containsKey(normalizedDate)){
                dataset[normalizedDate] = dataset[normalizedDate]! + 1;
               }
               else{
                // initialize it with a count 1
                dataset[normalizedDate] = 1;
               }
            }
          }
          return dataset;

}