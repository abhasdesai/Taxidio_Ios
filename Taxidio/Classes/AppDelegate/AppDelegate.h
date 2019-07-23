//
//  AppDelegate.h
//  Taxidio
//
//  Created by E-Intelligence on 03/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

#import <Mapbox/Mapbox.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Webservice.h"
#import <GooglePlaces/GooglePlaces.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Utilities.h"
#import "SignInPage.h"
#import "HomeScreenVC.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <UserNotifications/UserNotifications.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate,MBProgressHUDDelegate,UNUserNotificationCenterDelegate>
{
    MBProgressHUD	*HUD;
    NSInteger indexr;
    NSString *strUDIDToken;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@property (strong, nonatomic) UIWindow *window;

-(BOOL)checkInternetConnection :(int)sMessage;

-(void)showActivityIndicator;
-(void)showActivityIndicator:(NSString *)sMessage;
-(void)hideActivityIndicator;
-(void)hideActivityIndicator:(NSString *)sMessage;


@end

