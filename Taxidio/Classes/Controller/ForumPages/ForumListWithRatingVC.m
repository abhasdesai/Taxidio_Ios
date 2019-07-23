//
//  ForumListWithRatingVC.m
//  Taxidio
//
//  Created by E-Intelligence on 30/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "ForumListWithRatingVC.h"
#import "HCSStarRatingView.h"

@interface ForumListWithRatingVC ()

@end

@implementation ForumListWithRatingVC
@synthesize strItineraryId,strTripSelected,objForReply,strTripOwnerId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    intStarRating = 0;
    starRatings.value = intStarRating;
    starRatings.allowsHalfStars = YES;
    starRatings.accurateHalfStars = YES;
    starRatings.tintColor = COLOR_ORANGE;
    
    arrData = [[NSMutableArray alloc]init];
    tblViewForumList.separatorStyle = UITableViewCellSelectionStyleNone;
    tblViewForumList.allowsSelection = NO;
    noOfPage = 1;
    total_page = 0;
    [arrData removeAllObjects];
    [self loadForumList:noOfPage];
    starRatings.value = ceil(intStarRating);
    
    lblTripName.text = [NSString stringWithFormat:@"%@",strTripSelected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    txtMessage.delegate = self;
    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //    [self checkLogin];
    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSObject *obj = [arrData objectAtIndex:indexPath.row];
        
        NSString *identifier = @"CellForumList";
        CellForumList *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[CellForumList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    
        cell.btnDelete.tag = indexPath.row;
        cell.btnReply.tag = indexPath.row;
    
        if([[obj valueForKey:@"posted_by"]isEqualToString:[NSString stringWithFormat:@"%@",[Helper getPREF:PREF_UID]]])
        {
            cell.btnDelete.hidden = FALSE;
            [cell.btnDelete addTarget:self action:@selector(pressDeleteForumQuestion:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.btnDelete.hidden = TRUE;
        }
        [cell.btnReply addTarget:self action:@selector(pressReplyForumQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
        cell.viewCellMain.backgroundColor=[UIColor whiteColor];
        [cell.viewCellMain.layer setCornerRadius:5.0f];
        [cell.viewCellMain.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.viewCellMain.layer setBorderWidth:0.2f];
        [cell.viewCellMain.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
        [cell.viewCellMain.layer setShadowOpacity:1.0];
        [cell.viewCellMain.layer setShadowRadius:5.0];
        [cell.viewCellMain.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];

        cell.lblForumQuestionTitle.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"question"]];
        cell.lblAskedByUserName.text = [NSString stringWithFormat:@"Asked By : %@",[obj valueForKey:@"name"]];
        cell.lblComment.text = [NSString stringWithFormat:@"%@ Comments",[obj valueForKey:@"totalcomments"]];
        cell.lblDuration.text = [[NSString stringWithFormat:@"(%@)",[obj valueForKey:@"created"]]capitalizedString];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,[obj valueForKey:@"userimage"]]];
        //dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        //dispatch_async(qLogo, ^{
            /* Fetch the image from the server... */
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if(data)
            {
                //dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imgProfileImage.image = img;
                //});
            }
        //});
    cell.imgProfileImage.layer.cornerRadius = cell.imgProfileImage.frame.size.height / 2.0;
    cell.imgProfileImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.imgProfileImage.layer.borderWidth = 3;
    cell.imgProfileImage.clipsToBounds = true;

        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 200;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - IBACTION METHODS

-(IBAction)pressDeleteForumQuestion:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);

    NSObject *obj = [arrData objectAtIndex:i];
    [self deleteQuestion:obj];
}

-(IBAction)pressReplyForumQuestion:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    objForReply  = [arrData objectAtIndex:i];

    [self performSegueWithIdentifier:@"segueShowReplyToQuestion" sender:self];
}

- (IBAction)pressBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressSubmitRatings:(id)sender
{
    if([self.strTripOwnerId isEqualToString:[Helper getPREF:PREF_UID]])
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"You cannot rate your own trip!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        intStarRating = ceil(starRatings.value);
        [self addUpdateRatingsForItinerary];
    }
}

- (IBAction)pressSendMessage:(id)sender
{
    [self dismissKeyboard];
    if(txtMessage.text.length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addForumQuestion];
        });
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please type your question."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark- ==== WebServiceMethod =======

-(void)addUpdateRatingsForItinerary
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    self.strItineraryId,@"itirnaryid",
                                    [NSString stringWithFormat:@"%f",ceil(intStarRating)],@"rating",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ADD_UPDATE_RATING_FORUM dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];

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

-(void)addForumQuestion
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    self.strItineraryId,@"itirnaryid",
                                    txtMessage.text,@"question",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ADD_FORUM_QUESTION dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    //do something when click button
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                txtMessage.text = @"";
                noOfPage = 0;
                [arrData removeAllObjects];
                [self loadForumList:noOfPage];
                [tblViewForumList reloadData];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [tblViewForumList selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionTop];
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

-(void)loadForumList  : (int)noPage
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [NSString stringWithFormat:@"%d",noPage],@"pageno",
                                    self.strItineraryId,@"itirnaryid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ITINERARIES_FORUM_LIST dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                total_page = [[dicResponce valueForKey:@"total_page"] intValue];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                arr = [dicResponce valueForKey:@"data"];
                for(int i=0;i<arr.count;i++)
                {
                    [arrData addObject:[arr objectAtIndex:i]];
                }
                intStarRating = [[dicResponce valueForKey:@"userrating"] floatValue];
                starRatings.value = ceil(intStarRating);
                
                NSLog(@"%@",arrData);
                if(noOfPage<=total_page)
                    noOfPage+=1;
                [tblViewForumList reloadData];
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

-(void)deleteQuestion : (NSObject*)obj
{
    @try{
        SHOW_AI;
        
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [obj valueForKey:@"id"],@"question_id",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_DELETE_QUESTION dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                [arrData removeAllObjects];
                noOfPage = 1;
                [self loadForumList:noOfPage];
                [tblViewForumList reloadData];
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


#pragma mark - keyboard movements

- (void) keyboardWillShow:(NSNotification *)note {
    //NSDictionary *userInfo = [note userInfo];
    //CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    CGRect kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSLog(@"Keyboard Height: %f Width: %f", kbSize.size.height, kbSize.size.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    
    frame.origin.y = -90;
    [UIView animateWithDuration:0.3 animations:^{
        viewForumList.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
    
    // move the view back to the origin
    
    //if(flagkeyboard == TRUE)
    {
        CGRect frame = self.view.frame;
        frame.origin.y = 170;
        
        [UIView animateWithDuration:0.3 animations:^{
            viewForumList.frame = frame;
        }];
    }
}


-(void)dismissKeyboard {
    [txtMessage resignFirstResponder];
    
    {
        CGRect frame = self.view.frame;
        frame.origin.y = 162;
        
        [UIView animateWithDuration:0.3 animations:^{
            viewForumList.frame = frame;
        }];
    }
    //    CGRect frame = self.view.frame;
    //    frame.origin.y = 176;
    //
    //    [UIView animateWithDuration:0.3 animations:^{
    //    } completion: ^(BOOL finished) {
    //        viewMain.frame = frame;
    //    }];
}
//
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    CGRect kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//
//    NSLog(@"Keyboard Height: %f Width: %f", kbSize.size.height, kbSize.size.width);
//
//    // move the view up by 30 pts
//    CGRect frame = self.view.frame;
//
//
//    NSLog(@"%f",screenHeight);
//
//    if(screenHeight == 736)
//    {
//        if(kbSize.size.height == 271)
//        {
//            frame.origin.y = -202;
//        }
//        else if(kbSize.size.height == 236)
//        {
//            frame.origin.y = -168;
//        }
//        else
//        {
//            frame.origin.y = -158;
//        }
//
//    }
//    else if (screenHeight == 667)
//    {
//        if(kbSize.size.height == 258)
//        {
//            frame.origin.y = -190;
//        }
//        else if (kbSize.size.height == 225)
//        {
//            frame.origin.y = -157;
//        }
//        else
//        {
//            frame.origin.y = -149;
//        }
//    }
//    else
//    {
//        if(kbSize.size.height == 253)
//        {
//            frame.origin.y = -185;
//        }
//        else if(kbSize.size.height == 224)
//        {
//            frame.origin.y = -156;
//        }
//        else if(kbSize.size.height == 258)
//        {
//            frame.origin.y = -190;
//        }
//        else if (kbSize.size.height == 225)
//        {
//            frame.origin.y = -157;
//        }
//        else
//        {
//            frame.origin.y = -149;
//        }
//    }
//    //[UIView animateWithDuration:0.3 animations:^{
//        viewMain.frame = frame;
//    //}];
//}
//
//-(void)keyboardWillHide:(NSNotification *)notification
//{
//    CGRect frame = self.view.frame;
//    frame.origin.y = 162;
//    [UIView animateWithDuration:0.3 animations:^{
//
//    } completion: ^(BOOL finished) {
//        viewMain.frame = frame;
//    }];
//}
//
//-(void)dismissKeyboard {
//    [txtMessage resignFirstResponder];
//
//    CGRect frame = self.view.frame;
//    frame.origin.y = 162;
//
//    [UIView animateWithDuration:0.3 animations:^{
//    } completion: ^(BOOL finished) {
//        viewMain.frame = frame;
//    }];
//}

#pragma mark- ==== TextView Delegate Method =====
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([txtMessage.text isEqualToString:@"Type your question here"])
    {
        txtMessage.text = @"";
    }
    
    NSLog(@"%f",screenHeight);
    // move the view up by 30 pts
    CGRect frame = viewMain.frame;//self.view.frame;
    
    if(screenHeight == 736)
    {
        frame.origin.y = -212;
    }
    else if (screenHeight == 667)
    {
        frame.origin.y = -200;
    }
    else
    {
        frame.origin.y = -195;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        //self.view.frame = frame;

        viewMain.frame = frame;
    }];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(txtMessage.text.length == 0){
        txtMessage.textColor = [UIColor blackColor];
        txtMessage.text = @"Type your question here";
        [txtMessage resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueShowReplyToQuestion"])
    {
        ReplyToForumPageVCViewController *detail = (ReplyToForumPageVCViewController *)[segue destinationViewController];
        detail.objForReply = self.objForReply;
        detail.strItineraryId = self.strItineraryId;
    }
}


@end
