//
//  singleCity.h
//  Taxidio
//
//  Created by E-Intelligence on 04/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface singleCity : NSObject
{
    NSString *city_name;
    NSString *cityimage;
    NSString *cityslug;
    NSString *code;
    NSString *latitude;
    NSString *longitude;
    NSString *rome2rio_name;
    NSString *sortorder;
    NSString *total_days;
    NSString *totaltags;
}

@property(nonatomic,strong) NSString *city_name;
@property(nonatomic,strong) NSString *cityimage;
@property(nonatomic,strong) NSString *cityslug;
@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *rome2rio_name;
@property(nonatomic,strong) NSString *sortorder;
@property(nonatomic,strong) NSString *total_days;
@property(nonatomic,strong) NSString *totaltags;

@end
