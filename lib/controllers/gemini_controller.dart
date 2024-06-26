
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GeminiChatController extends GetxController{
  final gemini=Gemini.instance;
  RxString streamAnswer=''.obs;
  RxList<String> outputs=<String>[].obs;
  RxBool isLoading=false.obs;
  RxBool isGenerating=false.obs;


    void geminiVisionResponse(String text,XFile file,String? model)async{
      try{
        isLoading.value=true;
        streamAnswer.value='';
        String quary;

        if (model=='Kendiniz Seçiniz'){
          quary=text;
        }else{
          quary='Bu görüntüdeki $model nedir';
        }
        //final ByteData data = await rootBundle.load('assets/leaf.png');
        final File data = File(file.path);
        final Uint8List bytes=data.readAsBytesSync();
          print(bytes);
        await gemini.textAndImage(text: quary, images: [bytes]).then((value){
          streamAnswer.value=value!.content!.parts!.last.text.toString();
        });
        isLoading.value=false;
        print(streamAnswer);
      }catch(error){
        streamAnswer.value='BIR ŞEYLER YANLIŞ GITTI FARKLI BIR RESIMLE TEKRAR DENEYIN';
        print(error);
                isLoading.value=false;

      }
    }




  void geminiStream(String text,VoidCallback scrollToBottom)async{
    try{
      isLoading.value=true;
      isGenerating.value=true;
      outputs.clear();

      await gemini.streamGenerateContent(text).forEach((event) {
        streamAnswer.value=event.output.toString();
        outputs.add(streamAnswer.value);
        isLoading.value=false;
        
      });
      scrollToBottom();
      isGenerating.value=false;
      isLoading.value=false;
    }catch(error){
      streamAnswer.value=error.toString();
      isLoading.value=false;
    }
  }

  
}