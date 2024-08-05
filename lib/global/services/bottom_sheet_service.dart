import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/login_page.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/register_page.dart';
import 'package:tn_bottom_sheet_navigator/core/entities/tn_bottom_sheet_route.dart';
import 'package:tn_bottom_sheet_navigator/core/tn_router.dart';

class BottomSheetService{

  static Future<BottomSheetService> init()async{
    final bottomSheetRoutes = [
      TnBottomSheetRoute(
        path: 'register',
        builder: (context, params) => const RegisterPage(),
      ),
      TnBottomSheetRoute(
        path: 'login',
        builder: (context, params) => LoginPage(getIt<SharedPreferencesService>()),
      ),
    ];
    // Bottom sheet nav
    TnRouter().setRoutes(bottomSheetRoutes);

    return BottomSheetService();
  }
}