//
//  cityAttraction.h
//  Taxidio
//
//  Created by E-Intelligence on 26/09/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

//[{"type":"Feature","geometry":{"type":"Point","coordinates":["2.2944813000000295","48.85837009999999"]},"properties":{"name":"Eiffel Tower","knownfor":"2,3,11","known_tags":"Architecture, History, Romance","tag_star":"2","getyourguide":"1","attractionid":"ccf0304d099baecfbe7ff6844e1f6d91","cityid":"5ef698cd9fe650923ea331c15af3b160","isplace":1,"ispaid":1,"category":1},"devgeometry":{"devcoordinates":["2.35880380000003","48.8587029"]},"distance":0,"isselected":1,"tempremoved":0,"order":0}

@interface cityAttraction : NSObject
{
    NSString *type;
    NSString *geometry;
    
}
@end
