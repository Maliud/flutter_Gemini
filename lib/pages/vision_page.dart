import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gemini_main/controllers/gemini_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
class VisionPage extends StatefulWidget {
  const VisionPage({super.key});

  @override
  State<VisionPage> createState() => _VisionPageState();
}


class _VisionPageState extends State<VisionPage> {
List<CoolDropdownItem<String>> dropdownItemList=[];

List<String> models=['Kendiniz Seçiniz','Çiçek','Bitkiler','Bitki Hastalıkları','Sebzeler','Hayvan'];

String? _selectedModel='Kendiniz Seçiniz';


XFile? image;
GeminiChatController controller=Get.find();
TextEditingController textController=TextEditingController();

  Future<void> pickImage()async{
   try{
    print('galeri seçildi!');
                  final ImagePicker picker=ImagePicker();
                  final img=await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    image=img;
                  });
      

   }catch(error){
    print(error);
   }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 375.w,
      height: 812.h,
      //color: Colors.amber,

      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            Container(
              width: 200.w,
              height: 200.w,
              
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                
                borderRadius: BorderRadius.circular(15.w)
              ),
              child:image!=null
              ?ClipRRect(child: Image(image: FileImage(File(image!.path),),fit: BoxFit.cover,),borderRadius: BorderRadius.circular(10.w),)
              :ClipRRect(child: Image(image: AssetImage('assets/imgsearch.jpeg')),borderRadius: BorderRadius.circular(50.w),),
            ),
      
             Container(
               margin: EdgeInsets.only(bottom: 20,top: 20),
               width: 300.w,
             height: 50.h,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(15.w),
               //gradient: LinearGradient(colors: [Colors.blueAccent,Colors.orangeAccent])
             ),
             child: Center(
               child: Row(
                 children: [

                  Text('Model: ',style: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold),),
                   DropdownButton(
                    dropdownColor: Colors.purpleAccent.withOpacity(0.3),
                    items: models.map((model){
                    return DropdownMenuItem(child: Text(model,style: TextStyle(color: const Color.fromARGB(255, 250, 250, 250),fontWeight: FontWeight.bold),),value: model,);
                   }).toList(),
                    onChanged: (value){
                      setState(() {
                        _selectedModel=value;
                      });
                    },
                    value: _selectedModel,
                    icon: Icon(Icons.arrow_drop_down_circle_outlined),
                    ),
                 ],
               ),
             ),
              
             
             
             ),
            SizedBox(height: 50.h,),
            Obx((){
              if(controller.isLoading.value){
                return LoadingAnimationWidget.staggeredDotsWave(color: Colors.blueAccent, size: 50);
              }else{
                return Container(
              width: 300.w,
              height: 70.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                color: const Color.fromARGB(255, 34, 34, 34),
                boxShadow: [BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset:Offset(1, 2)
                )]
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    child:_selectedModel=="Kendiniz Seçiniz"? TextField(
                      style: TextStyle(color: Colors.white),
                      controller: textController,
                                  decoration: InputDecoration(
                                    hintText: 'Resim hakkında soru sorun.',
                                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                                  ),
                                ):Container(),
                  ),
                IconButton(onPressed: ()async{
                  pickImage();
                }, icon: Icon(Icons.image,color: Colors.blueAccent,)),
                IconButton(onPressed: (){
                  if(_selectedModel=='Kendiniz Seçiniz'){
                    if(image!=null && textController.text!=''){
                        controller.geminiVisionResponse(textController.text, image!,_selectedModel);
                    }else{
                      Get.snackbar('Error', 'Resim ve Soru Boş Olamaz!',
                      backgroundColor: Colors.amberAccent,
                      titleText: Text('Invalid Input',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                      
                      );
                    }
                    
                  }else{
                      if(image!=null){
                        controller.geminiVisionResponse(textController.text, image!,_selectedModel);
                    }else{
                      Get.snackbar('Error', 'Resim Boş Olamaz!',backgroundColor: Colors.amberAccent,
                      titleText: Text('Invalid Input',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),));
                    }
                  }
                }, icon: Icon(Icons.send),color: Colors.greenAccent,)
                ],
              )
            );
              }
            }),
            Obx((){
              if(controller.isLoading.value){
                return Container();
              }else{
                return Container(
              //color: Colors.green,
              padding: EdgeInsets.all(8.w),
              width: 300.w,
              
              child: Text(controller.streamAnswer.toString(),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
            );
              }
            })
          ],
        ),
      ),
    );

  }
}