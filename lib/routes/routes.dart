import 'package:CP_TMTL_Sensor_Zig/dev/dev_screen.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/bindings/login_bindings.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/bindings/testing_bindings.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/auth/login.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/dashboard.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/recipeAdditionScreen.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/recipeAdditionScreenReadOnly.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/sensorAnalysis.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/settings.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/testRecipeScreen.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/testingScreen.dart';
import 'package:get/get.dart';
import 'package:CP_TMTL_Sensor_Zig/routes/routes_string.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/splash_screen.dart';

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
      binding: TestingBinding(),
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
      name: Routes.settingsScreen,
      page: () => SettingsScreen(),
    ),
     GetPage(
      name: Routes.recipeAdditionReadOnlyScreen,
      page: () => RecipeAdditionReadOnly(),
    ),
     GetPage(
      name: Routes.sensorAnalysis,
      page: () => SensorAnalysisScreen(),
    ),
    // GetPage(
    //   name: Routes.registerScreen,
    //   binding: RegisterBindings(),
    //   page: () => RegisterScreen(),
    // ),
  ];
}
