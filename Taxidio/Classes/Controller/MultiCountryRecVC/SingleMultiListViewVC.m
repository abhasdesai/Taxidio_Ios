//
//  SingleMultiListViewVC.m
//  Taxidio
//
//  Created by E-Intelligence on 10/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "SingleMultiListViewVC.h"

@interface SingleMultiListViewVC ()

@end

@implementation SingleMultiListViewVC

@synthesize arrDataSingleCountry,arrDataMultiCountry,arrDataForCountrySelected,strCountryName,strInfo,arrCountryDataForOptSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.


    borderMulti.backgroundColor = [UIColor clearColor];
    borderSingle.backgroundColor = [UIColor clearColor];

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:14], NSFontAttributeName,
                                [UIColor darkGrayColor], NSForegroundColorAttributeName,
                                nil];
    [segmentSingleMulti setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [segmentSingleMulti setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];

    //    CGFloat width            = segmentSingleMulti.frame.size.width/2;
    //    CGFloat x                = segmentSingleMulti.selectedSegmentIndex * width;
    //    CGFloat y                = segmentSingleMulti.frame.size.height;// - bottomBorder.borderWidth;
    //
    //
    //    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(x+15, 0,width, y)];
    //    viewBG.backgroundColor = COLOR_ORANGE;
    //
    //    [segmentSingleMulti.layer addSublayer:viewBG];

    [bottomBorder removeFromSuperlayer];
    bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 0;

    CGFloat width            = segmentSingleMulti.frame.size.width/2;
    CGFloat x                = segmentSingleMulti.selectedSegmentIndex * width;
    CGFloat y                = segmentSingleMulti.frame.size.height;
    bottomBorder.backgroundColor = COLOR_ORANGE.CGColor;

    [segmentSingleMulti.layer addSublayer:bottomBorder];
    //    bottomBorder.frame       = CGRectMake(x+15, y,width-45, bottomBorder.borderWidth);

    bottomBorder.frame       = CGRectMake(x, 0,width, y);
    segmentSingleMulti.selectedSegmentIndex = 0;
    [self selectSegmentControl:nil];
    viewMainMultiCountry.hidden = TRUE;
    isSingleSelected = TRUE;
    index=0;
    lastIndexPath = -99;
    lblNoMultiData.layer.borderColor = [UIColor blackColor].CGColor;
    lblNoMultiData.layer.borderColor = [UIColor colorWithRed:52.0/255.0 green:75.0/255.0 blue:126.0/255.0 alpha:1.0].CGColor;

    lblNoMultiData.layer.borderWidth = 2;
    lblNoMultiData.clipsToBounds = true;

    lblNoSingleData.layer.borderColor = [UIColor blackColor].CGColor;
    lblNoSingleData.layer.borderWidth = 2;
    lblNoSingleData.clipsToBounds = true;
    
    [self loadData];
}

-(void)showWalkThrough
{
    // Setup coach marks
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //    [self checkLogin];
    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Helper setPREFint:0 :@"isFromAttractionListing"];
    viewNoMultiCountryData.hidden = true;
    viewNoSingleCountryData.hidden = true;
//    segmentSingleMulti.selectedSegmentIndex = 0;
    [self selectSegmentControl:nil];
}

-(void)loadData
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(
                                                        NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *folder = [path objectAtIndex:0];
    NSLog(@"Your NSUserDefaults are stored in this folder: %@/Preferences", folder);

    dictSignleCountryData = [[NSMutableDictionary alloc]init];
    dictSignleCountryData = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_SINGLE_COUNTRY_DATA];

    arrDataSingleCountry = [[NSArray alloc]init];
    arrDataSingleCountry = [dictSignleCountryData copy];
    _arrDataMultiCountryCityData = [[NSArray alloc]init];

    dictMultiCountryData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *dictDataMultiCity =  [[NSMutableDictionary alloc]init];
    dictMultiCountryData = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_MULTI_COUNTRY_DATA];
    dictDataMultiCity = [dictMultiCountryData valueForKey:@"countries"];

    _arrDataMultiCountryCityData = [dictDataMultiCity copy];
    dictMultiCountryData  = [dictMultiCountryData valueForKey:@"combinations"];

    arrDataMultiCountry = [dictMultiCountryData copy];
    //[tblView reloadData];
}

- (IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if(isSingleSelected==TRUE)
        return arrDataSingleCountry.count;
    else
        return arrDataMultiCountry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSingleSelected==TRUE)
    {
        static NSString *cellIdentifier = @"cellSingleCountry";
        cellSingleCountry *cell = (cellSingleCountry *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[cellSingleCountry alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[[arrDataSingleCountry valueForKey:@"countryimage"]objectAtIndex:indexPath.row]]];

        cell.tag = indexPath.row;
        cell.imgViewCountry.image = [UIImage imageNamed:@"Image_Loading"];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.imgViewCountry.image = image;
                        });
                    }
                }
                else
                {
                    cell.imgViewCountry.image = [UIImage imageNamed:@"Image_Loading"];
                }
            }];
            [task resume];
        });
        cell.lblCountryName.text = [[[arrDataSingleCountry valueForKey:@"country_name"]objectAtIndex:indexPath.row]mutableCopy];
        cell.btnExplore.tag = indexPath.row;
        cell.btnInfo.tag = indexPath.row;
        cell.btnView.tag = indexPath.row;

        [cell.btnExplore addTarget:self action:@selector(pressExploreCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnInfo addTarget:self action:@selector(pressInfoCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnView addTarget:self action:@selector(pressViewCountry:) forControlEvents:UIControlEventTouchUpInside];

        
        BOOL walkthroughSingle = [[NSUserDefaults standardUserDefaults] boolForKey: @"walkthroughSingle"];

        if(indexPath.row==0 && repeatCnt==0 && (!walkthroughSingle))
        {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            CGFloat topPadding = window.safeAreaInsets.top;
            if(topPadding>0)
                topPadding = topPadding - 20;

            [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"walkthroughSingle"];
            repeatCnt++;
            CGRect coachmarkbtnInfo = CGRectMake(tblView.frame.origin.x+15+ cell.btnInfo.frame.origin.x, tblView.frame.origin.y+120+topPadding + 20, cell.btnInfo.frame.size.width, cell.btnInfo.frame.size.height);
            CGRect coachmarkbtnView = CGRectMake(tblView.frame.origin.x+15, tblView.frame.origin.y+120+topPadding+cell.frame.size.height - 35, cell.btnView.frame.size.width, cell.btnView.frame.size.height);
            CGRect coachmarkbtnExplore = CGRectMake(tblView.frame.origin.x +15 + cell.btnExplore.frame.origin.x, tblView.frame.origin.y+120+topPadding+cell.frame.size.height - 35, cell.btnExplore.frame.size.width, cell.btnExplore.frame.size.height);

            // Setup coach marks
            NSArray *coachMarks = @[
                                    @{
                                        @"rect": [NSValue valueWithCGRect:coachmarkbtnInfo],
                                        @"caption": @"Glance through the country information",
                                        @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
//                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                        @"showArrow":[NSNumber numberWithBool:YES]
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:coachmarkbtnView],
                                        @"caption": @"View cities and attractions in the selected country",
                                        @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
//                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                        @"showArrow":[NSNumber numberWithBool:YES]
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:coachmarkbtnExplore],
                                        @"caption": @"Explore the country",
                                        @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
//                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                        @"showArrow":[NSNumber numberWithBool:YES]
                                        }
                                    ];
            MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
            [self.view addSubview:coachMarksView];
            [coachMarksView start];
        }

        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"cellMultiCountry";

        cellMultiCountry *cell = (cellMultiCountry *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell == nil) {
            cell = [[cellMultiCountry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }

        UIView *tempUIView=[[UIView alloc]initWithFrame:cell.viewInnerView.bounds];
        tempUIView.backgroundColor=[UIColor colorWithRed:40.0/256.0 green:43.0/256.0 blue:76.0/256.0 alpha:1.0];

        NSArray *arrDataForRecommendation = [[NSArray alloc]init];
        arrDataForRecommendation = [[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:indexPath.row];

//        if(isLastIndexPath==TRUE)
//            cell.btnNext.hidden = TRUE;
//        else
//            cell.btnNext.hidden = FALSE;
//
//        if(isFirstIndexPath==TRUE)
//            cell.btnPrevious.hidden = TRUE;
//        else
//            cell.btnPrevious.hidden = FALSE;
        
        if(isNext==FALSE && isPrevious==FALSE)
            index = 0;

        if((isNext==TRUE && (arrDataForRecommendation.count>index+1))&& (isPrevious==FALSE))
            index++;

        if((isPrevious==TRUE && (index>0))&& isNext==FALSE)
            index--;
        
        if(intFirstIndex==0 || index==0)
            cell.btnPrevious.hidden = true;
        else
            cell.btnPrevious.hidden = false;
        
        if(intLastIndex==1 || index<arrDataForRecommendation.count-1)
            cell.btnNext.hidden = FALSE;
        else
            cell.btnNext.hidden = true;

        cell.lblRecoTitle.text = [NSString stringWithFormat:@"Recommendation %ld",indexPath.row+1];
        cell.lblCountryName.text = [[arrDataForRecommendation valueForKey:@"country_name"] objectAtIndex:index];
        cell.lblCountryName.text = [[arrDataForRecommendation valueForKey:@"country_name"] objectAtIndex:index];

        NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[[arrDataForRecommendation valueForKey:@"countryimage"] objectAtIndex:index]];
        strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:strurl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.imgViewCountry.image = image;
                        });
                    }
                }
                else
                {
                    cell.imgViewCountry.image = [UIImage imageNamed:@"Image_Loading"];
                }
            }];
            [task resume];
        });

        cell.btnExplore.tag = indexPath.row;
        [cell.btnExplore.layer setValue:[NSString stringWithFormat:@"%d",index] forKey:@"innerTag"];

        cell.btnInfo.tag = indexPath.row;
        [cell.btnInfo.layer setValue:[NSString stringWithFormat:@"%d",index] forKey:@"innerTag"];

        cell.btnView.tag = indexPath.row;
        [cell.btnView.layer setValue:[NSString stringWithFormat:@"%d",index] forKey:@"innerTag"];

        cell.btnNext.tag = indexPath.row;
        [cell.btnNext.layer setValue:[NSString stringWithFormat:@"%d",index] forKey:@"innerTag"];

        cell.btnPrevious.tag = indexPath.row;
        [cell.btnPrevious.layer setValue:[NSString stringWithFormat:@"%d",index] forKey:@"innerTag"];

        [cell.btnExplore addTarget:self action:@selector(pressExploreCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnInfo addTarget:self action:@selector(pressInfoCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnView addTarget:self action:@selector(pressViewCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnNext addTarget:self action:@selector(pressNextCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPrevious addTarget:self action:@selector(pressPreviousCountry:) forControlEvents:UIControlEventTouchUpInside];

        //[cell.btnNext addTarget:self action:@selector(pressInfoCountry:) forControlEvents:UIControlEventTouchUpInside];
        isNext = FALSE;
        isPrevious = FALSE;
        
        int intGap = 0;
        CGRect screenRect;
        CGFloat screenHeight;
        
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;

        if(screenHeight == 480 || screenHeight == 568)
        {
            intGap = 0;
        }
        else
        {
            intGap = 15;
        }
        
        BOOL walkthroughMulti = [[NSUserDefaults standardUserDefaults] boolForKey: @"walkthroughMulti"];
        
        if(indexPath.row==0 && repeatCnt==0 && (!walkthroughMulti))
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"walkthroughMulti"];
            repeatCnt++;
            
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            CGFloat topPadding = window.safeAreaInsets.top;
            if(topPadding>0)
                topPadding = topPadding - 20;

            CGRect coachmarkbtnInfo = CGRectMake(tblMultiCountryView.frame.origin.x+intGap+ cell.btnInfo.frame.origin.x, tblMultiCountryView.frame.origin.y+20+topPadding+viewHeader.frame.size.height + viewTab.frame.size.height + 20, cell.btnInfo.frame.size.width, cell.btnInfo.frame.size.height);
            CGRect coachmarkbtnView = CGRectMake(tblMultiCountryView.frame.origin.x+intGap, tblMultiCountryView.frame.origin.y+20+topPadding+viewHeader.frame.size.height + viewTab.frame.size.height +cell.frame.size.height - 35, cell.btnView.frame.size.width, cell.btnView.frame.size.height);
            CGRect coachmarkbtnExplore = CGRectMake(tblMultiCountryView.frame.origin.x +intGap + cell.btnExplore.frame.origin.x, tblMultiCountryView.frame.origin.y+20+topPadding+viewHeader.frame.size.height + viewTab.frame.size.height+cell.frame.size.height - 35, cell.btnExplore.frame.size.width, cell.btnExplore.frame.size.height);

            CGRect coachmarkbtnNext = CGRectMake(tblMultiCountryView.frame.origin.x +intGap + cell.btnNext.frame.origin.x, tblMultiCountryView.frame.origin.y+120+topPadding+cell.btnNext.frame.origin.y+15, cell.btnNext.frame.size.width, cell.btnNext.frame.size.height);

            // Setup coach marks
            NSArray *coachMarks = @[
                                    @{
                                        @"rect": [NSValue valueWithCGRect:coachmarkbtnInfo],
                                        @"caption": @"Glance through the country information",
                                        @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                        //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                        @"showArrow":[NSNumber numberWithBool:YES]
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:coachmarkbtnView],
                                        @"caption": @"View cities and attractions in the selected country",
                                        @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                                        //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                        @"showArrow":[NSNumber numberWithBool:YES]
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:coachmarkbtnExplore],
                                        @"caption": @"Explore the country",
                                        @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                        //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                        @"showArrow":[NSNumber numberWithBool:YES]
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:coachmarkbtnNext],
                                        @"caption": @"Tap the button to view the other recommended countries",
                                        @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                        @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT],
                                        @"showArrow":[NSNumber numberWithBool:YES]
                                        }
                                    ];
            MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
            [self.view addSubview:coachMarksView];
            [coachMarksView start];
        }

        return cell;
    }
    return 0;
}

-(IBAction)pressNextCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    if(lastIndexPath==i)
    {
        isLastIndexPath = TRUE;
    }
    else
    {
        lastIndexPath = (int)i;
        isLastIndexPath = FALSE;
    }
    
    if(i>=0)
        intFirstIndex = 1;
    else
        intFirstIndex = 0;

    isNext = TRUE;
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
    [tblMultiCountryView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

-(IBAction)pressPreviousCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);

    if(firstIndexParh==i)
    {
        isFirstIndexPath = FALSE;
    }
    else
    {
        firstIndexParh = (int)i;
        isFirstIndexPath = TRUE;
    }
    if(lastIndexPath==(i-1))
        intLastIndex = 1;
    else
        intLastIndex = 0;
    isPrevious = TRUE;
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
    [tblMultiCountryView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

-(IBAction)pressExploreCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);

    if(isSingleSelected==TRUE)
    {
        self.arrDataForCountrySelected = [[NSMutableArray alloc]init];
        self.arrDataForCountrySelected = [arrDataSingleCountry objectAtIndex:i];
        self.strCountryName = [[arrDataSingleCountry valueForKey:@"country_name"]objectAtIndex:i];
        strInfo = [[arrDataSingleCountry valueForKey:@"country_conclusion"]objectAtIndex:i];
    }
    else
    {
        NSString *str = [button.layer valueForKey:@"innerTag"];
        int indexforinnerTag = [str intValue];

        self.arrDataForCountrySelected = [[NSMutableArray alloc]init];
        self.arrCountryDataForOptSelected = [[NSMutableArray alloc]init];
        self.arrCountryDataForOptSelected = [[arrDataMultiCountry objectAtIndex:i]valueForKey:@"recommendation"];

        for(int i=0;i<_arrDataMultiCountryCityData.count;i++)
        {
            for(int j=0;j<self.arrCountryDataForOptSelected.count;j++)
            {
                if([[[self.arrCountryDataForOptSelected valueForKey:@"country_id"]objectAtIndex:j]isEqualToString:[[_arrDataMultiCountryCityData valueForKey:@"country_id"] objectAtIndex:i]])
                {
                    [self.arrDataForCountrySelected addObject:[_arrDataMultiCountryCityData objectAtIndex:i]];
                }
            }
        }

        self.strCountryName =[[[[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:i]valueForKey:@"country_name"] objectAtIndex:indexforinnerTag];
        strInfo = [[[[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:i]valueForKey:@"country_conclusion"] objectAtIndex:indexforinnerTag];
    }
    [self performSegueWithIdentifier:@"segueExploreCity" sender:self];
}

-(IBAction)pressViewCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);

    if(isSingleSelected==TRUE)
    {
        self.arrDataForCountrySelected = [[NSMutableArray alloc]init];
        self.arrDataForCountrySelected = [arrDataSingleCountry objectAtIndex:i];
    }
    else
    {
//        NSString *str = [button.layer valueForKey:@"innerTag"];
//        int indexforinnerTag = [str intValue];
//
//        strInfo = [[[[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:i]valueForKey:@"country_conclusion"] objectAtIndex:indexforinnerTag];

        
        NSString *str = [button.layer valueForKey:@"innerTag"];
        int indexforinnerTag = [str intValue];

        //self.arrDataForCountrySelected = [[NSMutableArray alloc]init];
        NSString *country_id = [[[[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:i]valueForKey:@"countryid"]objectAtIndex:indexforinnerTag];

        self.arrDataForCountrySelected = [[NSMutableArray alloc]init];

        for(int i=0;i<_arrDataMultiCountryCityData.count;i++)
        {
            if([[[_arrDataMultiCountryCityData valueForKey:@"country_id"]objectAtIndex:i] isEqualToString:country_id])
            {
                self.arrDataForCountrySelected = [_arrDataMultiCountryCityData objectAtIndex:i];
//                strMultiTimeToReach = [[[[arrDataMultiCountry valueForKey:@"recommendation"] objectAtIndex:i]objectAtIndex:0]valueForKey:@"timetoreach"];
            }
        }
//        for(int i=0;i<arrDataMultiCountry.count;i++)
        {
            if([[[[[arrDataMultiCountry valueForKey:@"recommendation"] objectAtIndex:i]objectAtIndex:indexforinnerTag]valueForKey:@"country_id"]isEqualToString:country_id])
            {
                strMultiTimeToReach = [[[[arrDataMultiCountry valueForKey:@"recommendation"] objectAtIndex:i]objectAtIndex:0]valueForKey:@"timetoreach"];
            }
        }
    }
    [self performSegueWithIdentifier:@"segueViewCity" sender:self];
}

-(IBAction)pressInfoCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);

    if(isSingleSelected==TRUE)
    {
        strInfo = [[arrDataSingleCountry valueForKey:@"country_conclusion"]objectAtIndex:i];
        self.strCountryName = [[arrDataSingleCountry valueForKey:@"country_name"]objectAtIndex:i];
    }
    else
    {
        NSString *str = [button.layer valueForKey:@"innerTag"];
        int indexforinnerTag = [str intValue];

        strInfo = [[[[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:i]valueForKey:@"country_conclusion"] objectAtIndex:indexforinnerTag];
        self.strCountryName =[[[[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:i]valueForKey:@"country_name"] objectAtIndex:indexforinnerTag];
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:[NSString stringWithFormat:@"About %@",self.strCountryName]
                                  message:strInfo
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SEGMENT CONTROL METHOD

- (IBAction)selectSegmentControl:(id)sender
{
    [bottomBorder removeFromSuperlayer];
    bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 0;
    repeatCnt = 0;

    CGFloat width            = segmentSingleMulti.frame.size.width/2;
    CGFloat x                = segmentSingleMulti.selectedSegmentIndex * width;
    CGFloat y                = segmentSingleMulti.frame.size.height;// - bottomBorder.borderWidth;
    bottomBorder.backgroundColor = COLOR_ORANGE.CGColor;

    [segmentSingleMulti.layer addSublayer:bottomBorder];
    //    bottomBorder.frame       = CGRectMake(x+15, y,width-45, bottomBorder.borderWidth);
    bottomBorder.frame       = CGRectMake(0, 0,width, y);

    if (segmentSingleMulti.selectedSegmentIndex == 0)
    {
        [segmentSingleMulti.layer addSublayer:bottomBorder];
        bottomBorder.frame       = CGRectMake(x, 0,width, y);
        segmentSingleMulti.hidden = FALSE;
        viewMainMultiCountry.hidden = TRUE;
        viewMain.hidden = FALSE;
        isSingleSelected = TRUE;
        if(arrDataSingleCountry.count>0)
        {
            [tblView reloadData];
            viewNoSingleCountryData.hidden = true;
            tblView.hidden = FALSE;
        }
        else
        {
            tblView.hidden = true;
            viewNoSingleCountryData.hidden = FALSE;
        }
    }
    else if(segmentSingleMulti.selectedSegmentIndex == 1)
    {
        [segmentSingleMulti.layer addSublayer:bottomBorder];
        bottomBorder.frame       = CGRectMake(x, 0,width, y);
        viewMainMultiCountry.hidden = FALSE;
        viewMain.hidden = TRUE;
        isSingleSelected = FALSE;
        if(arrDataMultiCountry.count>0)
        {
            [tblMultiCountryView reloadData];
            viewNoMultiCountryData.hidden = true;
            tblMultiCountryView.hidden = FALSE;
        }
        else
        {
            viewNoMultiCountryData.hidden = FALSE;
            tblMultiCountryView.hidden = TRUE;
        }
        isNext = FALSE;
    }
}

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueViewCity"])
    {
        CityListViewVC *detail = (CityListViewVC *)[segue destinationViewController];
        detail.arrCountryData = self.arrDataForCountrySelected;
        detail.strTimeToReach = strMultiTimeToReach;
        detail.isSingleSelected = isSingleSelected;
    }
    if([[segue identifier] isEqualToString:@"segueExploreCity"])
    {
        CitySwipeViewVC *detail = (CitySwipeViewVC *)[segue destinationViewController];
        detail.arrData = self.arrDataForCountrySelected;
        detail.arrCountryDataForOptSelected = self.arrCountryDataForOptSelected;
        
        if(isSingleSelected==true)
            detail.strTripType = @"1";
        else
            detail.strTripType = @"2";
        detail.isSingleSelected = isSingleSelected;
    }
}

@end

