//
//  WalkThrough.h
//  Taxidio
//
//  Created by E-Intelligence on 11/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface WalkThrough : UIViewController
{
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewMainView;
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *lblDescription;
    UIView *tempUIView;
    IBOutlet UIButton *btnLeft,*btnRight;
    NSMutableArray *arrDataWalkThrough;
    IBOutlet UIPageControl *pageCntrl;

    NSInteger index;
}

@property (nonatomic, strong) NSMutableArray *arrDataWalkThrough;

- (IBAction)pressSkip:(id)sender;
- (IBAction)pressNext:(id)sender;
- (IBAction)pressPrevious:(id)sender;

@end
