//
//  LocationListingVC.h
//  Taxidio
//
//  Created by E-Intelligence on 21/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Webservice.h"
#import <GooglePlaces/GooglePlaces.h>
#import "MVPlaceSearchTextField.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Utilities.h"


@interface LocationListingVC : UIViewController<GMSAutocompleteViewControllerDelegate, PlaceSearchTextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    CGRect screenRect;
    CGFloat screenHeight;
}
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtPlace;
//@property (nonatomic,retain)


@end
