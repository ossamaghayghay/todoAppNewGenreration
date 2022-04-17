import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key,required this.payload}) : super(key: key);
  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

 String _payload='';


  @override
  void initState() {
    _payload=widget.payload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: ()=>Get.back(),
    
           icon:const Icon(Icons.arrow_back)
           ),
         
          backgroundColor:context.theme.backgroundColor,
          title:Text(
            _payload.toString().split('|')[0],
            style: TextStyle(color: Get.isDarkMode?Colors.white:Colors.black),
          ),
          ),
        body: 
          SafeArea(
            child: Column(
              
              
                  children: [
               Text(
                 'Hello,Oussama',
                 style: TextStyle(fontSize: 27,fontWeight: FontWeight.w800,color: Get.isDarkMode?Colors.white:darkGreyClr),
               ),
              const SizedBox(height: 14),
               Text(
                 'You Have New Reminder',
                 style: TextStyle(fontSize: 17,fontWeight: FontWeight.w800,color: Get.isDarkMode?Colors.grey[100]:darkGreyClr),
               ),
               Expanded(
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                   margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryClr
                  ),
                 child: SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      //  :::::::::::::::We show Title::::::::::::::::::::::::::::::::::::::::
                      Row(
                         children:const [
                          Icon(Icons.text_format),
                           SizedBox(width: 10,),
                        Text('Title',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.white),),
                           SizedBox(width: 8,),
                         ]),
                      const SizedBox(height: 20,),
                      Text(
                        _payload.toString().split('|')[0],
                        style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                         ),
                      //  ::::::::::::::::::::::::::::::::::::::::::::::::::::::
                      const SizedBox(height: 24,),
                      //  :::::::::::::::We show Description::::::::::::::::::::::::::::::::::::::::
                      Row(
                  children: const [
                        Icon(Icons.description),
                        SizedBox(width: 10,),
                        Text('Description',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.white),),
                        
                  ],
                ),
                      const SizedBox(height: 20,),
                      Text(
                  _payload.toString().split('|')[1],
                  style: const TextStyle(color:Colors.white,fontSize: 14,fontWeight: FontWeight.bold)
                 ),
                      //  :::::::::::::::::::::::::::::::::::::::::::::::::
                      const SizedBox(height: 24,),
                      //  :::::::::::::::We show Date::::::::::::::::::::::::::::::::::::::::
                      Row(
                    children: const [
                        Icon(Icons.date_range),
                        SizedBox(width: 10,),
                        Text('Date',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.white),),    
                  ],
                ),
                      const SizedBox(height: 20),
                      Text(
                  _payload.toString().split('|')[2],
                  style: const TextStyle(color:Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                 ),
            
                     ],
                   ),
                 ),
                 ),
                 ),
              
                  ]
            ),
          ),
        ),
    
    );
  }
}
