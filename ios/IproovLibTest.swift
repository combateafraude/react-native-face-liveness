import UIKit
import Foundation
import FaceLiveness
import React

@objc(IproovLibTest)
class IproovLibTest: RCTEventEmitter {

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc(startFaceLiveness:personId:) 
  func startFaceLiveness(mobileToken: String, personId: String) {
    let faceLivenessController = FaceLivenessController()
    faceLivenessController.iproovLibTest = self
    faceLivenessController.startSDK(mobileToken, personId: personId)
  }

  @objc(FaceLivenessController)
  class FaceLivenessController: UIViewController, RCTBridgeModule, FaceLivenessDelegate {
    var faceLiveness: FaceLivenessSDK!
    weak var iproovLibTest: IproovLibTest?

    @objc func startSDK(_ mobileToken: String, personId: String) {
      faceLiveness = FaceLivenessSDK.Build()
        .setCredentials(mobileToken: mobileToken, personId: personId)
        .setFilter(filter: .natural)
        .build()

      faceLiveness?.delegate = self
      faceLiveness?.startSDK(viewController: self)
    }

    func didFinishLiveness(with faceLivenessResult: FaceLivenessResult) {
      if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessSuccess", eventBody: faceLivenessResult.signedResponse)
      }
    }

    func didFinishWithFail(with faceLivenessFailResult: FaceLivenessFailResult) {
      if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessFail", eventBody: faceLivenessFailResult.description)
      }
    }
        
    func didFinishWithError(with faceLivenessErrorResult: FaceLivenessErrorResult) {
      if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessCancel", eventBody: faceLivenessErrorResult.description)
      }
    }
        
    func didFinishWithCancelled(with faceLivenessResult: FaceLivenessResult) {
      if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessCancel", eventBody: faceLivenessResult.signedResponse)
      }
    }
        
    func openLoadingScreenStartSDK() {
      if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessLoading", eventBody: true)
      }   
    }
        
    func closeLoadingScreenStartSDK() {
      if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessLoading", eventBody: false)
      }
    }
        
    func openLoadingScreenValidation() {
      if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessLoading", eventBody: true)
      }
    }
          
    func closeLoadingScreenValidation() {
       if let iproovLibTest = self.iproovLibTest {
        iproovLibTest.emitEvent(eventName: "onFaceLivenessLoaded", eventBody: false)
      }
    }

    static func moduleName() -> String! {
      return "FaceLivenessController"
    }
  }

  @objc func emitEvent(eventName: String, eventBody: Any?) {
    sendEvent(withName: eventName, body: eventBody)
  }

  override func supportedEvents() -> [String]! {
    return [
      "onFaceLivenessSuccess",
      "onFaceLivenessFail",
      "onFaceLivenessError", 
      "onFaceLivenessCancel", 
      "onFaceLivenessLoading",
      "onFaceLivenessLoaded",
    ]
  }
}
