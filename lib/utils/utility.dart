import 'dart:async';
import 'dart:io' as IO;
import 'package:another_flushbar/flushbar.dart';
import 'package:coachmax_coach/utils/text/small_text_poppin.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'component/outline.dart';
import 'component/primary_button.dart';
import 'constants.dart';
import 'dimensions.dart';

class Utility {
  static String getDurationStr(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = duration.inHours != 0
        ? "${twoDigits(duration.inHours)} HR "
        : "";
    String twoDigitMinutes = duration.inMinutes.remainder(60) != 0
        ? "${twoDigits(duration.inMinutes.remainder(60))} MINS "
        : "";
    String twoDigitSeconds = duration.inSeconds.remainder(60) != 0
        ? "${twoDigits(duration.inSeconds.remainder(60))} SEC "
        : "";

    return "$twoDigitHours$twoDigitMinutes$twoDigitSeconds";
  }

  static showAlertDialogUploading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: const Text("Uploading"),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<String> deviceType() async {
    var platformName = "web";
    if (IO.Platform.isAndroid) {
      platformName = "Android";
    } else if (IO.Platform.isIOS) {
      platformName = "IOS";
    }
    return platformName;
  }

  // static void hideLoader(BuildContext context) {
  //   if (context.loaderOverlay
  //       .visible /* && context.loaderOverlay.overlayWidgetType == ReconnectingOverlay*/) {
  //     context.loaderOverlay.hide();
  //   }
  // }

  // static void showLoader(BuildContext context) {
  //   context.loaderOverlay.show();
  // }

  static showConfirmAlertDialog({
    required BuildContext context,
    required String title,
    required String msg,
    String positiveText = "Yes",
    String negativeText = "No",
    Function? onPositiveClick,
    Function? onNegativeClick,
  }) {
    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.whiteColor,
      content: Container(
        padding: const EdgeInsets.all(20),
        // decoration: BoxDecoration(
        //   borderRadius: const BorderRadius.all(Radius.circular(10)),
        //   border: Border.all(color: AppColors.whiteColor, width: 1),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: Dimensions.textLargeSize,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Text(
                  msg,
                  style: const TextStyle(
                    fontSize: Dimensions.textMediumSize,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPositiveClick?.call();
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: Text(
                  positiveText,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: Dimensions.textMediumSize,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                onNegativeClick?.call();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
              child: Text(
                negativeText,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: Dimensions.textMediumSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showAlertDialog({
    required BuildContext? context,
    required String msg,
    String btnText = "Ok",
    Function? onPositiveClick,
  }) {
    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.whiteColor,
      content: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Text(
                    msg,
                    style: const TextStyle(
                      fontSize: Dimensions.textMediumSize,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context!);
                    onPositiveClick?.call();
                  },
                  child: Text(
                    btnText,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: Dimensions.textMediumSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // static Future<String> getFcmToken() async {
  //   String token = "";
  //   token = await FirebaseMessaging.instance.getToken() ?? "";
  //   debugPrint("FCM Token : $token");
  //   return token;
  // }
  //
  // static Future<bool> isAnonymousUser() async {
  //   // Assuming `getUserid` returns a Future<String>
  //   String user = await AppSession().getUserid();
  //   return user.isEmpty; // Check if the user ID is an empty string
  // }

  Flushbar? flushBar;

  void showFlushBar({
    required BuildContext context,
    required String message,
    bool isError = false,
    bool isNotification = false,
    bool isChange = false,
    String otherMessage = "",
  }) {
    if (flushBar?.isShowing() == true ||
        flushBar?.isAppearing() == true ||
        flushBar?.isHiding() == true) {
      flushBar!.dismiss();
      flushBar = null;
      // return;
    }
    var color = isChange == true
        ? AppColors.primaryColor.withOpacity(0.8)
        : isError == true
        ? AppColors.lightRedColor
        : AppColors.flushDoneColor;
    // var icon = isNotification == true
    //     ? Image.asset(
    //         notificationEnable,
    //         height: 26,
    //         width: 26,
    //       )
    //     : isError == true
    //         ? Image.asset(
    //             dangerIcon,
    //             height: 26,
    //             width: 26,
    //           )
    //:
    Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isError == true
                ? AppColors.lightRedColor
                : AppColors.whiteColor,
            blurRadius: 15.0, // soften the shadow
          ),
        ],
      ),
      // child: Image.asset(
      //   flushTick,
      //   height: 40,
      //   width: 40,
      // )
    );
    flushBar = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: color,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.only(left: 15, right: 15),
      isDismissible: true,
      duration: const Duration(seconds: 3),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          otherMessage.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: isError == true
                            ? AppColors.whiteColor
                            : AppColors.whiteColor,
                        fontSize: Dimensions.textSize,
                        fontFamily: Constants.fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: SmallTextPoppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isError == true
                            ? AppColors.whiteColor
                            : AppColors.whiteColor,
                        text: otherMessage,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Text(
                    message,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: isError == true
                          ? AppColors.whiteColor
                          : AppColors.whiteColor,
                      fontSize: Dimensions.textSize,
                      fontFamily: Constants.fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: const Icon(
                  Icons.clear,
                  color: AppColors.whiteColor,
                  size: 20.0,
                ),
                onTap: () {
                  flushBar?.dismiss();
                },
              ),
              SizedBox(height: otherMessage.isNotEmpty ? 30 : 0),
            ],
          ),
        ],
      ),
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) flushBar = null;
      },
    );
    flushBar?.show(context);
  }

  static showConfirmAlertDialogForAnonymousUser({
    required BuildContext context,
    String positiveText = "Yes",
    String negativeText = "No",
    Function? onPositiveClick,
    Function? onNegativeClick,
  }) {
    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.whiteColor,
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Text(
                  "Please SignIn first to access any this content.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.textMediumSize,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dividerColor, width: 1),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.add_rounded),
            ),
            const SizedBox(height: 30),
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      height: 40,
                      borderRadius: 8,
                      backgroundColor: AppColors.primary,
                      text: "signIn",
                      onClicked: () {
                        Navigator.pop(context);
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(
                        //         builder: (_) => const SignInPage()),
                        //     (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutLineButton(
                      textColor: AppColors.black,
                      height: 40,
                      text: "cancel",
                      onPress: () {
                        onNegativeClick?.call();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
