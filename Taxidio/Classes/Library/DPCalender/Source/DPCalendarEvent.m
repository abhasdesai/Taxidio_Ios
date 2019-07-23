//
//  DPCalendarEvent.m
//  DPCalendar
//
//  Created by Ethan Fang on 7/01/14.
//  Copyright (c) 2014 Ethan Fang. All rights reserved.
//

#import "DPCalendarEvent.h"

@implementation DPCalendarEvent

-(id)initWithTitle:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime colorIndex:(uint)colorIndex setID:(NSString*)strIds{
    self = [super init];
    if (self) {
        _title = title;
        _startTime = startTime;
        _endTime = endTime;
        _colorIndex = colorIndex;
        _strIds = strIds;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Title:%@, StartTime:%@, EndTime:%@, colorIndex:%d,IDs:%@", self.title, self.startTime, self.endTime, self.colorIndex, self.strIds];
}

@end
