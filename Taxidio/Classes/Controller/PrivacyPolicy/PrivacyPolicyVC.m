//
//  PrivacyPolicyVC.m
//  Taxidio
//
//  Created by E-Intelligence on 12/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "PrivacyPolicyVC.h"

@interface PrivacyPolicyVC ()

@end

@implementation PrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self loadPrivacyPolicyData];
}

-(void)checkLogin
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

- (IBAction)pressClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressMenu:(id)sender
{
    
}

- (IBAction)pressUserProfile:(id)sender
{
    
}


#pragma mark- ==== WebServiceMethod =======
-(void)loadPrivacyPolicyData
{
    @try{
        SHOW_AI;
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_PRIVACY_POLICY];
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
                
                NSString *strcSSLink = [NSString stringWithFormat:@"<link rel=\"stylesheet\" href=\"http://reesort.com/taxidio/assets/css/bootstrap.css\" type=\"text/css\" /><link rel=\"stylesheet\" href=\"http://reesort.com/taxidio/assets/css/star-rating.css\" type=\"text/css\" /><link rel=\"stylesheet\" href=\"http://reesort.com/taxidio/assets/css/style.css\" type=\"text/css\"/>"];
                
                [webviewPolicy loadHTMLString:[NSString stringWithFormat:@"<html><head>%@</head><body bgcolor=\"#FFFFFF\" text=\"#000000\" face=\"Avenir 45 Book\" size=\"14\">%@</body></html>",strcSSLink ,[dictData valueForKey:@"content"]] baseURL: nil];

//                [webviewPolicy loadHTMLString:[[NSString stringWithFormat:@"%@",] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
                [webviewPolicy reload];
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
