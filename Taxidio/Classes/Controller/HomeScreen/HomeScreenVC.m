//
//  HomeScreenVC.m
//  Taxidio
//
//  Created by E-Intelligence on 07/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "HomeScreenVC.h"
#import "AutocompletionTableView.h"

static CGFloat const kViewControllerRangeSliderWidth = 290.0;
//static CGFloat const kViewControllerLabelWidth = 100.0;

@interface HomeScreenVC ()

@end

@implementation HomeScreenVC

@synthesize autoCompleter = _autoCompleter;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFontColor];
    viewChooseDestinations.hidden = YES;
    CGFloat viewWidth = CGRectGetWidth(viewSearch.frame);
    
    segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"FIND ME A DESTINATION", @"I WANT TO TRAVEL TO"]];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 0, viewWidth, 50);
    //segmentedControl1.frame = CGRectMake(0, 60, viewWidth, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl1.selectionIndicatorBoxColor = COLOR_ORANGE_SEGMENT;
    segmentedControl1.selectionIndicatorBoxOpacity = 1.0;
    segmentedControl1.backgroundColor = [UIColor lightGrayColor];
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    segmentedControl1.verticalDividerEnabled = YES;
    
    if(screenHeight == 480 || screenHeight == 568)
        segmentedControl1.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],  NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:11]};
    else
        segmentedControl1.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],  NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14]};

    segmentedControl1.verticalDividerWidth = 1.0f;
//    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
//        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//        return attString;
//    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [viewSearchTab addSubview:segmentedControl1];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblDateDepartureTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [lblDateDeparture addGestureRecognizer:tapGestureRecognizer];
    lblDateDeparture.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblDateSearchTapped)];
    tapGestureRecognizerSearch.numberOfTapsRequired = 1;
    [lblDestiDepDate addGestureRecognizer:tapGestureRecognizerSearch];
    lblDestiDepDate.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblAccomodationTypeTapped)];
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [lblAccomodationType addGestureRecognizer:tapGestureRecognizer2];
    lblAccomodationType.userInteractionEnabled = YES;

    [bottomBorder removeFromSuperlayer];
    bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 0;
    
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    int firstRow = 0;
    int firstOptionIndex = 0;
    [pickerAccomodation selectRow:firstRow inComponent:firstOptionIndex animated:NO];
//    [pickerAccomodation selectRow:0 inComponent:0 animated:YES];

    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    btnBeginYourJourney.exclusiveTouch = TRUE;
    strAccoType = @"";
    strDateDep = @"";
    strSearchDate = @"";
    //[self selectSegmentControl:nil];
    
    arrDestination = [[NSMutableArray alloc]initWithObjects:
                      @"Archaeological",@"Architecture",@"Beach / Islands",@"Castles",@"Child Attraction",@"Community Tourism",@"Festivals & Culture",@"Food & Nightlife",@"High Altitude",@"History",@"Museum",
                      @"Nature / Ecotourism",@"Relaxation & Spa",@"Romance",@"Shopping",@"Spirituality & Religion",@"Sports & Adventure",@"Wildlife",@"World Heritage / UNESCO",@"Restricted Accessibility",Nil];
    
    arrDestinationSearch = [[NSMutableArray alloc]initWithObjects:
                            @"Archaeological",@"Architecture",@"Beach / Islands",@"Castles",@"Child Attraction",@"Community Tourism",@"Festivals & Culture",@"Food & Nightlife",@"High Altitude",@"History",@"Museum",
                            @"Nature / Ecotourism",@"Relaxation & Spa",@"Romance",@"Shopping",@"Spirituality & Religion",@"Sports & Adventure",@"Wildlife",@"World Heritage / UNESCO",@"Restricted Accessibility",Nil];
    sidebarMenuOpen = NO;
    
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
    
    BOOL walkthrough = [[NSUserDefaults standardUserDefaults] boolForKey: @"walkthrough"];
    if (!walkthrough) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"walkthrough"];
        [self showWalkThrough];
    }
}

-(void)showWalkThrough
{
    // Setup coach marks
    int setXUser = 0;
    int setYUser = 0;
    int setXMenu = 0;
    int setYMenu = 0;

    if(screenHeight == 480 || screenHeight == 568)
    {
        setXUser = btnUserMenu.frame.origin.x;
        setYUser = btnUserMenu.frame.origin.y+20;
        setXMenu = btnMenu.frame.origin.x;
        setYMenu = btnMenu.frame.origin.y+20;
    }
    else
    {
        setXUser = btnUserMenu.frame.origin.x;
        setYUser = btnUserMenu.frame.origin.y+20;
        setXMenu = btnMenu.frame.origin.x;
        setYMenu = btnMenu.frame.origin.y+20;
    }
    CGRect coachmarkbtnUserMenu = CGRectMake(setXUser,setYUser , btnUserMenu.frame.size.width, btnUserMenu.frame.size.height);
    CGRect coachmarkbtnMenu = CGRectMake(setXMenu,setYMenu, btnMenu.frame.size.width, btnMenu.frame.size.height);
    
    // Setup coach marks
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:coachmarkbtnUserMenu],
                                @"caption": @"Sign in to your account and manage your trips & profile.",
                                @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                //@"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                @"showArrow":[NSNumber numberWithBool:YES]
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:coachmarkbtnMenu],
                                @"caption": @"Explore different destinations, pre-planned itineraries and travel blogs",
                                @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_RIGHT_BOTTOM],
                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                @"showArrow":[NSNumber numberWithBool:YES]
                             }
                            ];
    MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    [self.view addSubview:coachMarksView];
    [coachMarksView start];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self checkLogin];
    //    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

-(void)checkLogin
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        [btnUserMenu addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        self.revealViewController.panGestureRecognizer.enabled = true;
    }
    else
    {
        [btnUserMenu addTarget:self action:@selector(showLoginPage:) forControlEvents:UIControlEventTouchUpInside];
        self.revealViewController.panGestureRecognizer.enabled = FALSE;
    }
}

-(IBAction)showLoginPage:(id)sender
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        [btnUserMenu addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    else
    {
        UIStoryboard* storyboard;
        if(screenHeight == 480 || screenHeight == 568)
            storyboard = [UIStoryboard storyboardWithName:@"Main_5s" bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SignInPage *add = [storyboard instantiateViewControllerWithIdentifier:@"SignInPage"];
        [self presentViewController:add animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   // [self checkLogin];
    [self loadAccomodationData];
    [self wsNewTripInvitePopUp];
    if([Helper getPREF:PREF_UID].length>0 && ([Helper getPREFint:@"askforemail"]==1))
    {
        [self wsCheckForEmail:[Helper getPREF:PREF_UID]];
    }
    segmentedControl1.selectedSegmentIndex = 0;
    
    [arrSelectedTags removeAllObjects];
    [arrSelectedTagsSearch removeAllObjects];

    isFromSearch = FALSE;
    [Helper setPREFint:0 :@"isFromViewItinerary"];

//    if([Helper getPREFint:@"askforemail"]==1)
//    {
//        CGRect screenRect;
//        CGFloat screenHeight;
//        CGFloat screenWidth;
//
//        screenRect = [[UIScreen mainScreen] bounds];
//        screenHeight = screenRect.size.height;
//        screenWidth = screenRect.size.width;
//
//        UIStoryboard* storyboard;
//        if(screenHeight == 480 || screenHeight == 568)
//            storyboard = [UIStoryboard storyboardWithName:@"Main_5s" bundle:nil];
//        else
//            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SignInPage *add = [storyboard instantiateViewControllerWithIdentifier:@"SignInPage"];
//        [self presentViewController:add animated:YES completion:nil];
//    }

    arrSelectedTags = [[NSMutableArray alloc]init];
    arrSelectedTagsSearch = [[NSMutableArray alloc]init];
    [self SetDestination];
    [self SetDestinationSearch];
    [self.switchInter setOn:TRUE];
    [self.switchDomestic setOn:FALSE];
    viewDatePicker.hidden = TRUE;
    viewPickerAccomodation.hidden = TRUE;
    [datePicker setMinimumDate: [NSDate date]];
    viewSearch.hidden = TRUE;
//    borderRecc.hidden = FALSE;
//    borderSearch.hidden = TRUE;
    viewRecommendation.hidden = FALSE;
    
    [txtStartingPoint addTarget:self action:@selector(textFieldDidChangePlaceSearch:) forControlEvents:UIControlEventEditingChanged];
    [txtDestination addTarget:self action:@selector(textFieldDidChangePlaceSearch:) forControlEvents:UIControlEventEditingChanged];
    strIsDomestic = @"0";
    
    isFromSearchData = FALSE;
    [Helper setPREFint:0 :@"isFromAttractionListing"];
}

-(void)showSearchTbl
{
    if (segmentedControl1.selectedSegmentIndex == 0 && arrNameStartingPoint.count>0)
    {
        [self.autoCompleter textFieldValueChanged:txtStartingPoint];
        _autoCompleter.hidden = FALSE;

        [txtStartingPoint addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    else if (segmentedControl1.selectedSegmentIndex == 1 && arrNamesDestination.count>0)
    {
        [self.autoCompleter textFieldValueChanged:txtDestination];
        _autoCompleter.hidden = FALSE;
        
        [txtDestination addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    else
    {
        _autoCompleter.hidden = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
    [self setBottomBorderTextField:txtStartingPoint];
    [self setBottomBorderTextField:txtDestination];
    [self setBottomBorderLabel:lblAccomodationType];
    [self setBottomBorderLabel:lblDateDeparture];
    [self setBottomBorderLabel:lblDestiDepDate];
    
    [self setBottomBorderView:viewStartingPoint];
    [self setBottomBorderView:viewSearchDesti];
//    [self setBottomBorderView:viewDomestic];
//    [self setBottomBorderView:viewInternational];
//    [self setBottomBorderView:viewDepartureDate];
//    [self setBottomBorderView:viewAccType];
//    [self setBottomBorderView:viewTravelTime];
//    [self setBottomBorderView:viewNoHrs];
//    [self setBottomBorderView:viewTemperature];
//    [self setBottomBorderView:viewBudgetNight];
//
//    [self setBottomBorderView:viewSearchDate];
//    [self setBottomBorderView:viewSearchNoDays];

    if(screenHeight == 480 || screenHeight == 568)
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.3)];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.1)];
    }
}

#pragma mark - FORMAT METHODS

-(void)setBottomBorder : (UITextField*) txtfield
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, txtfield.frame.size.height - 1, txtfield.frame.size.width, 5.0f);
    bottomBorder1.backgroundColor = [UIColor whiteColor].CGColor;
    [txtfield.layer addSublayer:bottomBorder1];
}

-(void)setFontColor
{
    txtDestination.delegate = self;
    txtStartingPoint.delegate = self;
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    CALayer *innerShadowOwnerLayer = [[CALayer alloc]init];
    innerShadowOwnerLayer.frame = CGRectMake(0, scrollDestinations.frame.size.height+2,self.view.frame.size.width, 5);
    innerShadowOwnerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    innerShadowOwnerLayer.shadowColor = [UIColor blackColor].CGColor;
    innerShadowOwnerLayer.shadowOffset = CGSizeMake(0,1);
    innerShadowOwnerLayer.shadowRadius = 10.0;
    innerShadowOwnerLayer.shadowOpacity = 2.5;
    
    [scrollDestinations.layer addSublayer:innerShadowOwnerLayer];
    [scrollSearchDesti.layer addSublayer:innerShadowOwnerLayer];
    [self setUpViewComponents];
    
    txtStartingPoint.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Starting Point" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txtDestination.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Destination" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

//    UIView *bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, btnRecommendation.frame.size.height - 10.0f, btnRecommendation.frame.size.width, 3)];
//    bottomBorder1.backgroundColor = [UIColor orangeColor];
//    [viewButtons addSubview:bottomBorder1];
    
}

-(void)setBottomBorderLabel : (UILabel*)label
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, label.frame.size.height +1, label.frame.size.width, 1);
    bottomBorder1.backgroundColor = [UIColor whiteColor].CGColor;
    [label.layer addSublayer:bottomBorder1];
}

-(void)setBottomBorderTextField : (UITextField*)txtField
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, txtField.frame.size.height +2  , txtField.frame.size.width, 1);
    bottomBorder1.backgroundColor = [UIColor whiteColor].CGColor;
    [txtField.layer addSublayer:bottomBorder1];
}

-(void)setBottomBorderView : (UIView*) view1
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(15.0f, view1.frame.size.height - 1, view1.frame.size.width-30, 1.0f);
    bottomBorder1.backgroundColor = [UIColor clearColor].CGColor;
    [view1.layer addSublayer:bottomBorder1];
}

#pragma mark - UITEXTFIELD METHODS

-(void)dismissKeyboard
{
    [txtDestination resignFirstResponder];
    [txtStartingPoint resignFirstResponder];
    viewDatePicker.hidden = TRUE;
    viewPickerAccomodation.hidden = TRUE;
    _autoCompleter.hidden = TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [txtStartingPoint resignFirstResponder];
    [txtDestination resignFirstResponder];
    return YES;
}

#pragma mark - DESTINATION SCROLL METHODS

-(void)SetDestination
{
    [allcollectionView reloadData];
}

#pragma mark - CollectionView Method ===

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(isFromSearch == FALSE)
        return arrDestination.count;
    else if(isFromSearch == TRUE)
        return arrDestinationSearch.count;
    else
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DestinationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imgDestination.image = [UIImage imageNamed:@"Image_Loading"];
    
    NSString *strimge;
    NSString *strTitle;

    if(isFromSearch == FALSE)
    {
        strimge = [NSString stringWithFormat:@"%@.jpg",[arrDestination objectAtIndex:indexPath.row]];
        strTitle = [arrDestination objectAtIndex:indexPath.row];
    }
    else
    {
        strimge = [NSString stringWithFormat:@"%@.jpg",[arrDestinationSearch objectAtIndex:indexPath.row]];
        strTitle = [arrDestinationSearch objectAtIndex:indexPath.row];
    }
    strimge = [strimge stringByReplacingOccurrencesOfString:@"/" withString:@":"];
    cell.imgDestination.image = [UIImage imageNamed:strimge];
    
    cell.lblDestination.text = strTitle;
    cell.lblDestination.textColor = [UIColor whiteColor];
    //cell.lblDestination.font = FONT_AVENIR_45_BOOK_SIZE_10;
    
    cell.imgDestination.layer.cornerRadius = 10;
    cell.imgDestination.clipsToBounds = YES;
    
    cell.viewBG.layer.cornerRadius = 10;
    cell.viewBG.clipsToBounds = YES;
    cell.btnViewCities.hidden = true;
    cell.layer.cornerRadius = 10;
    cell.clipsToBounds = YES;

    if(isFromSearch == FALSE)
    {
        if([arrSelectedTags containsObject:[arrDestination objectAtIndex:indexPath.row]])
        {
            cell.layer.borderWidth = 3;
            cell.layer.borderColor = COLOR_ORANGE.CGColor;
            cell.viewBG.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        }
        else
        {
            cell.layer.borderWidth = 3;
            cell.layer.borderColor = [UIColor grayColor].CGColor;
            cell.viewBG.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }
    }
    else
    {
        if([arrSelectedTagsSearch containsObject:[arrDestinationSearch objectAtIndex:indexPath.row]])
        {
            cell.layer.borderWidth = 3;
            cell.layer.borderColor = COLOR_ORANGE.CGColor;
            cell.viewBG.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        }
        else
        {
            cell.layer.borderWidth = 3;
            cell.layer.borderColor = [UIColor grayColor].CGColor;
            cell.viewBG.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }
    }
    
    BOOL walkthrough2 = [[NSUserDefaults standardUserDefaults] boolForKey: @"walkthrough2"];
    if(indexPath.row==0 && isFromSearch==FALSE && viewChooseDestinations.hidden == false && !walkthrough2)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"walkthrough2"];
        CGRect coachmarkbtnCity = CGRectMake(collectionView.frame.origin.x+ cell.viewBG.frame.origin.x, collectionView.frame.origin.y+120, cell.viewBG.frame.size.width, cell.viewBG.frame.size.height);
        
        NSArray *coachMarks = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkbtnCity],
                                    @"caption": @"You'll get recomendations based on parameters selected",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_BOTTOM],
                                    //@"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                    @"showArrow":[NSNumber numberWithBool:YES]
                                    }
                                ];
        NSArray *newArray;
        newArray =[coachMarks mutableCopy];
        
        MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.view.bounds coachMarks:newArray];
        
        coachMarksView.layer.cornerRadius = 10;
        coachMarksView.clipsToBounds = YES;

        [self.view addSubview:coachMarksView];
        [coachMarksView start];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(screenHeight == 480 || screenHeight == 568)
        return CGSizeMake(80,80);
    else
        return CGSizeMake(100,100);
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [allcollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(isFromSearch == FALSE)
    {
        NSString *strTagSelected = [arrDestination objectAtIndex:indexPath.row];
        
        if(![arrSelectedTags containsObject:strTagSelected])
            [arrSelectedTags addObject:strTagSelected];
        else
            [arrSelectedTags removeObject:strTagSelected];
        [self SetDestination];
    }
    else
    {
        NSString *strTagSelected = [arrDestinationSearch objectAtIndex:indexPath.row];
        
        if(![arrSelectedTagsSearch containsObject:strTagSelected])
            [arrSelectedTagsSearch addObject:strTagSelected];
        else
            [arrSelectedTagsSearch removeObject:strTagSelected];
        [self SetDestinationSearch];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(IBAction)pressAttractionTagPress:(id)sender
{
    NSInteger i;
    UIButton *currentButton = (UIButton *)sender;
    i= currentButton.tag;
    NSString *strTagSelected = [arrDestination objectAtIndex:i];
    
    if(![arrSelectedTags containsObject:strTagSelected])
       [arrSelectedTags addObject:strTagSelected];
    else
        [arrSelectedTags removeObject:strTagSelected];
    [self SetDestination];
}

-(IBAction)pressAttractionTagPressForSearch:(id)sender
{
    NSInteger i;
    UIButton *currentButton = (UIButton *)sender;
    i= currentButton.tag;
    NSString *strTagSelected = [arrDestinationSearch objectAtIndex:i];
    
    if(![arrSelectedTagsSearch containsObject:strTagSelected])
        [arrSelectedTagsSearch addObject:strTagSelected];
    else
        [arrSelectedTagsSearch removeObject:strTagSelected];
    [self SetDestinationSearch];
}

-(void)SetDestinationSearch
{
    [searchCollectionView reloadData];
}

#pragma mark - IBACTION METHODS

-(IBAction)pressNext:(id)sender
{
    if([self checkTheValidationToSaveForDestination] ==TRUE)
    {
        [UIView transitionWithView:viewChooseDestinations
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            viewChooseDestinations.hidden = NO;
                        }
                        completion:NULL];
        [self SetDestination];
    }
}

-(IBAction)pressPrevious:(id)sender
{
    [UIView transitionWithView:viewChooseDestinations
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        viewChooseDestinations.hidden = YES;
                    }
                    completion:NULL];
}

- (IBAction)pressMenu:(id)sender {
}

- (IBAction)pressProfileBtn:(id)sender {
    
}

- (IBAction)pressRecommendation:(id)sender
{
    viewRecommendation.hidden = FALSE;
    viewSearch.hidden = TRUE;
//    borderRecc.hidden = FALSE;
//    borderSearch.hidden = TRUE;
}

- (IBAction)pressSearchDestination :(id)sender
{
    //viewChooseDestinations.hidden = YES;

    viewRecommendation.hidden = TRUE;
    viewSearch.hidden = FALSE;
//    borderRecc.hidden = TRUE;
//    borderSearch.hidden = FALSE;
    if([self checkTheValidationToSaveForSearch] ==TRUE)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.tbl reloadData];
            [self setSearchDestinationData];
        });
    }
//  [self performSegueWithIdentifier:@"segueCountryRecc" sender:self];
}

- (IBAction)pressBeginJourney:(id)sender
{
    //viewChooseDestinations.hidden = YES;

    if(arrSelectedTags.count>0)
        strTags = [arrSelectedTags componentsJoinedByString:@","];
    else
        strTags = @"";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setFindMeDestinationData];
        });
//    [self performSegueWithIdentifier:@"segueCountryRecc" sender:self];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    viewChooseDestinations.hidden = true;
    _autoCompleter.hidden = TRUE;
    [arrSelectedTags removeAllObjects];
    [arrSelectedTagsSearch removeAllObjects];
    [arrNameStartingPoint removeAllObjects];
    strCountryCode = nil;
    //[self setUpViewComponents];
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        viewRecommendation.hidden = FALSE;
        viewSearch.hidden = TRUE;
        isFromSearch =FALSE;
        [self SetDestination];
        txtStartingPoint.text = @"";
        lblDateDeparture.text = @"Date of Departure";
        strDateDep = nil;

//        lblDestiDepDate.text = @"Date of Departure";
//        lblAccomodationType.text = @"Accomodation Type";
//        _lblbudget.text = @"$150 - $300";
//        _lblTravelTime.text = @"1 - 15";
//        _lblNoOfDays.text = @"1";
//        _lblTemperature.text = @"";
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    {
        viewRecommendation.hidden = TRUE;
        viewSearch.hidden = FALSE;
        isFromSearch =TRUE;
        [self SetDestinationSearch];
        txtDestination.text = @"";
        lblDestiDepDate.text =@"Date of Departure";
        strSearchDate =  nil;

//        lblDestiDepDate.text = @"";
//        _lblNoOfDaysSearch.text = @"";
    }
}

#pragma mark - UISLIDER METHODS

- (IBAction)setLabel:(UISlider *)sender
{
    int iVal = sender.value;
    self.lblNoOfDays.text = [NSString stringWithFormat:@"%d",iVal];
//    self.lblNoOfDays.text = [NSString stringWithFormat:@"%g", sender.value];
    [self updateRangeText];
}

- (IBAction)setLabelSearch:(UISlider *)sender
{
    int iVal = sender.value;
    if(iVal==32)
        self.lblNoOfDaysSearch.text = [NSString stringWithFormat:@"%d+",iVal];
    else
        self.lblNoOfDaysSearch.text = [NSString stringWithFormat:@"%d",iVal];
    [self updateRangeText];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat sliderXTemp = (CGRectGetWidth(viewTemperature.frame) - kViewControllerRangeSliderWidth) / 2;
    CGFloat sliderXTravel = (CGRectGetWidth(viewTravelTime.frame) - kViewControllerRangeSliderWidth) / 2;
    CGFloat sliderXBudget = (CGRectGetWidth(viewBudgetNight.frame) - kViewControllerRangeSliderWidth) / 2;
    
    if(screenHeight == 480 || screenHeight == 568)
    {
        self.lblTemperature.frame = CGRectMake(160, 5.0, 200, 20.0);
        self.lblTravelTime.frame = CGRectMake(160, 5.0, 200, 20.0);
        self.lblbudget.frame = CGRectMake(160, 5.0, 200, 20.0);
    }
    else
    {
        self.lblTemperature.frame = CGRectMake(180, 5.0, 200, 20.0);
        self.lblTravelTime.frame = CGRectMake(180, 15.0, 200, 20.0);
        self.lblbudget.frame = CGRectMake(180, 5.0, 200, 20.0);
        
        self.lblTemperature.font = FONT_AVENIR_45_BOOK_SIZE_19;
        self.lblTravelTime.font = FONT_AVENIR_45_BOOK_SIZE_19;
        self.lblbudget.font = FONT_AVENIR_45_BOOK_SIZE_19;
        self.lblNoOfDays.font = FONT_AVENIR_45_BOOK_SIZE_19;
        self.lblNoOfDaysSearch.font = FONT_AVENIR_45_BOOK_SIZE_19;
    }
    if(screenHeight == 480 || screenHeight == 568)
    {
        self.travelSlider.frame = CGRectMake(48, CGRectGetMaxY(self.lblTravelTime.frame)+20 , 260.0, 20.0);
        self.tempSlider.frame = CGRectMake(48, CGRectGetMaxY(self.lblTemperature.frame)+20 , 260.0, 20.0);
        self.budgetSlider.frame = CGRectMake(48, CGRectGetMaxY(self.lblbudget.frame)+20 , 260.0, 20.0);
    }
    else
    {
        self.travelSlider.frame = CGRectMake(sliderXTravel, CGRectGetMaxY(self.lblTravelTime.frame)+25 , 290.0, 20.0);
        self.tempSlider.frame = CGRectMake(sliderXTemp, CGRectGetMaxY(self.lblTemperature.frame)+20 , 290.0, 20.0);
        self.budgetSlider.frame = CGRectMake(sliderXBudget, CGRectGetMaxY(self.lblbudget.frame)+20 , 290.0, 20.0);
    }
}

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    [self updateRangeText];
}

- (void)setUpViewComponents
{
    //TEMPERATURE
    // Text label
    self.lblTemperature = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblTemperature.backgroundColor = [UIColor clearColor];
    self.lblTemperature.numberOfLines = 1;
    self.lblTemperature.textAlignment = NSTextAlignmentCenter;
    self.lblTemperature.textColor = [UIColor secondaryTextColor];
    
    // Init slider
    self.tempSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectZero];
    self.tempSlider.backgroundColor = [UIColor clearColor];
    [self.tempSlider addTarget:self
                        action:@selector(rangeSliderValueDidChange:)
              forControlEvents:UIControlEventValueChanged];
    
    [self.tempSlider setMinValue:-50.0 maxValue:50.0];
    [self.tempSlider setLeftValue:0.0 rightValue:20.0];
    
    self.tempSlider.minimumDistance = 5.0;
    
    [self updateRangeText];
    
    [viewTemperature addSubview:self.lblTemperature];
    [viewTemperature addSubview:self.tempSlider];
    
    //TRAVEL
    
    // Text label
    self.lblTravelTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblTravelTime.backgroundColor = [UIColor clearColor];
    self.lblTravelTime.numberOfLines = 1;
    self.lblTravelTime.textAlignment = NSTextAlignmentCenter;
    self.lblTravelTime.textColor = [UIColor secondaryTextColor];
    
    // Init slider
    self.travelSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectZero];
    self.travelSlider.backgroundColor = [UIColor clearColor];
    [self.travelSlider addTarget:self
                          action:@selector(rangeSliderValueDidChange:)
                forControlEvents:UIControlEventValueChanged];
    
    [self.travelSlider setMinValue:1.0 maxValue:35.0];
    [self.travelSlider setLeftValue:1.0 rightValue:15.0];
    
    self.travelSlider.minimumDistance = 5.0;
    
    [self updateRangeText];
    
    [viewTravelTime addSubview:self.lblTravelTime];
    [viewTravelTime addSubview:self.travelSlider];
    
    //BUDGET
    // Text label
    self.lblbudget = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblbudget.backgroundColor = [UIColor clearColor];
    self.lblbudget.numberOfLines = 1;
    self.lblbudget.textAlignment = NSTextAlignmentCenter;
    self.lblbudget.textColor = [UIColor secondaryTextColor];
    
    // Init slider
    self.budgetSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectZero];
    self.budgetSlider.backgroundColor = [UIColor clearColor];
    [self.budgetSlider addTarget:self
                          action:@selector(rangeSliderValueDidChange:)
                forControlEvents:UIControlEventValueChanged];
    
    [self.budgetSlider setMinValue:0.0 maxValue:500.0];
    [self.budgetSlider setLeftValue:150.0 rightValue:300.0];
    
    self.budgetSlider.minimumDistance = 75.0;
    [self updateRangeText];
    
    [viewBudgetNight addSubview:self.lblbudget];
    [viewBudgetNight addSubview:self.budgetSlider];
}

- (void)updateRangeText
{
    self.lblTemperature.text = [NSString stringWithFormat:@"%0.0f\u00b0c - %0.0f\u00b0c",
                                self.tempSlider.leftValue, self.tempSlider.rightValue];
    self.lblTravelTime.text = [NSString stringWithFormat:@"%0.0f - %0.0f",
                               self.travelSlider.leftValue, self.travelSlider.rightValue];
    self.lblbudget.text = [NSString stringWithFormat:@"$%0.0f - $%0.0f",
                           self.budgetSlider.leftValue, self.budgetSlider.rightValue];
    int iVal = self.noOfDaysSlider.value;
    self.lblNoOfDays.text = [NSString stringWithFormat:@"%d",iVal];
    int iVal1 = self.noOfDaysSliderSearch.value;
    
    if(iVal1==32)
        self.lblNoOfDaysSearch.text = [NSString stringWithFormat:@"%d+",iVal1];
    else
        self.lblNoOfDaysSearch.text = [NSString stringWithFormat:@"%d",iVal1];
    strSearchNoDays = [NSString stringWithFormat:@"%@",self.lblNoOfDaysSearch.text];

    strTemperature = [NSString stringWithFormat:@"%d-%d",(int)self.tempSlider.leftValue,(int)self.tempSlider.rightValue];
    strTravelTime = [NSString stringWithFormat:@"%d-%d",(int)self.travelSlider.leftValue,(int)self.travelSlider.rightValue];
    strBudget =[NSString stringWithFormat:@"%d-%d",(int)self.budgetSlider.leftValue,(int)self.budgetSlider.rightValue];
    strNoDays = [NSString stringWithFormat:@"%d",iVal];
   // strSearchNoDays = [NSString stringWithFormat:@"%d",iVal1];
}

#pragma mark - UISWITCH METHODS

- (IBAction) switchDOmesticPressed:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn])
    {
        NSLog(@"Domestic on!");
        [self.switchInter setOn:FALSE];
        [self.switchDomestic setOn:TRUE];
        strIsDomestic = @"1";
    }
    else
    {
        NSLog(@"Domestic off!");
        [self.switchInter setOn:TRUE];
        [self.switchDomestic setOn:FALSE];
        strIsDomestic = @"0";
    }
}

- (IBAction) switchInterPressed:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn])
    {
        NSLog(@"International on!");
        [self.switchInter setOn:TRUE];
        [self.switchDomestic setOn:FALSE];
        strIsDomestic = @"0";
    }
    else
    {
        NSLog(@"International off!");
        [self.switchInter setOn:FALSE];
        [self.switchDomestic setOn:TRUE];
        strIsDomestic = @"1";
    }
}

#pragma mark - DATEPICKER METHODS

-(void)lblDateDepartureTapped
{
    [txtDestination resignFirstResponder];
    [txtStartingPoint resignFirstResponder];
    [datePicker setDate:[NSDate date]];
    viewDatePicker.hidden = FALSE;
}

- (IBAction)onDatePickerValueChanged:(UIDatePicker *)datePicker1
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"dd/MM/YYYY"];
    lblDateDeparture.text = [dateFormat stringFromDate:datePicker.date];
    strDateDep = [dateFormat stringFromDate:datePicker.date];
}

-(void)lblDateSearchTapped
{
    [txtDestination resignFirstResponder];
    [txtStartingPoint resignFirstResponder];
    
    [datePicker setDate:[NSDate date]];
    viewDatePicker.hidden = FALSE;
}

- (IBAction)onDatePickerValueChangedSearch:(UIDatePicker *)datePicker1
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"dd/MM/YYYY"];
    lblDestiDepDate.text = [dateFormat stringFromDate:datePicker.date];
    strSearchDate =  [dateFormat stringFromDate:datePicker.date];
}

- (IBAction)pressDoneDatePicker:(id)sender
{
    if(isFromSearch==FALSE)//if(strDateDep.length==0 && isFromSearchData == FALSE)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setDateFormat:@"dd/MM/YYYY"];
        if([lblDateDeparture.text isEqualToString:@"Date of Departure"] || strDateDep.length==0)
            lblDateDeparture.text = [dateFormat stringFromDate:[NSDate date]];
        else
            lblDateDeparture.text = [dateFormat stringFromDate:datePicker.date];
        strDateDep =  lblDateDeparture.text;
    }
    else
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setDateFormat:@"dd/MM/YYYY"];
        
        if([lblDestiDepDate.text isEqualToString:@"Date of Departure"])
            lblDestiDepDate.text = [dateFormat stringFromDate:[NSDate date]];
        else
            lblDestiDepDate.text = [dateFormat stringFromDate:datePicker.date];

        strSearchDate =  lblDestiDepDate.text;
    }
    viewDatePicker.hidden = TRUE;
}

#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return arrAccomodation.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [[arrAccomodation valueForKey:@"accomodation_type"] objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lblAccomodationType.text = [NSString stringWithFormat:@"%@",[[arrAccomodation valueForKey:@"accomodation_type"] objectAtIndex:indexPath.row]];
    strAccoType = [NSString stringWithFormat:@"%@",[[arrAccomodation valueForKey:@"id"] objectAtIndex:indexPath.row]];
    viewPickerAccomodation.hidden = TRUE;
    
}

#pragma mark - Accomodation Picker Methods

-(void)lblAccomodationTypeTapped
{
    [txtDestination resignFirstResponder];
    [txtStartingPoint resignFirstResponder];

    if(arrAccomodation.count>0)
    {
    
        viewPickerAccomodation.hidden = FALSE;
        [tblAccomodationType reloadData];
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Something went wrong. Try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        [self loadAccomodationData];
    }
//    [pickerAccomodation selectRow:1 inComponent:0 animated:YES];
}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return 6;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString * title = nil;
//    
//    title = [[arrAccomodation valueForKey:@"accomodation_type"] objectAtIndex:row];
//    
//    return title;
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    lblAccomodationType.text = [NSString stringWithFormat:@"%@",[[arrAccomodation valueForKey:@"accomodation_type"] objectAtIndex:row]];
//    strAccoType = [NSString stringWithFormat:@"%@",[[arrAccomodation valueForKey:@"id"] objectAtIndex:row]];
//}
//
- (IBAction)pressDonePickerAccomodation:(id)sender
{
//    if(strAccoType.length==0)
//    {
//        lblAccomodationType.text = [NSString stringWithFormat:@"%@",[[arrAccomodation valueForKey:@"accomodation_type"] objectAtIndex:0]];
//        strAccoType = [NSString stringWithFormat:@"%@",[[arrAccomodation valueForKey:@"id"] objectAtIndex:0]];
//    }
    viewPickerAccomodation.hidden = TRUE;
}

#pragma mark - AutoCompleteTableViewDelegate

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        if (segmentedControl1.selectedSegmentIndex == 0)
        {
            NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
            [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
            [options setValue:nil forKey:ACOUseSourceFont];
            _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:txtStartingPoint inViewController:self withOptions:options];
            _autoCompleter.autoCompleteDelegate = self;
            _autoCompleter.suggestionsDictionary = [arrNameStartingPoint mutableCopy];
        }
        if(segmentedControl1.selectedSegmentIndex == 1)
        {
            NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
            [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
            [options setValue:nil forKey:ACOUseSourceFont];

            _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:txtDestination inViewController:self withOptions:options];
            _autoCompleter.autoCompleteDelegate = self;
            _autoCompleter.suggestionsDictionary = [arrNamesDestination mutableCopy];
        }
    }
    return _autoCompleter;
}

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string
{
        if (segmentedControl1.selectedSegmentIndex == 0 && arrNameStartingPoint.count>0)
        {
                return [arrNameStartingPoint valueForKey:@"longName"];
        }
        else if (segmentedControl1.selectedSegmentIndex == 1 && arrNamesDestination.count>0)
        {
            return [arrNamesDestination valueForKey:@"name"];
        }
    return 0;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (segmentedControl1.selectedSegmentIndex == 0)
    {
        if(arrNameStartingPoint.count>0)
        {
            NSLog(@"%@ - Suggestion chosen: %ld", completer, index);
            strCountryCode = [[arrNameStartingPoint valueForKey:@"countryCode"]objectAtIndex:index];
            strLocationSelected = [[arrNameStartingPoint valueForKey:@"longName"]objectAtIndex:index];
            txtStartingPoint.text = [[arrNameStartingPoint valueForKey:@"longName"]objectAtIndex:index];
        }
            [self dismissKeyboard];
        [arrNameStartingPoint removeAllObjects];
    }
    else if (segmentedControl1.selectedSegmentIndex == 1)
    {
        if(arrNamesDestination.count>0)
        {
            NSLog(@"%@ - Suggestion chosen: %ld", completer, index);
            txtDestination.text = [[arrNamesDestination valueForKey:@"name"]objectAtIndex:index];
        }
        [arrNamesDestination removeAllObjects];
        [self dismissKeyboard];
    }
    [self dismissKeyboard];
    self.autoCompleter.hidden = TRUE;
}

#pragma mark- ==== WebServiceMethod =======
-(void)setFindMeDestinationData
{

    @try{
        {
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),^{
                
                //[self performSegueWithIdentifier:@"segueCountryRecc" sender:self];
                //SHOW_AI;
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   strLocationSelected,@"start_city",
                                                   strNoDays,@"days",
                                                   strTravelTime,@"traveltime",
                                                   strTemperature,@"weather",
                                                   strAccoType,@"accomodation",
                                                   strBudget,@"budget",
                                                   strCountryCode,@"ocode",
                                                   strDateDep,@"start_date",
                                                   strIsDomestic,@"isdomestic",
                                                   strTags,@"tags",
                                                   nil];
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_RECOMMENDATION_COUNTRY dicParams:Parameters];
                double timestamp = [[NSDate date] timeIntervalSince1970];
                NSInteger intTimeStamp = timestamp;
                [Helper setPREF:[NSString stringWithFormat:@"%li",intTimeStamp] :@"strTokenId"];
            
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;

            
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_MULTI_COUNTRY_DATA];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_SINGLE_COUNTRY_DATA];

                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    //HIDE_AI;
                    NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
                    NSString *strMessage = [dicResponce objectForKey:@"message"];
                    self.wsStatus = intStatus;
                    if(strMessage.length==0)
                        strMessage = MSG_NO_MESSAGE;
                    
                    if(intStatus == 0)
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                        HIDE_AI;
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                    else
                    {
                        [Parameters setValue:[NSString stringWithFormat:@"[%@]",strTags] forKey:@"tags"];
                        [Parameters setValue:[NSString stringWithFormat:@"%li",intTimeStamp] forKey:@"token"];
                        NSError *error;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Parameters
                                                                           options:NSJSONWritingPrettyPrinted
                                                                             error:&error];
                        NSString *jsonString;
                        if (! jsonData) {
                            NSLog(@"Got an error: %@", error);
                        } else {
                            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        }
                        [Helper setPREF:jsonString :PREF_INPUT_SEARCH_DATA];

                        HIDE_AI;
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        _arrData = nil;
//                        _arrData = [dicResponce valueForKey:@"data"];
                        if([strIsDomestic isEqualToString:@"1"])
                        {
                            dictSearchData = [dicResponce valueForKey:@"data"];
                            dictSearchData = [dictSearchData valueForKey:@"domesticCities"];
                            //[Helper setPREFDict:dictSearchData :@"DomesticData"];
                            [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
                        }
                        else
                        {
                            
                            NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                            dicResponce = [dict mutableCopy];
                            dict = nil;

                            NSMutableDictionary *dictSingleCountry = [[NSMutableDictionary alloc]init];
                            dictSingleCountry = [dicResponce valueForKey:@"data"];
                            dictSingleCountry = [dictSingleCountry valueForKey:@"singalcountries"];
                            [Helper setPREFDict:dictSingleCountry :PREF_SINGLE_COUNTRY_DATA];
                            
                            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
                            
                            NSArray *path = NSSearchPathForDirectoriesInDomains(
                                                                                NSLibraryDirectory, NSUserDomainMask, YES);
                            NSString *folder = [path objectAtIndex:0];
                            NSLog(@"Your NSUserDefaults are stored in this folder: %@/Preferences", folder);
                            
                            NSMutableDictionary *dictMultiCountry = [[NSMutableDictionary alloc]init];
                            dictMultiCountry = [dicResponce valueForKey:@"data"];
                            dictMultiCountry = [dictMultiCountry valueForKey:@"multicountries"];

                            //NSMutableString *str = [dictMultiCountry valueForKey:@"multicountries"];
                            
//                            if(str.length!=0)
                            {
                                NSString *strMultiData = [NSString stringWithFormat:@"%@",[dictMultiCountry valueForKey:@"multicountries"]];
                                NSMutableDictionary *dictMutable = [[NSMutableDictionary alloc]init];
                                if (strMultiData == nil || [strMultiData isEqual:[NSNull null]] || [strMultiData isEqualToString:@"<null>"] || dictMultiCountry.count==0)
                                {
                                    NSLog(@"Multi country data is Null");
                                    [Helper setPREFDict:dictMutable :PREF_MULTI_COUNTRY_DATA];
                                    //[self performSegueWithIdentifier:@"segueCountryRecc" sender:self];
                                }
                                else //if(dictMutable.count>0)
                                {
                                    dictMutable = [dictMultiCountry mutableCopy];
                                    [dictMutable removeObjectsForKeys:[dictMultiCountry allKeysForObject:[NSNull null]]];
                                    if(dictMutable != NULL || dictMutable!=(id)[NSNull null] || [dictMutable count]!=0)
                                    {
                                        [Helper setPREFDict:dictMutable :PREF_MULTI_COUNTRY_DATA];
                                        //[self performSegueWithIdentifier:@"segueCountryRecc" sender:self];
                                        //[self performSegueWithIdentifier:@"segueCountryRecc" sender:self];
                                    }
                                }
                            }
                            //[self performSegueWithIdentifier:@"segueCountryRecc" sender:self];
                        }
                    }
                };
//            if([strIsDomestic isEqualToString:@"0"] && _arrData.count>0)
                [self performSegueWithIdentifier:@"segueCountryRecc" sender:self];


                [wsLogin send];

//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    //SHOW_AI;
//
//                    //here you can do what you want with main thread
//                    //once you got data you can get it on to main thread and execute the operation
//                });
            //});
        }
        HIDE_AI;

    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

-(void)setSearchDestinationData
{
    @try{
        if(arrSelectedTagsSearch.count>0)
            strSearchTags = [arrSelectedTagsSearch componentsJoinedByString:@","];
        else
            strSearchTags = @"";
        double timestamp = [[NSDate date] timeIntervalSince1970];
        NSInteger intTimeStamp = timestamp;
        [Helper setPREF:[NSString stringWithFormat:@"%li",intTimeStamp] :@"strTokenId"];
        
        NSError *errorTag;
        NSData *jsonDataTag = [NSJSONSerialization dataWithJSONObject:arrSelectedTagsSearch
                                                              options:NSJSONWritingPrettyPrinted
                                                                error:&errorTag];
        NSString *jsonStringTag;
        if (! jsonDataTag) {
            NSLog(@"Got an error: %@", errorTag);
        } else {
            jsonStringTag = [[NSString alloc] initWithData:jsonDataTag encoding:NSUTF8StringEncoding];
        }

        jsonStringTag = [jsonStringTag stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //if([self checkTheValidationToSaveForDestination] ==TRUE)
        {
            SHOW_AI;
            NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               txtDestination.text,@"sdestination",
                                               strSearchNoDays,@"sdays",
                                               strSearchDate,@"sstart_date",
                                               strSearchTags,@"searchtags",
                                               nil];
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_TRIP_TO_DESTINATION dicParams:Parameters];
            
            wsLogin.isLogging=TRUE;
            wsLogin.isSync=TRUE;
            wsLogin.onSuccess=^(NSDictionary *dicResponce)
            {
                HIDE_AI;
                NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
                NSString *strMessage = [dicResponce objectForKey:@"message"];
                if(strMessage.length==0)
                    strMessage = MSG_NO_MESSAGE;
                
                if(intStatus == 0)
                {
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:strMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        //do something when click button
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    HIDE_AI;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                else
                {
                    [Parameters setValue:[NSString stringWithFormat:@"%@",jsonStringTag] forKey:@"searchtags"];
                    [Parameters setValue:[NSString stringWithFormat:@"%li",intTimeStamp] forKey:@"token"];
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Parameters
                                                                       options:NSJSONWritingPrettyPrinted
                                                                         error:&error];
                    NSString *jsonString;
                    if (! jsonData) {
                        NSLog(@"Got an error: %@", error);
                    } else {
                        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    }
                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                    dicResponce = [dict mutableCopy];
                    dict = nil;
                    
                    [Helper setPREF:jsonString :PREF_INPUT_SEARCH_DESTI_DATA];

                    dictSearchData = [dicResponce valueForKey:@"data"];
                    HIDE_AI;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    [self loadSearchDestiData];
                }

            };
            [wsLogin send];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

-(void)loadSearchDestiData
{
    NSUInteger totalDays = [[dictSearchData valueForKey:@"totaldaysneeded"]integerValue];
    NSUInteger cntOtherCityArray = [[dictSearchData valueForKey:@"othercities"]count];
    isFromSearchData = TRUE;
    if(totalDays>0 && cntOtherCityArray==0)
    {
        NSString *strMessage = [dictSearchData valueForKey:@"message"];
        
        if(strMessage.length==0)
        {
           // [Helper setPREFDict:dictSearchData :PREF_SEARCH_DESTI_DATA];
            [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
        }
        else
        {
            strMessage = [NSString stringWithFormat:@"%@ Do you wish to modify?",strMessage];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:strMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                        {
                                            
                                        }];
            UIAlertAction *NoAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                       {
                                           //[Helper setPREFDict:dictSearchData :PREF_SEARCH_DESTI_DATA];
                                           [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
                                       }];
            [alert addAction:YesAction];
            [alert addAction:NoAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(totalDays==0 && cntOtherCityArray==0)
    {
        [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
    }
    else if(totalDays==0 && cntOtherCityArray>0)
    {
         [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
//        NSString *strMessage = [dictSearchData valueForKey:@"message"];
//        //strMessage = [NSString stringWithFormat:@"%@ Do you wish to modify?",strMessage];
//        UIAlertController * alert=   [UIAlertController
//                                      alertControllerWithTitle:@""
//                                      message:strMessage
//                                      preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
//        {
//            [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
//        }];
//        UIAlertAction *NoAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//           {
//                                       //[Helper setPREFDict:dictSearchData  :PREF_SEARCH_DESTI_DATA];
//                                       [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
//           }];
//        [alert addAction:YesAction];
//        [alert addAction:NoAction];
//        [self presentViewController:alert animated:YES completion:nil];
    }
    else
        [self performSegueWithIdentifier:@"segueSearchAddCity" sender:self];
}

-(void)loadAccomodationData
{
    @try{
        //SHOW_AI;
        arrAccomodation = [[NSMutableArray alloc]init];
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GETACCOTYPE];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=FALSE;

        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    //do something when click button
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                arrAccomodation = [dicResponce valueForKey:@"data"];
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

-(BOOL)checkTheValidationToSaveForDestination
{
    NSString *strMessage =@"";
    
    if([txtStartingPoint.text isEqualToString:@""] || [txtStartingPoint.text isEqual:[NSNull null]] || [txtStartingPoint.text isEqualToString:@"<nil>"] || txtStartingPoint.text.length==0)
    {
        strMessage = [NSString stringWithFormat:@"Enter Starting Point."];
    }
//    if([txtDestination.text isEqualToString:@""])
//    {
//        strMessage = [NSString stringWithFormat:@"Enter Starting Point."];
//    }
//    else if([strSearchDate isEqualToString:@""])
//    {
//        strMessage = [NSString stringWithFormat:@"Enter Accommodation Type."];
//    }
    else if([strAccoType isEqualToString:@""] || [strAccoType isEqual:[NSNull null]] || [strAccoType isEqualToString:@"<nil>"] || strAccoType.length==0)
    {
        strMessage = [NSString stringWithFormat:@"Enter Accommodation Type."];
    }
    else if ([strDateDep isEqualToString:@""] || [strDateDep isEqual:[NSNull null]] || [strDateDep isEqualToString:@"<nil>"] || strDateDep.length==0 || [strDateDep isEqualToString:@"Date of Departure"])
    {
        strMessage = [NSString stringWithFormat:@"Enter Date of Departure."];
    }
    
    if(strMessage.length > 0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:strMessage
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return  FALSE;
    }
    return TRUE;
}

-(BOOL)checkTheValidationToSaveForSearch
{
    NSString *strMessage =@"";
    
    if([txtDestination.text isEqualToString:@""] || [txtDestination.text isEqual:[NSNull null]] || [txtDestination.text isEqualToString:@"<nil>"] || txtDestination.text.length==0 || [txtDestination.text isEqualToString:@"Date of Departure"])
    {
        strMessage = [NSString stringWithFormat:@"Enter Starting Point."];
    }
    else if([strSearchDate isEqualToString:@""] || [strSearchDate isEqual:[NSNull null]] || [strSearchDate isEqualToString:@"<nil>"] || strSearchDate.length==0)
    {
        strMessage = [NSString stringWithFormat:@"Enter Date of Departure."];
    }
    
    if(strMessage.length > 0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:strMessage
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return  FALSE;
    }
    return TRUE;
}

-(void)wsCheckForEmail :(NSString*)strUserEmail
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_CHECK_ASK_FOR_EMAIL dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
                
            }
            else if(intStatus == 1)
            {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"askforemail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

-(void)wsNewTripInvitePopUp
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_NEW_TRIP_INVITE_POPUP dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:strMessage
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                    //lblEditTripEndDate.text = @"";
//                }];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(intStatus == 1)
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    [self wsNewTripInviteViewed];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    } 
    @finally {
        // Added to show finally works as well
    }
}

-(void)wsNewTripInviteViewed
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_NEW_TRIP_INVITE_VIEWED dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:strMessage
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                    //lblEditTripEndDate.text = @"";
//                }];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(intStatus == 1)
            {
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:strMessage
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//
//                }];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

#pragma mark - STARTING POINT SEARCH METHODS

-(void)textFieldDidChangePlaceSearch:(UITextField *) textField
{
    if(txtStartingPoint.text.length != 0)
    {
        if (textField == txtStartingPoint)
        {
           // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self performSelector:@selector(GetSearchStartingPoint:) withObject:NULL afterDelay:0.3];
        }
    }
    if(txtDestination.text.length != 0)
    {
        if (textField == txtDestination)
        {
            [self performSelector:@selector(GetSearchDestination:) withObject:NULL afterDelay:0.3];
        }
    }
    if(txtDestination.text.length==0 || txtStartingPoint.text.length==0 )
    {
        _autoCompleter.hidden = TRUE;
    }
}

#pragma mark - SEARCH DESTINATION WEB-SERVICE

-(void)GetSearchDestination: (id) sender
{
    @try{
        //SHOW_AI;
        NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           txtDestination.text,@"key",
                                           nil];
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_SUGGESTED_CITIES dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=FALSE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:strMessage
//                                              preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                    
//                    //do something when click button
//                }];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
                _autoCompleter.hidden = TRUE;

            }
            else
            {
                NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                dicResponce = [dict mutableCopy];
                dict = nil;

                [arrNamesDestination removeAllObjects];

                arrNamesDestination = [[dicResponce valueForKey:@"data"]mutableCopy];
                 //SHOW_AI;
                if(arrNamesDestination.count>0)
                {
                    [self performSelector:@selector(showSearchTbl) withObject:nil afterDelay:1.0];
                    [self autoCompletion:_autoCompleter suggestionsFor:txtDestination.text];
                }
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

#pragma mark - STARTING POINT WEB-SERVICE

-(void)GetSearchStartingPoint: (id) sender
{
    @try{
        //[self dismissKeyboard];

        //SHOW_AI
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://taxidio.rome2rio.com/api/1.4/json/Autocomplete?key=iWe3aBSN&query=%@",txtStartingPoint.text]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *error;
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *sResponce = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"sResponce : ::: : %@",sResponce);
        
        NSDictionary *dictData = [self convertResponceJSON:sResponce];
        NSLog(@"sResponce : ::: : %@",dictData);
        dictData = [dictData valueForKey:@"places"];
        //HIDE_AI
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [arrNameStartingPoint removeAllObjects];
        arrNameStartingPoint = [dictData mutableCopy];;// [dictData valueForKey:@"longName"];
        //SHOW_AI;
        //if(arrNameStartingPoint.count>0)
        {
            [self performSelector:@selector(showSearchTbl) withObject:nil afterDelay:1.0];
            [self autoCompletion:_autoCompleter suggestionsFor:txtStartingPoint.text];
        }
         //SHOW_AI;
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e.reason);
    }
    @finally {
        // Added to show finally works as well
    }
}

-(NSDictionary *)convertResponceJSON:(NSString *)sResponce{
    NSError *e = nil;
    
    NSDictionary *dicResponce =
    [NSJSONSerialization JSONObjectWithData: [sResponce dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &e];
    return dicResponce;
}

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    viewChooseDestinations.hidden = YES;
    if([[segue identifier] isEqualToString:@"segueSearchAddCity"])
    {
        if(isFromSearchData==true && [strIsDomestic isEqualToString:@"0"])
        {
            CitySwipeViewVC *detail = (CitySwipeViewVC *)[segue destinationViewController];
            detail.isFromSearchData = isFromSearchData;
            detail.dictSearchData = dictSearchData;
            detail.strTripType = @"3";
        }
        else
        {
            CitySwipeViewVC *detail = (CitySwipeViewVC *)[segue destinationViewController];
            detail.dictSearchData = dictSearchData;
            detail.strTripType = @"4";
        }
    }
    if([[segue identifier] isEqualToString:@"segueSearchShowAttraction"])
    {
        CityLocationSwipeVC *detail = (CityLocationSwipeVC *)[segue destinationViewController];
        detail.isFromSearchData = isFromSearchData;
        detail.dictSearchData = dictSearchData;
        detail.strCityName = [dictSearchData valueForKey:@"city_name"];
        detail.strLongitude = [dictSearchData valueForKey:@"longitude"];
        detail.strLatitude = [dictSearchData valueForKey:@"latitude"];
    }
    if([[segue identifier] isEqualToString:@"segueCountryRecc"])
    {
        CityLocationSwipeVC *detail = (CityLocationSwipeVC *)[segue destinationViewController];
//        detail.isFromSearchData = FALSE;
//        detail.dictSearchData = dictSearchData;
    }
    //
}

@end
