import 'package:flutter/material.dart';

//this class gives scales depending on the dimenions of the device
//we can create a safe soze for the dimensions
class SizeConfig {
  BuildContext context;

  SizeConfig(this.context);

  MediaQueryData get _mediaQueryData {
    return MediaQuery.of(context);
  }

  double get screenWidth {
    return this._mediaQueryData.size.width;
  }

  double get screenHeight {
    return this._mediaQueryData.size.height;
  }

  double get blockSizeHorizontal {
    return this._mediaQueryData.size.width / 100;
  }

  double get blockSizeVertical {
    return this._mediaQueryData.size.height / 100;
  }

  double get _safeAreaHorizontal {
    return this._mediaQueryData.padding.left +
        this._mediaQueryData.padding.right;
  }

  double get _safeAreaVertical {
    return this._mediaQueryData.padding.top +
        this._mediaQueryData.padding.bottom;
  }

  double get safeBlockHorizontal {
    return (this.screenWidth - this._safeAreaHorizontal) / 100;
  }

  double get safeBlockVertical {
    return (this.screenHeight - this._safeAreaVertical) / 100;
  }
}
