Examples : 
// Post WS with File Upload
	NSDictionary *dicParams = [[NSDictionary alloc] initWithObjectsAndKeys:
							   <VALUE1>,<KEY1>,
							   <VALUE2>,<KEY2>,
							   <VALUE3>,<KEY3>,
							   nil];
	
	NSData *file1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"<IMAGE_URL1>"]];

	NSData *file2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"<IMAGE_URL2>"]];
	
	NSDictionary *dicFilesParams = nil;
	dicFilesParams = [[NSDictionary alloc] initWithObjectsAndKeys:
								file1,@"file1",
								file2,@"file2",
								nil];

	WSFrameWork *ws = [[WSFrameWork alloc] initWithURLParamsAndFiles:@"<URL_OF_POST_WS>" dicParams:dicParams dicFilesParams:dicFilesParams];
	
	ws.sDomainName = @"<DOMAIN_NAME>";
	ws.WSType = kPOST;
	ws.WSDatatype = kJSON; // Cam be kXML also
//	ws.dicFilesParams = dicFilesParams; // Can be nil as well if there is no file upload
	ws.isSync = TRUE;
	ws.isLogging=TRUE;
	
	ws.onSuccess=^(NSDictionary *dic){
		NSLog(@"Success...%@",dic);
		NSLog(@"Path ::: %@",[ws getResponceForPath:dic path:@"root/users/images"]);
	};
	ws.onError=^(NSError *err){
		// Error handling block would be implement here
	};
	[ws send];
	[ws release];
	[dicParams release];
	[dicFilesParams release];
	
// GET WS Example
dicParams = [[NSDictionary alloc] initWithObjectsAndKeys:
				 <VALUE1>,<KEY1>,
				 nil];
	ws = [[WSFrameWork alloc] initWithURLAndParams:@"<URL_OF_GET_WS>" dicParams:dicParams];
	ws.sDomainName = @"<DOMAIN_NAME>"; // Default can be set from setup function of framework
	ws.WSType = kGET;// Default value is kGET
	ws.WSDatatype = kXML;
	ws.onSuccess=^(NSDictionary *dic){
		NSLog(@"Get Responce For Path :::: %@",[ws getResponceForPath:dic path:@"root/info/id/text"]);
	};
//	ws.isSync = TRUE; // Default value is FALSE
//	ws.isLogging=TRUE;// Default value is FALSE

	ws.onError=^(NSError *err){
		
	};
	
	[ws send];
	[ws release];
	[dicParams release];