//
//  BlogViewVC.m
//  Taxidio
//
//  Created by E-Intelligence on 12/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "BlogViewVC.h"

@interface BlogViewVC ()

@end

@implementation BlogViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblView.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
    
    tblView.contentInset = UIEdgeInsetsMake(0, 0, 88, 0);
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //[self checkLogin];
   // [btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    arrData = [[NSMutableArray alloc]init];

    noOfPage = 1;
    total_page = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.tbl reloadData];
        [self GetBlogData:noOfPage];
    });

    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
    isLastElement = FALSE;
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
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"CellBlogView";
    
    CellBlogView *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[CellBlogView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.btnReadMore.tag = indexPath.row;
    [cell.btnReadMore addTarget:self action:@selector(pressReadMore:) forControlEvents:UIControlEventTouchUpInside];

    cell.btnShare.tag = indexPath.row;
    [cell.btnShare addTarget:self action:@selector(pressShare:) forControlEvents:UIControlEventTouchUpInside];

    NSObject *obj = [arrData objectAtIndex:indexPath.row];
    NSString *strDate = [obj valueForKey:@"date"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    cell.lblBlogDate.text = [obj valueForKey:@"date"];
    cell.lblBlogTitle.text = [self convertHtmlPlainText:[obj valueForKey:@"post_custom_title"]];
    cell.lblBlogSubject.text = [obj valueForKey:@"post_custom_categories"];

    cell.viewBlogView.backgroundColor=[UIColor whiteColor];
    [cell.viewBlogView.layer setCornerRadius:5.0f];
    [cell.viewBlogView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.viewBlogView.layer setBorderWidth:1.2f];
    [cell.viewBlogView.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [cell.viewBlogView.layer setShadowOpacity:1.0];
    [cell.viewBlogView.layer setShadowRadius:5.0];
    [cell.viewBlogView.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"featured_image_src"]]];
    cell.tag = indexPath.row;
    cell.imgView.image = [UIImage imageNamed:@"Image_Loading"];
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
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
        
   // });
    
    cell.viewBlogView.backgroundColor=[UIColor whiteColor];
    [cell.viewBlogView.layer setCornerRadius:5.0f];
    [cell.viewBlogView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.viewBlogView.layer setBorderWidth:0.2f];
    [cell.viewBlogView.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [cell.viewBlogView.layer setShadowOpacity:1.0];
    [cell.viewBlogView.layer setShadowRadius:5.0];
    [cell.viewBlogView.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];

    if(([indexPath row] == arrData.count-1)&& isLastElement==false)
    {
        //        if(total_page==0)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self GetBlogData:noOfPage];
            });
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //[self.tbl reloadData];
//                [self GetBlogData:noOfPage];
//            });
        }
    }
    return cell;
}

-(NSString*)convertHtmlPlainText:(NSString*)HTMLString{
    
    NSData *HTMLData = [HTMLString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:HTMLData
                                                                      options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding),NSFontAttributeName : [UIFont fontWithName:@"Arial" size:16.0]}
                                                           documentAttributes:nil error:nil];
    //    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:HTMLData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:NULL error:NULL];
    NSString *plainString = attrString.string;
    return plainString;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == noOfPage - 1 ) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //[self.tbl reloadData];
//            [self GetBlogData:noOfPage++];
//        });
//    }
    
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}

-(void)pressReadMore :(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    
    NSString* url = [NSString stringWithFormat:@"%@",[[arrData valueForKey:@"link"]objectAtIndex:i]];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    //    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];

//     [self performSegueWithIdentifier:@"segueBlogDetails" sender:self];
}

-(IBAction)pressShare:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);

    NSString *strToShare = [[arrData objectAtIndex:i] valueForKey:@"link"];

    NSString *textToShare =[NSString stringWithFormat:@"%@",strToShare];
    
    NSArray* sharedObjects=[NSArray arrayWithObjects:textToShare,  nil];

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;

//    if ([activityViewController isEqualToString:@"net.whatsapp.WhatsApp.ShareExtension"])
//    {
//        NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",textToShare];
//        NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
//        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
//        {
//            [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
//        }
//        else
//        {
//            UIAlertController * alert=   [UIAlertController
//                                          alertControllerWithTitle:@"WhatsApp not installed."
//                                          message:@"Your device has no WhatsApp installed."
//                                          preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//            }];
//            [alert addAction:okAction];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark- ==== WebServiceMethod =======
#pragma mark - STARTING POINT WEB-SERVICE

-(void)GetBlogData : (int)noPage
{
    @try{
        SHOW_AI;
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://taxidio.com/blog/wp-json/wp/v2/posts?page=%d",noPage]];
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
            //dictData = [dictData valueForKey:@"data"];
        HIDE_AI;
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        arr = [dictData mutableCopy];;//[[dictData valueForKey:@"data"] mutableCopy];
        
        NSLog(@"--->>>%@",arr);
        if(arr.count>0)
        {
            for(int i=0;i<arr.count;i++)
            {
                [arrData addObject:[arr objectAtIndex:i]];
            }
        }
        if(arr.count==0)
        {
            isLastElement = true;
        }
            [arrData removeObjectIdenticalTo:[NSNull null]];
        if(arr.count>0)
        {
            noOfPage+=1;
        }
        else
        {
            total_page++;
        }
        [tblView reloadData];
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
    if([[segue identifier] isEqualToString:@"segueBlogDetails"])
    {
        BlogDetailsVC *detail = (BlogDetailsVC *)[segue destinationViewController];
        detail.arrData = _arrDataSelected;
    }
}

@end
