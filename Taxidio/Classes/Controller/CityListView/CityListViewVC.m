//
//  CityListViewVC.m
//  Taxidio
//
//  Created by E-Intelligence on 01/08/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CityListViewVC.h"

@interface CityListViewVC ()

@end

@implementation CityListViewVC

@synthesize arrCountryData,isSingleSelected,strTimeToReach;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(115, 115);
    //flow.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    
    allcollectionView.collectionViewLayout = flow;
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenwidth = screenRect.size.width;
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
    NSLog(@"%@",self.arrCountryData);
    _arrCityData = [self.arrCountryData valueForKey:@"cityData"];
    lblCountryTitle.text = [arrCountryData valueForKey:@"country_name"];
    
    _mapView.latitude =[[NSString stringWithFormat:@"%@",[arrCountryData valueForKey:@"countrylatitude"]]doubleValue];
    _mapView.longitude =[[arrCountryData valueForKey:@"countrylongitude"]doubleValue];
    _mapView.camera.pitch = 45.0;
    
    MGLPointAnnotation *point;
    point = [[MGLPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(_mapView.latitude,_mapView.longitude);
    
    [_mapView addAnnotation:point];
    _mapView.zoomLevel = 6;
    if(isSingleSelected==true)
        lblTimeTakenToReach.text =[NSString stringWithFormat:@"%@",[arrCountryData valueForKey:@"timetoreach"]];
    else
        lblTimeTakenToReach.text = [NSString stringWithFormat:@"%@",strTimeToReach];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressUserProfile:(id)sender {
}


#pragma mark - CollectionView Method ===

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrCityData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DestinationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imgDestination.image = [UIImage imageNamed:@"Image_Loading"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[[_arrCityData valueForKey:@"cityimage"]objectAtIndex:indexPath.row]]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.imgDestination.image = image;
                    });
                }
            }
            else
            {
                cell.imgDestination.image = [UIImage imageNamed:@"Image_Loading"];
            }
        }];
        [task resume];
        
    });
    
    //    cell.layer.borderColor = COLOR_ORANGE.CGColor;
    //    cell.layer.borderWidth = 1.0;
    //    cell.layer.masksToBounds = YES;
    
    NSString *strTitle = [[_arrCityData valueForKey:@"city_name"]objectAtIndex:indexPath.row];
    cell.lblDestination.text = strTitle;
    cell.lblDestination.textColor = [UIColor whiteColor];
    cell.lblDestination.font = FONT_AVENIR_45_BOOK_SIZE_15;
    
    cell.viewBG.layer.borderColor = COLOR_ORANGE.CGColor;
    cell.viewBG.layer.borderWidth = 1.0;
    cell.viewBG.layer.cornerRadius = 5.0;
    [cell.viewBG.layer setMasksToBounds: YES];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(screenwidth == 320)
    //    {
    //        return CGSizeMake(106.666, 116.5);
    //    }
    //    else if (screenwidth == 375)
    //    {
    //        return CGSizeMake(125,141.25);
    //    }
    //    else if (screenwidth == 414)
    //    {
    //        return CGSizeMake(138,158.5);
    //    }
    
    //    CGRect screenRect;
    //    CGFloat screenHeight;
    //    CGFloat screenWidth;
    //
    //    screenRect = [[UIScreen mainScreen] bounds];
    //    screenHeight = screenRect.size.height;
    //    screenWidth = screenRect.size.width;
    //
    //    UIStoryboard* storyboard;
    if(screenHeight == 480 || screenHeight == 568)
        return CGSizeMake(120,120);
    else
        return CGSizeMake(160,160);
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [allcollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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



//#pragma mark - ========== Tableview Events ===============
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
//{
//    return _arrCityData.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *identifier;
//
////    if(indexPath.row % 2 == 0)
//    {
//        identifier = @"CellCityListLeft";
//
//        CellCityListLeft *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//        if(cell == nil)
//        {
//            cell = [[CellCityListLeft alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        cell.lblCityName.text = [[_arrCityData valueForKey:@"city_name"]objectAtIndex:indexPath.row];
//
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[[_arrCityData valueForKey:@"cityimage"]objectAtIndex:indexPath.row]]];
//
//        cell.tag = indexPath.row;
//        cell.imgViewCity.image = [UIImage imageNamed:@"Image_Loading"];
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                if (data) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    if (image) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            cell.imgViewCity.image = image;
//                        });
//                    }
//                }
//                else
//                {
//                    cell.imgViewCity.image = [UIImage imageNamed:@"Image_Loading"];
//                }
//            }];
//            [task resume];
//
//        });
//
////        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
////        dispatch_async(qLogo, ^{
////            /* Fetch the image from the server... */
////            NSData *data = [NSData dataWithContentsOfURL:url];
////            UIImage *img = [[UIImage alloc] initWithData:data];
////            if(data)
////            {
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    /* This is the main thread again, where we set the tableView's image to
////                     be what we just fetched. */
////                    cell.imgViewCity.image = img;
////                });
////            }
////        });
//
//        return cell;
//    }
////    else
////    {
////        identifier = @"CellCityListRight";
////
////        CellCityListRight *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
////        if(cell == nil)
////        {
////            cell = [[CellCityListRight alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
////        }
////        cell.lblCityName.text = [[_arrCityData valueForKey:@"city_name"]objectAtIndex:indexPath.row];
////        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[[_arrCityData valueForKey:@"cityimage"]objectAtIndex:indexPath.row]]];
////        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
////        dispatch_async(qLogo, ^{
////            /* Fetch the image from the server... */
////            NSData *data = [NSData dataWithContentsOfURL:url];
////            UIImage *img = [[UIImage alloc] initWithData:data];
////            if(data)
////            {
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    /* This is the main thread again, where we set the tableView's image to
////                     be what we just fetched. */
////                    cell.imgViewCity.image = img;
////                });
////            }
////        });
////
////        return cell;
////    }
////
////    return 0;
//    //etc.
//}
//
//#pragma mark - UITableViewDelegate
//// when user tap the row, what action you want to perform
//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"selected %ld row", (long)indexPath.row);
//}

@end
