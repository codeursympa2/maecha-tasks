import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/global/services/bottom_sheet_service.dart';
import 'package:maecha_tasks/global/services/easy_loading/easy_loading_service.dart';
import 'package:maecha_tasks/global/services/firebase_service.dart';
import 'package:maecha_tasks/global/injectable/injectable.config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';


final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async => await getIt.init();

@module
abstract class AppModule {

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<FirebaseService> get fireService => FirebaseService.init();

  @preResolve
  Future<EasyLoadingService> get eazyLoadingService => EasyLoadingService.init();

  @preResolve
  Future<BottomSheetService> get bottomSheetServ => BottomSheetService.init();
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

}