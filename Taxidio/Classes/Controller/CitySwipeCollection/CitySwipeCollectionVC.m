//
//  CitySwipeCollectionVC.m
//  Taxidio
//
//  Created by E-Intelligence on 27/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CitySwipeCollectionVC.h"

@interface CitySwipeCollectionVC ()

@end

@implementation CitySwipeCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

-(void)loadData
{
    _currentData = [[NSMutableArray alloc]initWithObjects:
                    @"Archaeological",@"Architecture",@"Beach & Island",@"Castles",@"Child Attraction",@"Community Tourism",@"Festivals & Culture",@"Food & Nightlife",@"High Altitude",@"History",@"Museum",
                    @"Nature & Ecotourism",@"Relaxation & Spa",@"Romance",@"Shopping",@"Spirituality & Religion",@"Sports & Adventure",@"Wildlife",@"World Heritage & UNESCO",@"Restricted Accessibility",Nil];
    [_gmGridView reloadData];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];

    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:viewMain.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStylePush;
    _gmGridView.itemSpacing = 20;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(20,20,20,20);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    
    _gmGridView.dataSource = self;
   // _gmGridView.editing = TRUE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
        return CGSizeMake(140, 110);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"cancel.png"];
        cell.deleteButtonOffset = CGPointMake(size.width-15,0);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor yellowColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *lblCityName = [[UILabel alloc] initWithFrame:CGRectMake(0,15,cell.contentView.frame.size.width,20)];
    lblCityName.text = (NSString *)[_currentData objectAtIndex:index];
    lblCityName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lblCityName.textAlignment = NSTextAlignmentCenter;
 //   lblCityName.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    lblCityName.textColor = [UIColor whiteColor];
    lblCityName.numberOfLines = 0;
    lblCityName.lineBreakMode = NSLineBreakByWordWrapping;
    lblCityName.highlightedTextColor = [UIColor whiteColor];
    lblCityName.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:lblCityName];

    UILabel *lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(0,40,cell.contentView.frame.size.width,30)];
    lblDistance.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lblDistance.text = (NSString *)@"(Time to reach Interlaken is 2hrs and 40 min)";
    lblDistance.textAlignment = NSTextAlignmentCenter;
    //lblDistance.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    lblDistance.textColor = [UIColor whiteColor];
    lblDistance.numberOfLines = 0;
    lblDistance.lineBreakMode = NSLineBreakByWordWrapping;
    lblDistance.highlightedTextColor = [UIColor whiteColor];
    lblDistance.font = [UIFont systemFontOfSize:11];
    [cell.contentView addSubview:lblDistance];
    
    UIButton *btnExploreCity = [[UIButton alloc]initWithFrame:CGRectMake(15,75,80,32)];
//    btnExploreCity.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    btnExploreCity.titleLabel.text = @"Explore City";
    btnExploreCity.backgroundColor = [UIColor grayColor];
//    btnExploreCity.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"explore btn.png"]];
    
 //   [btnExploreCity addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:btnExploreCity];
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"Castles.jpg"]]];
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %li", position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    _gmGridView.editing = TRUE;
//    [_gmGridView layoutSubviewsWithAnimation:GMGridViewItemAnimationFade];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"Castles.jpg"]]];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
        return CGSizeMake(300, 310);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %li", (long)index];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    label.font = [UIFont boldSystemFontOfSize:15];
    [fullView addSubview:label];
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"Castles.jpg"]]];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}

//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////

- (void)addMoreItem
{
    // Example: adding object at the last position
    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
    
    [_currentData addObject:newItem];
    [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)removeItem
{
    if ([_currentData count] > 0)
    {
        NSInteger index = [_currentData count] - 1;
        
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:index];
    }
}

- (void)refreshItem
{
    // Example: reloading last item
    if ([_currentData count] > 0)
    {
        NSInteger index = [_currentData count] - 1;
        
        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];
        
        [_currentData replaceObjectAtIndex:index withObject:newMessage];
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    }
}

- (void)presentInfo
{
    NSString *info = @"Long-press an item and its color will change; letting you know that you can now move it around. \n\nUsing two fingers, pinch/drag/rotate an item; zoom it enough and you will enter the fullsize mode";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:info
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)dataSetChange
{
    _currentData = _data;
    
    [_gmGridView reloadData];
}

//- (void)presentOptions:(UIBarButtonItem *)barButton
//{
//        [self presentModalViewController:_optionsNav animated:YES];
//}
//
//- (void)optionsDoneAction
//{
//        [self dismissModalViewControllerAnimated:YES];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressUserProfile:(id)sender {
}

- (IBAction)pressBack:(id)sender {
    
    if(_gmGridView.editing==TRUE)
        _gmGridView.editing = FALSE;
    else
        _gmGridView.editing = TRUE;
    [_gmGridView layoutSubviewsWithAnimation:GMGridViewItemAnimationFade];
}
@end
