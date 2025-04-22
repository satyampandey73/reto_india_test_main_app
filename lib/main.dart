import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reto_app/controllers/category_controller.dart';
import 'package:reto_app/views/splash_screen.dart';
import 'package:reto_app/provider/shared_preference_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //This line ensures that all our Widgets in Flutter has been initialised successfully and after this only we will initialise our Firebase.

  //Initialising Firebase
  try {
    Platform.isAndroid
        ? await Firebase.initializeApp(
          //'isAndroid' means to check whether we are on Android device or not. 'await' is used to wait till our Firebase has been initialised.
          options: const FirebaseOptions(
            //We are adding 'const' to make these Options constant. FirebaseOptions gives us some Options or Parameters which will link our App with our Firebase. To get all these FirebaseOptions go to our 'google-services.json' file inside 'android/app' and you will get everything there.
            apiKey:
                'AIzaSyDylM9k8M-srASv8J4STYFvKSsNIPto4do', // This is our 'current_key' in our 'google-services.json' file
            appId:
                '1:104171970853:android:6b6d52cc63918a9e27facc', // This is our 'mobilesdk_app_id' in our 'google-services.json' file
            messagingSenderId:
                '104171970853', // This is our 'project_number' in our 'google-services.json' file
            projectId:
                'retoindia-test', // This is our 'project_id' in our 'google-services.json' file
            storageBucket:
                'retoindia-test.firebasestorage.app', // This is the another additional important property we need to pass. 'storageBucket' will enable us to upload images and files to our Firebase Storage. Got this from Firebase site in Storage and copied folder path.
          ),
        )
        : await Firebase.initializeApp(); //This is the else part and it means that if we are not on Android Device then simply initialise Firebase just like that.
  } catch (e) {
    print(e);
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(),
    ),
  ); //This is the main method. It runs our App.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Giving the color of top main status bar of our phone which shows notifications, our phone battery health, etc.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    ); //Making the color as Transparent so that it can have the background color of the Scaffold of the respective pages.

    return GetMaterialApp(
      debugShowCheckedModeBanner:
          false, //This will remove the debug tag from top right corner
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home:
          SplashScreen(), //Will Direct to that particular Screen when we open our App
      //What the below code will do is it will register our 'CategoryController' class in our 'category_controller' page and will make it GENERALLY ACCESSIBLE (we can use it anywhere) throughout our entire app.
      initialBinding: BindingsBuilder(() {
        Get.put<CategoryController>(CategoryController());
      }),
    );
  }
}
