//
//  LocationReadMoreViewController.m
//  Taxidio
//
//  Created by E-Intelligence on 01/08/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "LocationReadMoreViewController.h"

@interface LocationReadMoreViewController ()

@end

@implementation LocationReadMoreViewController

@synthesize objAttractionData;

- (void)viewDidLoad {
    [super viewDidLoad];
    tblLocationDetails.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblLocationDetails.allowsSelection = NO;
    tblLocationDetails.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
 }

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //    [self checkLogin];
    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    arrData = [[NSMutableArray alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadLocationReadMoreData];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if(arrData.count>0)
        return 10;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = @"AutoCompleteRowIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    UILabel *lblHeading;
    UILabel *lblContent;

    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

//    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    lblHeading = [[UILabel alloc]initWithFrame:CGRectMake(15,15,tblLocationDetails.frame.size.width-30,30)];
    lblHeading.textColor = [UIColor blackColor];
    [self setBottomBorder:lblHeading];
    
    lblContent = [[UILabel alloc]initWithFrame:CGRectMake(15,47,tblLocationDetails.frame.size.width-30,30)];
    lblContent.textColor = [UIColor blackColor];
    lblContent.font = FONT_AVENIR_45_BOOK_SIZE_13;
    lblContent.textAlignment = NSTextAlignmentLeft;

    lblContent.numberOfLines = 0;
    lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    
    switch (indexPath.row)
    {
        case 0:
            lblHeading.text = @"Known For:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"tag_name"]];
            ;
            break;
        case 1:
            lblHeading.text = @"Address:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_address"]];
            break;
        case 2:
        {
            lblHeading.text = @"Contact:";
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressCallContact:)];
            tapGestureRecognizer.cancelsTouchesInView = NO;
            [lblContent addGestureRecognizer:tapGestureRecognizer];
            lblContent.textColor = COLOR_ORANGE;
            lblContent.userInteractionEnabled = YES;
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_contact"]];
        }
            break;
        case 3:
        {
            lblHeading.text = @"Website:";
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressOpenUrl:)];
            tapGestureRecognizer.cancelsTouchesInView = NO;
            [lblContent addGestureRecognizer:tapGestureRecognizer];
            lblContent.textColor = COLOR_ORANGE;
            lblContent.userInteractionEnabled = YES;
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_website"]];
        }
            break;
        case 4:
            lblHeading.text = @"Details:";
            lblContent.textAlignment = NSTextAlignmentJustified;
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"details"]];
            break;
        case 5:
            lblHeading.text = @"Public Transport:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_public_transport"]];
            break;
        case 6:
            lblHeading.text = @"Timing:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_timing"]];
            break;
        case 7:
            lblHeading.text = @"Time Required in Hours:";
            lblContent.text = [NSString stringWithFormat:@"%@",[self convertHtmlPlainText:[arrData valueForKey:@"attraction_time_required"]]];
            break;
        case 8:
            lblHeading.text = @"Waiting Time:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_wait_time"]];
            break;
        case 9:
            lblHeading.text = @"Entry Fee:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_admissionfee"]];
            break;
        default:
            break;
    }
    int y = 5;
    y = [self getLabelHeight:lblContent];
    
    lblContent.frame = CGRectMake(15,47,tblLocationDetails.frame.size.width-30 ,y);
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lblHeading];
    [cell.contentView addSubview:lblContent];
    return cell;
}

#pragma mark - IBACTION METHODS

- (IBAction)pressCallContact:(id)sender
{
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", [arrData valueForKey:@"attraction_contact"]];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

-(IBAction)pressOpenUrl:(id)sender
{
//    UIButton *button = (UIButton *)sender;
//    NSInteger i = button.tag;
//    NSLog(@"%ld",(long)i);
    NSURL *phoneURL = [NSURL URLWithString:[arrData valueForKey:@"attraction_website"]];
    [[UIApplication sharedApplication] openURL:phoneURL];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *Identifier = @"AutoCompleteRowIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    UILabel *lblHeading;
    UILabel *lblContent;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    lblHeading = [[UILabel alloc]initWithFrame:CGRectMake(15,15,cell.contentView.frame.size.width-15,30)];
    lblHeading.textColor = [UIColor whiteColor];
    [self setBottomBorder:lblHeading];
    
    lblContent = [[UILabel alloc]init];
    lblContent.textColor = [UIColor whiteColor];
    lblContent.numberOfLines = 0;
    lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    
    [cell.contentView addSubview:lblHeading];
    [cell.contentView addSubview:lblContent];
    
    switch (indexPath.row)
    {
        case 0:
            lblHeading.text = @"Known For:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"tag_name"]];
            
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"tag_name"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            ;
            break;
        case 1:
            lblHeading.text = @"Address:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_address"]];
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"attraction_address"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 2:
            lblHeading.text = @"Contact:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_contact"]];
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"attraction_contact"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 3:
            lblHeading.text = @"Website:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_website"]];
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"attraction_website"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 4:
            lblHeading.text = @"Details:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"details"]];
            lblContent.textAlignment = NSTextAlignmentJustified;
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"details"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 5:
            lblHeading.text = @"Public Transport:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_public_transport"]];
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"attraction_public_transport"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 6:
            lblHeading.text = @"Timing:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_timing"]];
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"attraction_timing"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 7:
            lblHeading.text = @"Time Required in Hours:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_time_required"]];
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"attraction_time_required"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 8:
            lblHeading.text = @"Waiting Time:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_wait_time"]];
            //            lblContent.attributedText = [[NSAttributedString alloc] initWithData:[[arrData valueForKey:@"attraction_wait_time"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
        case 9:
            lblHeading.text = @"Entry Fee:";
            lblContent.text = [self convertHtmlPlainText:[arrData valueForKey:@"attraction_admissionfee"]];
            //            [self convertHtmlPlainText:htmlResponse];
            //
            //            [[NSAttributedString alloc] initWithData:[ dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            break;
            
        default:
            break;
    }
    
//    int height;
//    int y = 5;
//    height = [self getLabelHeight:lblContent];
//
//    y +=height;
//
//    lblContent.frame = CGRectMake(20,47,340,y);
//
   CGSize size;
//
    NSString *title = lblContent.text;
    size = [title sizeWithFont:[UIFont systemFontOfSize:(CGFloat)17.0]
                         constrainedToSize:CGSizeMake(280, 2000)
                             lineBreakMode:NSLineBreakByWordWrapping];//[lblContent sizeThatFits:CGSizeMake(lblContent.frame.size.width, 20000.0f)];//CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    if (indexPath.row==4 || indexPath.row==9)
        return  size.height + 50;
    else
        return  size.height + 50;
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



#pragma mark - FORMAT METHODS

-(void)setBottomBorder : (UILabel*)label
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, label.frame.size.height - 1, label.frame.size.width, 1);
    bottomBorder1.backgroundColor = COLOR_ORANGE.CGColor;
    [label.layer addSublayer:bottomBorder1];
}

#pragma mark- ==== WebServiceMethod =======
-(void)loadLocationReadMoreData
{
    @try{
            NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [[self.objAttractionData valueForKey:@"properties"]valueForKey:@"cityid"],@"cityid",
                                        [[self.objAttractionData valueForKey:@"properties"]valueForKey:@"attractionid"],@"attractionid",
                                        [[self.objAttractionData valueForKey:@"properties"]valueForKey:@"category"],@"category",
                                        nil];
            
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_READ_MORE_ATTRACTION_DATA dicParams:Parameters];
            wsLogin.isLogging=TRUE;
            wsLogin.isSync=TRUE;
            wsLogin.onSuccess=^(NSDictionary *dicResponce)
            {
                NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                dicResponce = [dict mutableCopy];
                dict = nil;

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
                    arrData = [dicResponce valueForKey:@"data"];
                    [tblLocationDetails reloadData];
                    lblLocationTitle.text = [arrData valueForKey:@"name"];
                    
                    NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_ATTRACTION,[arrData valueForKey:@"image"]];
                    strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                    NSURL *url = [NSURL URLWithString:strurl];
                    dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                    dispatch_async(qLogo, ^{
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        if(data)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                imageViewLocation.image = img;
                            });
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [imageViewLocation setImage:[UIImage imageNamed:@"no_image_attraction.jpg"]];
                            });
                        }
                    });

                }
            };
            [wsLogin send];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

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
