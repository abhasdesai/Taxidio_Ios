//
//  CityLocationSwipeVC.m
//  Taxidio
//
//  Created by E-Intelligence on 28/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CityLocationSwipeVC.h"
#import "AutocompletionTableView.h"
#import "MVPlaceSearchTextField.h"
#import <GoogleMaps/GoogleMaps.h>


@interface CityLocationSwipeVC ()<I3DragBetweenDelegate>
@property (nonatomic, strong) NSMutableDictionary *dictAttraction;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtAddNewAttraction;
@property (nonatomic, strong) UIImage *taxidioImg;
@property (nonatomic, strong) UIImage *gygImg;
@property (nonatomic, strong) UIImage *imgNewImage;

@end

@implementation CityLocationSwipeVC

@synthesize arrData,dictAttraction,objAttractionDataForReadMore,strCityName,isFromSearchData,dictSearchData, strLongitude,strLatitude,strItineraryIdSelected,strCountryId,strCitySlug,strCityId,collectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _taxidioImg = [UIImage imageNamed:@"taxidio_Marker"];
    _gygImg = [UIImage imageNamed:@"GYG_Marker"];
    _imgNewImage = [UIImage imageNamed:@"new_marker"];
    
    self.mapView.delegate = self;
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    lblViewAll.text = @"View All";

    scrollView.userInteractionEnabled = YES;
    scrollView.exclusiveTouch = YES;
    
    scrollView.canCancelContentTouches = YES;
    scrollView.delaysContentTouches = FALSE;

    self.rightTable = [[UITableView alloc]init];
    //[tblViewLocationListing registerClass:[UITableViewCell class] forCellReuseIdentifier:DequeueReusableCell];
    [self.rightTable registerClass:[UITableViewCell class] forCellReuseIdentifier:DequeueReusableCell];
    
    viewAddNewLocation.hidden = true;

    viewAddMore.hidden = TRUE;
    lblCityNameTitle.text = self.strCityName;
    NSLog(@"self.arrData : : %@",self.arrData);
    
    if(self.isFromSearchData==true)
    {
        arrAttractionsList = [[NSMutableArray arrayWithObject:[dictSearchData valueForKey:@"filestore"]]objectAtIndex:0];
        if(_isFromEditTrip==TRUE)
            arrAttractionsList = [arrAttractionsList objectAtIndex:0];
//        arrAttractionsList = [NSMutableArray arrayWithObject:[dictSearchData valueForKey:@"filestore"]];
        arrDataToShow = [[[NSMutableArray alloc]initWithArray:arrAttractionsList]mutableCopy];
        strCityIdForSelectedLocations = [[[arrDataToShow firstObject]valueForKey:@"properties"]valueForKey:@"cityid"];
        [self loadData:arrDataToShow];
        //btnSaveTrip.hidden = FALSE;
    }
    else
    {
        if(arrData.count>0)
        {
            self.strCountryId = [self.strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            self.strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",self.strCountryId];
            NSString *strCityIds = [self.arrData valueForKey:@"id"];
            strCityIds = [strCityIds stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
            strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",self.strCountryId,strCityIds];
            strCityCountryId = [strCityCountryId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            strCityCountryId = [strCityCountryId stringByReplacingOccurrencesOfString:@"(" withString:@""];
            strCityCountryId = [strCityCountryId stringByReplacingOccurrencesOfString:@")" withString:@""];
            //btnSaveTrip.hidden = TRUE;
            arrAttractionsList = [[NSMutableArray alloc]initWithArray:[self.arrData valueForKey:@"filestore"]];
            arrDataToShow = [[[NSMutableArray alloc]initWithArray:arrAttractionsList]mutableCopy];
           // arrDataToShow = [arrDataToShow objectAtIndex:0];
           // arrDataToShow  = [self removeNotSelectedValues:arrDataToShow];

            strCityIdForSelectedLocations = [[[arrDataToShow firstObject]valueForKey:@"properties"]valueForKey:@"cityid"];
            [self loadData:arrDataToShow];
        }
    }
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
    isViewAllTapped = FALSE;
    repeatCnt = 0;

    if(([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        viewViewAllAddLocation.hidden = TRUE;
        viewBottomBar.hidden = TRUE;
        viewHotelAttraction.frame = viewViewAllAddLocation.frame;// CGRectMake( viewHotelAttraction.frame.origin.x,viewHotelAttraction.frame.origin.y-100 , viewHotelAttraction.frame.size.width, viewHotelAttraction.frame.size.height );
        //tblViewLocationListing.allowsSelection = YES;
        self.collectionView.allowsSelection = YES;
        btnSaveTrip.hidden = TRUE;
    }
    else
    {
        self.collectionView.allowsSelection = YES;
        viewViewAllAddLocation.hidden = FALSE;
        viewBottomBar.hidden = FALSE;
        btnSaveTrip.hidden = FALSE;
    }
    [self loadZooming];
   // [self loadData:arrDataToShow];
}

-(void)loadData :(NSMutableArray*)arrDataToLoadForOption
{
    isFromSwipe = FALSE;
    [arrMapData removeAllObjects];
    arrMapData = [[NSMutableArray alloc]init];
    
    for(int i=0;i<arrDataToLoadForOption.count;i++)
    {
        if(isViewAllTapped==FALSE)
        {
            if([[[arrDataToLoadForOption objectAtIndex:i] valueForKey:@"isselected"]intValue]==1)
            {
                NSMutableArray *dict = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:[[[arrDataToLoadForOption valueForKey:@"geometry"]valueForKey:@"coordinates"] objectAtIndex:i] forKey:@"coordinates"],[NSDictionary dictionaryWithObject:[[[arrDataToLoadForOption valueForKey:@"properties"]valueForKey:@"name"] objectAtIndex:i] forKey:@"name"] ,[NSDictionary dictionaryWithObject:[[[arrDataToLoadForOption valueForKey:@"properties"]valueForKey:@"getyourguide"] objectAtIndex:i] forKey:@"getyourguide"],nil];
                [arrMapData addObject:dict];
            }
        }
        else
        {
            NSMutableArray *dict = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:[[[arrDataToLoadForOption valueForKey:@"geometry"]valueForKey:@"coordinates"] objectAtIndex:i] forKey:@"coordinates"],[NSDictionary dictionaryWithObject:[[[arrDataToLoadForOption valueForKey:@"properties"]valueForKey:@"name"] objectAtIndex:i] forKey:@"name"],[NSDictionary dictionaryWithObject:[[[arrDataToLoadForOption valueForKey:@"properties"]valueForKey:@"getyourguide"] objectAtIndex:i] forKey:@"getyourguide"] ,nil];
            [arrMapData addObject:dict];
        }
    }
    _mapView.camera.pitch = 45.0;
    
    NSMutableArray *newAnnotations = [[NSMutableArray alloc] init];
    for(int i=0;i<arrMapData.count;i++)
    {
        MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
        
        NSArray *arr = [[[arrMapData valueForKey:@"coordinates"]objectAtIndex:i] objectAtIndex:0];
        //NSLog(@"%@,%@",[arr objectAtIndex:1],[arr objectAtIndex:0]);
        point.coordinate = CLLocationCoordinate2DMake([[arr objectAtIndex:1]doubleValue],[[arr objectAtIndex:0]doubleValue]);
        if(i==0)
        {
            latOne = [[arr objectAtIndex:1]doubleValue];
            LongOne = [[arr objectAtIndex:0]doubleValue];
        }
        point.title = [[[arrMapData objectAtIndex:i]objectAtIndex:1]valueForKey:@"name"];
        point.subtitle = [[[arrMapData objectAtIndex:i]objectAtIndex:2]valueForKey:@"getyourguide"];
        NSLog(@"%@", point);
    }
    NSArray *existingAnnotations = [_mapView annotations];
    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] init];
    for(MGLPointAnnotation *existingAnnotation in existingAnnotations)
    {
        if([newAnnotations containsObject:existingAnnotation]) {
            [newAnnotations removeObject:existingAnnotation];
        } else {
            [annotationsToRemove addObject:existingAnnotation];
        }
    }
    if([annotationsToRemove count] > 0) {
        [_mapView removeAnnotations:annotationsToRemove];
    }
    if([newAnnotations count] > 0) {
        [_mapView addAnnotations:newAnnotations];
    }
    self.mapView.delegate = self;
    //[tblViewLocationListing reloadData];
    [self.collectionView reloadData];
    [self loadZooming];
}

-(void)loadZooming
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latOne,LongOne);
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:coordinate fromDistance:5000
                                                                   pitch:60 heading:0];
    [_mapView flyToCamera:camera completionHandler:nil];
}

-(void)loadCameraAnimation :(double)lat :(double)lng
{
    self.mapView.delegate = self;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat,lng);
//    _mapView.centerCoordinate = coordinate;
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:coordinate
                                                            fromDistance:5
                                                                   pitch:1
                                                                 heading:90];
    //_mapView.zoomLevel = 20;
    [_mapView flyToCamera:camera completionHandler:nil];
}

#pragma mark - MAPBOX METHODS

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"gyg"];
    if (!annotationImage)
    {
        UIImage *image;
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
            int isGetYourGuide = 0;
            for(int i=0;i<arrDataToShow.count;i++)
            {
                NSString *strNameLoop = [[[arrDataToShow objectAtIndex:i]valueForKey:@"properties"]valueForKey:@"name"];
                int isGYG = [[[[arrDataToShow objectAtIndex:i]valueForKey:@"properties"]valueForKey:@"getyourguide"]intValue];

                //int isSelected = [[[[arrDataToShow objectAtIndex:i]valueForKey:@"properties"]valueForKey:@"isselected"]intValue];

                int isUserActivity = [[[[arrDataToShow objectAtIndex:i] valueForKey:@"properties"]valueForKey:@"useractivity"] intValue];

                if([strNameLoop isEqualToString:annotation.title] && isGYG==1 && isUserActivity==0)
                    isGetYourGuide = 1;
                else if([strNameLoop isEqualToString:annotation.title] && isGYG==0 && isUserActivity==0)
                    isGetYourGuide = 0;
                else if(isUserActivity==1 && [strNameLoop isEqualToString:annotation.title])
                    isGetYourGuide = 3;
            }

            if(isGetYourGuide==0)
                annotationImage = [MGLAnnotationImage annotationImageWithImage:_taxidioImg reuseIdentifier:@"taxidio_Marker"];
            else if(isGetYourGuide==1)
                annotationImage = [MGLAnnotationImage annotationImageWithImage:_gygImg reuseIdentifier:@"GYG_Marker"];
            else if(isGetYourGuide==3)
                annotationImage = [MGLAnnotationImage annotationImageWithImage:_imgNewImage reuseIdentifier:@"new_marker"];

        return annotationImage;
    }
    return 0;
}

- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    return 0;
}

- (void)mapView:(MGLMapView *)mapView annotation:(id<MGLAnnotation>)annotation calloutAccessoryControlTapped:(UIControl *)control
{
    // Hide the callout view.
    [self.mapView deselectAnnotation:annotation animated:NO];
    
}

// Use the default marker. See also: our view annotation or custom marker examples.
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    return nil;
}

// Allow callout view to appear when an annotation is tapped.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    
    return YES;
}

-(void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //This method only returns 20 objects
    //NSArray *myObjects = [arrMapData getObjectsInVisibleRect:[mapView visibleCoordinateBounds].sw ne:[mapView visibleCoordinateBounds].ne];
    NSMutableArray *newAnnotations = [[NSMutableArray alloc] init];
    for(int i=0;i<arrMapData.count;i++)
    {
        MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
        NSArray *arr = [[[arrMapData valueForKey:@"coordinates"]objectAtIndex:i] objectAtIndex:0];//[[arrMapData objectAtIndex:i]valueForKey:@"coordinates"]];
        //NSLog(@"%@,%@",[arr objectAtIndex:1],[arr objectAtIndex:0]);
        point.coordinate = CLLocationCoordinate2DMake([[arr objectAtIndex:1]doubleValue],[[arr objectAtIndex:0]doubleValue]);
        if(i==0)
        {
            latOne = [[arr objectAtIndex:1]doubleValue];
            LongOne = [[arr objectAtIndex:0]doubleValue];
        }
        
        NSString *strName = [[[arrMapData objectAtIndex:i]objectAtIndex:1]valueForKey:@"name"];
        strName = [strName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        strName = [strName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        strName = [strName stringByReplacingOccurrencesOfString:@"\\u0027" withString:@"'"];

        point.title = strName;
        [newAnnotations addObject:point];
    }
    NSArray *existingAnnotations = [_mapView annotations];
    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] init];
    for(MGLPointAnnotation *existingAnnotation in existingAnnotations)
    {
        if([newAnnotations containsObject:existingAnnotation]) {
            [newAnnotations removeObject:existingAnnotation];
        } else {
            [annotationsToRemove addObject:existingAnnotation];
        }
    }
    if([annotationsToRemove count] > 0) {
        [_mapView removeAnnotations:annotationsToRemove];
    }

    if([newAnnotations count] > 0) {
        //_mapView.zoomLevel = _mapView.maximumZoomLevel;
        [_mapView addAnnotations:newAnnotations];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);

    if(screenHeight == 480 || screenHeight == 568)
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.3)];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.1)];
    }
}

#pragma mark - IBACTION METHODS

- (IBAction)pressViewRecomm:(id)sender
{
    if(isViewAllTapped==FALSE)
        isViewAllTapped=TRUE;
    else
        isViewAllTapped = FALSE;
    
    if(isViewAllTapped==true)
    {
        lblViewAll.text = @"View Recommended";
        [btnViewAll setTitle:@"View Recommended" forState:UIControlStateNormal];
        [self loadData:arrDataToShow];
//        if(arrDataToShow.count==0)
//        {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self wsLoadCityAttractions:strCityCountryId];
//            });
//        }
//        else
//        {
//            for(int i=0;i<arrDataToShow.count;i++)
//            {
//                NSString *strI = [[[arrDataToShow  valueForKey:@"properties"]valueForKey:@"name"] objectAtIndex:i];
//
//                LocationData *objLocation = [[LocationData alloc]init];
//                objLocation = [arrDataToShow objectAtIndex:i];
//                [objLocation setValue:[NSNumber numberWithInt:0] forKey:@"isselected"];
//                //[objLocation setValue:@"1" forKey:@"tempremoved"];
//
//                for(int j=0;j<arrDataToShow.count;j++)
//                {
//                    NSString *strJ = [[[arrDataToShow valueForKey:@"properties"]valueForKey:@"name"] objectAtIndex:j];
//
//                    if([strI isEqualToString:strJ])
//                    {
//                        [objLocation setValue:[NSNumber numberWithInt:1] forKey:@"isselected"];
//                        //[objLocation setValue:@"0" forKey:@"tempremoved"];
//                   }
//                }
//            }
//            [self loadData:arrDataToShow];
//        }
    }
    else
    {
        lblViewAll.text = @"View All";
        [btnViewAll setTitle:@"View All" forState:UIControlStateNormal];
        [self loadData:arrDataToShow];

//        lblViewAll.text = @"View All";
//
//        [arrDataToShow removeAllObjects];
//        for(int i=0;i<arrDataToShow.count;i++)
//        {
//            LocationData *objLocation = [[LocationData alloc]init];
//            objLocation = [arrDataToShow objectAtIndex:i];
//
//            if([[objLocation valueForKey:@"isselected"] intValue]==1)
//                [arrDataToShow addObject:objLocation];
//        }
//        [self loadData:arrDataToShow];

//        [self loadData:arrDataToShow];
    }
    //[tblViewLocationListing setContentOffset:CGPointZero animated:YES];
    [scrollView setContentOffset:
     CGPointMake(0, -scrollView.contentInset.top) animated:YES];
}

- (IBAction)pressAddLocation:(id)sender {
    viewAddNewLocation.hidden = FALSE;
    _txtAddNewAttraction.text = @"";
    _txtAddNewAttraction.autocorrectionType = UITextAutocorrectionTypeNo;
    [_txtAddNewAttraction addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self SetPlaceText];
    
}

- (IBAction)pressAttractionTicket:(id)sender
{
    [self performSegueWithIdentifier:@"segueShowAttraction" sender:self];

//    NSString *strURL = [NSString stringWithFormat:@"http://www.taxidio.com/cityAttractionFromGYG/%@/%@/%@",self.strCityName,self.strLongitude,self.strLatitude];
//
//    strURL = [strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    //https://www.taxidio.com/cityAttractionFromGYG/Mumbai/72.84456/19.00263
//    NSURL *URL = [NSURL URLWithString:strURL];
//    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
//        if (success) {
//            NSLog(@"Opened url");
//        }
//    }];
}

- (IBAction)pressHotellBookings:(id)sender
{
    [self performSegueWithIdentifier:@"segueHotelBooking" sender:self];
}

- (IBAction)pressDeleteAddRow:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    //NSLog(@"%ld",(long)i);
    LocationData *objLocation = [[LocationData alloc]init];
    
    if(isViewAllTapped==FALSE)
    {
        objLocation = [[arrDataToShow objectAtIndex:i]mutableCopy];
    }
    else
    {
        objLocation = [[arrDataToShow objectAtIndex:i]mutableCopy];
    }
    
    if(isViewAllTapped==true)
    {
      //  lblViewAll.text = @"View All";
        
        if([[objLocation valueForKey:@"isselected"]intValue]==0)
        {
            if([[objLocation valueForKey:@"order"]intValue]==99999)
            {
                [objLocation setValue:[NSNumber numberWithLong:arrDataToShow.count] forKey:@"order"];
            }
            [objLocation setValue:[NSNumber numberWithInt:1] forKey:@"isselected"];
            [objLocation setValue:[NSNumber numberWithInt:0] forKey:@"tempremoved"];
            [arrDataToShow replaceObjectAtIndex:i withObject:objLocation];
            [self loadData:arrDataToShow];
        }
        else if([[objLocation valueForKey:@"isselected"]intValue]==1)
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Are you sure you want to delete this attraction?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                        {
                                            if([[[objLocation valueForKey:@"properties"]valueForKey:@"useractivity"]intValue]==1)
                                            {
                                                [arrDataToShow removeObject:objLocation];
                                            }
                                            else
                                            {
                                                [objLocation setValue:[NSNumber numberWithInt:0] forKey:@"isselected"];
                                                [objLocation setValue:[NSNumber numberWithInt:1] forKey:@"tempremoved"];
                                                [arrDataToShow replaceObjectAtIndex:i withObject:objLocation];
                                            }
                                            [self loadData:arrDataToShow];
                                        }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Are you sure you want to delete this attraction?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        if([[[objLocation valueForKey:@"properties"]valueForKey:@"useractivity"]intValue]==1)
                                        {
                                            [arrDataToShow removeObject:objLocation];
                                        }
                                        else
                                        {
                                            [objLocation setValue:[NSNumber numberWithInt:0] forKey:@"isselected"];
                                            [objLocation setValue:[NSNumber numberWithInt:1] forKey:@"tempremoved"];
                                            [arrDataToShow replaceObjectAtIndex:i withObject:objLocation];
                                        }
                                        [self loadData:arrDataToShow];
                                    }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

- (IBAction)pressBackBtn:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

        [self.arrData setValue:arrDataToShow forKey:@"filestore"];

        dict = [self.arrData mutableCopy];
        [Helper setPREFDict:dict :@"dictDataFromLocationView"];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(                                                         NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *folder = [path objectAtIndex:0];
        NSLog(@"Your NSUserDefaults are stored in this folder: %@/Preferences", folder);

        [Helper setPREFint:1 :@"isFromAttractionListing"];
        [self.navigationController popViewControllerAnimated:YES];
//        [self performSegueWithIdentifier:@"segueLoadAttractionsBack" sender:self];

    });
}

- (IBAction)pressSaveTrip:(id)sender {
 //   [self wsSaveTripData];
    
    if([Helper getPREF:PREF_UID].length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self wsSaveTripData];
        });

    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please log in to save the trip."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            CGRect screenRect;
            CGFloat screenHeight;
            CGFloat screenWidth;
            
            screenRect = [[UIScreen mainScreen] bounds];
            screenHeight = screenRect.size.height;
            screenWidth = screenRect.size.width;
            
            UIStoryboard* storyboard;
            if(screenHeight == 480 || screenHeight == 568)
                storyboard = [UIStoryboard storyboardWithName:@"Main_5s" bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SignInPage *add = [storyboard instantiateViewControllerWithIdentifier:@"SignInPage"];
            [self presentViewController:add animated:YES completion:nil];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)pressAddNewLocation:(id)sender {
    viewAddNewLocation.hidden = true;
    txtNewLocation.text = @"";
    [txtNewLocation resignFirstResponder];
    [self loadData:arrDataToShow];
}

- (IBAction)pressCancelAddLocation:(id)sender {
    viewAddNewLocation.hidden = true;
    [txtNewLocation resignFirstResponder];
    [arrDataToShow removeLastObject];
}

- (IBAction)pressReadMore:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
   // NSLog(@"%ld",(long)i);
    
    self.objAttractionDataForReadMore = [arrDataToShow objectAtIndex:i];
    viewAddMore.hidden = TRUE;

    [self performSegueWithIdentifier:@"segueReadMore" sender:self];
}

- (IBAction)pressBuyTicket:(id)sender
{
    [self performSegueWithIdentifier:@"segueShowAttraction" sender:self];

//    NSString *strCityId = [[[arrDataToShow firstObject]valueForKey:@"properties"]valueForKey:@"cityid"];
//    NSString *strURL = [NSString stringWithFormat:@"http://www.taxidio.com/attractionsFromGYG/%@/%@/%@",strCityId,self.strLongitude,self.strLatitude];
//
//    NSURL *URL = [NSURL URLWithString:strURL];
//    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
//        if (success) {
//            NSLog(@"Opened url");
//        }
//    }];
}

- (IBAction)pressCloseReadMore:(id)sender
{
    viewAddMore.hidden = TRUE;
    [self loadZooming];

//    [arrMapData removeAllObjects];
//    [self loadData:arrDataToShow];
}

#pragma mark- ==== PlaceTextMethod ====
-(void)SetPlaceText
{
    _txtAddNewAttraction.placeSearchDelegate                 = self;
    _txtAddNewAttraction.strApiKey                           = GOOGLE_PLACE_KEY;
    _txtAddNewAttraction.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    _txtAddNewAttraction.autoCompleteShouldHideOnSelection   = YES;
    _txtAddNewAttraction.maximumNumberOfAutoCompleteRows     = 5;
    
    //Optional Properties
    _txtAddNewAttraction.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _txtAddNewAttraction.autoCompleteBoldFontName = @"HelveticaNeue";
    _txtAddNewAttraction.autoCompleteTableCornerRadius=0.0;
    _txtAddNewAttraction.autoCompleteRowHeight=35;
    _txtAddNewAttraction.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _txtAddNewAttraction.autoCompleteFontSize=14;
    _txtAddNewAttraction.autoCompleteTableBorderWidth=1.0;
    _txtAddNewAttraction.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _txtAddNewAttraction.autoCompleteShouldHideOnSelection=YES;
    _txtAddNewAttraction.autoCompleteShouldHideClosingKeyboard=YES;
    _txtAddNewAttraction.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _txtAddNewAttraction.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-_txtAddNewAttraction.frame.size.width - 10 )*0.5, _txtAddNewAttraction.frame.size.height+250.0, _txtAddNewAttraction.frame.size.width + 10, 200.0);
}

#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
    
    LocationData *obj = [[LocationData alloc]init];
    
    obj.distance = 9999999999;
    obj.isselected = 1;
    obj.tempremoved = 0;
    obj.order = arrDataToShow.count;
    obj.type = @"Feature";
    NSArray *arrCordi = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%f",responseDict.coordinate.longitude],[NSString stringWithFormat:@"%f",responseDict.coordinate.latitude], nil];

    NSArray *arrCordiCity = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",self.strLongitude],[NSString stringWithFormat:@"%@",self.strLatitude], nil];

    NSString *strName = [responseDict valueForKey:@"name"];
    strName = [strName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strName = [strName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strName = [strName stringByReplacingOccurrencesOfString:@"'" withString:@"\\u0027"];

    obj.geometry = [NSDictionary dictionaryWithObjectsAndKeys:@"Point",@"type",arrCordi,@"coordinates", nil];
    obj.properties = [NSDictionary dictionaryWithObjectsAndKeys:strName,@"name",
                      [NSNumber numberWithInt:0],@"knownfor",
                      [NSNumber numberWithInt:0],@"known_tags",
                      [NSNumber numberWithInt:0],@"tag_star",
                      [NSNumber numberWithInt:0],@"getyourguide",
                      [self getAttractionId],@"attractionid",
                      strCityIdForSelectedLocations,@"cityid",
                      [NSNumber numberWithInt:1],@"isplace",
                      [NSNumber numberWithInt:1], @"useractivity",
                      [NSNumber numberWithInt:0],@"category", nil];
    obj.devgeometry = [NSDictionary dictionaryWithObjectsAndKeys:arrCordiCity,@"devcoordinates", nil];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
    [dict setValue:obj.devgeometry forKey:@"devgeometry"];
    [dict setValue:[NSNumber numberWithInteger:obj.distance] forKey:@"distance"];
    [dict setValue:obj.geometry forKey:@"geometry"];
    [dict setValue:[NSNumber numberWithInteger:obj.isselected] forKey:@"isselected"];
    [dict setValue:[NSNumber numberWithInteger:obj.order] forKey:@"order"];
    [dict setValue:obj.properties forKey:@"properties"];
    [dict setValue:[NSNumber numberWithInteger:obj.tempremoved] forKey:@"tempremoved"];
    [dict setValue:obj.type forKey:@"type"];

    [arrDataToShow addObject:dict];
    [self removeKeyboard];
}

-(NSString*)getAttractionId
{
    NSString *strCharacter = @"abcdefghijklmnopqrstuvwxyz0123456789";
    NSUInteger charLen = strCharacter.length;
    charLen = charLen-1;
    int maxlen = (int)charLen;
    NSString *strRandom = @"";
    for(int i=0;i<5;i++)
    {
        NSInteger intRandom = [self generateRandomNumberWithlowerBound:0 upperBound:maxlen];
        NSString *theCharacter = [NSString stringWithFormat:@"%c", [strCharacter characterAtIndex:intRandom-1]];
        strRandom = [NSString stringWithFormat:@"%@%@",strRandom,theCharacter];
    }
    double timestamp = [[NSDate date] timeIntervalSince1970];
    NSInteger intTimeStamp = timestamp;

    strRandom = [NSString stringWithFormat:@"%@%li",strRandom,intTimeStamp];
    return strRandom;
}

-(int) generateRandomNumberWithlowerBound:(int)lowerBound
                               upperBound:(int)upperBound
{
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue;
}

-(void)placeSearchForArray:(MVPlaceSearchTextField*)textField ResponseForSelectedData:(NSMutableArray*)responseArray
{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseArray);
   // NSError *error;
//    NSArray *arr = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[responseArray valueForKey:@"coordinate"] forKey:@"devcoordinates"]];
//    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
//
//    NSString *devgeometry = jsonString;
//
    [self removeKeyboard];
}

-(void)removeKeyboard
{
    [_txtAddNewAttraction resignFirstResponder];
}

-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{}

-(void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{}

-(void)wasCancelled:(GMSAutocompleteViewController *)viewController
{}

-(void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{}

-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
}

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma  mark- ==== TextDelegateMethod ====

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == _txtAddNewAttraction)
    {
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        if(screenHeight == 480)
        {
            pt.y -=160;
            [scrollView setContentOffset:pt animated:YES];
        }
        else
        {
            pt.y -=220;
            [scrollView setContentOffset:pt animated:YES];
        }
    }
    return  YES;
}

-(void)textChanged:(UITextField *)textField
{
    NSLog(@"textfield data %@ ",textField.text);
}

#pragma mark - SAVE TRIP METHODS

-(void)wsSaveTripData
{
    int type = [self.strTripType intValue];
    if(type==4)
        type = 1;
    // SEARCH FLOW
    
        [self.arrData setValue:arrDataToShow forKey:@"filestore"];
        
        for(int i=0;i<self.arrCityData.count;i++)
        {
            if([[[self.arrCityData valueForKey:@"id"]objectAtIndex:i]isEqualToString:[self.arrData valueForKey:@"id"]])
            {
                [self.arrCityData replaceObjectAtIndex:i withObject:self.arrData];
            }
        }
    
    if([self.strTripType isEqualToString:@"3"])
    {
        if(self.isFromEditTrip==FALSE) // SAVING FOR FIRST TIME
        {
            NSString *strMainCityId;
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            for(int i=0;i<self.arrCityData.count;i++)
            {
                NSString *strDistance;
                if(i==self.arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrCityData valueForKey:@"nextdistance"] objectAtIndex:i+1];
                
                if([[[self.arrCityData objectAtIndex:i]valueForKey:@"ismain"]isEqualToString:@"1"])
                    strMainCityId = [[self.arrCityData valueForKey:@"id"]objectAtIndex:i];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"total_days"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"latitude"] forKey:@"latitude"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"longitude"] forKey:@"longitude"];
                [dict setObject:[[self.arrCityData objectAtIndex:0] valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"cityid"] forKey:@"cityid"];
                [dict setObject:[[self.arrCityData objectAtIndex:0] valueForKey:@"countryimage"] forKey:@"countryimage"];
                [dict setObject:[[_arrCityData objectAtIndex:i] valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
                [dict setObject:[[_arrCityData objectAtIndex:0] valueForKey:@"country_name"] forKey:@"country_name"];
                [dict setObject:[[_arrCityData objectAtIndex:i] valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[[_arrCityData objectAtIndex:i] valueForKey:@"code"] forKey:@"code"];
                //                if([[[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"]intValue]==0)
                //                    [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"totaldaysneeded"];
                //                else
                //                    [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"] forKey:@"totaldaysneeded"];
                [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                [dict setObject:strDistance forKey:@"nextdistance"];
                
                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryWiseCityData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            ///////////////------------ATTRACTION DATA----------/////////////
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<self.arrCityData.count;i++)
            {
//                [self.arrData setValue:arrDataToShow forKey:@"filestore"];
//
//                for(int i=0;i<self.arrCityData.count;i++)
//                {
//                    if([[[self.arrCityData valueForKey:@"id"]objectAtIndex:i]isEqualToString:[self.arrData valueForKey:@"id"]])
//                    {
//                        [self.arrCityData replaceObjectAtIndex:i withObject:self.arrData];
//                    }
//                }
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[self.arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[self.arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                
                [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *strCountryId;
            strCountryId = [self.arrData valueForKey:@"country_id"];
            
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput;
                if(![self.strTripType isEqualToString:@"3"])
                    strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                else
                    strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                [Parameters setObject:strMainCityId forKey:@"main_cityid"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SAVE_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                    dicResponce = [dict mutableCopy];
                    dict = nil;

                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            self.isFromEditTrip = TRUE;
                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueAttractionToTrip" sender:self];
                        }];
                        [alert addAction:MyTripAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
        else // EDIT SEARCH TRIP
        {
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            NSString *strMainCityId;
            
            for(int i=0;i<self.arrCityData.count;i++)
            {
                NSString *strDistance;
                if(i==self.arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrCityData valueForKey:@"nextdistance"] objectAtIndex:i+1];
                
                if([[[self.arrCityData objectAtIndex:i]valueForKey:@"ismain"]isEqualToString:@"1"])
                    strMainCityId = [[self.arrCityData valueForKey:@"id"]objectAtIndex:i];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"total_days"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"latitude"] forKey:@"latitude"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"longitude"] forKey:@"longitude"];
                [dict setObject:[[self.arrCityData objectAtIndex:0] valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[self.arrCountryData valueForKey:@"countryimage"] forKey:@"countryimage"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
                //                [dict setObject:@"" forKey:@"rome2rio_name"];
                //                [dict setObject:@"" forKey:@"code"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"cityid"] forKey:@"cityid"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"code"] forKey:@"code"];
                [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"cityid"] forKey:@"cityid"];
                
                if([[self.arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"] != nil)
                    [dict setObject:[[self.arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"] forKey:@"totaldaysneeded"];
                else
                    [dict setObject:@"" forKey:@"totaldaysneeded"];
                [dict setObject:strDistance forKey:@"nextdistance"];
                
                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            // NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictCountryWiseCityData,[NSString stringWithFormat:@"%@",[self.arrCountryData valueForKey:@"country_id"]], nil];
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryWiseCityData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            ///////////////------------ATTRACTION DATA----------/////////////
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<_arrCityData.count;i++)
            {
//                [self.arrData setValue:arrDataToShow forKey:@"filestore"];
//
//                for(int i=0;i<self.arrCityData.count;i++)
//                {
//                    if([[[self.arrCityData valueForKey:@"id"]objectAtIndex:i]isEqualToString:[self.arrData valueForKey:@"id"]])
//                    {
//                        [self.arrCityData replaceObjectAtIndex:i withObject:self.arrData];
//                    }
//                }

                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[_arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[_arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                
                [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *strCountryId;
            strCountryId = [[_arrCityData valueForKey:@"country_id"]objectAtIndex:0];
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput;
                strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                [Parameters setObject:strMainCityId forKey:@"main_cityid"];
                [Parameters setObject:self.strItineraryIdSelected forKey:@"itineraryid"];
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                 //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            //self.isFromEditTrip = TRUE;
                            //                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueAttractionToTrip" sender:self];
                        }];
                        [alert addAction:MyTripAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
    }
    else if([self.strTripType isEqualToString:@"1"] || [self.strTripType isEqualToString:@"4"]) //SINGLE COUNTRY
    {
        if(self.isFromEditTrip==FALSE) //FIRST TIME SAVE
        {
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            for(int i=0;i<self.arrCityData.count;i++)
            {
                NSObject *objCityData = [self.arrCityData objectAtIndex:i];
                NSString *strDistance;
                if(i==self.arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrCityData valueForKey:@"nextdistance"] objectAtIndex:i+1];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                [dict setObject:[self.arrCountryData valueForKey:@"slug"] forKey:@"slug"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
                [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                [dict setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [dict setObject:[NSNumber numberWithInt:[[objCityData valueForKey:@"sortorder"]intValue]] forKey:@"sortorder"];
                
                if([objCityData valueForKey:@"timetoreach"] != nil)
                    [dict setObject:[objCityData valueForKey:@"timetoreach"] forKey:@"timetoreach"];
                else
                    [dict setObject:@"" forKey:@"timetoreach"];
                
                if([objCityData valueForKey:@"actualtime"] != nil)
                    [dict setObject:[objCityData valueForKey:@"actualtime"] forKey:@"actualtime"];
                else
                    [dict setObject:@"" forKey:@"actualtime"];

                if([objCityData valueForKey:@"total_days"] != nil)
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                else
                    [dict setObject:@"" forKey:@"total_days"];

                if([objCityData valueForKey:@"nextdistance"] != nil)
                    [dict setObject:[objCityData valueForKey:@"nextdistance"] forKey:@"nextdistance"];
                else
                    [dict setObject:@"" forKey:@"nextdistance"];

                if([objCityData valueForKey:@"totaltags"] != nil)
                    [dict setObject:[objCityData valueForKey:@"totaltags"] forKey:@"totaltags"];
                else
                    [dict setObject:@"" forKey:@"totaltags"];
                
                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictCountryWiseCityData,[NSString stringWithFormat:@"%@",[self.arrCountryData valueForKey:@"country_id"]], nil];
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<self.arrCityData.count;i++)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[self.arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[self.arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                
                [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            
            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SAVE_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                    dicResponce = [dict mutableCopy];
                    dict = nil;

                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            //do something when click button
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            self.isFromEditTrip = TRUE;
                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueAttractionToTrip" sender:self];
                        }];
                        [alert addAction:MyTripAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
        else // EDIT SINGLE
        {
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            for(int i=0;i<self.arrCityData.count;i++)
            {
                //                if(isFirstTimeSaved==true)
                //                    arrCityData = [[self.arrCountryData valueForKey:@"cityData"]mutableCopy];
                
                NSObject *objCityData = [self.arrCityData objectAtIndex:i];
                NSString *strDistance;
                if(i==self.arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrCityData valueForKey:@"nextdistance"] objectAtIndex:i+1];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                [dict setObject:[self.arrCountryData valueForKey:@"slug"] forKey:@"slug"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
                [dict setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [dict setObject:[NSNumber numberWithInt:[[objCityData valueForKey:@"sortorder"]intValue]] forKey:@"sortorder"];
                [dict setObject:strDistance forKey:@"nextdistance"];
                //                if([[NSString stringWithFormat:@"%@",[objCityData valueForKey:@"totaltags"]]length]==0)
                //                    [dict setObject:@"" forKey:@"totaltags"];
                //                else
                
                if([objCityData valueForKey:@"totaltags"] != nil)
                    [dict setObject:[objCityData valueForKey:@"totaltags"] forKey:@"totaltags"];
                else
                    [dict setObject:@"" forKey:@"totaltags"];
                
                if([objCityData valueForKey:@"total_days"] != nil)
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                else
                    [dict setObject:@"" forKey:@"total_days"];

                if([objCityData valueForKey:@"rome2rio_code"] != nil)
                    [dict setObject:[objCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                else
                    [dict setObject:@"" forKey:@"rome2rio_code"];

                if([objCityData valueForKey:@"rome2rio_country_name"] != nil)
                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                else
                    [dict setObject:@"" forKey:@"rome2rio_country_name"];
                
                if([objCityData valueForKey:@"timetoreach"] != nil)
                    [dict setObject:[objCityData valueForKey:@"timetoreach"] forKey:@"timetoreach"];
                else
                    [dict setObject:@"" forKey:@"timetoreach"];
                
                [dict setObject:@"" forKey:@"actualtime"];
                
                if([objCityData valueForKey:@"actualtime"] != nil)
                    [dict setObject:[objCityData valueForKey:@"actualtime"] forKey:@"actualtime"];
                else
                    [dict setObject:@"" forKey:@"actualtime"];
                //[dict setObject:@"" forKey:@"rome2rio_country_name"];
//                if(self.isFirstTimeSaved)
//                    [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
//                else
//                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictCountryWiseCityData,[NSString stringWithFormat:@"%@",[self.arrCountryData valueForKey:@"country_id"]], nil];
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            ///////////////------------ATTRACTION DATA----------/////////////
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            for(int i=0;i<_arrCityData.count;i++)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[self.arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[_arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                
                [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *strCountryId;
            strCountryId = [self.arrCountryData valueForKey:@"country_id"];

            if(strCountryId.length==0)
                strCountryId = [[_arrCityData valueForKey:@"country_id"]objectAtIndex:0];

            @try{
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                [Parameters setObject:self.strItineraryIdSelected forKey:@"itineraryid"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                   //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            //self.isFromEditTrip = TRUE;
                            //self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueAttractionToTrip" sender:self];
                        }];
                        [alert addAction:MyTripAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        //                        self.isFromEditTrip = TRUE;
                        //                        self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                        
                        //                        [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
    }
    else if([self.strTripType isEqualToString:@"2"]) //MULTI COUNTRY
    {
        if(self.isFromEditTrip==FALSE) //FIRST TIME SAVE
        {
            NSMutableDictionary *dictCountryCitywiseData = [[NSMutableDictionary alloc]init];
            for(int i=0;i<self.arrMultiCountryData.count;i++)
            {
                NSMutableArray *arrDataForCity = [[NSMutableArray alloc]init];
                NSMutableDictionary *dict;
                NSMutableArray *objArrCityData = [[self.arrMultiCountryData valueForKey:@"cityData"] objectAtIndex:i];
                for(int j=0;j<objArrCityData.count;j++)
                {
                    NSObject *objCityData = [objArrCityData objectAtIndex:j];
                    NSString *strDistance;
                    //                    if(i==arrDataForCountryAtIndex.count-1)
                    strDistance = @"";
                    //                    else
                    //                        strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                    dict = [NSMutableDictionary dictionaryWithCapacity:20];
                    [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                    [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                    [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                    [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"citylatitude"];
                    [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"citylongitude"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"country_id"];
                    [dict setObject:[objCityData valueForKey:@"country_name"] forKey:@"country_name"];
                    [dict setObject:[objCityData valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
                    [dict setObject:[objCityData valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
                    [dict setObject:[objCityData valueForKey:@"continent_id"] forKey:@"continent_id"];
                    [dict setObject:[objCityData valueForKey:@"slug"] forKey:@"slug"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                    [dict setObject:[objCityData valueForKey:@"country_total_days"] forKey:@"country_total_days"];
                    [dict setObject:[objCityData valueForKey:@"city_rome2rio_name"] forKey:@"city_rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_rome2rio_name"] forKey:@"country_rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"countryid"] forKey:@"countryid"];
                    [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                    [dict setObject:strDistance forKey:@"nextdistance"];
                    [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                    [dict setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                    [arrDataForCity addObject:dict];
                }
                [dictCountryCitywiseData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:arrDataForCity,[NSString stringWithFormat:@"%@",[[arrDataForCity valueForKey:@"country_id"]objectAtIndex:0]], nil]];
                //                [dictCountryWiseCityData addObject:dictCountryCityData];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryCitywiseData);
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryCitywiseData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            //============================COMBINATION============================
            
            NSString *strCountryId;
            if([self.strTripType isEqualToString:@"1"])
            {
                strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            }
            else
            {
                NSArray *arrCountryId = [self.arrCountryDataForOptSelected valueForKey:@"country_id"];
                strCountryId = [arrCountryId componentsJoinedByString:@"-"];
            }
            NSString *strEncodeKey = [self encodeStringTo64:strCountryId];
            strEncodeKey = [strEncodeKey stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
            strEncodeKey = [strEncodeKey stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            strEncodeKey = [strEncodeKey stringByReplacingOccurrencesOfString:@"=" withString:@"~"];
            
            //=======
            
            NSMutableArray *arrCombinationData = [[NSMutableArray alloc]init];
            NSMutableDictionary *dictCountryCityData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<self.arrMultiCountryData.count;i++)
            {
                NSMutableArray *arrDataForCountryAtIndex = [NSMutableArray arrayWithObject:[_arrCountryDataForOptSelected objectAtIndex:i]];
                
                NSObject *objCityData = [arrDataForCountryAtIndex objectAtIndex:0];
                NSString *strDistance;
                strDistance = @"";
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[objCityData valueForKey:@"slug"] forKey:@"slug"];
                [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"latitude"];
                [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"longitude"];
                [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[objCityData valueForKey:@"country_name"] forKey:@"country_name"];
                [dict setObject:[objCityData valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
                [dict setObject:[objCityData valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
                [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"citylatitude"];
                [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"citylongitude"];
                [dict setObject:[objCityData valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
                [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                [dict setObject:[objCityData valueForKey:@"country_total_days"] forKey:@"country_total_days"];
                [dict setObject:[objCityData valueForKey:@"city_rome2rio_name"] forKey:@"city_rome2rio_name"];
                [dict setObject:[objCityData valueForKey:@"country_rome2rio_name"] forKey:@"country_rome2rio_name"];
                [dict setObject:[objCityData valueForKey:@"countryid"] forKey:@"countryid"];
                [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                [dictCountryCityData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:dict,[NSString stringWithFormat:@"%d",i], nil]];
            }
            
            [dictCountryCityData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:strEncodeKey,@"encryptkey", nil]];
            [arrCombinationData addObject:dictCountryCityData];
            NSLog(@"arrCombinationData : : : %@",arrCombinationData);
            
            NSError *error1;
            NSData *jsonCombiData = [NSJSONSerialization dataWithJSONObject:arrCombinationData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonCombiDataString = [[NSString alloc] initWithData:jsonCombiData encoding:NSUTF8StringEncoding];
            jsonCombiDataString = [jsonCombiDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //=======
            
            //=======------------ATTRACTION DATA----------=======//
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<self.arrMultiCountryData.count;i++)
            {
                NSMutableDictionary *objCountryData = [[self.arrMultiCountryData objectAtIndex:i]mutableCopy];
                NSMutableArray *arrDataForCity = [[objCountryData valueForKey:@"cityData"]mutableCopy];
                
                for(int j=0;j<arrDataForCity.count;j++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrDataForCity objectAtIndex:j]valueForKey:@"filestore"],[[arrDataForCity objectAtIndex:j]valueForKey:@"id"], nil];
                    
                    [arrCityWiseAttractionData addEntriesFromDictionary:dict];
                }
            }
            
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error12;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error12];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            //[self wsSaveTripData:jsonCityDataString :jsonAttrDataString];
            //}
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonCombiDataString forKey:@"combinations"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SAVE_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                    dicResponce = [dict mutableCopy];
                    dict = nil;

                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            //do something when click button
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            self.isFromEditTrip = TRUE;
                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueAttractionToTrip" sender:self];
                        }];
                        [alert addAction:MyTripAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        //                        self.isFromEditTrip = TRUE;
                        //                        self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                        //
                        ////                        [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
        else
        {
            NSMutableDictionary *dictCountryCitywiseData = [[NSMutableDictionary alloc]init];
            for(int i=0;i<self.arrMultiCountryData.count;i++)
            {
                //                NSMutableArray *arrDataForCountryAtIndex = [NSMutableArray arrayWithObject:[arrCountryDataForOptSelected objectAtIndex:i]];
                NSMutableArray *arrDataForCity = [[NSMutableArray alloc]init];
                NSMutableDictionary *dict;
                NSMutableArray *objArrCityData = [[self.arrMultiCountryData valueForKey:@"cityData"] objectAtIndex:i];
                for(int j=0;j<objArrCityData.count;j++)
                {
                    NSObject *objCityData = [objArrCityData objectAtIndex:j];
                    NSString *strDistance;
                    //                    if(i==arrDataForCountryAtIndex.count-1)
                    strDistance = @"";
                    //                    else
                    //                        strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                    dict = [NSMutableDictionary dictionaryWithCapacity:20];
                    [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                    [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                    [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                    [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"citylatitude"];
                    [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"citylongitude"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"country_id"];
                    [dict setObject:[objCityData valueForKey:@"country_name"] forKey:@"country_name"];
                    
                    if([objCityData valueForKey:@"countrylatitude"] != nil)
                        [dict setObject:[objCityData valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
                    else
                        [dict setObject:@"" forKey:@"countrylatitude"];
                    
                    if([objCityData valueForKey:@"countrylongitude"] != nil)
                        [dict setObject:[objCityData valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
                    else
                        [dict setObject:@"" forKey:@"countrylongitude"];
                    
                    if([objCityData valueForKey:@"continent_id"] != nil)
                        [dict setObject:[objCityData valueForKey:@"continent_id"] forKey:@"continent_id"];
                    else
                        [dict setObject:@"" forKey:@"continent_id"];
                    
                    [dict setObject:[objCityData valueForKey:@"slug"] forKey:@"slug"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                    
                    if([objCityData valueForKey:@"country_total_days"] != nil)
                        [dict setObject:[objCityData valueForKey:@"country_total_days"] forKey:@"country_total_days"];
                    else
                        [dict setObject:@"" forKey:@"country_total_days"];
                    
                    if([objCityData valueForKey:@"city_rome2rio_name"] != nil)
                        [dict setObject:[objCityData valueForKey:@"city_rome2rio_name"] forKey:@"city_rome2rio_name"];
                    else
                        [dict setObject:@"" forKey:@"city_rome2rio_name"];
                    
                    if([objCityData valueForKey:@"country_rome2rio_name"] != nil)
                        [dict setObject:[objCityData valueForKey:@"country_rome2rio_name"] forKey:@"country_rome2rio_name"];
                    else
                        [dict setObject:@"" forKey:@"country_rome2rio_name"];
                    
                    if([objCityData valueForKey:@"country_id"] != nil)
                        [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"countryid"];
                    else
                        [dict setObject:[objCityData valueForKey:@"countryid"] forKey:@"countryid"];

//                    [dict setObject:[objCityData valueForKey:@"countryid"] forKey:@"countryid"];
                    [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                    [dict setObject:strDistance forKey:@"nextdistance"];
                    [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                    [arrDataForCity addObject:dict];
                }
                [dictCountryCitywiseData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:arrDataForCity,[NSString stringWithFormat:@"%@",[[arrDataForCity valueForKey:@"country_id"]objectAtIndex:0]], nil]];
                //                [dictCountryWiseCityData addObject:dictCountryCityData];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryCitywiseData);
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryCitywiseData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            //=======------------ATTRACTION DATA----------=======//
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<self.arrMultiCountryData.count;i++)
            {
                NSMutableDictionary *objCountryData = [[self.arrMultiCountryData objectAtIndex:i]mutableCopy];
                NSMutableArray *arrDataForCity = [[objCountryData valueForKey:@"cityData"]mutableCopy];
                
                for(int j=0;j<arrDataForCity.count;j++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrDataForCity objectAtIndex:j]valueForKey:@"filestore"],[[arrDataForCity objectAtIndex:j]valueForKey:@"id"], nil];
                    
                    [arrCityWiseAttractionData addEntriesFromDictionary:dict];
                }
            }
            
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error12;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error12];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            //[self wsSaveTripData:jsonCityDataString :jsonAttrDataString];
            //}
            
            NSString *strCountryId;
            if([self.strTripType isEqualToString:@"1"])
            {
                strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            }
            else
            {
                NSArray *arrCountryId = [self.arrCountryDataForOptSelected valueForKey:@"country_id"];
                strCountryId = [arrCountryId componentsJoinedByString:@"-"];
            }
            
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                NSArray *arrCountryId = [self.arrMultiCountryData valueForKey:@"country_id"];
                strCountryId = [arrCountryId componentsJoinedByString:@"-"];
                
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                //[Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                [Parameters setObject:self.strItineraryIdSelected forKey:@"itineraryid"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                   //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            //do something when click button
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            self.isFromEditTrip = TRUE;
                            //self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueAttractionToTrip" sender:self];
                        }];
                        [alert addAction:MyTripAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        //                        self.isFromEditTrip = TRUE;
                        //                        self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                        //
                        ////                        [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
    }

//    if(isFromSearchData==TRUE)
//    {
//        NSMutableArray *arrCountryData = [[NSMutableArray alloc]initWithObjects:dictSearchData, nil];
//        if(_isFromEditTrip==TRUE)
//            arrCountryData = [arrCountryData objectAtIndex:0];
//        NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
//        for(int i=0;i<arrCountryData.count;i++)
//        {
//            NSString *strDistance,*strisMain;
//                strDistance = @"";
//                strisMain = @"1";
//
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"city_name"] forKey:@"city_name"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"cityslug"] forKey:@"cityslug"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"total_days"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"latitude"] forKey:@"latitude"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"longitude"] forKey:@"longitude"];
//            [dict setObject:[[arrCountryData objectAtIndex:0] valueForKey:@"country_id"] forKey:@"country_id"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"cityid"] forKey:@"cityid"];
//            [dict setObject:[[arrCountryData objectAtIndex:0] valueForKey:@"countryimage"] forKey:@"countryimage"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
//            [dict setObject:[[arrCountryData objectAtIndex:0] valueForKey:@"country_name"] forKey:@"country_name"];
//            [dict setObject:[[arrCountryData objectAtIndex:0] valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
//            [dict setObject:[[arrCountryData objectAtIndex:i] valueForKey:@"code"] forKey:@"code"];
//            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"sortorder"];
//            [dict setObject:strDistance forKey:@"nextdistance"];
//            [dictCountryWiseCityData addObject:dict];
//        }
//        NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
//        NSString *strMainCityId = [[arrCountryData valueForKey:@"id"]objectAtIndex:0];
//
//        NSError *error;
//        NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryWiseCityData options:NSJSONWritingPrettyPrinted error:&error];
//        NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
//        jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        ///////////////------------ATTRACTION DATA----------/////////////
//
//        NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
////        for(int i=0;i<arrDataToShow.count;i++)
////        {
//            NSString *strCityId = [[arrCountryData valueForKey:@"id"]objectAtIndex:0];
////            NSMutableArray *arrDataforCity = [[NSMutableArray alloc]init];
////            [arrDataforCity addObject:[arrDataToShow objectAtIndex:i]];
////
//            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:arrDataToShow,[NSString stringWithFormat:@"%@",strCityId], nil];
//
//            [arrCityWiseAttractionData addEntriesFromDictionary:dict];
////        }
//
//        NSError *error1;
//        NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
//        NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
//        jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//
//        int type = 3;
//        NSString *strCountryId = [[arrCountryData valueForKey:@"country_id"]objectAtIndex:0];
//
//        @try{
//            NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
//
//            NSString *strInput;
//            if(!isFromSearchData)
//                strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
//            else
//                strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
//            [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
//            [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
//            [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
//            [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
//            [Parameters setObject:strInput forKey:@"inputs"];
//            [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
//            [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
//            [Parameters setObject:strMainCityId forKey:@"main_cityid"];
//            if(self.isFromEditTrip==true)
//                [Parameters setObject:self.strItineraryIdSelected forKey:@"itineraryid"];
//
//            NSString *strWebServiceName;
//            if(self.isFromEditTrip==true)
//                strWebServiceName =WS_EDIT_TRIP;
//            else
//                strWebServiceName =WS_SAVE_TRIP;
//
//            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:strWebServiceName dicParams:Parameters];
//            wsLogin.isLogging=TRUE;
//            wsLogin.isSync=TRUE;
//            wsLogin.onSuccess=^(NSDictionary *dicResponce)
//            {
//                //   HIDE_AI;
//                NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
//                NSString *strMessage = [dicResponce objectForKey:@"message"];
//                if(strMessage.length==0)
//                    strMessage = MSG_NO_MESSAGE;
//
//                if(intStatus == 0)
//                {
//                    UIAlertController * alert=   [UIAlertController
//                                                  alertControllerWithTitle:@""
//                                                  message:strMessage
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//
//                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                    }];
//                    [alert addAction:okAction];
//                    [self presentViewController:alert animated:YES completion:nil];
//                }
//                else
//                {
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
//            };
//            [wsLogin send];
//        }
//        @catch (NSException * e) {
//            NSLog(@"Exception: %@", e);
//        }
//        @finally {
//        }
//    }
}

- (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}


#pragma mark - Web service Methods

-(void)wsLoadCityAttractions :(NSString*)strCityCountryId
{
    @try{
        NSString *str = [NSString stringWithFormat:@"%@",strCityCountryId];
        
        NSString *strInput;
        if(![self.strTripType isEqualToString:@"3"])
            strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
        else
            strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
        NSData* data = [strInput dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *strTags = [values valueForKey:@"searchtags"];
        strTags = [strTags stringByReplacingOccurrencesOfString:@"[" withString:@""];
        strTags = [strTags stringByReplacingOccurrencesOfString:@"]" withString:@""];

        NSString *strisView;
        if([strTags isEqualToString:@""])
            strisView = @"0";
        else
            strisView = @"1";
        
        
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    str,@"countryidwithcityid",
                                    strTags,@"tags",
//                                    strisView,@"isview",
                                    nil];
       
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_ATTRACTION_CITY dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            //   HIDE_AI;
            NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
            dicResponce = [dict mutableCopy];
            dict = nil;

            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                //[self.arrAttractionData removeAllObjects];
                arrDataToShow  = [[[dicResponce valueForKey:@"data"]objectAtIndex:0]mutableCopy];
                
                arrDataToShow = [[NSMutableArray arrayWithObject:[arrDataToShow valueForKey:@"attractions"]]objectAtIndex:0];
                arrDataToShow = [[NSMutableArray arrayWithObject:[arrDataToShow valueForKey:@"filestore"]]objectAtIndex:0];
                //                [self.arrAttractionData addObject:[[[dicResponce valueForKey:@"data"]objectAtIndex:0]mutableCopy]];
                
                arrDataToShow = [arrDataToShow objectAtIndex:0];
                
                for(int i=0;i<arrDataToShow.count;i++)
                {
                    NSString *strI = [[[arrDataToShow  valueForKey:@"properties"]valueForKey:@"name"] objectAtIndex:i];

                    LocationData *objLocation = [[LocationData alloc]init];
                    objLocation = [arrDataToShow objectAtIndex:i];
                    [objLocation setValue:[NSNumber numberWithInt:0] forKey:@"isselected"];
//                    [objLocation setValue:@"1" forKey:@"tempremoved"];

                    for(int j=0;j<arrDataToShow.count;j++)
                    {
                        NSString *strJ = [[[arrDataToShow valueForKey:@"properties"]valueForKey:@"name"] objectAtIndex:j];
                        
                        if([strI isEqualToString:strJ])
                        {
                            [objLocation setValue:[NSNumber numberWithInt:1] forKey:@"isselected"];
                           // [objLocation setValue:@"0" forKey:@"tempremoved"];
                        }
                    }
                }
                
                //self.arrAttractionData = [self.arrAttractionData objectAtIndex:0];
                NSLog(@"arrDataToShow : : :%@",arrDataToShow);
                //              self.dictAttractionData = [[self.dictAttractionData valueForKey:@"attractions"] objectAtIndex:0];
                //                [Helper setPREFDict:self.dictAttractionData :PREF_ATTRACTION_DATA];
                [self loadData:arrDataToShow];
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueReadMore"])
    {
        LocationReadMoreViewController *detail = (LocationReadMoreViewController *)[segue destinationViewController];
        detail.objAttractionData = self.objAttractionDataForReadMore;
    }
    else if([[segue identifier] isEqualToString:@"segueShowAttraction"])
    {
        AttractionListingVC *detail = (AttractionListingVC *)[segue destinationViewController];
        detail.strCityName = self.strCityName;
        detail.strLatitude = self.strLatitude;
        detail.strLongitude = self.strLongitude;
    }
    else if([[segue identifier] isEqualToString:@"segueHotelBooking"])
    {
        HotelViewVC *detail = (HotelViewVC *)[segue destinationViewController];
        detail.strCityName = self.strCityName;
        detail.strCityId = self.strCityId;
        detail.strCitySlug = self.strCitySlug;
    }
    else if([[segue identifier] isEqualToString:@"segueLoadAttractionsBack"])
    {
//
//        CitySwipeViewVC *detail = (CitySwipeViewVC *)[segue destinationViewController];
//        detail.dictDataFromLocationView = [self.arrData mutableCopy];
//        detail.isFromAttractionListing = TRUE;
//        detail.isFromEditTrip = FALSE;
//
//        detail.arrData = self.arrDataToGetBack;
//        detail.arrCountryDataForOptSelected = self.arrCountryDataForOptSelectedToGetBack;
//        detail.isSingleSelected = self.isSingleSelectedToGetBack;
    }
}

#pragma mark - UICollectionViewDataSource methods

#pragma mark - CollectionView Method ===

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex
{
    return arrDataToShow.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 01;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellAttractionList";

    CellAttractionList *cell = [collectionView1 dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    LocationData *objLocation = [[LocationData alloc]init];
    
    if(isViewAllTapped==FALSE)
    {
        NSInteger index = indexPath.row;
        objLocation = [[arrDataToShow objectAtIndex:indexPath.row]mutableCopy];
        if([[objLocation valueForKey:@"order"]intValue]!=99999 && isFromSwipe==FALSE)
            [objLocation setValue:[NSNumber numberWithInteger:index] forKey:@"order"];
        [cell.btnDeleteAdd setImage:[UIImage imageNamed:@"delete_trip"] forState:UIControlStateNormal];
    }
    else
    {
        objLocation = [arrDataToShow objectAtIndex:indexPath.row];
        //      for(int i=0;i<arrDataToShow.count;i++)
        {
            //if(([arrDataToShow containsObject:objLocation]))
            if([[objLocation valueForKey:@"isselected"]intValue]==1 && [[objLocation valueForKey:@"tempremoved"]intValue]==0)
            {
                [cell.btnDeleteAdd setImage:[UIImage imageNamed:@"delete_trip"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnDeleteAdd setImage:[UIImage imageNamed:@"add_city"] forState:UIControlStateNormal];
            }
        }
    }
    
    cell.lblTitleCityLocation.textColor = [UIColor blackColor];
    cell.lblTitleCityLocation.font = FONT_AVENIR_45_BOOK_SIZE_14;
    cell.lblTitleCityLocation.backgroundColor = [UIColor clearColor];
    cell.layer.anchorPointZ = indexPath.row;
    //cell.contentView.userInteractionEnabled = TRUE;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    NSString *strLabel = [NSString stringWithFormat:@"%@",[[objLocation valueForKey:@"properties"] valueForKey:@"name"]];
    NSString *myUnicodeString = @"u0027";
    strLabel = [strLabel stringByReplacingOccurrencesOfString:myUnicodeString withString:@"'"];
    strLabel = [strLabel stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    cell.lblTitleCityLocation.text = strLabel;
    [cell.btnDeleteAdd addTarget:self action:@selector(pressDeleteAddRow:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDeleteAdd.tag = indexPath.row;
    //cell.btnDeleteAdd.userInteractionEnabled = YES;
    [cell bringSubviewToFront:cell.btnDeleteAdd];

    int isgetyourguide = [[[objLocation valueForKey:@"properties"]valueForKey:@"getyourguide"]intValue];
    if(isgetyourguide==0)
        cell.imgViewLogo.image = [UIImage imageNamed:@"taxidio-logo-1"];
    else
        cell.imgViewLogo.image = [UIImage imageNamed:@"gyg"];

    int ispaid = [[[objLocation valueForKey:@"properties"]valueForKey:@"ispaid"]intValue];
    if(ispaid==0)
        cell.imgViewDollar.hidden = true;
    else
        cell.imgViewDollar.hidden = false;

    int isStar = [[[objLocation valueForKey:@"properties"]valueForKey:@"tag_star"] intValue];
    if(isStar==0)
        cell.imgViewStar.hidden = true;
    else
        cell.imgViewStar.hidden = false;
    //cell.contentView.userInteractionEnabled = false;
    cell.backgroundView.backgroundColor = [UIColor whiteColor];

    int isUserActivity = [[[objLocation valueForKey:@"properties"]valueForKey:@"useractivity"] intValue];
    if(isUserActivity==1)
        cell.imgNew.hidden = FALSE;
    else
        cell.imgNew.hidden = TRUE;

    cell.viewBackGround.layer.borderColor = COLOR_ORANGE.CGColor;
    cell.viewBackGround.layer.borderWidth = 2.0;
    cell.viewBackGround.layer.masksToBounds = TRUE;

    [cell.viewBackGround.layer setCornerRadius:5.0f];
    [cell.viewBackGround.layer setShadowColor:[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0].CGColor];
    [cell.viewBackGround.layer setShadowOpacity:1.0];
    [cell.viewBackGround.layer setShadowRadius:5.0];
    [cell.viewBackGround.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];

    if(([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        cell.btnDeleteAdd.hidden = TRUE;
    }
    else
    {
        cell.btnDeleteAdd.hidden = FALSE;
    }
    
    BOOL walkthroughLocation = [[NSUserDefaults standardUserDefaults] boolForKey: @"walkthroughLocation"];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = window.safeAreaInsets.top;
    if(topPadding>0)
        topPadding = topPadding - 20;

    if(indexPath.row==0 && repeatCnt==0 && !walkthroughLocation && ([Helper getPREFint:@"isFromViewItinerary"]!=1) && topPadding==0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"walkthroughLocation"];

        int intGap = 0;
        CGRect screenRect;
        CGFloat screenHeight;
        
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;
        
        if(screenHeight == 480 || screenHeight == 568)
        {
            intGap = 230;
        }
        else
        {
            intGap = 300;
        }

        repeatCnt++;
        CGRect coachmarkbtnLocation = CGRectMake(collectionView.frame.origin.x+ cell.frame.origin.x, collectionView.frame.origin.y+intGap, cell.frame.size.width, cell.frame.size.height-20);
        
        CGRect coachmarkDollarSign = CGRectMake(collectionView.frame.origin.x + cell.imgViewDollar.frame.origin.x, collectionView.frame.origin.y+intGap+cell.imgViewDollar.frame.origin.y, cell.imgViewDollar.frame.size.width, cell.imgViewDollar.frame.size.height);

        CGRect coachmarkStarSign = CGRectMake(collectionView.frame.origin.x + cell.imgViewStar.frame.origin.x, collectionView.frame.origin.y+intGap+cell.imgViewStar.frame.origin.y, cell.imgViewStar.frame.size.width, cell.imgViewStar.frame.size.height);

        CGRect coachmarkDeleteSign = CGRectMake(collectionView.frame.origin.x + cell.btnDeleteAdd.frame.origin.x, collectionView.frame.origin.y+intGap+cell.btnDeleteAdd.frame.origin.y, cell.btnDeleteAdd.frame.size.width, cell.btnDeleteAdd.frame.size.height);

        NSArray *coachMarksLocation = @[
                                    @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkbtnLocation],
                                    @"caption": @"Long press & drag the attraction to rearrange the order",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                                    //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                    @"showArrow":[NSNumber numberWithBool:YES]
                                    }];
        NSArray *coachMarksDollar = @[
                                    @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkDollarSign],
                                    @"caption": @"This is a paid attraction",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                    //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                    @"showArrow":[NSNumber numberWithBool:YES]
                                    }
                                    ];
        NSArray *coachMarksStar = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkStarSign],
                                    @"caption": @"Taxidio recommends this attraction",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                    //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                    @"showArrow":[NSNumber numberWithBool:YES]
                                    }
                                ];
        NSArray *coachMarksDelete = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkDeleteSign],
                                    @"caption": @"Delete this attraction",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                    //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                    @"showArrow":[NSNumber numberWithBool:YES]
                                    }
                                ];
        NSArray *newArray;
            newArray =[coachMarksLocation mutableCopy];
        
        int ispaidLocation = [[[objLocation valueForKey:@"properties"]valueForKey:@"ispaid"]intValue];
        if(ispaidLocation!=0)
           newArray = [newArray arrayByAddingObjectsFromArray:coachMarksDollar];
        
        int isStarLocation = [[[objLocation valueForKey:@"properties"]valueForKey:@"tag_star"] intValue];
        if(isStarLocation!=0)
            newArray = [newArray arrayByAddingObjectsFromArray:coachMarksStar];

        newArray = [newArray arrayByAddingObjectsFromArray:coachMarksDelete];
        
        MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.view.bounds coachMarks:newArray];
        [self.view addSubview:coachMarksView];
        [coachMarksView start];
    }
    
    return cell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        
    }
    else
    {
        NSObject *obj;
        obj = [arrDataToShow [fromIndexPath.item]mutableCopy];
        [arrDataToShow removeObjectAtIndex:fromIndexPath.item];
        [arrDataToShow insertObject:obj atIndex:toIndexPath.item];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([Helper getPREFint:@"isFromViewItinerary"]==1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"did end drag");
//    [self loadDistance];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(screenHeight == 480 || screenHeight == 568)
//        return CGSizeMake(120,120);
//    else
    
    LocationData *objLocation = [[LocationData alloc]init];
    if(isViewAllTapped==FALSE)
        objLocation = [[arrDataToShow objectAtIndex:indexPath.row]mutableCopy];
    else
        objLocation = [arrDataToShow objectAtIndex:indexPath.row];
    NSString *strAttractionId = [[objLocation valueForKey:@"properties"]valueForKey:@"attractionid"];
    int isPlace = [[[objLocation valueForKey:@"properties"]valueForKey:@"isplace"] intValue];
    int height;
    int width;
//    int tagStar;
    if(isViewAllTapped==false)
    {
        if ([strAttractionId containsString:@"tag_"] || isPlace==0 || ([[objLocation valueForKey:@"isselected"]intValue]==0))// || ((![self.strTripType isEqualToString:@"3"]) && ([[[objLocation valueForKey:@"properties"]valueForKey:@"tag_star"] intValue]==0)))
        {
            height = 0;
            width = 0;
        }
        else
        {
            height = 70;
            if(screenHeight == 480 || screenHeight == 568)
                width = 300;
            else
                width = 345;
        }
    }
    else
    {
        if ([strAttractionId containsString:@"tag_"])
        {
            height = 0;
            width = 0;
        }
        else
        {
            height = 70;
            if(screenHeight == 480 || screenHeight == 568)
                width = 300;
            else
                width = 345;
        }
    }
        return CGSizeMake(width,height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Do some stuff when the row is selected
    ///[tableView deselectRowAtIndexPath:indexPath animated:YES];
    LocationData *obj = [[LocationData alloc]init];
    
    if(isViewAllTapped==FALSE)
        obj = [[arrDataToShow objectAtIndex:indexPath.row] mutableCopy];
    else
        obj = [arrDataToShow objectAtIndex:indexPath.row];
    
    NSMutableArray *dict = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:[[obj valueForKey:@"geometry"]valueForKey:@"coordinates"]  forKey:@"coordinates"],[NSDictionary dictionaryWithObject:[[obj valueForKey:@"properties"]valueForKey:@"name"] forKey:@"name"] ,nil];
    
    NSArray *arr = [NSArray arrayWithArray:[[dict objectAtIndex:0]valueForKey:@"coordinates"]];
    
    [self loadCameraAnimation:[[arr objectAtIndex:1]doubleValue] :[[arr objectAtIndex:0]doubleValue]];
    /////////
    for(int i=0;i<arrDataToShow.count;i++)
    {
        if([[[[arrDataToShow objectAtIndex:i] valueForKey:@"properties"]valueForKey:@"name"]isEqualToString:[[obj valueForKey:@"properties"]valueForKey:@"name"]])
        {
            NSObject *obj = [arrDataToShow objectAtIndex:i];
            NSString *strName = [[obj valueForKey:@"properties"]valueForKey:@"name"];
            
            strName = [strName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            strName = [strName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            strName = [strName stringByReplacingOccurrencesOfString:@"\\u0027" withString:@"'"];

            lblAttractionName.text = strName;
            if(([[[obj valueForKey:@"properties"]valueForKey:@"isplace"]intValue]==1) && ([[[obj valueForKey:@"properties"]valueForKey:@"knownfor"]intValue]==0))
            {
                lblKnownFor.text = @"My Activity";
                btnReadMore.hidden = TRUE;
            }
            else if (([[[obj valueForKey:@"properties"]valueForKey:@"isplace"]intValue]==1) && ([[[obj valueForKey:@"properties"]valueForKey:@"knownfor"]intValue]!=0))
            {
                lblKnownFor.text = [NSString stringWithFormat:@"Known For : %@",[[obj valueForKey:@"properties"]valueForKey:@"known_tags"]];
                btnReadMore.hidden = FALSE;
            }
            else if (([[[obj valueForKey:@"properties"]valueForKey:@"isplace"]intValue]==0) && ([[[obj valueForKey:@"properties"]valueForKey:@"attractionid"]containsString:@"tag_"]))
            {
                lblKnownFor.text = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"properties"]valueForKey:@"known_tags"]];
                btnReadMore.hidden = FALSE;
            }
            else if (([[[obj valueForKey:@"properties"]valueForKey:@"isplace"]intValue]==0) && (![[[obj valueForKey:@"properties"]valueForKey:@"attractionid"]containsString:@"tag_"]))
            {
                lblKnownFor.text = @"My Activity";
                btnReadMore.hidden = TRUE;
            }
            
            if(([[[obj valueForKey:@"properties"]valueForKey:@"getyourguide"]intValue]==1)&&([[[obj valueForKey:@"properties"]valueForKey:@"ispaid"]intValue]==1))
            {
                btnBuyTicket.hidden = FALSE;
            }
            else
            {
                btnBuyTicket.hidden = TRUE;
            }
            btnReadMore.tag = i;
            btnBuyTicket.tag = i;
            viewAddMore.hidden = FALSE;
        }
    }
}

@end
