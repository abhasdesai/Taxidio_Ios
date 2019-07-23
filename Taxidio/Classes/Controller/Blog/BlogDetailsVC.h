//
//  BlogDetailsVC.h
//  Taxidio
//
//  Created by E-Intelligence on 26/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogDetailsVC : UIViewController
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgBlogImg;
    IBOutlet UIWebView *webviewPolicy;

}
@property(nonatomic,retain) NSMutableArray *arrData;
-(IBAction)pressBack:(id)sender;
@end
