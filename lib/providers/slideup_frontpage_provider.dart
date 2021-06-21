import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//form state of the slide up panel when user is reg or log in
class FrontPageFormState {
  bool userReg;
  bool hpReg;
  bool login;

  FrontPageFormState(this.userReg, this.hpReg, this.login);
}

class SlideUpState with ChangeNotifier {
  FrontPageFormState _formState = FrontPageFormState(false, false, false);
  bool _isSlideUpPanelActive = false;

  void mapButtonEventToState(FrontPageFormState event) {
    _formState = event;
    notifyListeners();
  }

  void setSlideUpPanelActive(bool event) {
    _isSlideUpPanelActive = event;
    notifyListeners();
  }

  FrontPageFormState get formState {
    return _formState;
  }

  bool get isSlideUpPanelActive {
    return _isSlideUpPanelActive;
    ;
  }
}
