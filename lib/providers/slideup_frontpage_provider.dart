import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//form state of the slide up panel when user is reg or log in
class FrontPageFormState {
  bool userRegistration;
  bool hairProfRegistration;
  bool login;

  FrontPageFormState(
      this.userRegistration, this.hairProfRegistration, this.login);
}

enum AuthenticationForm {
  userRegistration,
  hairProfRegistration,
  login,
}

enum Panel {
  closed,
  open,
}

class SlideUpState with ChangeNotifier {
  FrontPageFormState _formState = FrontPageFormState(false, false, false);
  bool _isSlideUpPanelOpen = false;
  PanelController _panelController;

  SlideUpState(this._panelController);

  void setFormOnPanel(AuthenticationForm event) {
    if (event == AuthenticationForm.userRegistration) {
      _formState = FrontPageFormState(true, false, false);
    } else if (event == AuthenticationForm.hairProfRegistration) {
      _formState = FrontPageFormState(false, true, false);
    } else if (event == AuthenticationForm.login) {
      _formState = FrontPageFormState(false, false, true);
    }
    notifyListeners();
  }

  void setPanelState(Panel event) {
    if (event == Panel.open) {
      _isSlideUpPanelOpen = true;
    } else if (event == Panel.closed) {
      _isSlideUpPanelOpen = false;
    }
    notifyListeners();
  }

  FrontPageFormState get formState {
    return _formState;
  }

  bool get isSlideUpPanelOpen {
    return _isSlideUpPanelOpen;
  }

  PanelController get panelController {
    return _panelController;
  }
}
