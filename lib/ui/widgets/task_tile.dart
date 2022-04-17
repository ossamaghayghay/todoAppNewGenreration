import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/models/task.dart';
import '/ui/size_config.dart';
import '/ui/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile( {Key? key, required this.task}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 4 : 20),
      ),
      width: SizeConfig.orientation == Orientation.landscape
            ? SizeConfig.screenWidth / 2
            : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: getBGClr(task.color),
        ),
        child: Row(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time_rounded),
                      const SizedBox(width: 10),
                      Text(
                        '${task.startTime}-${task.endTime}',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 13,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Text(
                    task.note!,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 12,
                    )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task.isCompleted == 0 ? 'TODO' : 'Completed',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
