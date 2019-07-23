//
//  CoTravellerDataViewController.m
//  Taxidio
//
//  Created by Jitesh Keswani on 03/10/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import "CoTravellerDataViewController.h"

@interface CoTravellerDataViewController ()

@end

@implementation CoTravellerDataViewController
@synthesize arrCoTravellerDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblView.allowsSelection = FALSE;
    self.tblView.backgroundColor = [UIColor clearColor];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    [self.tblView reloadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrCoTravellerDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    identifier = @"CoTravellerTableViewCell";
    CoTravellerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[CoTravellerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

//    for (id object in cell.contentView.subviews)
//    {
//        [object removeFromSuperview];
//    }
//
    NSString *strName   = [[self.arrCoTravellerDetails valueForKey:@"name"]objectAtIndex:indexPath.row];
    NSString *strDOB    = [[self.arrCoTravellerDetails valueForKey:@"dob"]objectAtIndex:indexPath.row];
    NSString *strGender = [[self.arrCoTravellerDetails valueForKey:@"gender"]objectAtIndex:indexPath.row];
    NSString *strEmail  = [[self.arrCoTravellerDetails valueForKey:@"email"]objectAtIndex:indexPath.row];
    
    if([strGender isEqualToString:@"1"])
        strGender = @"Male";
    else if([strGender isEqualToString:@"2"])
        strGender = @"Female";
    NSString *display_string=[NSString stringWithFormat:@"Name : %@",strName];
    NSMutableAttributedString *attri_str=[[NSMutableAttributedString alloc]initWithString:display_string];
    long begin=0;//-[strName length];
    long end=[display_string length]-[strName length];//[strName length];
    [attri_str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] range:NSMakeRange(begin, end)];

    NSString *display_string2=[NSString stringWithFormat:@"Date of Birth : %@",strDOB];
    NSMutableAttributedString *attri_str2 =[[NSMutableAttributedString alloc]initWithString:display_string2];
    long begin2=0;//-[strName length];
    long end2=[display_string2 length]-[strDOB length];//[strName length];
    [attri_str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] range:NSMakeRange(begin2, end2)];

    NSString *display_string3 = [NSString stringWithFormat:@"Gender : %@",strGender];
    NSMutableAttributedString *attri_str3 = [[NSMutableAttributedString alloc]initWithString:display_string3];
    long begin3 = 0;//-[strName length];
    long end3 = [display_string3 length]-[strGender length];//[strName length];
    [attri_str3 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] range:NSMakeRange(begin3, end3)];

    NSString *display_string4 = [NSString stringWithFormat:@"Email ID : %@",strEmail];
    NSMutableAttributedString *attri_str4 = [[NSMutableAttributedString alloc]initWithString:display_string4];
    long begin4 = 0;//-[strName length];
    long end4 = [display_string4 length]-[strEmail length];//[strName length];
    [attri_str4 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] range:NSMakeRange(begin4, end4)];

    cell.lblName.attributedText = attri_str;
    cell.lblDOB.attributedText =attri_str2;
    cell.lblGender.attributedText =attri_str3;
    cell.lblEmailId.attributedText = attri_str4;

    return cell;
}

@end
