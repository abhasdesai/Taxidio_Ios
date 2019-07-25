//
//  AppDelegate.m
//  Taxidio
//
//  Created by E-Intelligence on 03/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Webkit/WebKit.h>
@import Firebase;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //New Notifications Settings:
    
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"Oops, no access");
                              }
                          }];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Hi from Plot!";
    content.body = @"Plot Projects says hi";
    content.sound = [UNNotificationSound defaultSound];
    
    //Notification part ends
    
    [Helper setPREFint:0 :@"isFromViewItinerary"];

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError* configureError;
//    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;

    [MGLAccountManager setAccessToken:@"pk.eyJ1IjoiZWlqaW5hYWwiLCJhIjoiY2lwM3ZpZnc2MDBsdHRybTM4aTVqZGFmdyJ9.8OoaIhs2xQSl6azZDiGzcw"];

//    [MGLAccountManager setAccessToken:@"pk.eyJ1IjoiZWkteWFtYS1wdXZhciIsImEiOiJjajVjZGhqNmYwOW85MndvN2RraG9vZnViIn0.Lsg8exh9ecz5i7_0EBtVgA"];
    
    [GMSServices provideAPIKey:GOOGLE_PLACE_KEY];
    [GMSPlacesClient provideAPIKey:GOOGLE_PLACE_KEY];
    
    // Use Firebase library to configure APIs
    [FIRApp configure];
    
    application.applicationIconBadgeNumber = 0;
    if( SYSTEM_VERSION_LESS_THAN( @"10.0"))
    {
       [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {                   
                 NSLog( @"Push registration success." );
            }
             else
             {
                 NSLog(@"Push registration FAILED");
                 NSLog(@"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription);
                 NSLog(@"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion);
             }
             
         }];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tokenAvailableNotification:)
                                                 name:@"NEW_TOKEN_AVAILABLE"
                                            object:nil];
    [self updateUserDeviceDetails : strUDIDToken];

    // For CrashLytics
    [Fabric with:@[[Crashlytics class]]];

    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;

    NSString *storyBoardName;
    
    if(screenHeight == 480 || screenHeight == 568)
        storyBoardName = @"Main_5s";
    else
        storyBoardName = @"Main";

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController  = initialViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    return [[FBSDKApplicationDelegate sharedInstance] application:app
//                                                          openURL:url
//                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    if(error!=nil)
    {
        NSLog(@"error : %@",error);
    }
    else
    {
        NSLog(@"Success...!%@",user);
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - ======= HUD Activity Indicator Methods =======

-(void)showActivityIndicator
{
    [self showActivityIndicator:@"Loading..."];
}

-(void)showActivityIndicator:(NSString *)sMessage
{
//    if (HUD==nil)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
        
        HUD.dimBackground = YES;
    }
    //HUD.labelText = sMessage;
    HUD.detailsLabelText = sMessage;
    
    if (HUD.isHidden) {
        [HUD show:YES];
    }
}

-(void)hideActivityIndicator
{
    // Show the HUD while the provided method executes in a new thread
    if (!HUD.isHidden) {
        [HUD hide:FALSE];
    }
}

-(void)hideActivityIndicator:(NSString *)sMessage
{
    HUD.detailsLabelText = sMessage;
    if (!HUD.isHidden) {
        [HUD hide:YES afterDelay:0.5];
    }
}

-(BOOL)checkInternetConnection :(int)sMessage
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus networkStatus = [r currentReachabilityStatus];
    if(networkStatus != ReachableViaWiFi && networkStatus != ReachableViaWWAN)
    {
        if (sMessage == 0)
        {
            [self showAlert:@"Network Connection" andMessage:@"Sorry. Internet Connection is not available."];
        }
        return FALSE;
    }
    else
    {
        return TRUE;
        //[self showAlert:@"Network Connection" andMessage:@"Internet Connection is available."];
    }
}

- (void) showAlert:(NSString*)title andMessage:(NSString *)alertMessage
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark- ==== WebServiceMethod =======

-(void)updateUserDeviceDetails :(NSString*)deviceToken
{
    if(deviceToken.length==0)
        deviceToken = @"xyz";
    NSString *strAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [Helper setPREF:strAppVersion :PREF_APP_VERSION];
    
    @try{
        NSMutableDictionary *Parameters1 = [[NSMutableDictionary alloc]initWithCapacity:4];
        Parameters1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        deviceToken,@"device_udid",
                                     strAppVersion,@"device_version",
                                     @"2",@"device_type",nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_UPGRADE_DEVICE_ID dicParams:Parameters1];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
                
            }
            else if(intStatus == 1)
            {
                NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
                dictData = [[dicResponce valueForKey:@"data"]copy];
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

- (void)tokenAvailableNotification:(NSNotification *)notification {
    strUDIDToken = (NSString *)notification.object;
    NSLog(@"new token available : %@", strUDIDToken);
    [Helper setPREF:strUDIDToken:PREF_DEVICE_UDID];
}

#pragma mark-======= Push Notification Delegates =======

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"%@", notification.request.content.userInfo);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
    NSLog(@"%@", response.notification.request.content.userInfo);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
   openSettingsForNotification:(UNNotification *)notification{
    
}
@end
