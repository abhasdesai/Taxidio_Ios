//
//  HotelViewVC.m
//  Taxidio
//
//  Created by E-Intelligence on 11/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "HotelViewVC.h"
#import "LeftCellHotel.h"

@interface HotelViewVC ()

@end

@implementation HotelViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    noOfPage = 1;
    total_page = 0;
    _arrData = [[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadHotelDetails:noOfPage];
    });
    lblCityName.text = [NSString stringWithFormat:@"Hotels in %@",self.strCityName];
    isLastElement = false;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    [self checkLogin];
        self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

-(void)checkLogin
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        [btnUserMenu addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        self.revealViewController.panGestureRecognizer.enabled = TRUE;
    }
    else
    {
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
        self.revealViewController.panGestureRecognizer.enabled = FALSE;
   }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
        identifier = @"LeftCellHotel";
        LeftCellHotel *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if(cell == nil)
        {
            cell = [[LeftCellHotel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    
//    for (id object in cell.contentView.subviews)
//    {
//        [object removeFromSuperview];
//    }
    
    NSObject *objHotelData = [[NSObject alloc]init];
    objHotelData = [_arrData objectAtIndex:indexPath.row];
    cell.lblTitle.text = [objHotelData valueForKey:@"hotel_name"];
    NSString *strMinPrice = [objHotelData valueForKey:@"minrate"];
    NSString *strMaxPrice = [objHotelData valueForKey:@"maxrate"];
    NSString *strPrice = @"";
    if(strMaxPrice.length>0)
        strPrice = [NSString stringWithFormat:@"%@ %@-%@",[objHotelData valueForKey:@"currencycode"],strMinPrice,strMaxPrice];
    cell.lblPrice.text = [NSString stringWithFormat:@"%@",strPrice];
    cell.txtAddress.text = [objHotelData valueForKey:@"address"];
    
    NSString *strimge =[NSString stringWithFormat:@"%@",[objHotelData valueForKey:@"photo_url"]];
    
//    NSString *strimge = [NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[[arrDestinationData valueForKey:@"countryimage"]objectAtIndex:indexPath.row]];
    
    strimge = [strimge stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:strimge];
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

    
//    strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    NSURL *url = [NSURL URLWithString:strurl];
//    dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    dispatch_async(qLogo, ^{
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *img = [[UIImage alloc] initWithData:data];
//        if(data)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                cell.imgView.image = img;
//            });
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [cell.imgView setImage:[UIImage imageNamed:@"no_image_attraction.jpg"]];
//            });
//        }
//    });
    
    cell.tag = indexPath.row;

    cell.btnBookNow.tag = indexPath.row;
    cell.btnInfo.tag = indexPath.row;
    cell.btnMap.tag = indexPath.row;
    
    [cell.btnBookNow addTarget:self action:@selector(pressBookNow:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnInfo addTarget:self action:@selector(pressInfo:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMap addTarget:self action:@selector(pressShowMap:) forControlEvents:UIControlEventTouchUpInside];

    if(([indexPath row] == _arrData.count-1)&& isLastElement==false)
    {
        //if(noOfPage<=total_page)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadHotelDetails:noOfPage];
            });
        }
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//     if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
}

#pragma mark - IBACTION METHODS


-(IBAction)pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressDoneMap:(id)sender {
}

-(IBAction)pressInfo:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    NSString *strDescription = [[_arrData valueForKey:@"description"]objectAtIndex:i];
    NSString *strHotelName = [[_arrData valueForKey:@"hotel_name"]objectAtIndex:i];

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:[NSString stringWithFormat:@"%@",strHotelName]
                                  message:strDescription
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)pressBookNow:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    NSString* url = [NSString stringWithFormat:@"%@",[[_arrData valueForKey:@"hotel_url"]objectAtIndex:i]];
    url = [NSString stringWithFormat:@"%@?aid=1219471",url];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    //    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (IBAction)pressShowMap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;

    double strLatitude = [[[_arrData valueForKey:@"latitude"]objectAtIndex:i]doubleValue];
    double strLongitude = [[[_arrData valueForKey:@"longitude"]objectAtIndex:i]doubleValue];
    
    NSString* versionNum = [[UIDevice currentDevice] systemVersion];
    NSString *nativeMapScheme = @"maps.apple.com";
    if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending){
        nativeMapScheme = @"maps.google.com";
    }
    NSString* url = [NSString stringWithFormat:@"http://%@/maps?q=%f,%f", nativeMapScheme, strLatitude, strLongitude];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
//    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}


#pragma mark- ==== WebServiceMethod =======
-(void)loadHotelDetails : (int)noPage
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.strCityId,@"cityid",
                                    self.strCitySlug,@"cityslug",
                                    self.strCityName,@"city_name",
                                    [NSString stringWithFormat:@"%d",noPage],@"pageno",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_HOTEL_GET_DETAILS dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            HIDE_AI;
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
                total_page = [[dicResponce valueForKey:@"total_page"] intValue];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                arr = [dicResponce valueForKey:@"data"];
                if(arr.count==0)
                {
                    isLastElement = true;
                }

                for(int i=0;i<arr.count;i++)
                {
                    [_arrData addObject:[arr objectAtIndex:i]];
                }
                //NSLog(@"%@",_arrData);
                if(noOfPage<=total_page)
                    noOfPage+=1;
                
                if(_arrData.count>0)
                {
                    [tblView reloadData];
                }
                else
                {
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:@"No Hotels found for the loation selected."
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        //do something when click button
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
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

@end
