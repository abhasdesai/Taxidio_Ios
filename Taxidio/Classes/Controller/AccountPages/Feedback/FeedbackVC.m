//
//  FeedbackVC.m
//  Taxidio
//
//  Created by E-Intelligence on 13/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenwidth = screenRect.size.width;
    
    txtFeedback.layer.cornerRadius=5;
    txtFeedback.layer.borderWidth=1.0;
    txtFeedback.layer.borderColor = [UIColor darkGrayColor].CGColor;
    txtFeedback.layer.masksToBounds = YES;
    txtFeedback.textColor = [UIColor blackColor];

    txtSubject.layer.cornerRadius=5;
//    txtSubject.layer.borderWidth=1.0;
//    txtSubject.layer.borderColor = [UIColor whiteColor].CGColor;
    txtSubject.layer.masksToBounds = YES;
    txtSubject.textColor = [UIColor blackColor];
    
    txtSubject.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Subject" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setBottomBorder:txtSubject];
    
    txtFeedback.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Message" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressSubmitFeedback:(id)sender {
    [self addFeedbackDetails];
}

#pragma mark- ==== TextView Delegate Method =====
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:viewMainView];
    pt = rc.origin;
    pt.x = 0;
    
    if(screenHeight == 480)
    {
        pt.y -=40;
    }
    
    if(screenHeight == 568)
    {
        pt.y -=60;
    }
    
    if(screenHeight == 667)
    {
        pt.y -=150;
    }
    
//    if([txtFeedback.text isEqualToString:@"Enter your message"])
//    {
//        txtFeedback.text = @"";
//    }
    
    return YES;
}


-(void)dismissKeyboard {
    [txtSubject resignFirstResponder];
    [txtFeedback resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


#pragma mark - keyboard movements

- (void)keyboardWillShow:(NSNotification *)notification
{
    //    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -0;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(txtFeedback.text.length == 0){
        txtFeedback.textColor = [UIColor blackColor];
        //txtFeedback.text = @"Enter your message";
        [txtFeedback resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    
    return YES;
    
    //    [textView scrollRangeToVisible:range];
    //    return YES;
}

#pragma mark - FORMAT METHODS

-(void)setBottomBorder : (UITextField*) txtfield
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, txtfield.frame.size.height - 1, txtfield.frame.size.width, 5.0f);
    bottomBorder1.backgroundColor = [UIColor darkGrayColor].CGColor;
    [txtfield.layer addSublayer:bottomBorder1];
}

#pragma mark- ==== WebServiceMethod =======

-(void)addFeedbackDetails
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [Helper getPREF:PREF_USER_NAME],@"username",
                                    [Helper getPREF:PREF_USER_EMAIL],@"useremail",
                                    txtSubject.text, @"subject",
                                    txtFeedback.text, @"message",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ADD_FEEDBACK dicParams:Parameters];
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
                [self dismissViewControllerAnimated:NO completion:nil];
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
