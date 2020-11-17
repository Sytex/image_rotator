#import "ImageRotatorPlugin.h"
#import <image_rotator/image_rotator-Swift.h>

@implementation ImageRotatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImageRotatorPlugin registerWithRegistrar:registrar];
}
@end
