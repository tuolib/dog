#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <PushKit/PushKit.h>
#import "FlutterVoipPushNotificationPlugin.h"
#import "FlutterCallKitPlugin.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // flutter_apns
  if (@available(iOS 10.0, *)) {
    [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
  }

  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}

// flutter_voip_notification
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


// flutter_call_kit
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion {
  // Process the received push
  [FlutterVoipPushNotificationPlugin didReceiveIncomingPushWithPayload:payload forType:(NSString *)type];
    NSLog(@"payload voip");
    
//    NSString *uuid = payload.dictionaryPayload[@"uuid"];
    NSString *uuid = payload.dictionaryPayload[@"data"][@"uuid"];
    NSLog(@"Value of uuid = %@", uuid);
//    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];

    NSString *handle = payload.dictionaryPayload[@"data"][@"handle"];
    bool hasVideo = payload.dictionaryPayload[@"data"][@"hasVideo"];

  // Retrieve information like handle and callerName here
//   NSString *uuid = /* fetch for payload or ...  [[[NSUUID UUID] UUIDString] lowercaseString];*/
   NSString *callerName = payload.dictionaryPayload[@"data"][@"callerName"];
   NSLog(@"Value of callerName = %@", callerName);
//   NSString *handle = @"+12011234567";

  [FlutterCallKitPlugin reportNewIncomingCall:uuid handle:handle handleType:@"generic" hasVideo:hasVideo  localizedCallerName:callerName fromPushKit: YES];

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
