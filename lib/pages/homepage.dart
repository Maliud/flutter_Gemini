import 'package:flutter/material.dart';
import 'package:flutter_gemini_main/controllers/gemini_controller.dart';
import 'package:flutter_gemini_main/pages/chat_page.dart';
import 'package:flutter_gemini_main/pages/vision_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

int item=1;
GeminiChatController geminiChatController=Get.find();
void handleClick(int newItem){
    
    setState(() {
      item=newItem;
      geminiChatController.streamAnswer.value="";
    }
    );
      
}

PageController controller=PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(children: [Image(image: AssetImage('assets/leaf.png'),width: 40.w,),SizedBox(width: 10.w,), Text('Flutter Gemini',style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),)],),
          actions:<Widget>[
            PopupMenuButton<int>(
              onSelected: (item)=>handleClick(item),
              itemBuilder:(BuildContext context)=>[
                PopupMenuItem<int>(value: 1, child: Text('Metin')),
                PopupMenuItem(child: Text('Resim'),value: 2,)
              ]
             )
          ],
        ),
      
        body:
            
            _page(item)
        
      
      ),
    );
  }

  Widget _page(index){
    switch(index){
      case 1:
        return ChatPage();
      case 2:
        return VisionPage();
      default:
      return ChatPage();
          
    }
    
  }

}