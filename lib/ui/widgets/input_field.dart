import 'package:flutter/material.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import '../theme.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.title, required this.hint,this.controller,this.widget}) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;



  @override
  Widget build(BuildContext context) {
    return Container(
                 margin: const EdgeInsets.only(top: 16),      
                 child:Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                    Text(title,style:titleStyle),
                     Container(
                        width: SizeConfig.screenWidth,
                        height: 52,
                        padding: const EdgeInsets.only(left: 14),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey)
                  ),
                        child:
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                autofocus: false,
                                style: subtitleStyle,
                                cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                                readOnly: widget !=null?true:false,
                                decoration:InputDecoration(
                                  hintText: hint,
                                  hintStyle: subtitleStyle,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:context.theme.backgroundColor),   
                                    ),
                                  focusedBorder:  UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:context.theme.backgroundColor,
                                      width: 0,
                                      ),
                                    ),
                                )
                              ),
                              ),
                              widget ?? Container(),

                           ],
                         ),
                     ),
                   ],
                 )
                    
                  




    );
  }
}
