#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(IproovLibTest, RCTEventEmitter)

RCT_EXTERN_METHOD(startFaceLiveness: (NSString *)mobileToken personId:(NSString *)personId)

@end
