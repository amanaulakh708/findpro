import 'dart:io';

import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/screens/login.dart';
import 'package:findpro/screens/registration.dart';
import 'package:findpro/screens/signInUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyRegistration extends StatefulWidget {
  const MyRegistration({super.key, required this.title});

  final String title;

  @override
  State<MyRegistration> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyRegistration> {
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey webViewKey = GlobalKey();

  WebViewController controller = WebViewController();
  var loadingPercentage = 0;


  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  bool _showHeader = false;
  bool _showErrorMsg = false;

  @override
  void initState() {

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    super.initState();
  }

  goBack(){
    // print('dfjgbf ${webViewController}');
    // if(webViewController!.getUrl().toString() == 'https://www.findpro.net/registration'){
      Navigator.of(context).pop();
    // }
    // webViewController!.goBack();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => goBack(),
        child: Scaffold(
          body:
          // OverflowBox(
          //   maxHeight: 850.h,
          //   alignment: Alignment.topCenter,
          //   child:
            Stack(
                  children: [
                    // WebViewWidget(controller: controller),
                    InAppWebView(

                      key: webViewKey,
                      initialUrlRequest:
                      URLRequest(url: Uri.parse("https://www.findpro.net/registration")),
                      initialOptions: options,
                      onWebViewCreated: (controller) {
                        webViewController = controller;

                      },

                      onLoadStart: (controller, url) {
                        setState(() {
                          loadingPercentage = 0;
                        });
                      },

                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![ "http", "https", "file", "chrome",
                          "data", "javascript", "about"].contains(uri.scheme)) {
                          if (await canLaunch(url)) {
                            // Launch the App
                            await launch(
                              url,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },

                      onLoadStop: (controller, url) async {
                        // pullToRefreshController.endRefreshing();
                        setState(() {
                          // _showHeader = true;
                          loadingPercentage = 100;
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        setState(() {
                          _showErrorMsg = true;
                        });
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {

                        if(progress >= 70){
                        setState(() {
                        _showHeader = true;
                          });}
                        setState(() {
                          loadingPercentage = progress;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),


                    Visibility(
                      visible: _showHeader,
                      child: Container(
                        // alignment: Alignment.topCenter,
                        height: 150.h,
                        // color: Color(0xFFF5F5F5),

                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFF5F5F5),
                                Color(0xFFF5F5F5),
                                Color(0xFFF5F5F5),
                                Color(0xFFF5F5F5),
                                Color(0xFFF5F5F5),
                                Color(0xFFF5F5F5),
                                Color(0xFFF5F5F5),
                                Color(0xFFF5F5F5),
                                Color(0xfff1f8ff).withOpacity(0.3),
                                Color(0xfff1f8ff).withOpacity(0),

                              ],
                            ),
                            // gradient: LinearGradient(
                            //     begin: Alignment.topCenter, end: Alignment.bottomCenter,
                            //     colors: [ Color(0xFFF5F5F5),Colors.transparent,],
                            //     stops: [.4, 1]
                            // )
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 120.w),
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _showHeader,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: 90.h,
                          color: Color(0xFFF5F5F5),

                          // decoration: BoxDecoration(
                          //   gradient: LinearGradient(
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //     colors: [
                          //       Color(0xfff1f8ff).withOpacity(0),
                          //       Color(0xfff1f8ff).withOpacity(0.3),
                          //       Color(0xFFF5F5F5).withOpacity(0.5),
                          //       Color(0xFFF5F5F5),
                          //       Color(0xFFF5F5F5),
                          //       Color(0xFFF5F5F5),
                          //       Color(0xFFF5F5F5),
                          //       Color(0xFFF5F5F5),
                          //       Color(0xFFF5F5F5),
                          //       Color(0xFFF5F5F5),
                          //
                          //
                          //     ],
                          //   ),
                          //   // gradient: LinearGradient(
                          //   //     begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          //   //     colors: [ Color(0xFFF5F5F5),Colors.transparent,],
                          //   //     stops: [.4, 1]
                          //   // )
                          // ),
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 160.w),
                            child: Image.asset(
                              'assets/images/logo.png',
                            ),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: _showErrorMsg,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xFFF5F5F5),

                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 160.w),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                ),
                              ),
                              Text('Check internet connection')
                            ],
                          ),
                        ),
                    ),


                    (loadingPercentage < 80)?
                     Container(
                          margin: EdgeInsets.symmetric(horizontal: 100.w),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 10.h, left: 40.w, right: 40.w),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                ),
                              ),
                              LinearProgressIndicator(
                                  color: ColorConstants.themeBlue,
                                  value: loadingPercentage / 100.0,

                                ),

                            ],
                          ),
                        ):
                        Container()
                  ],
                ),
          // ),
        ),
      ),
    );
  }
}
