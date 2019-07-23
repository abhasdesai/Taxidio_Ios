#import <Foundation/Foundation.h>
#import "XMLReader.h"
#import "JSON.h"
#import "NSURLConnection+SendAsync.h"
#import "Utilities.h"

typedef enum{
	kPOST,
	kGET
}
WSType;

typedef enum{
	kJSON,
	kXML
}
WSDatatype;

@interface WSFrameWork : NSObject

@property (nonatomic, retain) NSString		*sDomainName;
@property (nonatomic, retain) NSString		*sURL;
@property (nonatomic, assign) BOOL			isSync;
@property (nonatomic, retain) NSDictionary	*dicParams;
@property (nonatomic, retain) NSDictionary	*dicFilesParams;
@property (nonatomic, retain) NSDictionary	*dicFilesParamsName;
@property (nonatomic, retain) NSString		*sContentType;
@property (nonatomic, assign) WSType		WSType;
@property (nonatomic, assign) WSDatatype	WSDatatype;
@property (nonatomic, copy) void (^beforeSend)();
@property (nonatomic, copy) void (^onSuccess)(NSDictionary	*dicResponce);
@property (nonatomic, copy) void (^onError)(NSError *err);
@property (nonatomic, copy) void (^onComplete)();
@property (nonatomic, assign) int iTimeOutInterval;
@property (nonatomic, assign) BOOL isLogging;

-(id)initWithURLAndParams:(NSString *)_sURL;
-(id)initWithURLAndParams:(NSString *)_sURL dicParams:(NSDictionary *)_dicParams;
-(id)initWithURLParamsAndFiles:(NSString *)_sURL dicParams:(NSDictionary *)_dicParams dicFilesParams:(NSDictionary *)_dicFilesParams dicFilesParamsName:(NSDictionary *)_dicFilesParamsName;
-(void)send;
-(void)get;
-(NSDictionary *)getResponceForPath:(NSDictionary *)dicResponce path:(NSString *)path;
#pragma mark - Private Methods
-(void)setUp;
-(NSDictionary *)convertResponce:(NSString *)sResponce;
-(NSDictionary *)convertResponceJSON:(NSString *)sResponce;
-(NSDictionary *)convertResponceXML:(NSString *)sResponce;
-(void)handleResponce:(NSURLResponse *)responce dataReturn:(NSData *)dataReturn errConnection:(NSError *)errConnection;
@end
