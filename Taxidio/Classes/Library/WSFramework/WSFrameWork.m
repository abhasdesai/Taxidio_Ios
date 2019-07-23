#import "WSFrameWork.h"

@implementation WSFrameWork

@synthesize sDomainName;
@synthesize sURL;
@synthesize isSync;
@synthesize dicParams;
@synthesize WSType;
@synthesize WSDatatype;
@synthesize beforeSend;
@synthesize onSuccess;
@synthesize onError;
@synthesize onComplete;
@synthesize iTimeOutInterval;
@synthesize dicFilesParams;
@synthesize isLogging;
@synthesize dicFilesParamsName;
@synthesize sContentType;

#pragma mark - init Methods
-(id)init{
	[self setUp];
	return [super init];
}

-(id)initWithURLAndParams:(NSString *)_sURL{
    
    self.WSType = kGET;
    self.sURL=_sURL;
    return [self init];
}

-(id)initWithURLAndParams:(NSString *)_sURL dicParams:(NSDictionary *)_dicParams{
    
    self.WSType = kPOST;
	self.sURL=_sURL;
	self.dicParams=_dicParams;
	return [self init];
}

-(id)initWithURLParamsAndFiles:(NSString *)_sURL dicParams:(NSDictionary *)_dicParams dicFilesParams:(NSDictionary *)_dicFilesParams dicFilesParamsName:(NSDictionary *)_dicFilesParamsName{
	self.sURL=_sURL;
	self.dicParams=_dicParams;
	self.dicFilesParams=_dicFilesParams;
	self.dicFilesParamsName=_dicFilesParamsName;
	return [self init];
}
#pragma mark - Send/Handle Request
/*!
 @method send
 @abstract To send Request to server
 */
-(void)send{
	self.beforeSend();
//    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
//	NSString * sUrl = [[NSString stringWithFormat:@"%@%@",self.sDomainName, self.sURL] stringByAddingPercentEncodingWithAllowedCharacters:set];

    NSString * sUrl = [[NSString stringWithFormat:@"%@%@",self.sDomainName, self.sURL] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
//    NSString *sVersion =[NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];

    NSMutableDictionary *dicMutableParams=[[NSMutableDictionary alloc] initWithDictionary:self.dicParams];
//    [dicMutableParams setValue:sVersion forKey:@"version_number"];
    
    self.dicParams=dicMutableParams;
	if (self.isLogging) {
		NSLog(@"Dic params :%@", self.dicParams);
	}
    
    
    //Generate Http request with Post data
	//NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	//[request setTimeoutInterval:self.iTimeOutInterval];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.iTimeOutInterval];

    
    
    
	if(self.WSType == kPOST){
		if(isLogging){
			NSLog(@"WS URL :::: %@",sUrl);
		}
		//[request setURL:[NSURL URLWithString:sUrl]];
		[request setHTTPMethod:@"POST"];
		//NSString *sBoundary = @"---------------------------14737809831466499882746641449";
        
        NSString *sBoundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
        
//		
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",sBoundary];
		[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
//        NSString *struid = [Helper getPREF:PREF_USER_ID];
//        NSString *strToken = [Helper getPREF:PREF_ACCESS_TOKEN];
//        NSString *strversion = [Helper getPREF:PREF_SYSTEM_VERSION_APP];
//
//        if(struid.length != 0)
//        {
//            [request setValue:struid forHTTPHeaderField:@"user_id"];
//        }
//        if(strToken.length != 0)
//        {
//             [request setValue:strToken forHTTPHeaderField:@"access_token"];
//        }
//        [request setValue:strversion forHTTPHeaderField:@"iOS_version"];
        
         //[request setValue:strversion forHTTPHeaderField:@"android_version"];
        
        
        //android_version
        
		
		//Set boby to request
		NSMutableData *body = [NSMutableData data];
		if([[self.dicParams allKeys] count]>0){
			for(NSString * sParam in [self.dicParams allKeys])
			{
				[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];   
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",sParam, [self.dicParams valueForKey:sParam]] dataUsingEncoding:NSUTF8StringEncoding]]; 
			}
		}
		
		if(self.dicFilesParams != nil && [[self.dicFilesParams allKeys] count]>0){
			for (NSString *sParams in [self.dicFilesParams allKeys]) {
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\n",sParams, [self.dicFilesParamsName	objectForKey:sParams]]dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

                [body appendData:[NSData dataWithData:[self.dicFilesParams	objectForKey:sParams]]];
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
		}
		 
		//Setting the body of the post to the reqeust
		[request setHTTPBody:body];
		
	}else {
		NSMutableString *sParams = [NSMutableString string];
		// Generating Query string from Parameters Dic
		for (NSString* key in [dicParams allKeys]){
			if ([sParams length]>0)
				[sParams appendString:@"&"];
			[sParams appendFormat:@"%@=%@", key, [dicParams objectForKey:key]];
		}
		
		sUrl = [NSString stringWithFormat:@"%@?%@",sUrl,sParams];
		
		if(isLogging){
			NSLog(@"WS URL :::: %@",sUrl);
		}
		[request setURL:[NSURL URLWithString:sUrl]];
		[request setHTTPMethod:@"GET"];
	}
	
	//Send requsest to server and retrieve response
	if (isSync) {
		if (self.isLogging) {
			NSLog(@"WSType :::: Scyn Request Sent");
		}

		NSURLResponse *responce = nil;
		NSData *dataReturn;
		NSError *errConnection = nil;
		
		dataReturn = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&errConnection];
		
		[self handleResponce:responce dataReturn:dataReturn errConnection:errConnection];
		
	}else {
		if (self.isLogging) {
			NSLog(@"WSType :::: Ascyn Request Sent");
		}
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce, NSData *dataReturn, NSError *errConnection) {
			[self handleResponce:responce dataReturn:dataReturn errConnection:errConnection];
		}];
	}
}


-(void)get{
    self.beforeSend();
    //    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    //	NSString * sUrl = [[NSString stringWithFormat:@"%@%@",self.sDomainName, self.sURL] stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString * sUrl = [[NSString stringWithFormat:@"%@%@",self.sDomainName, self.sURL] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *sVersion =[NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    
    NSMutableDictionary *dicMutableParams=[[NSMutableDictionary alloc] initWithDictionary:self.dicParams];
    [dicMutableParams setValue:sVersion forKey:@"version_number"];
    
    self.dicParams=dicMutableParams;
    if (self.isLogging) {
        NSLog(@"Dic params :%@", self.dicParams);
    }
    
    
    //Generate Http request with Post data
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setTimeoutInterval:self.iTimeOutInterval];
    if(self.WSType == kGET){
        if(isLogging){
            NSLog(@"WS URL :::: %@",sUrl);
        }
        [request setURL:[NSURL URLWithString:sUrl]];
        [request setHTTPMethod:@"POST"];
        NSString *sBoundary = @"---------------------------14737809831466499882746641449";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",sBoundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //Set boby to request
        NSMutableData *body = [NSMutableData data];
        if([[self.dicParams allKeys] count]>0){
            for(NSString * sParam in [self.dicParams allKeys])
            {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",sParam, [self.dicParams valueForKey:sParam]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        if(self.dicFilesParams != nil && [[self.dicFilesParams allKeys] count]>0){
            for (NSString *sParams in [self.dicFilesParams allKeys]) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\"%@\"\r\n",sParams, [self.dicFilesParamsName	objectForKey:sParams]] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",self.sContentType] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:[self.dicFilesParams	objectForKey:sParams]]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        //Setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
    }else {
        NSMutableString *sParams = [NSMutableString string];
        // Generating Query string from Parameters Dic
        for (NSString* key in [dicParams allKeys]){
            if ([sParams length]>0)
                [sParams appendString:@"&"];
            [sParams appendFormat:@"%@=%@", key, [dicParams objectForKey:key]];
        }
        
        sUrl = [NSString stringWithFormat:@"%@?%@",sUrl,sParams];
        
        if(isLogging){
            NSLog(@"WS URL :::: %@",sUrl);
        }
        [request setURL:[NSURL URLWithString:sUrl]];
        [request setHTTPMethod:@"GET"];
    }
    
    //Send requsest to server and retrieve response
    
    
    if (isSync) {
        if (self.isLogging) {
            NSLog(@"WSType :::: Scyn Request Sent");
        }
        
        NSURLResponse *responce = nil;
        NSData *dataReturn;
        NSError *errConnection = nil;
        
        dataReturn = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&errConnection];
        
        [self handleResponce:responce dataReturn:dataReturn errConnection:errConnection];
        
    }else {
        if (self.isLogging) {
            NSLog(@"WSType :::: Ascyn Request Sent");
        }
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce, NSData *dataReturn, NSError *errConnection) {
            [self handleResponce:responce dataReturn:dataReturn errConnection:errConnection];
        }];
    }
}

/*!
 @method getResponceForPath
 @abstract To get Responce for path given path should be separate with "/" e.g. [wsObj getResponceForPath:dic path:@"root/info/id/text"]
 */
-(NSDictionary *)getResponceForPath:(NSDictionary *)dicResponce path:(NSString *)path{
	NSArray *arrPath = [path componentsSeparatedByString:@"/"];
	NSDictionary *dicReturn=dicResponce;
	for (NSString *pathComponent in arrPath) {
		@try {
			if([dicReturn objectForKey:pathComponent]!=nil && [dicReturn count]>0){
				dicReturn=[dicReturn objectForKey:pathComponent];
			}else {
				NSLog(@"Key not found :::: %@",pathComponent);
			}
		}
		@catch (NSException * e) {
			NSLog(@"Key not found :::: %@",pathComponent);
		}
	}
	return dicReturn;
}

#pragma mark - Private Methods
-(void)setUp{
    
   // AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
	
	self.WSDatatype = kJSON;
	self.isSync = FALSE;
    
    
    self.sDomainName = WS_DOMAIN;
    
    
	self.beforeSend = ^{};
	self.onComplete = ^{};
	self.onSuccess = ^(NSDictionary	*dicResponce){};
	self.onError = ^(NSError *err){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:[err localizedDescription]
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    HIDE_AI;
	};
	self.iTimeOutInterval = 100;
	self.isLogging=FALSE;
	self.sContentType = @"application/octet-stream";
}
/*!
 @method convertResponce
 @abstract To convert Responce String from Specifide Format JSON/XML to NSDictionary
 */
-(NSDictionary *)convertResponce:(NSString *)sResponce{
	NSDictionary *dicResponce=nil;
	switch (self.WSDatatype) {
		case kJSON:
			dicResponce=[self convertResponceJSON:sResponce];
			break;
		case kXML:
			dicResponce=[self convertResponceXML:sResponce];
			break;
		default:
			break;
	}
	return dicResponce;
}
/*!
 @method convertResponceJSON
 @abstract To convert Responce String from Specifide Format JSON to NSDictionary
 */
-(NSDictionary *)convertResponceJSON:(NSString *)sResponce{
	NSError *e = nil;
	
	NSDictionary *dicResponce =
    [NSJSONSerialization JSONObjectWithData: [sResponce dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &e];
	return dicResponce;
}

/*!
 @method convertResponceXML
 @abstract To convert Responce String from Specifide Format XML to NSDictionary
 */
-(NSDictionary *)convertResponceXML:(NSString *)sResponce{
	NSError *errXMLParsing = nil;
	NSDictionary *dicResponce = [XMLReader dictionaryForXMLString:sResponce error:&errXMLParsing];
	if(errXMLParsing != nil){
		if (self.isLogging) {
			NSLog(@"Error :::: %@ Error Code :::: %li",[errXMLParsing localizedDescription],(long)[errXMLParsing code]);
		}
        HIDE_AI;
		return nil;
	}
	return dicResponce;
}
/*!
 @method handleResponce
 @abstract To handle responce
 */
-(void)handleResponce:(NSURLResponse *)responce dataReturn:(NSData *)dataReturn errConnection:(NSError *)errConnection{
	if(errConnection != nil){
		if (self.isLogging) {
			NSLog(@"Error :::: %@ Error Code :::: %li",[errConnection localizedDescription],(long)[errConnection code]);
		}
        HIDE_AI;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];

		self.onError(errConnection);
	}else {
		NSString *sResponce = [[NSString alloc] initWithData:dataReturn encoding:NSUTF8StringEncoding];
		if (self.isLogging) {
			NSLog(@"Responce Received :::: %@",sResponce);
		}
		NSDictionary *dicResponce = [self convertResponce:sResponce];
		self.onSuccess(dicResponce);
		[sResponce release];
		self.onComplete();
	}
}
- (void)dealloc
{
	[self.onComplete release];
	[self.onSuccess release];
	[self.onError release];
	[self.beforeSend release];
	[super dealloc];
}
@end
