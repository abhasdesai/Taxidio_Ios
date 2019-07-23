
#define IS_IPHONE		([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


#define IS_RATINA  ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define IS_I5  (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON)

#define IOS_5_PLUS	([[[UIDevice currentDevice] systemVersion] floatValue]  >= 5.0 )
#define IOS_7_PLUS	([[[UIDevice currentDevice] systemVersion] floatValue]  >= 7.0 )

#define SALog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define SALog(fmt, ...)  {};
#define TLog	SALog(@"%@",[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]);

#define APP_DELEGATE		((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define SHARED_APP			[UIApplication sharedApplication]
#define SHOW_AI				[APP_DELEGATE showActivityIndicator];
#define SHOW_AI_M(s)		[APP_DELEGATE showActivityIndicator:s];
#define HIDE_AI				[APP_DELEGATE hideActivityIndicator];
#define HIDE_AI_M(s)		[APP_DELEGATE hideActivityIndicator:s];


#define UIIMAGE_NAMED(s)                [UIImage imageNamed:s]
#define BG_PATTERN_IMAGE(s)				[UIColor colorWithPatternImage:UIIMAGE_NAMED(s)]

/**
 Create a UIColor with r,g,b values between 0.0 and 1.0.
 */
#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

/**
 Create a UIColor with r,g,b,a values between 0.0 and 1.0.
 */
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

/**
 Create a UIColor from a hex value.
 
 For example, `UIColorFromRGB(0xFF0000)` creates a `UIColor` object representing
 the color red.
 */
#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

/**
 Create a UIColor with an alpha value from a hex value.
 
 For example, `UIColorFromRGBA(0xFF0000, .5)` creates a `UIColor` object
 representing a half-transparent red.
 */
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]


#define degreesToRadians(x) (M_PI * (x) / 180.0)


#define IS_PUSH_ENABLE	([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone)

