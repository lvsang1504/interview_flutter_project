import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:interview_project/shared_code/dialog_manager/data_models/type_dialog.dart';
import 'package:interview_project/shared_code/dialog_manager/locator.dart';
import 'package:interview_project/shared_code/dialog_manager/services/dialog_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({
    required this.bloc,
    required this.di,
    required this.child,
  });

  final Widget child;

  final List<SingleChildWidget> bloc;
  final List<SingleChildWidget> di;

  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  bool _isDialogNetWorkShowing = false;

  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _checkNetWork();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkNetWork() async {
    final hasConnection = await _checkConnectionAddress();
    if (hasConnection) {
      // Hide popup
      if (_isDialogNetWorkShowing) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _isDialogNetWorkShowing = false;
      }
    } else {
      // Has shown popup???
      // if (_isDialogNetWorkShowing) {
      //   return;
      // }

      const snackBar =  SnackBar(
        content:  Text('No Internet!'),
        // action: SnackBarAction(
        //   label: 'try',
        //   onPressed: () {
        //     // Some code to undo the change.
        //   },
        // ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Show popup
      // await _showAlertConnectionDialog(tr('errorNetWork'));
    }
  }

  Future<bool> _checkConnectionAddress() async {
    try {
      // final result = await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //   return true;
      // }
      // return false;
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        return true;
      }
      return false;
    } on SocketException catch (_) {
      print('Connect network: Socket');
      return false;
    }
  }

  // Future<void> _showAlertConnectionDialog(String content) async {
  //   _isDialogNetWorkShowing = true;
  //   final dialogResult = await _dialogService.showDialog(
  //     title: tr('Alert'),
  //     description: content,
  //     typeDialog: DIALOG_ONE_BUTTON,
  //   );

  //   if (dialogResult.confirmed) {
  //     _isDialogNetWorkShowing = false;
  //     // Check Network
  //     await _checkNetWork();
  //   } else {
  //     _isDialogNetWorkShowing = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var widgets = <SingleChildWidget>[];

    widgets = [
      ...widgets,
      ...widget.di,
    ];

    widgets = [
      ...widgets,
      ...widget.bloc,
    ];

    return widgets.isNotEmpty
        ? MultiProvider(
            providers: widgets,
            child: WillPopScope(onWillPop: handleClose, child: widget.child),
          )
        : widget.child;
  }

  // Fix "Back" Physical on Android
  Future<bool> handleClose() {
    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(false);
  }
}

class NavigatorProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
