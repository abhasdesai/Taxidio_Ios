//
//  DestinationListingVC.m
//  Taxidio
//
//  Created by E-Intelligence on 25/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "DestinationListingVC.h"

@interface DestinationListingVC ()

@end

@implementation DestinationListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrDestinationData = [[NSMutableArray alloc]init];
    noOfSection = 3;
    
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
    
    viewCityListing.layer.borderWidth = 5;
    viewCityListing.layer.borderColor = [UIColor darkGrayColor].CGColor;
    viewCityListing.layer.cornerRadius = 10;
    viewCityListing.clipsToBounds = YES;
    viewCityListing.hidden = TRUE;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //[self checkLogin];
    //[btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self loadDestinationDetails];
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-40;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-40;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDialog)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.view.userInteractionEnabled = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self checkLogin];
    //    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}


-(void)closeDialog
{
    [viewCityListing setHidden:TRUE];
}
-(void)checkLogin
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        [btnUserMenu addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        self.revealViewController.panGestureRecognizer.enabled = TRUE;
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
    }
}


#pragma mark - CollectionView Method ===

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrDestinationData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DestinationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imgDestination.image = [UIImage imageNamed:@"Image_Loading"];

    NSString *strimge = [NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[[arrDestinationData valueForKey:@"countryimage"]objectAtIndex:indexPath.row]];
    
    strimge = [strimge stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:strimge];
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
    
    NSString *strTitle = [[arrDestinationData valueForKey:@"country_name"]objectAtIndex:indexPath.row];
    cell.lblDestination.text = strTitle;
    cell.lblDestination.textColor = [UIColor whiteColor];
    cell.lblDestination.font = FONT_AVENIR_45_BOOK_SIZE_15;
    
    cell.imgDestination.layer.cornerRadius = 10;
    cell.imgDestination.clipsToBounds = YES;

    cell.viewBG.layer.cornerRadius = 10;
    cell.viewBG.clipsToBounds = YES;
    
    cell.btnViewCities.layer.borderColor = COLOR_ORANGE.CGColor;
    cell.btnViewCities.layer.borderWidth = 1.0;
    cell.btnViewCities.layer.cornerRadius = 5.0;
    [cell.btnViewCities.layer setMasksToBounds: YES];
    
    cell.btnViewCities.tag = indexPath.row;
    [cell.btnViewCities addTarget:self action:@selector(pressViewCities:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(IBAction)pressViewCities:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    viewCityListing.hidden = FALSE;
    lblCountryName.text = [[arrDestinationData valueForKey:@"country_name"] objectAtIndex:i];
    arrCityNames = [[arrDestinationData valueForKey:@"cities"]objectAtIndex:i];
    
    NSArray *arrCityName = [arrCityNames valueForKey:@"city_name"];
    UILabel *lblCityName;
    
    int x = 0;
    for(UIView *subview in [scrollCityName subviews]) {
        [subview removeFromSuperview];
    }
    
    int y = 0;
    scrollCityName.backgroundColor = [UIColor clearColor];
    for( int i = 0; i < arrCityName.count; i++)
    {
        NSString *strTitle = [NSString stringWithFormat:@"%@",[arrCityName objectAtIndex:i]];
        CGSize stringsize = [strTitle sizeWithAttributes:
                             @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
        
        lblCityName=[[UILabel alloc]init];//WithFrame:CGRectMake(x, y , 60, 30)];
        lblCityName.numberOfLines=0;
        lblCityName.font = FONT_AVENIR_45_BOOK_SIZE_12;
        lblCityName.textColor = [UIColor darkGrayColor];
        lblCityName.layer.borderColor = [UIColor orangeColor].CGColor;
        lblCityName.layer.borderWidth = 1.0;
//        lblCityName.backgroundColor = [UIColor orangeColor];
        lblCityName.text = [arrCityName objectAtIndex:i];
        lblCityName.numberOfLines = 1;
        lblCityName.textAlignment = NSTextAlignmentCenter;
        
        [lblCityName setFrame:CGRectMake(x,y,stringsize.width+50,30)];
        lblCityName.alpha = 1.0;
        //        lblCityName.titleEdgeInsets = UIEdgeInsetsMake(5, 8,5, 8);
        lblCityName.tag = i;
        
        [scrollCityName addSubview:lblCityName];
        
        //        x += stringsize.width +50;
        y += 40;//stringsize.width +50;
        
        //        x += 70;
    }
    //    scrollCityName.contentSize = CGSizeMake(x + 100,35);
    scrollCityName.contentSize = CGSizeMake(x ,y+50);
    
    
    //    [tblViewCityListing reloadData];

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

#pragma mark - UITABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [arrCityNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[arrCityNames valueForKey:@"city_name"] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pressCloseDialog:(id)sender {
    [viewCityListing setHidden:TRUE];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    id object = [arrCityNames objectAtIndex:fromIndexPath.item];
    [arrCityNames removeObjectAtIndex:fromIndexPath.item];
    [arrCityNames insertObject:object atIndex:toIndexPath.item];
}

#pragma mark- ==== WebServiceMethod =======
-(void)loadDestinationDetails
{
    @try{
        SHOW_AI;
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_DESTINATION_LIST];
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
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                arrDestinationData = [dicResponce valueForKey:@"data"];
                [allcollectionView reloadData];
                //[arrHeader addObject:[dict valueForKey:@"category"]];
                
                //[tblView reloadData];
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
