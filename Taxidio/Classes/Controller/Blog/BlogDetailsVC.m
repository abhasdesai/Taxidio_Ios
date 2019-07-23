//
//  BlogDetailsVC.m
//  Taxidio
//
//  Created by E-Intelligence on 26/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "BlogDetailsVC.h"

@interface BlogDetailsVC ()

@end

@implementation BlogDetailsVC
@synthesize arrData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [webviewPolicy loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor=\"#FFFFFF\" text=\"#000000\" face=\"Avenir 45 Book\" size=\"14\">%@</body></html>", [[arrData valueForKey:@"post_custom_content"] valueForKey:@"rendered"]] baseURL: nil];

    
    lblTitle.text = [[arrData valueForKey:@"title"]valueForKey:@"rendered"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrData valueForKey:@"featured_image_src"]]];
    dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(qLogo, ^{
        /* Fetch the image from the server... */
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        if(data)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgBlogImg.image = img;
            });
        }
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
