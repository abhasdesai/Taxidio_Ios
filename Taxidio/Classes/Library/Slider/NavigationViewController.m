//
//  NavigationViewController.m
//  NavjotDemo
//
//  Created by emenglobal on 10/27/15.
//  Copyright © 2015 Hemant. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"

@interface NavigationViewController (){
    NSArray *menu;
}
@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     menu = @[@"Home",@"Discover Taxidio", @"Destination", @"Hotels",@"Attractions", @"Blog",@"Planned Itinerary",@"FAQs", @"Privacy Policy"];
    
    //scroll designing
    self.tableView.separatorColor = [UIColor whiteColor];
    self.view.layer.borderWidth = .6;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
 
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    // for Backgound Image
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
//    self.tableView.backgroundView = imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menu count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    if(indexPath.row==3)
    {
        NSString* url = [NSString stringWithFormat:@"https://www.taxidio.com/hotel-search-engine"];
        NSURL *URL = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    }
    else if(indexPath.row==4)
    {
        NSString* url = [NSString stringWithFormat:@"https://www.taxidio.com/discount-attraction-tickets"];
        NSURL *URL = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    }
    else if(indexPath.row==7)
    {
        NSString* url = [NSString stringWithFormat:@"https://www.taxidio.com/faq"];
        NSURL *URL = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    }
    else if(indexPath.row==8)
    {
        NSString* url = [NSString stringWithFormat:@"https://www.taxidio.com/policies"];
        NSURL *URL = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[menu objectAtIndex:indexPath.row]];
    // Configure the cell...
    //cell.imageView.image = [UIImage imageNamed:@"Birthday"];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return imgHeader;
    return @"   ";
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection: (NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView.backgroundColor = [UIColor whiteColor];

    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    UIImageView *imgHeader;
    if(screenHeight == 480 || screenHeight == 568)
        imgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(30,0,215,100)];
    else
        imgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(50,0,215,100)];
    
    imgHeader.image = [UIImage imageNamed:@"taxidio_banner"];
    //header.frame = CGRectMake(0,0,108,50);
    [header.contentView addSubview:imgHeader];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}

@end
