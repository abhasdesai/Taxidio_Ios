//
//  FAQsViewController.m
//  Taxidio
//
//  Created by E-Intelligence on 14/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "FAQsViewController.h"

@interface FAQsViewController ()

@end

@implementation FAQsViewController

@synthesize cellQuestions,cellAnswers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFAQDetails];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self checkLogin];
    //[btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view setNeedsLayout];
    tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tblView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (IBAction)pressClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressMenu:(id)sender
{
    
}
- (IBAction)pressUserProfile:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableView Delegate and Datasource

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dictData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[dictData valueForKey:@"category"] objectAtIndex:section];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, tableView.bounds.size.width-1, 30)];
    [headerView setBackgroundColor:COLOR_ORANGE];
    headerView.layer.borderColor = COLOR_ORANGE.CGColor;
    headerView.layer.borderWidth = 1.0;
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,30)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = [UIFont fontWithName:@"Avenir 45 Book " size:15];
    tempLabel.text=[[dictData valueForKey:@"category"] objectAtIndex:section];
    [headerView addSubview:tempLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

- (IBAction)reload:(id)sender {
    [tblView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrDataForSection = [[dictData valueForKey:@"qa"]objectAtIndex:section];
        return JNExpandableTableViewNumberOfRowsInSection((JNExpandableTableView *)tableView,section,[arrDataForSection count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * adjustedIndexPath = [tblView adjustedIndexPathFromTable:indexPath];
    NSArray *arrDataForSection = [[dictData valueForKey:@"qa"]objectAtIndex:indexPath.section];
    static NSString *CellIdentifier;

    if ([tblView.expandedContentIndexPath isEqual:indexPath])
        CellIdentifier = @"expandedCell";
    else
        CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (id object in cell.contentView.subviews)
    {
        [object removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(([tblView.expandedContentIndexPath isEqual:indexPath]))
    {
//        NSString *strHTML = [NSString stringWithFormat:@"%@",[[arrDataForSection valueForKey:@"answer"] objectAtIndex:adjustedIndexPath.row]];
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[strHTML dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        //@{NSFontAttributeName:[UIFont fontWithName:@"Avenir 45 book" size:15]}
//        cell.textLabel.attributedText = attrStr;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[arrDataForSection valueForKey:@"answer"] objectAtIndex:adjustedIndexPath.row]];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.font = [UIFont fontWithName:@"Avenir 45 Book" size:15];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir 45 Book" size:15];
        cell.textLabel.textColor = [UIColor blackColor];

        cell.textLabel.text = [NSString stringWithFormat:@"\u2022 %@",[[arrDataForSection valueForKey:@"question"] objectAtIndex:adjustedIndexPath.row]];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return cell;
}

#pragma mark JNExpandableTableView DataSource
- (BOOL)tableView:(JNExpandableTableView *)tableView canExpand:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(JNExpandableTableView *)tableView willExpand:(NSIndexPath *)indexPath
{
    NSLog(@"Will Expand: %@",indexPath);
}

- (void)tableView:(JNExpandableTableView *)tableView willCollapse:(NSIndexPath *)indexPath
{
    NSLog(@"Will Collapse: %@",indexPath);
}

#pragma  mark - ==== Label Height and Width Method ====

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
    CGSize size;

    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;

    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));

    return size.height;
}

#pragma mark- ==== WebServiceMethod =======
-(void)loadFAQDetails
{
    @try{
        SHOW_AI;
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_FAQS_LIST];
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
                dictData = [dicResponce valueForKey:@"data"];
                //[arrHeader addObject:[dict valueForKey:@"category"]];
                
                [tblView reloadData];
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
