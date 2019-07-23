//
//  TripObject.h
//  Taxidio
//
//  Created by E-Intelligence on 05/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripObject : NSObject

@property (nonatomic,strong) NSString *citiorcountries;
@property (nonatomic,strong) NSString *country_id;
@property (nonatomic,strong) NSString *country_name;
@property (nonatomic,strong) NSString *end_date;
@property (nonatomic,strong) NSString *strid;
@property (nonatomic,strong) NSString *inputs;
@property (nonatomic,strong) NSString *isblock;
@property (nonatomic,strong) NSString *rating;
@property (nonatomic,strong) NSString *slug;
@property (nonatomic,strong) NSString *start_date;
@property (nonatomic,strong) NSString *total;
@property (nonatomic,strong) NSString *trip_mode;
@property (nonatomic,strong) NSString *trip_type;
@property (nonatomic,strong) NSString *tripname;
@property (nonatomic,strong) NSString *user_trip_name;
@property (nonatomic,strong) NSString *views;

@end
