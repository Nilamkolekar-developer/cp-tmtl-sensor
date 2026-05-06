import 'package:cp_tmtl_sensor_zig/common_widgets/button.dart';
import 'package:cp_tmtl_sensor_zig/common_widgets/custom_app_bar.dart';
import 'package:cp_tmtl_sensor_zig/utils/assets.dart';
import 'package:cp_tmtl_sensor_zig/utils/sizes.dart';
import 'package:cp_tmtl_sensor_zig/utils/strings.dart';
import 'package:cp_tmtl_sensor_zig/utils/ui_helper_widgets.dart';
import 'package:flutter/material.dart';


class CustomPlaceholder extends StatelessWidget {
  final String? title;

  const CustomPlaceholder({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        CustomAppBar(
          title: title!,
          subTitle: title!,
          showBackButton: false,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsets.all(Sizes.s35),
                child: Image(
                  image: AssetImage(Assets.facebook),
                ),
              ),
              Center(child: Text("WIP")),
              C50(),
              Padding(
                padding: EdgeInsets.all(Sizes.s40),
                child: AppButton(
                  onTap: () async {
                    // await auth.clearUser();
                    // AppRoutes.makeFirst(context, SplashScreen());
                  },
                  title: Strings.restartApp,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
