#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <PushKit/PushKit.h>
#import "FlutterVoipPushNotificationPlugin.h"
#import "FlutterCallKitPlugin.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

/* Add PushKit delegate method */

// Handle updated push credentials
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
  // Register VoIP push token (a property of PKPushCredentials) with server
  [FlutterVoipPushNotificationPlugin didUpdatePushCredentials:credentials forType:(NSString *)type];
}

// Handle incoming pushes
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
   //Process the received push
  [FlutterVoipPushNotificationPlugin didReceiveIncomingPushWithPayload:payload forType:(NSString *)type];
}


- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion {
  // Process the received push
  [FlutterVoipPushNotificationPlugin didReceiveIncomingPushWithPayload:payload forType:(NSString *)type];

  // Retrieve information like handle and callerName here
   NSString *uuid = /* fetch for payload or ... */ [[[NSUUID UUID] UUIDString] lowercaseString];
   NSString *callerName = @"ham";
   NSString *handle = @"+12011234567";

  [FlutterCallKitPlugin reportNewIncomingCall:uuid handle:handle handleType:@"generic" hasVideo:false  localizedCallerName:callerName fromPushKit: YES];

  completion();
}


//- (BOOL)application:(UIApplication *)application
//  continueUserActivity:(NSUserActivity *)userActivity
//  restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler {
//    return [CallKeep application:application
//                        continueUserActivity:userActivity
//                        restorationHandler:restorationHandler];
//
//}

@end
