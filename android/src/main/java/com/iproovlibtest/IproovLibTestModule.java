package com.iproovlibtest;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.*;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import android.content.Context;
import android.os.Bundle;

import com.caf.facelivenessiproov.input.CAFStage;
import com.caf.facelivenessiproov.input.FaceLiveness;
import com.caf.facelivenessiproov.input.VerifyLivenessListener;
import com.caf.facelivenessiproov.input.iproov.Filter;
import com.caf.facelivenessiproov.output.FaceLivenessResult;

public class IproovLibTestModule extends ReactContextBaseJavaModule {
  public static final String NAME = "IproovLibTest";
  private Context context;
  private String stage;

  public IproovLibTestModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.context = reactContext;
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  public CAFStage getStage(String stage) {
    switch(stage) {
      case "BETA":
        return CAFStage.BETA;
      case "DEV":
        return CAFStage.DEV;
      default:
        return CAFStage.PROD;
    }
  }

  public Filter getFilter(String filter) {
    if (filter.equals("NATURAL")) {
      return Filter.NATURAL;
    }

    return Filter.LINE_DRAWING;
  }

  @ReactMethod
  public void startFaceLiveness(String mobileToken, String personId, String stage, String filter) {
    FaceLiveness faceLiveness = new FaceLiveness.Builder(mobileToken)
      .setStage(getStage(stage))
      .setFilter(getFilter(filter))
      .build();

    faceLiveness.startSDK(this.context, personId, new VerifyLivenessListener() {
      @Override
      public void onSuccess(FaceLivenessResult faceLivenessResult) {
        getReactApplicationContext()
          .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
          .emit("onFaceLivenessSuccess", faceLivenessResult.getSignedResponse());
      }

      @Override
      public void onError(FaceLivenessResult faceLivenessResult) {
        getReactApplicationContext()
          .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
          .emit("onFaceLivenessError", faceLivenessResult.getErrorMessage());
      }

      @Override
      public void onCancel(FaceLivenessResult faceLivenessResult) {
        getReactApplicationContext()
          .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
          .emit("onFaceLivenessCancel", faceLivenessResult.getErrorMessage());
      }

      @Override
      public void onLoading() {
        getReactApplicationContext()
          .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
          .emit("onFaceLivenessLoading", true);
      }

      @Override
      public void onLoaded() {
        getReactApplicationContext()
          .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
          .emit("onFaceLivenessLoaded", true);
      }
    });
  }
}
