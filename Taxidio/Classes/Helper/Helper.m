//
//  Helper.m
//  KaraoQ
//
//  Created by Hardik Bhut on 11/03/15.
//  Copyright (c) 2015 Hardik Bhut. All rights reserved.
//

#import "Helper.h"
#import <UIKit/UIView.h>
#import <UIKit/UIKit.h>


static Helper * _sharedHelper = nil;

@implementation Helper
+ (Helper *) sharedHelper
{
    if (_sharedHelper == nil)
    {
        _sharedHelper = [[Helper alloc] init];
    }
    
    return _sharedHelper;
}

+ (BOOL)isIphoneX
{
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        if(topPadding>0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}


/*!
 @method viewFromNib
 @abstract Load view from Nib Files
 */
+ (UIView *)viewFromNib:(NSString *)sNibName{
    return (UIView *)[Helper viewFromNib:sNibName sViewName:@"UIView"];
}
/*!
 @method viewFromNib
 @abstract Load view from Nib Files for dynemic class
 */
+ (id)viewFromNib:(NSString *)sNibName sViewName:(NSString *)sViewName{
    //	SALog(@"sNibName..%@",sNibName);
    Class className = NSClassFromString(sViewName);
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:sNibName owner:self options:nil];
    for (id _view in xib) { // have to iterate; index varies
        if ([_view isKindOfClass:[className class]]) return _view;
    }
    return nil;
}
/*!
 @method performBlock
 @abstract Perform Block Operation after delay
 */
+(void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (NSString *)getPREF:(NSString *)sKey {
    return (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:sKey];
}

/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (int)getPREFint:(NSString *)sKey {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:sKey];
}

+ (NSMutableDictionary*)getPREFDict:(NSString *)sKey {
    return (NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:sKey] ;
}


/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREF:(NSString *)sValue :(NSString *)sKey {
    [[NSUserDefaults standardUserDefaults] setValue:sValue forKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) setPREFDict :(NSMutableDictionary*)dict :(NSString*)strKey
{
//    for( id key in [dict allKeys] )
//    {
//        if( [[dict valueForKey:key] isKindOfClass:[NSNull class]] )
//        {
//            // doesn't work - values that are entered will never be removed from NSUserDefaults
//            //[dict removeObjectForKey:key];
//            [dict setObject:@"" forKey:key];
//        }
//    }
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableDictionary *)recursiveNullRemove:(NSMutableDictionary *)dictionaryResponse
{
    NSMutableDictionary *dictionary = [dictionaryResponse mutableCopy];
    NSString *nullString = @"";
    for (NSString *key in [dictionary allKeys])
    {
        id value = dictionary[key];
        
        if ([value isKindOfClass:[NSDictionary class]])
        {
            dictionary[key] = [self recursiveNullRemove:(NSMutableDictionary*)value];
        }
        else if([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *newArray = [value mutableCopy];
            for (int i = 0; i < [value count]; ++i) {
                
                id value2 = [value objectAtIndex:i];
                
                if ([value2 isKindOfClass:[NSDictionary class]]) {
                    newArray[i] = [self recursiveNullRemove:(NSMutableDictionary*)value2];
                }
                else if ([value2 isKindOfClass:[NSNull class]]){
                    newArray[i] = nullString;
                }
            }
            dictionary[key] = newArray;
        }else if ([value isKindOfClass:[NSNull class]])
        {
            dictionary[key] = nullString;
        }
    }
    return dictionary;
}


//+(void) setPREFArray :(NSMutableArray*)dict :(NSString*)strKey
//{
//    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:strKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREFint:(int)iValue :(NSString *)sKey {
    [[NSUserDefaults standardUserDefaults] setInteger:iValue forKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*!
 @method delPREF
 @abstract To delete the preference value for the key that has been passed
 */
+(void) delPREF:(NSString *)sKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*!
 @method displayAlertView
 @abstract To Display Alert Msg
 */
+ (void) displayAlertView :(NSString *) title message :(NSString *) message
{

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];

}

+(NSString*)removeWhiteSpaceString :(NSString*)strVal
{
    NSString *strUpdatedStr = [NSString stringWithFormat:@"%@",[strVal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
    strUpdatedStr = [[strUpdatedStr componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    return strUpdatedStr;
}

+(NSDate *)getDateWithTime:(NSDate *)localDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dateString = [formatter stringFromDate:localDate];
    NSDate *dt = [formatter dateFromString:dateString];
    return dt;
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL) createDirectory : (NSString *) dirName
{
    BOOL isCreated;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSMutableString *dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:dirName];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        isCreated = FALSE;
        NSLog(@"Couldn't create directory error: %@", error);
    }
    else {
        isCreated = TRUE;
        NSLog(@"directory created!");
    }
    
    NSLog(@"dataPath : %@ ",dataPath); // Path of folder created
    return isCreated;
}

+(NSString *) createSubDirectory : (NSString *) dirName :(NSString *)subDirectory
{
    BOOL isCreated;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    
    NSString *countryDirectory = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",dirName]];
    NSString *dataPath = (NSMutableString *)[countryDirectory stringByAppendingPathComponent:subDirectory];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        isCreated = FALSE;
        NSLog(@"Couldn't create directory error: %@", error);
    }
    else {
        isCreated = TRUE;
        NSLog(@"directory created!");
    }
    
    NSLog(@"dataPath : %@ ",dataPath);
    return dataPath;
}


/* The UI_USER_INTERFACE_IDIOM() macro is provided for use when deploying to a version of the iOS less than 3.2. If the earliest version of iPhone/iOS that you will be deploying for is 3.2 or greater, you may use -[UIDevice userInterfaceIdiom] directly.
 */
#define UI_USER_INTERFACE_IDIOM() ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : UIUserInterfaceIdiomPhone)

#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)

@end
