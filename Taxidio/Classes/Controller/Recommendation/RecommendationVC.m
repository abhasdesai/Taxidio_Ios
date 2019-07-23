//
//  RecommendationVC.m
//  Taxidio
//
//  Created by E-Intelligence on 04/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "RecommendationVC.h"

@interface RecommendationVC ()

@end

@implementation RecommendationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Other Methods

-(void)setBottomBorder : (UIButton*) btn
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, btn.frame.size.height - 1, btn.frame.size.width, 5.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [btn.layer addSublayer:bottomBorder];
}


@end
