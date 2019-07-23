//
//  WalkThrough.m
//  Taxidio
//
//  Created by E-Intelligence on 11/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "WalkThrough.h"

@interface WalkThrough ()

@end

@implementation WalkThrough

@synthesize arrDataWalkThrough;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tempUIView=[[UIView alloc]initWithFrame:viewMainView.bounds];
    tempUIView.backgroundColor=[UIColor colorWithRed:40.0/256.0 green:43.0/256.0 blue:76.0/256.0 alpha:1.0];
    
    self.arrDataWalkThrough = [[NSMutableArray alloc]init];
    index = 0;
    [self GetWalkThroughData];
    arrDataWalkThrough = [[NSMutableArray alloc]initWithObjects:@"a",@"b",@"a",@"b",@"a",@"b",@"a",@"b", nil];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pressNext:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pressPrevious:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    btnLeft.hidden = TRUE;
    
    imgView.alpha = 1.0;
    imgView.layer.cornerRadius = imgView.frame.size.height/2.0;
    imgView.clipsToBounds = YES;
    pageCntrl.numberOfPages = [arrDataWalkThrough count];
}

-(void)GetWalkThroughData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressSkip:(id)sender {
}

- (IBAction)changeScreen:(id)sender
{
    if(pageCntrl.currentPage>index)
    {
        [self performSelector:@selector(pressNext:) withObject:nil];
    }
    else
    {
        [self performSelector:@selector(pressPrevious:) withObject:nil];
    }
    
//    self.screenNumber.text = [NSString stringWithFormat:@"%i", ([self.pageController currentPage]+1)];
}

-(IBAction)pressPrevious:(id)sender
{
    if ([self.arrDataWalkThrough count] != 0)
    {
        if(self.arrDataWalkThrough.count == 1)
        {
            index = 0;
//            pageCntrl.currentPage = index+1;
            btnLeft.hidden = TRUE;
        }
        else
        {
            if(index != 0)
            {
                index--;
                pageCntrl.currentPage = index;
                
                CATransition *transition = [CATransition new];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                [viewMainView.layer addAnimation:transition forKey:@"transition"];
                btnLeft.hidden = FALSE;
                btnRight.hidden = FALSE;
                
                if(index==0)
                    btnLeft.hidden = TRUE;
            }
        }
//        WalkThroughObj *objWalkThr = [[WalkThroughObj alloc]init];
//        objWalkThr = [self.arrDataWalkThrough objectAtIndex:index];
//        lblDescription.text = [objWalkThr valueForKey:@""];
//        //imgView.image = [self imgFromUrlstirng:[objWalkThr valueForKey:@""]];
    }
}

-(IBAction)pressNext:(id)sender
{
    if ([self.arrDataWalkThrough count] != 0)
    {
        if(self.arrDataWalkThrough.count == 1)
        {
            index = 0;
            btnLeft.hidden = TRUE;
            btnRight.hidden = TRUE;
        }
        else
        {
            btnRight.hidden = FALSE;
            btnLeft.hidden = FALSE;
            NSInteger count = [self.arrDataWalkThrough count];
            if(count-1 > index)
            {
                index++;
                pageCntrl.currentPage = index;
                CATransition *transition = [CATransition new];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [viewMainView.layer addAnimation:transition forKey:@"transition"];
                if(count-1 == index)
                    btnRight.hidden = TRUE;
            }
            else
            {
                btnRight.hidden = TRUE;
            }
        }
//        WalkThroughObj *objWalkThr = [[WalkThroughObj alloc]init];
//        objWalkThr = [self.arrDataWalkThrough objectAtIndex:index];
//        lblDescription.text = [objWalkThr valueForKey:@""];
//        //imgView.image = [self imgFromUrlstirng:[objWalkThr valueForKey:@""]];
    }
}

#pragma mark- ====GetImageFormURL ====

-(UIImage *)imgFromUrlstirng :(NSString *)path
{
    
    //    NSMutableString *imgPath=[NSMutableString stringWithString:@""];
    //    imgPath = [NSMutableString stringWithFormat:@"%@%@",WS_BASE_URL_IMAGE,path];
    //    imgMyth = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgPath]]];
    //    return imgMyth;
    return 0;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [tempUIView removeFromSuperview];
}

@end
