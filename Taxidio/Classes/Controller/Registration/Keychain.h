//
//  Keychain.h
//  Taxidio
//
//  Created by Abhas Desai on 22/07/19.
//  Copyright © 2019 E-intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Keychain : NSObject
{
    NSString * service;
    NSString * group;
}

-(id) initWithService:(NSString *) service_ withGroup:(NSString*)group_;
-(BOOL) insert:(NSString *)key : (NSData *)data;
-(BOOL) update:(NSString*)key :(NSData*) data;
-(BOOL) remove: (NSString*)key;
-(NSData*) find:(NSString*)key;


@end

NS_ASSUME_NONNULL_END
