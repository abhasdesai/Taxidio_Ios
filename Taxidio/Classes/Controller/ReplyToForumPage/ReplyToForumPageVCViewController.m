//
//  ReplyToForumPageVCViewController.m
//  Taxidio
//
//  Created by E-Intelligence on 07/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "ReplyToForumPageVCViewController.h"

@interface ReplyToForumPageVCViewController ()

@end

@implementation ReplyToForumPageVCViewController
@synthesize strItineraryId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _arrData = [[NSMutableArray alloc]init];
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    NSLog(@"%@",self.objForReply);
    NSURL *url;
    if([[self.objForReply valueForKey:@"socialimage"]isEqualToString:@""])
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.objForReply valueForKey:@"userimage"]]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.objForReply valueForKey:@"socialimage"]]];
    
    lblDuration.text = [NSString stringWithFormat:@"(%@)",[[self.objForReply valueForKey:@"created"]capitalizedString]];
    txtQuestionTitle.text = [NSString stringWithFormat:@"%@",[self.objForReply valueForKey:@"question"]];
    lblAskedBy.text = [NSString stringWithFormat:@"Asked By: %@",[self.objForReply valueForKey:@"name"]];

    //dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    //dispatch_async(qLogo, ^{
    /* Fetch the image from the server... */
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    if(data)
    {
        //dispatch_async(dispatch_get_main_queue(), ^{
        imgView.image = img;
        //});
    }
    //});
    imgView.layer.cornerRadius = imgView.frame.size.height / 2.0;
    imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    imgView.layer.borderWidth = 2;
    imgView.clipsToBounds = true;
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    txtReplyToSend.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self loadCommentsForQuestion];
    
//    self.statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
//    self.statusWindow.windowLevel = UIWindowLevelStatusBar + 1;
//    self.statusWindow.hidden = NO;
//    self.statusWindow.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:56.0/255.0 blue:107.0/255.0 alpha:1.0];
//    [self.statusWindow makeKeyAndVisible];
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

#pragma mark - IBACTION METHODS

- (IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressSendReply:(id)sender
{
    [self dismissKeyboard];
    if(txtReplyToSend.text.length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addCommentToQuestion];
        });
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please type your reply."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - IBACTION METHODS

-(IBAction)pressDeleteComment:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    NSObject *obj = [_arrData objectAtIndex:i];
    [self deleteCommentsForQuestion:obj];
}

-(IBAction)pressEditComment:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @""
                                                                              message: @"Edit your comment:"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = [NSString stringWithFormat:@"%@",[[_arrData objectAtIndex:i]valueForKey:@"comment"]];
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    NSArray * textfields = alertController.textFields;
                                    UITextField * namefield = textfields[0];
                                    NSLog(@"%@",namefield.text);
                                    [self editCommentToQuestion:namefield.text: [[_arrData objectAtIndex:i]valueForKey:@"id"]];
                                }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                {
                                }]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - UITABLEVIEW METHODS

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
    static NSString *cellIdentifier = @"CellReplyToQuestion";
    CellReplyToQuestion *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[CellReplyToQuestion alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.viewBG.backgroundColor=[UIColor whiteColor];
    [cell.viewBG.layer setCornerRadius:5.0f];
    [cell.viewBG.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.viewBG.layer setBorderWidth:0.2f];
    [cell.viewBG.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [cell.viewBG.layer setShadowOpacity:1.0];
    [cell.viewBG.layer setShadowRadius:5.0];
    [cell.viewBG.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    
    NSObject *obj = [_arrData objectAtIndex:indexPath.row];
    
    NSURL *url;
    if([[self.objForReply valueForKey:@"socialimage"]isEqualToString:@""])
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,[obj valueForKey:@"userimage"]]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,[obj valueForKey:@"socialimage"]]];

//    dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    dispatch_async(qLogo, ^{
    /* Fetch the image from the server... */
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
        if(data)
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
            cell.imgProfile.image = img;
//            });
        }
//    });

    cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2.0;
    cell.imgProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imgProfile.layer.borderWidth = 2;
    cell.imgProfile.clipsToBounds = true;

    NSMutableString *strDuration = [self calculateTime:[obj valueForKey:@"created"]];
    NSString *strTimeDuration = [strDuration copy];
    strTimeDuration = [strTimeDuration stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    cell.txtQuestion.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"comment"]];
    cell.lblAskedBy.text = [NSString stringWithFormat:@"Asked By : %@",[obj valueForKey:@"name"]];
    
    cell.lblDuration.text = [NSString stringWithFormat:@"(%@ Ago)",strTimeDuration];
    
    if([[obj valueForKey:@"sender_id"]isEqualToString:[NSString stringWithFormat:@"%@",[Helper getPREF:PREF_UID]]])
    {
        cell.btnDeleteReply.hidden = FALSE;
        cell.btnEditReply.hidden = FALSE;
        cell.btnEditReply.tag = indexPath.row;
        cell.btnDeleteReply.tag = indexPath.row;
        
        [cell.btnDeleteReply addTarget:self action:@selector(pressDeleteComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEditReply addTarget:self action:@selector(pressEditComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.btnDeleteReply.hidden = TRUE;
        cell.btnEditReply.hidden = TRUE;
    }

    [cell layoutIfNeeded];
    return cell;
}

-(NSMutableString*) calculateTime :(NSString*)strDate
{
    NSMutableString *timeLeft = [[NSMutableString alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    
    NSString *strCurrentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate* todayDate = [dateFormatter dateFromString:strCurrentDate];
    
    NSDate *dateDB = [dateFormatter dateFromString:strDate];

    NSTimeInterval seconds = [todayDate timeIntervalSinceDate:dateDB];
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    if(days) {
        [timeLeft appendString:[NSString stringWithFormat:@"%ld Days", (long)days*-1]];
    }
    
    if(hours) {
        [timeLeft appendString:[NSString stringWithFormat: @"%ld Hours", (long)hours*-1]];
    }
    
    if(minutes) {
        [timeLeft appendString: [NSString stringWithFormat: @"%ld Minutes",(long)minutes*-1]];
    }
    
//    if(seconds) {
//        [timeLeft appendString:[NSString stringWithFormat: @"%ld seconds", (long)seconds*-1]];
//    }
    return timeLeft;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - keyboard movements
//
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    CGRect kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//
//    NSLog(@"Keyboard Height: %f Width: %f", kbSize.size.height, kbSize.size.width);
//
//    // move the view up by 30 pts
//    CGRect frame = viewMessage.frame;
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
//    viewMain.frame = frame;
//    //}];
//}
//
//-(void)keyboardWillHide:(NSNotification *)notification
//{
//    CGRect frame = viewMessage.frame;
//    frame.origin.y = self.view.frame.size.height-50;
//    [UIView animateWithDuration:0.3 animations:^{
//
//    } completion: ^(BOOL finished) {
//        viewMessage.frame = frame;
//    }];
//}


- (void) keyboardWillShow:(NSNotification *)note {
    //NSDictionary *userInfo = [note userInfo];
    //CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    CGRect kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    NSLog(@"Keyboard Height: %f Width: %f", kbSize.size.height, kbSize.size.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    
    frame.origin.y = -90;
    [UIView animateWithDuration:0.3 animations:^{
        viewMain.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
    
    // move the view back to the origin
    
    //if(flagkeyboard == TRUE)
    {
        CGRect frame = self.view.frame;
        frame.origin.y = 162;
        
        [UIView animateWithDuration:0.3 animations:^{
            viewMain.frame = frame;
        }];
    }
}


-(void)dismissKeyboard {
    [txtReplyToSend resignFirstResponder];

    {
        CGRect frame = self.view.frame;
        frame.origin.y = 162;
        
        [UIView animateWithDuration:0.3 animations:^{
            viewMain.frame = frame;
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

#pragma mark- ==== TextView Delegate Method =====
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([txtReplyToSend.text isEqualToString:@"Type your question here"])
    {
        txtReplyToSend.text = @"";
    }
    
    NSLog(@"%f",screenHeight);
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    
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
    if(txtReplyToSend.text.length == 0){
        txtReplyToSend.textColor = [UIColor blackColor];
        txtReplyToSend.text = @"Type your question here";
        [txtReplyToSend resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark- ==== WebServiceMethod =======
-(void)loadCommentsForQuestion
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [self.objForReply valueForKey:@"id"],@"question_id",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_FORUM_REPLY dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
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
                    
                    //do something when click button
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                _arrData  = [dicResponce valueForKey:@"data"];
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

-(void)deleteCommentsForQuestion : (NSObject*)obj
{
    @try{
        SHOW_AI;
        
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [self.objForReply valueForKey:@"id"],@"question_id",
                                    [obj valueForKey:@"id"],@"answer_id",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_DELETE_COMMENT_QUESTION dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
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
                    
                    //do something when click button
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                [_arrData removeAllObjects];
               [self loadCommentsForQuestion];
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

-(void)addCommentToQuestion
{
    @try{
        SHOW_AI;
        //userid,itirnaryid,question_id,usercomment
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    txtReplyToSend.text,@"usercomment",
                                    self.strItineraryId,@"itirnaryid",
                                    [self.objForReply valueForKey:@"id"],@"question_id",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ADD_COMMENT dicParams:Parameters];
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
                txtReplyToSend.text = @"";
                [_arrData removeAllObjects];
                [self loadCommentsForQuestion];
                [tblView reloadData];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [tblView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionTop];
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

-(void)editCommentToQuestion : (NSString*)strComment :(NSString*)strAns_id
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    strComment,@"usercomment",
                                    strAns_id,@"answer_id",
                                    [self.objForReply valueForKey:@"id"],@"question_id",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_COMMENT dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
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
                    
                    //do something when click button
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                txtReplyToSend.text = @"";
                [_arrData removeAllObjects];
                [self loadCommentsForQuestion];
                [tblView reloadData];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [tblView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionTop];
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
