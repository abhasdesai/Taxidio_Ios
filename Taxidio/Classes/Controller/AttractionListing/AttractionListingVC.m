//
//  AttractionListingVC.m
//  Taxidio
//
//  Created by E-Intelligence on 20/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "AttractionListingVC.h"

@interface AttractionListingVC ()

@end

@implementation AttractionListingVC
@synthesize strCityName, strLatitude, strLongitude;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc]init];
    lblCityName.text = [NSString stringWithFormat:@"Attractions in %@",strCityName];//
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.tbl reloadData];
        [self GetAttractionData : strCityName:strLatitude:strLongitude];
        //    [self GetAttractionData : @"Bruges":@"51.2093":@"3.2247"];
        [tblViewAttractionList reloadData];
    });
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    [self checkLogin];
        self.revealViewController.panGestureRecognizer.enabled = FALSE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressUserProfile:(id)sender {
}

#pragma mark - STARTING POINT WEB-SERVICE

-(void)GetAttractionData :(NSString *)city :(NSString*)lat :(NSString*)lng
{
    @try{
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.getyourguide.com/1/tours?q=%@&cnt_language=en&currency=USD&limit=500&access_token=TpY7sMc0qjBYso2ifXBBBpBqaIw32ToT8yH66yyfK0mkIrHp&coordinates[lat]=%@&coordinates[long]=%@",city,lat,lng]];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *error;
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *sResponce = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"sResponce : ::: : %@",sResponce);
        
        NSDictionary *dictData = [self convertResponceJSON:sResponce];
        NSLog(@"sResponce : ::: : %@",dictData);
        arrData = [dictData valueForKey:@"data"];//[dictData mutableCopy];
        arrData = [arrData valueForKey:@"tours"];
        
        //HIDE_AI
        // SHOW_AI;
        HIDE_AI;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
//    if(indexPath.row % 2 == 0)
    {
        identifier = @"CellLeftAttraction";
    }
//    else
//    {
//        identifier = @"CellRightAttraction";
//    }
    
//    if(indexPath.row % 2 == 0)
    {
        CellLeftAttraction *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if(cell == nil)
        {
            cell = [[CellLeftAttraction alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.viewMain.backgroundColor=[UIColor clearColor];
        [cell.viewMain.layer setCornerRadius:5.0f];
        [cell.viewMain.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.viewMain.layer setBorderWidth:0.2f];
        [cell.viewMain.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
        [cell.viewMain.layer setShadowOpacity:1.0];
        [cell.viewMain.layer setShadowRadius:5.0];
        [cell.viewMain.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
        
        NSObject *obj = [arrData objectAtIndex:indexPath.row];
        
        cell.lblAttractionName.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"title"]];
        cell.lblPrice.text = [NSString stringWithFormat:@"US$ %@",[[[obj valueForKey:@"price"] valueForKey:@"values"] valueForKey:@"amount"]];
        float intStarRating = [[obj valueForKey:@"overall_rating"]floatValue];
        cell.starRatingView.value = intStarRating;
        cell.starRatingView.allowsHalfStars = YES;
        cell.starRatingView.tintColor = COLOR_ORANGE;
        cell.starRatingView.userInteractionEnabled = FALSE;
//        for (int i = 0; i<intStarRating; i++)
//        {
//            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((15*i+10), 3, 10, 10)];
//
//            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star.png"]]];
//            [cell.imgViewStarRating addSubview:imageView];
//        }
        cell.lblUserReviews.text =  [NSString stringWithFormat:@"%@ Reviews",[obj valueForKey:@"number_of_ratings"]];
        cell.lblDuration.text = [NSString stringWithFormat:@"Duration:%@ %@",[[[obj valueForKey:@"durations"]valueForKey:@"duration"]objectAtIndex:0],[[[obj valueForKey:@"durations"]valueForKey:@"unit"]objectAtIndex:0]];
        
        NSString *strImgPath = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"pictures"]valueForKey:@"url"]];
        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"[format_id]" withString:@"75"];
        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"(" withString:@""];
        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@")" withString:@""];
        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@" " withString:@""];
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",strImgPath]];
        
        cell.tag = indexPath.row;
        cell.imgView.image = [UIImage imageNamed:@"Image_Loading"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.imgView.image = image;
                        });
                    }
                }
                else
                {
                    cell.imgView.image = [UIImage imageNamed:@"Image_Loading"];
                }
            }];
            [task resume];
            
        });

//        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(qLogo, ^{
//            /* Fetch the image from the server... */
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            UIImage *img = [[UIImage alloc] initWithData:data];
//            if(data)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.imgView.image = img;
//                });
//            }
//        });
        
        cell.btnBookNow.tag = indexPath.row;
        [cell.btnBookNow addTarget:self action:@selector(pressReadMore:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
//    else
//    {
//        CellRightAttraction *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//        if(cell == nil)
//        {
//            cell = [[CellRightAttraction alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        cell.viewMain.backgroundColor=[UIColor clearColor];
//        [cell.viewMain.layer setCornerRadius:5.0f];
//        [cell.viewMain.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        [cell.viewMain.layer setBorderWidth:0.2f];
//        [cell.viewMain.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
//        [cell.viewMain.layer setShadowOpacity:1.0];
//        [cell.viewMain.layer setShadowRadius:5.0];
//        [cell.viewMain.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
//        
//        NSObject *obj = [arrData objectAtIndex:indexPath.row];
//        
//        cell.lblAttractionName.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"title"]];
//        cell.lblPrice.text = [NSString stringWithFormat:@"US$ %@",[[[obj valueForKey:@"price"] valueForKey:@"values"] valueForKey:@"amount"]];
//        float intStarRating = [[obj valueForKey:@"overall_rating"]floatValue];
//        cell.starRatingView.value = intStarRating;
//        cell.starRatingView.allowsHalfStars = YES;
//        cell.starRatingView.tintColor = COLOR_ORANGE;
//
////        for (int i = 0; i<intStarRating; i++)
////        {
////            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((15*i+10), 3, 10, 10)];
////
////            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star.png"]]];
////            [cell.imgViewStarRating addSubview:imageView];
////        }
//        cell.lblUserReviews.text =  [NSString stringWithFormat:@"%@ Reviews",[obj valueForKey:@"number_of_ratings"]];
//        cell.lblDuration.text = [NSString stringWithFormat:@"Duration:%@ %@",[[[obj valueForKey:@"durations"]valueForKey:@"duration"]objectAtIndex:0],[[[obj valueForKey:@"durations"]valueForKey:@"unit"]objectAtIndex:0]];
//        
//        NSString *strImgPath = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"pictures"]valueForKey:@"url"]];
//        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"[format_id]" withString:@"75"];
//        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"(" withString:@""];
//        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@")" withString:@""];
//        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        strImgPath = [strImgPath stringByReplacingOccurrencesOfString:@" " withString:@""];
//        
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",strImgPath]];
//        cell.tag = indexPath.row;
//        cell.imgView.image = [UIImage imageNamed:@"Image_Loading"];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                if (data) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    if (image) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                            cell.imgView.image = image;
//                        });
//                    }
//                }
//                else
//                {
//                    cell.imgView.image = [UIImage imageNamed:@"Image_Loading"];
//                }
//            }];
//            [task resume];
//            
//        });
//
//        cell.btnBookNow.tag = indexPath.row;
//        [cell.btnBookNow addTarget:self action:@selector(pressReadMore:) forControlEvents:UIControlEventTouchUpInside];
//        
//        return cell;
//    }
//    return 0;
}

-(void)pressReadMore :(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    NSString* url = [NSString stringWithFormat:@"%@",[[arrData valueForKey:@"url"]objectAtIndex:i]];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    //    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

@end
