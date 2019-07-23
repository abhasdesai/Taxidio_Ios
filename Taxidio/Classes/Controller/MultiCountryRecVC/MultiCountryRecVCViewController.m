//
//  MultiCountryRecVCViewController.m
//  Taxidio
//
//  Created by E-Intelligence on 26/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "MultiCountryRecVCViewController.h"

@interface MultiCountryRecVCViewController ()

@end

@implementation MultiCountryRecVCViewController
@synthesize arrDataSingleCountry,arrDataMultiCountry,arrDataForCountrySelected,strCountryName,strInfo,arrCountryDataForOptSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
    
    
    borderMulti.backgroundColor = [UIColor clearColor];
    borderSingle.backgroundColor = [UIColor clearColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:14], NSFontAttributeName,
                                [UIColor grayColor], NSForegroundColorAttributeName,
                                nil];
    [segmentSingleMulti setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
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
    bottomBorder.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:1.0].CGColor;
    
    [segmentSingleMulti.layer addSublayer:bottomBorder];
//    bottomBorder.frame       = CGRectMake(x+15, y,width-45, bottomBorder.borderWidth);
    
    bottomBorder.frame       = CGRectMake(x, 0,width, y);
    segmentSingleMulti.selectedSegmentIndex = 0;
    [self selectSegmentControl:nil];
    viewMainMultiCountry.hidden = TRUE;
    isSingleSelected = TRUE;
    [self loadData];
    index=0;
    lastIndexPath = -99;
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
        [tblView reloadData];
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
            cell = [[cellSingleCountry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[[arrDataSingleCountry valueForKey:@"countryimage"]objectAtIndex:indexPath.row]]];
        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(qLogo, ^{
            /* Fetch the image from the server... */
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if(data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    /* This is the main thread again, where we set the tableView's image to
                     be what we just fetched. */
                    cell.imgViewCountry.image = img;
                });
            }
        });
        
        cell.lblCountryName.text = [[[arrDataSingleCountry valueForKey:@"country_name"]objectAtIndex:indexPath.row]mutableCopy];
        cell.btnExplore.tag = indexPath.row;
        cell.btnInfo.tag = indexPath.row;
        cell.btnView.tag = indexPath.row;
        
        [cell.btnExplore addTarget:self action:@selector(pressExploreCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnInfo addTarget:self action:@selector(pressInfoCountry:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnView addTarget:self action:@selector(pressViewCountry:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"cellMultiCountry";
        
        cellMultiCountry *cell = (cellMultiCountry *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[cellMultiCountry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
//        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pressNextCountry:)];
//        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
//        [cell.contentView addGestureRecognizer:swipeleft];
//        
//        UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pressPreviousCountry:)];
//        swiperight.direction=UISwipeGestureRecognizerDirectionRight;
//        [cell.contentView addGestureRecognizer:swiperight];
//        cell.btnPrevious.hidden = TRUE;

        UIView *tempUIView=[[UIView alloc]initWithFrame:cell.viewInnerView.bounds];
        tempUIView.backgroundColor=[UIColor colorWithRed:40.0/256.0 green:43.0/256.0 blue:76.0/256.0 alpha:1.0];
        
        NSArray *arrDataForRecommendation = [[NSArray alloc]init];
        arrDataForRecommendation = [[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:indexPath.row];
        
        if(isNext==FALSE && isPrevious==FALSE)
            index = 0;
        
        if(isLastIndexPath==FALSE && isFirstIndexPath==FALSE)
            index = 0;
        
        if((isNext==TRUE && (arrDataForRecommendation.count>index+1))&& (isPrevious==FALSE))
            index++;

        if((isPrevious==TRUE && (index>0))&& isNext==FALSE)
            index--;

//        if(isPrevious==FALSE && isNext == FALSE)
//            index = 0;
//        
//        if(isFirstIndexPath==FALSE && isLastIndexPath==TRUE)
//            index = 0;
//        
//        if(isPrevious==TRUE && (index>1))
//            index--;

        cell.lblRecoTitle.text = [NSString stringWithFormat:@"Recommendation %ld",indexPath.row+1];

        cell.lblCountryName.text = [[arrDataForRecommendation valueForKey:@"country_name"] objectAtIndex:index];
        cell.lblCountryName.text = [[arrDataForRecommendation valueForKey:@"country_name"] objectAtIndex:index];
        
        NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[[arrDataForRecommendation valueForKey:@"countryimage"] objectAtIndex:index]];
        strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:strurl];
        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(qLogo, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if(data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imgViewCountry.image = img;
                });
            }
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
        NSString *str = [button.layer valueForKey:@"innerTag"];
        int indexforinnerTag = [str intValue];
        
        self.arrDataForCountrySelected = [[NSMutableArray alloc]init];
        NSString *country_id = [[[[arrDataMultiCountry valueForKey:@"recommendation"]objectAtIndex:i]objectAtIndex:indexforinnerTag]valueForKey:@"countryid"];
        
        self.arrDataForCountrySelected = [[NSMutableArray alloc]init];

        for(int i=0;i<_arrDataMultiCountryCityData.count;i++)
        {
            if([[[_arrDataMultiCountryCityData valueForKey:@"country_id"]objectAtIndex:i] isEqualToString:country_id])
            {
                self.arrDataForCountrySelected = [_arrDataMultiCountryCityData objectAtIndex:i];
                strMultiTimeToReach = [[[[arrDataMultiCountry valueForKey:@"recommendation"] objectAtIndex:i]valueForKey:@"timetoreach"]objectAtIndex:0];
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
    
    CGFloat width            = segmentSingleMulti.frame.size.width/2;
    CGFloat x                = segmentSingleMulti.selectedSegmentIndex * width;
    CGFloat y                = segmentSingleMulti.frame.size.height;// - bottomBorder.borderWidth;
    bottomBorder.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:1.0 ].CGColor;
    
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
        [tblView reloadData];
    }
    else if(segmentSingleMulti.selectedSegmentIndex == 1)
    {
        [segmentSingleMulti.layer addSublayer:bottomBorder];
        bottomBorder.frame       = CGRectMake(x, 0,width, y);
         viewMainMultiCountry.hidden = FALSE;
        viewMain.hidden = TRUE;
        isSingleSelected = FALSE;
        [tblMultiCountryView reloadData];
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
        detail.isSingleSelected = isSingleSelected;
    }
}

@end
