//
//  Helper.h
//  KaraoQ
//
//  Created by Hardik Bhut on 11/03/15.
//  Copyright (c) 2015 Hardik Bhut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIAlertView.h>
#import "Utilities.h"

@interface Helper : NSObject
{
    
}
+ (Helper *) sharedHelper;

/*!
 @method viewFromNib
 @abstract Load view from Nib Files
 */
+ (UIView *)viewFromNib:(NSString *)sNibName;
/*!
 @method viewFromNib
 @abstract Load view from Nib Files for dynemic class
 */
+ (id)viewFromNib:(NSString *)sNibName sViewName:(NSString *)sViewName;
/*!
 @method performBlock
 @abstract Perform Block Operation after delay
 */
+(void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (NSString *)getPREF:(NSString *)sKey;
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (int)getPREFint:(NSString *)sKey;
/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREF:(NSString *)sValue :(NSString *)sKey;
/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREFint:(int)iValue :(NSString *)sKey;
/*!
 @method delPREF
 @abstract To delete the preference value for the key that has been passed
 */
+(void) delPREF:(NSString *)sKey;
+ (NSMutableDictionary*)getPREFDict:(NSString *)sKey;

+(void) setPREFDict :(NSMutableDictionary*)dict :(NSString*)strKey;
/*!
 @method displayAlertView
 @abstract To Display Alert Msg
 */
+(void) displayAlertView :(NSString *) title message :(NSString *) message;
+(NSString*)removeWhiteSpaceString :(NSString*)strVal;
+(NSDate *)getDateWithTime:(NSDate *)localDate;
//+(NSString*)strAlertMsg :(NSString*)strMsgWS;
+ (BOOL)validateEmailWithString:(NSString*)email;

+(BOOL) createDirectory : (NSString *) dirName;
+(NSString *) createSubDirectory : (NSString *) dirName :(NSString *)subDirectory;

+ (NSMutableDictionary *)recursiveNullRemove:(NSMutableDictionary *)dictionaryResponse;
+ (BOOL)isIphoneX;

@end
