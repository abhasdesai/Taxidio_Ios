//
//  DashBoardVC.h
//  Taxidio
//
//  Created by E-Intelligence on 18/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "DPCalendarMonthlySingleMonthViewLayout.h"

#import "DPCalendarMonthlyView.h"
#import "DPCalendarEvent.h"
#import "DPCalendarIconEvent.h"
#import "NSDate+DP.h"
#import "DPCalendarTestOptionsViewController.h"
#import "DPCalendarTestCreateEventViewController.h"
#import "Utilities.h"


@interface DashBoardVC : UIViewController<DPCalendarMonthlyViewDelegate, DPCalendarTestCreateEventViewControllerDelegate>
{
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UIView *viewMainView;    
    IBOutlet UIView *viewCounter;
    IBOutlet UIView *viewHeader;

    IBOutlet UILabel *lblInProgressCnt;
    IBOutlet UILabel *lblInProgressTitle;
    IBOutlet UIView *viewInProgress;
    IBOutlet UIView *viewRoundProgress;
    
    IBOutlet UIView *viewCompleted;
    IBOutlet UILabel *lblCompletedTitle;
    IBOutlet UIView *viewRoundCompleted;
    IBOutlet UILabel *lblCompletedCnt;
    
    IBOutlet UIView *viewUpComing;
    IBOutlet UILabel *lblUpComingTitle;
    IBOutlet UIView *viewRoundUpcoming;
    IBOutlet UILabel *lblUpcomingCnt;
    
    IBOutlet UIScrollView *scrollView;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenwidth;
    IBOutlet UIView *viewCalender;
    NSMutableArray *arrData;
    int intCompleted,intInprogress,intUpcoming;
    NSMutableDictionary *dictData;
}

@property (nonatomic, strong) NSString *strItineraryIdSelected;

@property (nonatomic, strong) NSMutableArray *arrData,*arrDataforCity;

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *todayButton;
@property (nonatomic, strong) UIButton *createEventButton;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSMutableArray *iconEvents;



@property (nonatomic, strong) DPCalendarMonthlyView *monthlyView;

@end
