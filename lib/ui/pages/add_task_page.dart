import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController=Get.put(TaskController());

  final TextEditingController titleController=TextEditingController();
  final TextEditingController noteController=TextEditingController();


  DateTime dateTime=DateTime.now();

  String starttime=DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endtime=DateFormat('hh:mm a').format(DateTime.now().add(const Duration(minutes: 15))).toString();
  int selectedRemind=5;
  List<int> remindList=[5,10,15,20];
  String selectedRepeat='None';
  List<String> repeatDaily=['None','Daily','Weeklly','Monthly'];
  

  int selectedColor=0;
  late bool isStarttime;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: appbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child:Column(
            children:[
                Text('Add Task',style: headingStyle,),
                 InputField(
                  title: 'Title',
                  hint: 'Enter Title Here...',
                  controller: titleController,
                  // widget: Icon(Icons.title,color: Colors.grey[200],),
                ),
                 InputField(
                  title: 'Note',
                  hint: 'Enter Note Here...',
                  controller: noteController,
                  // widget: Icon(Icons.note,color: Colors.grey[200]),
                ),
                const SizedBox(width: 12),
                InputField(
                  title: 'Date',
                  hint:DateFormat.yMd().format(dateTime),
                  widget: IconButton(
                    onPressed: ()=>getDateFromUser(),
                    icon:const Icon(Icons.date_range,color:Colors.grey)
                    
                    ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: 
                          InputField(
                          title: 'Start Time',
                          hint:starttime,
                          widget: IconButton(
                          onPressed: ()=>getTimeFromUser(isStartTime: true),
                          icon:const Icon(Icons.access_time_filled,color:Colors.grey)
                    
                      ),
                   ), 
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: 
                          InputField(
                          title: 'End Time',
                          hint:endtime,
                          widget: IconButton(
                          onPressed: ()=>getTimeFromUser(isStartTime: false),
                          icon:const Icon(Icons.access_time_filled,color:Colors.grey)
                    
                      ),
                   ), 
                      ),
                  ],
                ),
                
                
                InputField(
                  title: 'Remind',
                  hint:'$selectedRemind Minutes Early',
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(13),
                        dropdownColor: Colors.blueGrey[400],
                        items:remindList.map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(
                              '$value',
                              style: const TextStyle(color: Colors.white),
                              
                              ),
                            
                            );
                        }).toList(), 
                        icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                        iconSize: 32,
                        elevation: 2,
                        underline: Container(height: 0),
                        style: subtitleStyle,
                        onChanged: (String? newValue){
                            setState(() {
                              selectedRemind=int.parse(newValue!);
                            });
                        },
                        
                        ),
                      const SizedBox(height: 8,)
                    ],
                  ),
                        
                    
                ),
                  InputField(
                  title: 'Repeat',
                  hint:'$selectedRepeat ',
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(13),
                        dropdownColor: Colors.blueGrey[400],
                        items:repeatDaily.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                              
                              ),
                            
                            );
                        }).toList(), 
                        icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                        iconSize: 32,
                        elevation: 2,
                        underline: Container(height: 0),
                        style: subtitleStyle,
                        onChanged: (String? newValue){
                            setState(() {
                              selectedRepeat=newValue!;
                            });
                        },
                        
                        ),
                      const SizedBox(height: 8,)
                      
                    ],
                  )
                ),




            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                colorPalet(),
                MyButton(
                  label: const Text('Create Task'),
                  onTap: (){
                    validateDate();
                  }
                  
                  ),
              ]
            )
            
            ]
            
            )
        ),
      ),
    );
  }

  AppBar appbar() => AppBar(

  
          leading: IconButton(
            onPressed: ()=>Get.back(),
    
           icon:const Icon(
             Icons.arrow_back,
             size: 24,
             color: primaryClr,
             ),
           ),
         
          backgroundColor:context.theme.backgroundColor,
          elevation: 0,
          actions: const [
          
            CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg') ,
              radius: 18,
              ),
              SizedBox(width: 20),
          ],

          
  );

  validateDate(){
    if(titleController.text.isNotEmpty && noteController.text.isNotEmpty){
      addTaskToDb();
      Get.back();
    }else if(titleController.text.isEmpty || noteController.text.isEmpty){
      Get.snackbar(
        'required',
        'it\'s required to Fill this Fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon:const Icon(Icons.warning_amber_rounded,color: Colors.red),

      );
    }
    else{
      print('###########Somthing Bad Happend###########');
    }
  }
  addTaskToDb()async{
    try{
    int value=await taskController.addTask(
      Task(
        title:titleController.text,
        note: noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(dateTime),
        startTime: starttime,
        endTime: endtime,
        color: selectedColor,
        remind: selectedRemind,
        repeat: selectedRepeat,
        ),
    );
    print(value);
    }catch(e){
      print('WE Should Unlock this Problem It\'s Big Poblem');
    }
  }

  Column colorPalet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text('Color',style: titleStyle,),
              Wrap(
                children: List<Widget>.generate(3, (index) => GestureDetector(
                  onTap: (){
                    setState(() {
                    selectedColor=index;
                    });
                  },
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      child:selectedColor==index?const Icon(Icons.done,size: 16,color: Colors.white,):null,
                      backgroundColor: index==0?primaryClr:index==1?pinkClr:orangeClr,
                    
                    ),
                    ),
                  ),
                ),
                ),
    
                
              
              ],
              
              );
  }
// """"""""""""""""""""""""""""""""""""""""""""""""Get Date From User Function"""""""""""""""""""""""""""""""""""""

getDateFromUser()async{
  DateTime? pickedDate=await showDatePicker(
    context: context,
    initialDate:dateTime ,
    firstDate:DateTime(2016) ,
    lastDate:DateTime(2030),
    );
    if(pickedDate!=null){
      setState(() {
        dateTime=pickedDate;
      });
    }else{
      print('it\'s null Or somthing Went Wrong??');
    }
}
// """"""""""""""""""""""""""""""""""""""""""""""""Get Time From User Function"""""""""""""""""""""""""""""""""""""
getTimeFromUser({required bool isStartTime}) async{
  TimeOfDay? pickedTime=await showTimePicker(
    context: context,
    initialEntryMode: TimePickerEntryMode.input,
    initialTime:
    isStartTime
    ?TimeOfDay.fromDateTime(DateTime.now())
    :TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15),
    ),
    ),
  );
  String formatedTime=pickedTime!.format(context);
    if(isStartTime){
      setState(() {
        starttime=formatedTime;
      });
    }
    else if(!isStartTime){
      setState(() {
        endtime=formatedTime;
      });
    }
    else{
      print('it\'s null Or somthing Went Wrong??');
    }
}

}

