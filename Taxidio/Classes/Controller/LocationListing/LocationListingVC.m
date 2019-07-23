//
//  LocationListingVC.m
//  Taxidio
//
//  Created by E-Intelligence on 21/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "LocationListingVC.h"

@interface LocationListingVC ()

@end

@implementation LocationListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    _txtPlace.autocorrectionType = UITextAutocorrectionTypeNo;
    [_txtPlace addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self SetPlaceText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- ==== PlaceTextMethod ====
-(void)SetPlaceText
{
    _txtPlace.placeSearchDelegate                 = self;
    _txtPlace.strApiKey                           = GOOGLE_PLACE_KEY;
    _txtPlace.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    _txtPlace.autoCompleteShouldHideOnSelection   = YES;
    _txtPlace.maximumNumberOfAutoCompleteRows     = 5;
    
    
    //Optional Properties
    _txtPlace.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _txtPlace.autoCompleteBoldFontName = @"HelveticaNeue";
    _txtPlace.autoCompleteTableCornerRadius=0.0;
    _txtPlace.autoCompleteRowHeight=35;
    _txtPlace.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _txtPlace.autoCompleteFontSize=14;
    _txtPlace.autoCompleteTableBorderWidth=1.0;
    _txtPlace.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _txtPlace.autoCompleteShouldHideOnSelection=YES;
    _txtPlace.autoCompleteShouldHideClosingKeyboard=YES;
    _txtPlace.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    
    _txtPlace.autoCompleteTableFrame = CGRectMake(20, _txtPlace.frame.size.height+100.0, self.view.frame.size.width - 40, 200.0);
}

#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
    [self removeKeyboard];
}

-(void)placeSearchForArray:(MVPlaceSearchTextField*)textField ResponseForSelectedData:(NSMutableArray*)responseArray
{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseArray);
    [self removeKeyboard];
}

-(void)removeKeyboard
{
    [_txtPlace resignFirstResponder];
}

-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    
}

-(void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{
    
}


-(void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    
}

-(void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{
    
}


-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma  mark- ==== TextDelegateMethod ====

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == _txtPlace)
    {
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        if(screenHeight == 480)
        {
            pt.y -=160;
            [scrollView setContentOffset:pt animated:YES];
        }
        else
        {
            pt.y -=220;
            [scrollView setContentOffset:pt animated:YES];
        }
    }
    return  YES;
}

-(void)textChanged:(UITextField *)textField
{
    NSLog(@"textfield data %@ ",textField.text);
//    flagTextChange = 1;
}


@end
