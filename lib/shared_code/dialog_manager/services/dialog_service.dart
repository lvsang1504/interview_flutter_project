import 'dart:async';

import 'package:interview_project/shared_code/dialog_manager/data_models/dialog_request.dart';
import 'package:interview_project/shared_code/dialog_manager/data_models/dialog_response.dart';

//link intruction how to implement
//https://medium.com/flutter-community/manager-your-flutter-dialogs-with-a-dialog-manager-1e862529523a
class DialogService {
  late Function(DialogRequest) showDialogListener;
  late Completer<DialogResponse> _dialogCompleter;

  Future<DialogResponse> showDialog({
    required String title,
    required String description,
    required String typeDialog,
    String titleButton = 'OK',
    bool isMustTapButton = false,
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    showDialogListener(DialogRequest(
      title: title,
      description: description,
      typeDialog: typeDialog,
      titleButton: titleButton,
      isMustTapButton: isMustTapButton,
    ));
    return _dialogCompleter.future;
  }

  void dialogComplete(DialogResponse response) {
     if (!_dialogCompleter.isCompleted) {
      _dialogCompleter.complete(response);
    }
  }
}
