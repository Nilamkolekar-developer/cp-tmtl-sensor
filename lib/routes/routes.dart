import 'package:autopeepal/dev/dev_screen.dart';
import 'package:autopeepal/logic/bindings/login_bindings.dart';
import 'package:autopeepal/views/screens/auth/login.dart';
import 'package:autopeepal/views/screens/dashboard/dashboard.dart';
import 'package:autopeepal/views/screens/dashboard/recipeAdditionScreen.dart';
import 'package:autopeepal/views/screens/dashboard/recipeAdditionScreenReadOnly.dart';
import 'package:autopeepal/views/screens/dashboard/testRecipeScreen.dart';
import 'package:autopeepal/views/screens/dashboard/testingScreen.dart';
import 'package:get/get.dart';
import 'package:autopeepal/routes/routes_string.dart';
import 'package:autopeepal/views/screens/splash_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.splashScreen, page: () => SplashScreen()),
    GetPage(name: Routes.devScreen, page: () => DevScreen()),
    GetPage(
      name: Routes.loginScreen,
      binding: LoginBindings(),
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.testingScreen,
      page: () => TestingScreen(),
    ),
    GetPage(
      name: Routes.testRecipeScreen,
      //binding: LoginBindings(),
      page: () => TestRecipeScreen(),
    ),
    GetPage(
      name: Routes.recipeAdditionScreen,
      //binding: LoginBindings(),
      page: () => RecipeAdditionScreen(),
    ),
    GetPage(
      name: Routes.dashboardScreen,
      //binding: DashboardBinding(),
      page: () => DashboardScreen(),
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
    ),
     GetPage(
      name: Routes.recipeAdditionReadOnlyScreen,
      page: () => RecipeAdditionReadOnlyScreen(),
    ),
    // GetPage(
    //   name: Routes.registerScreen,
    //   binding: RegisterBindings(),
    //   page: () => RegisterScreen(),
    // ),
  ];
}
