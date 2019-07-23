//
//  LocationData.h
//  Taxidio
//
//  Created by E-Intelligence on 04/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationData : NSObject
{
}


//"devgeometry":{"devcoordinates":["4.39971","51.22111"]},"distance":21,"isselected":1,"tempremoved":0,"order":21},{"type":"Feature","geometry":{"type":"Point","coordinates":["4.4036446999","51.212040599"]},"properties":{"name":"Konditori","knownfor":"15","known_tags":"Food & Nightlife","tag_star":"1","getyourguide":0,"attractionid":"f2201f5191c4e92cc5af043eebfd0946","cityid":"44f683a84163b3523afe57c2e008bc8c","isplace":1,"ispaid":0,"category":3}
@property(nonatomic,retain) NSDictionary *devgeometry;
@property(nonatomic) NSInteger distance;
@property(nonatomic,retain) NSDictionary *geometry;
@property(nonatomic) NSInteger isselected;
@property(nonatomic) NSInteger order;
@property(nonatomic,retain) NSDictionary *properties;
@property(nonatomic) NSInteger tempremoved;
@property(nonatomic,retain) NSString *type;

@end

