//
//  GMGridViewSub.m
//  Taxidio
//
//  Created by E-Intelligence on 27/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "GMGridViewSub.h"

#import "GMGridViewLayoutStrategies.h"
#import "GMGridViewCell+Extended.h"

static const NSInteger kTagOffset = 50;
static const CGFloat kDefaultAnimationDuration = 0.3;

@implementation GMGridViewSub

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        return self;
        
    }
    return self;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL valid = [super gestureRecognizerShouldBegin:gestureRecognizer];
    BOOL isScrolling = self.isDragging || self.isDecelerating;

    if(gestureRecognizer ==self.longPressGesture_New)
    {
        valid = (self.sortingDelegate) && !isScrolling;
    }
    else
    {
        
    }
    return valid;
}

-(void) longPressGestureUpdate :(UILongPressGestureRecognizer*) longPressGesture
{
    if(!self.sortMovingItem)
    {
        CGPoint location = [longPressGesture locationInView:self];
        
        NSInteger position  = [self.layoutStrategy itemPositionFromLocation:location];
        
        if(position != GMGV_INVALID_POSITION)
        {
            [self sortingMoveDidStartAtPoint:location];
            if(!self.editing)
            {
                self.editing = YES;
            }
        }
    }
}


-(void) sortingMoveDidStartAtPoint :(CGPoint) point
{
    [self sortingMoveDidStartAtPoint:point];
    self.editing = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
