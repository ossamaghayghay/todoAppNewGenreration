import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/widgets/task_tile.dart';
// import '/ui/pages/notification_screen.dart';
import 'package:todo/ui/size_config.dart';
// import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
// import '/ui/widgets/input_field.dart';

import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifierhelper;

  @override
  void initState() {
    notifierhelper = NotifyHelper();
    notifierhelper.requestIOSPermissions();
    taskController.getTasks();
    super.initState();
    tz.initializeTimeZones();
  }

  DateTime selecteddate = DateTime.now();
  TaskController taskController = Get.put(TaskController());
  AppBar appbar() => AppBar(
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchThme();
            // :::::::::::::::::For Android:::::::::::::::::

            // ::::::::::For Ios::::::::::::::
            // notifierhelper.scheduledNotification();
          },
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        actions:  [
          // :::::::::::::::::::Deelete Button Icon:::::::::::::::::::::::::::::
          IconButton(
           icon: const Icon(Icons.cleaning_services_rounded,color: primaryClr,size: 24,),
           onPressed: (){
             notifierhelper.cancelAllNotifaction();
             taskController.deleteAllTasks();
             }
           ),
          //  ::::::::::::::::::::::::::Picture On App Bar On top::::::::::::::::::::
          const CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
        ],
      );

  // bool _isSwitched=false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: appbar(),
      body: Column(
        children: [
          addtaskbar(),
          adddateBar(),
          showTasks(),
        ],
      ),
    );
  }

// ::::::::::::::::::::::::::::::::::::::::::Add Task Bar:::::::::::::::::::::::::::::::::::::::::::::
  addtaskbar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: subheadingStyle,
                  ),
                  Text('Today', style: headingStyle),
                ],
              ),
              MyButton(
                label: const Text(
                  '+Add Task',
                ),
                onTap: () async {
                  await Get.to(() => const AddTaskPage());
                },
              ),

              // Container(
              //   margin: const EdgeInsets.only(top:10),
              //   child: MyButton(
              //     label:const Text(
              //       'Add Task',
              //       style: TextStyle(color: Colors.white,),
              //       textAlign: TextAlign.center,
              //       ),
              //     onTap: ()=>Get.to(()=>const AddTaskPage()),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::Add Date Bar ::::::::::::::::::::::::::::::::::::::::::::
  adddateBar() {
    return SizedBox(
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: selecteddate,
        width: 80,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newData) {
          setState(() {
            selecteddate = newData;
          });
        },
      ),
    );
  }

  // :::::::::::::::::::::::::::::::::::::::::::::::::::::::::Show Tasks::::::::::::::::::::::::::::::::::::::::::::
  showTasks() {
    return Expanded(
      child: Obx(() {
        if (taskController.taskList.isEmpty) {
          return noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = taskController.taskList[index];

// :::::::::::::::we check if they TodoList Diallt Or Not::::::::::::::::::::::::::::::
                // final timeformated=DateFormat.yMd().parse(task.date!);

                if ((task.repeat == 'Daily' 
                        ||
                        task.date ==  DateFormat.yMd().format(selecteddate))
                        || 
                        (task.repeat=='Weeklly' && selecteddate.difference(DateFormat.yMd().parse(task.date!)).inDays %7==0) 
                        ||
                        (task.repeat=='Monthly' && DateFormat.yMd().parse(task.date!).day == selecteddate.day  ))
                {
                  try{
                  var hours = task.startTime.toString().split(':')[0];
                  var minutes = task.startTime.toString().split(':')[1];

                  debugPrint('My time is ' + hours);
                  debugPrint('My Minutes is ' + minutes);

                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('hh:mm a').format(date);

                  notifierhelper.scheduledNotification(
                    int.parse(myTime.toString().split(':')[0]),
                    int.parse(myTime.toString().split(':')[0]),
                    taskController.taskList[index],
                  );
                  }catch(e){
                    print(e);
                  }
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1373),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            showBottomSheet(
                              context,
                              task,
                            );
                          },
                          child: TaskTile(
                            task: task,
                          ),
                        ),
                      ),
                    ),
                  );
                }  else {
                  return Container();
                }
              },
              itemCount: taskController.taskList.length,
            ),
          );
        }
      }),
    );
  }

  noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    'images/task.svg',
                    color: primaryClr.withOpacity(0.5),
                    height: 80,
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      'You Dont Have any ask Yet ?\nTry to have New task\nTo be More Productive',
                      style: subheadingStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 180)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showBottomSheet(BuildContext ctx, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : buildBotomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        notifierhelper.cancelNotifaction(task);
                        taskController.changeStateCompleted(task.id!);
                        Get.back();
                      },
                      clr: Colors.green,
                    ),
              buildBotomSheet(
                label: 'Delete Task',
                onTap: () {
                  taskController.deleteTasks(task);
                  Get.back();
                },
                clr: Colors.red,
              ),
              Divider(
                color: (Get.isDarkMode ? Colors.grey : darkGreyClr),
              ),
              buildBotomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  buildBotomSheet({required String label,required Function() onTap,required Color clr,bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: isClose ? Colors.transparent : clr,
          border: Border.all(
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    await taskController.getTasks();
  }
}
