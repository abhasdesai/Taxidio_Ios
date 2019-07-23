//
//  CitySwipeViewVC.m
//  Taxidio
//
//  Created by E-Intelligence on 28/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CitySwipeViewVC.h"

@interface CitySwipeViewVC ()

@end

@implementation CitySwipeViewVC
@synthesize arrCountryData,arrData,strCountryName,strCountryDescr,arrCountryDataForOptSelected,arrDistanceBetweenCities,isFromSearchData,strCityIdSelected,strCityNameSelected,strLatitudeCitySelected,strLongitudeCitySelected,strItineraryIdSelected,arrAttractionData,strCountryId,dictDataFromLocationView,isFromAttractionListing,strTripType,isFirstTimeSaved;

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.strItineraryIdSelected.length==0)
        self.isFirstTimeSaved = TRUE;

    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenwidth = screenRect.size.width;
    
    ViewAddExtraCityForSearch.hidden = TRUE;
    viewAddCityView.hidden = TRUE;
    
    self.arrCountryData = [[NSMutableArray alloc]init];
    self.arrAttractionData = [[NSMutableArray alloc]init];
    [self.arrAttractionData removeAllObjects];
    indexForCountrySelected = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadInitialData];
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled = FALSE;

    if([Helper getPREFint:@"isFromAttractionListing"]==1)
    {
        NSMutableDictionary *arr = [[NSMutableDictionary alloc] initWithDictionary: [[Helper getPREFDict:@"dictDataFromLocationView"] mutableCopy]];
        for(int i=0;i<arrCityData.count;i++)
        {
            if([[[arrCityData valueForKey:@"id"]objectAtIndex:i]isEqualToString:[arr valueForKey:@"id"]])
            {
                 [arrCityData replaceObjectAtIndex:i withObject:arr];
            }
        }
        [Helper setPREFint:0 :@"isFromAttractionListing"];
    }
}

-(void)loadInitialData
{
    if([self.strTripType isEqualToString:@"1"])
    {
        if(self.isFromEditTrip==FALSE)
        {
            self.arrCountryData = [self.arrData mutableCopy];
            lblCountryName.text =[self.arrCountryData valueForKey:@"country_name"];
            txtCountryDetails.text = [self.arrCountryData valueForKey:@"country_conclusion"];
            arrCityData = [[self.arrCountryData valueForKey:@"cityData"]mutableCopy];
            
            NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[self.arrCountryData valueForKey:@"countryimage"]];
            strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *url = [NSURL URLWithString:strurl];
            dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(qLogo, ^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [[UIImage alloc] initWithData:data];
                if(data)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imgViewCoutryImage.image = img;
                    });
                }
            });
            
            if(arrCityData.count==[[self.arrCountryData valueForKey:@"noofcities"]intValue])
                btnAddCity.hidden = TRUE;
            else
                btnAddCity.hidden = FALSE;

            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            strCountryId = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",strCountryId];
            
//            for(int i=0;i<arrCityData.count;i++)
//            {
//                NSString *strCityIds = [[arrCityData valueForKey:@"id"]objectAtIndex:i];
//                strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
//                NSString *strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",strCountryId,strCityIds];
//                [self wsLoadCityAttractions:strCityCountryId];
//
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
//                dict = [[arrCityData objectAtIndex:i]mutableCopy];
//                [dict addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                 self.arrAttractionData ,@"filestore", nil]];
//                [arrCityData replaceObjectAtIndex:i withObject:dict];
//            }
        }
        else if(self.isFromEditTrip==TRUE)
        {
            self.arrCountryData = [[NSMutableArray alloc]initWithObjects:_dictSearchData, nil];
            self.arrCountryData = [self.arrCountryData objectAtIndex:0];
            arrCityData = [self.arrCountryData valueForKey:@"singlecountry"];
            
            if(arrCityData.count==[[self.arrCountryData valueForKey:@"noofcities"]intValue])
                btnAddCity.hidden = TRUE;
            else
                btnAddCity.hidden = FALSE;
            
            lblCountryName.text =[self.arrCountryData valueForKey:@"country_name"];
            txtCountryDetails.text = [self.arrCountryData valueForKey:@"country_conclusion"];
        }
//        NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
//        NSArray *arr = [arrCityData valueForKey:@"id"];
//        NSString *strCityIds = [arr componentsJoinedByString:@","];
//        [self wsAddCityForCountry:strCountryId :strCityIds];
//
//        if(_arrExtraCountryList.count>0)
//            btnAddCity.hidden = FALSE;
//        else
//            btnAddCity.hidden = TRUE;

        //[self loadDistance];
    }
    
    if([self.strTripType isEqualToString:@"4"])
    {
        self.arrCountryData = [[NSMutableArray alloc]initWithObjects:_dictSearchData, nil];
        self.arrCountryData = [self.arrCountryData objectAtIndex:0];
        lblCountryName.text =[self.arrCountryData valueForKey:@"country_name"];
        txtCountryDetails.text = [self.arrCountryData valueForKey:@"country_conclusion"];
        arrCityData = [self.arrCountryData valueForKey:@"cityData"];
        NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[self.arrCountryData valueForKey:@"countryimage"]];
        strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:strurl];
        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(qLogo, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if(data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgViewCoutryImage.image = img;
                });
            }
        });
        strCountryId = [_dictSearchData valueForKey:@"country_id"];
        if(self.isFromEditTrip==TRUE)
        {
            arrCityData = [self.arrCountryData valueForKey:@"singlecountry"];
        }
        else{
//            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
//            NSArray *arr = [arrCityData valueForKey:@"id"];
//            NSString *strCityIds = [arr componentsJoinedByString:@","];
//            [self wsAddCityForCountry:strCountryId :strCityIds];
//            self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
//            indexForExtraCityList = 0;
//
//            strCountryId = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
//            strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",strCountryId];
//
//            for(int i=0;i<arrCityData.count;i++)
//            {
//                NSString *strCityIds = [[arrCityData valueForKey:@"id"]objectAtIndex:i];
//                strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
//                NSString *strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",strCountryId,strCityIds];
//                [self wsLoadCityAttractions:strCityCountryId];
//
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
//                dict = [[arrCityData objectAtIndex:i]mutableCopy];
//                [dict addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                 self.arrAttractionData ,@"filestore", nil]];
//                [arrCityData replaceObjectAtIndex:i withObject:dict];
//            }
        }
       // [self loadDistance];
    }


    if([self.strTripType isEqualToString:@"3"])
    {
        self.arrCountryData = [[NSMutableArray alloc]initWithObjects:_dictSearchData, nil];
        self.arrCountryData = [self.arrCountryData objectAtIndex:0];
        lblCountryName.text =[self.arrCountryData valueForKey:@"country_name"];
        txtCountryDetails.text = [self.arrCountryData valueForKey:@"country_conclusion"];
        
        NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[self.arrCountryData valueForKey:@"countryimage"]];
        strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:strurl];
        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(qLogo, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if(data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgViewCoutryImage.image = img;
                });
            }
        });
        strCountryId = [_dictSearchData valueForKey:@"country_id"];
        if(self.isFromEditTrip==TRUE)
        {
            arrCityData = [self.arrCountryData valueForKey:@"singlecountry"];
            btnAddCity.hidden = true;
        }
        else{
            NSMutableDictionary *dict = _dictSearchData;//[[NSMutableDictionary alloc] initWithDictionary: [[Helper getPREFDict:PREF_SEARCH_DESTI_DATA] mutableCopy]];
            
            NSUInteger totalDays = [[_dictSearchData valueForKey:@"totaldaysneeded"]integerValue];
            NSUInteger cntOtherCityArray = [[_dictSearchData valueForKey:@"othercities"]count];

            if(totalDays==0 && cntOtherCityArray>0)
            {
                NSString *strMessage = [_dictSearchData valueForKey:@"message"];
                //strMessage = [NSString stringWithFormat:@"%@ Do you wish to modify?",strMessage];
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                            {
                                                self.arrExtraCountryList = [NSMutableArray arrayWithObject:[dict valueForKey:@"othercities"]];
                                                self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
                                                if(self.arrExtraCountryList.count>0)
                                                {
                                                    indexForExtraCityList = 0;
                                                    [self loadExtraCityView:indexForExtraCityList];
                                                    //indexForExtraCityList++;
                                                    btnAddCity.hidden = FALSE;
                                                }
                                                else
                                                {
                                                    btnAddCity.hidden = TRUE;
                                                }
                                            }];
                UIAlertAction *NoAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                           {
                                               self.arrExtraCountryList = [NSMutableArray arrayWithObject:[dict valueForKey:@"othercities"]];
                                               self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
                                               if(self.arrExtraCountryList.count>0)
                                               {
                                                   ViewAddExtraCityForSearch.hidden = FALSE;
                                                   indexForExtraCityList = 0;
                                                   [self loadExtraCityView:indexForExtraCityList];
                                                   //indexForExtraCityList++;
                                                   btnAddCity.hidden = FALSE;
                                               }
                                               else
                                               {
                                                   btnAddCity.hidden = TRUE;
                                               }
                                           }];
                [alert addAction:YesAction];
                [alert addAction:NoAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                self.arrExtraCountryList = [NSMutableArray arrayWithObject:[dict valueForKey:@"othercities"]];
                self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
                if(self.arrExtraCountryList.count>0)
                {
                    ViewAddExtraCityForSearch.hidden = FALSE;
                    indexForExtraCityList = 0;
                    [self loadExtraCityView:indexForExtraCityList];
                    //indexForExtraCityList++;
                    btnAddCity.hidden = FALSE;
                }
                else
                {
                    btnAddCity.hidden = TRUE;
                }
            }
            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            strCountryId = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",strCountryId];
            
            arrCityData = [NSMutableArray arrayWithObject:[self.arrCountryData mutableCopy]];
            [[arrCityData objectAtIndex:0]setValue:@"1" forKey:@"ismain"];
        }
       // [self loadDistance];
    }
    
    else if([self.strTripType isEqualToString:@"2"])
    {
        self.arrData =  [[NSMutableArray alloc]init];
        if(self.isFromEditTrip==FALSE)
        {
            arrDataMultiCountryCityData = [[NSArray alloc]init];
            
            NSMutableDictionary *dictMultiCountryData = [[NSMutableDictionary alloc]init];
            NSMutableDictionary *dictDataMultiCity =  [[NSMutableDictionary alloc]init];
            dictMultiCountryData = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_MULTI_COUNTRY_DATA];
            dictDataMultiCity = [dictMultiCountryData valueForKey:@"countries"];
            arrDataMultiCountryCityData = [dictDataMultiCity copy];
            [self loadAllMultiCountryData];
            [self loadDataForIndexSelected:indexForCountrySelected];
            //[self loadDistance];
        }
        else if(self.isFromEditTrip==TRUE)
        {
            self.arrData = [[NSMutableArray alloc]initWithObjects:[_dictSearchData valueForKey:@"multicountries"], nil];
            self.arrData = [self.arrData objectAtIndex:0];
            [self loadDataForIndexSelected:indexForCountrySelected];
        }
    }
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        btnAddCity.hidden = TRUE;
        btnSaveChanges.hidden = TRUE;
    }
    [collectionView reloadData];
    HIDE_AI;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   //dispatch_async(dispatch_get_main_queue(), ^{
   //    [self loadDistance];
   // });

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDataAttractions];
    });
}

-(void)loadDataAttractions
{
    if([self.strTripType isEqualToString:@"1"])
    {
        if(self.isFromEditTrip==FALSE)
        {
            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            strCountryId = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",strCountryId];
            
            for(int i=0;i<arrCityData.count;i++)
            {
                NSString *strCityIds = [[arrCityData valueForKey:@"id"]objectAtIndex:i];
                strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
                NSString *strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",strCountryId,strCityIds];
                [self wsLoadCityAttractions:strCityCountryId : @""];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
                dict = [[arrCityData objectAtIndex:i]mutableCopy];
                [dict addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 self.arrAttractionData ,@"filestore", nil]];
                [arrCityData replaceObjectAtIndex:i withObject:dict];
            }
        }
        if(self.isFromEditTrip==FALSE)
        {
            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            NSArray *arr = [arrCityData valueForKey:@"id"];
            NSString *strCityIds = [arr componentsJoinedByString:@","];
            
            if([Helper getPREFint:@"isFromViewItinerary"]!=1)
            {
                [self wsAddCityForCountry:strCountryId :strCityIds];
            }
            if(_arrExtraCountryList.count>0)
                btnAddCity.hidden = FALSE;
            else
                btnAddCity.hidden = TRUE;
        }
        else
        {
            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            NSArray *arr = [arrCityData valueForKey:@"id"];
            NSString *strCityIds = [arr componentsJoinedByString:@","];
            
            if([Helper getPREFint:@"isFromViewItinerary"]!=1)
            {
                [self wsAddCityForCountry:strCountryId :strCityIds];
            }
//
//            [self wsAddCityForCountry:strCountryId :strCityIds];
            
            if(_arrExtraCountryList.count>0)
                btnAddCity.hidden = FALSE;
            else
                btnAddCity.hidden = TRUE;
        }
    }
    
    if([self.strTripType isEqualToString:@"4"])
    {
        self.arrCountryData = [[NSMutableArray alloc]initWithObjects:_dictSearchData, nil];
        self.arrCountryData = [self.arrCountryData objectAtIndex:0];
        lblCountryName.text =[self.arrCountryData valueForKey:@"country_name"];
        txtCountryDetails.text = [self.arrCountryData valueForKey:@"country_conclusion"];
        arrCityData = [self.arrCountryData valueForKey:@"cityData"];
        NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[self.arrCountryData valueForKey:@"countryimage"]];
        strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:strurl];
        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(qLogo, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if(data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgViewCoutryImage.image = img;
                });
            }
        });
        strCountryId = [_dictSearchData valueForKey:@"country_id"];
        if(self.isFromEditTrip==TRUE)
        {
            arrCityData = [self.arrCountryData valueForKey:@"singlecountry"];
        }
        else{
            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            NSArray *arr = [arrCityData valueForKey:@"id"];
            NSString *strCityIds = [arr componentsJoinedByString:@","];
            if([Helper getPREFint:@"isFromViewItinerary"]!=1)
            {
                [self wsAddCityForCountry:strCountryId :strCityIds];
            }
//            [self wsAddCityForCountry:strCountryId :strCityIds];
            //self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
            indexForExtraCityList = 0;
            
            strCountryId = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",strCountryId];
            
            for(int i=0;i<arrCityData.count;i++)
            {
                NSString *strCityIds = [[arrCityData valueForKey:@"id"]objectAtIndex:i];
                strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
                NSString *strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",strCountryId,strCityIds];
                [self wsLoadCityAttractions:strCityCountryId : @""];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
                dict = [[arrCityData objectAtIndex:i]mutableCopy];
                [dict addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 self.arrAttractionData ,@"filestore", nil]];
                [arrCityData replaceObjectAtIndex:i withObject:dict];
            }
        }
        // [self loadDistance];
    }
    
    
    if([self.strTripType isEqualToString:@"3"])
    {
        self.arrCountryData = [[NSMutableArray alloc]initWithObjects:_dictSearchData, nil];
        self.arrCountryData = [self.arrCountryData objectAtIndex:0];
        lblCountryName.text =[self.arrCountryData valueForKey:@"country_name"];
        txtCountryDetails.text = [self.arrCountryData valueForKey:@"country_conclusion"];
        
        NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[self.arrCountryData valueForKey:@"countryimage"]];
        strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:strurl];
        dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(qLogo, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if(data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgViewCoutryImage.image = img;
                });
            }
        });
        strCountryId = [_dictSearchData valueForKey:@"country_id"];
        if(self.isFromEditTrip==TRUE)
        {
            arrCityData = [self.arrCountryData valueForKey:@"singlecountry"];
            btnAddCity.hidden = true;
        }
        else{
            NSMutableDictionary *dict = _dictSearchData;//[[NSMutableDictionary alloc] initWithDictionary: [[Helper getPREFDict:PREF_SEARCH_DESTI_DATA] mutableCopy]];
            
            NSUInteger totalDays = [[_dictSearchData valueForKey:@"totaldaysneeded"]integerValue];
            NSUInteger cntOtherCityArray = [[_dictSearchData valueForKey:@"othercities"]count];
            
            if(totalDays==0 && cntOtherCityArray>0)
            {
                NSString *strMessage = [_dictSearchData valueForKey:@"message"];
                //strMessage = [NSString stringWithFormat:@"%@ Do you wish to modify?",strMessage];
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                            {
                                                self.arrExtraCountryList = [NSMutableArray arrayWithObject:[dict valueForKey:@"othercities"]];
                                                self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
                                                if(self.arrExtraCountryList.count>0)
                                                {
                                                    indexForExtraCityList = 0;
                                                    [self loadExtraCityView:indexForExtraCityList];
                                                    //indexForExtraCityList++;
                                                    btnAddCity.hidden = FALSE;
                                                }
                                                else
                                                {
                                                    btnAddCity.hidden = TRUE;
                                                }
                                            }];
                UIAlertAction *NoAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                           {
                                               self.arrExtraCountryList = [NSMutableArray arrayWithObject:[dict valueForKey:@"othercities"]];
                                               self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
                                               if(self.arrExtraCountryList.count>0)
                                               {
                                                   ViewAddExtraCityForSearch.hidden = FALSE;
                                                   indexForExtraCityList = 0;
                                                   [self loadExtraCityView:indexForExtraCityList];
                                                   //indexForExtraCityList++;
                                                   btnAddCity.hidden = FALSE;
                                               }
                                               else
                                               {
                                                   btnAddCity.hidden = TRUE;
                                               }
                                           }];
                [alert addAction:YesAction];
                [alert addAction:NoAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                self.arrExtraCountryList = [NSMutableArray arrayWithObject:[dict valueForKey:@"othercities"]];
                self.arrExtraCountryList = [self.arrExtraCountryList objectAtIndex:0];
                if(self.arrExtraCountryList.count>0)
                {
                    ViewAddExtraCityForSearch.hidden = FALSE;
                    indexForExtraCityList = 0;
                    [self loadExtraCityView:indexForExtraCityList];
                    //indexForExtraCityList++;
                    btnAddCity.hidden = FALSE;
                }
                else
                {
                    btnAddCity.hidden = TRUE;
                }
            }
            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            strCountryId = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",strCountryId];
            
            arrCityData = [NSMutableArray arrayWithObject:[self.arrCountryData mutableCopy]];
            [[arrCityData objectAtIndex:0]setValue:@"1" forKey:@"ismain"];
        }
        // [self loadDistance];
    }
    
    else if([self.strTripType isEqualToString:@"2"])
    {
       // self.arrData =  [[NSMutableArray alloc]init];
        if(self.isFromEditTrip==FALSE)
        {
//            arrDataMultiCountryCityData = [[NSArray alloc]init];
//
//            NSMutableDictionary *dictMultiCountryData = [[NSMutableDictionary alloc]init];
//            NSMutableDictionary *dictDataMultiCity =  [[NSMutableDictionary alloc]init];
//            dictMultiCountryData = [[NSUserDefaults standardUserDefaults] objectForKey:PREF_MULTI_COUNTRY_DATA];
//            dictDataMultiCity = [dictMultiCountryData valueForKey:@"countries"];
//            arrDataMultiCountryCityData = [dictDataMultiCity copy];
            //[self loadAllMultiCountryData];
            [self loadMultiCountryAllAttractions];
//            [self loadDataForIndexSelected:indexForCountrySelected];
            //[self loadDistance];
        }
        else if(self.isFromEditTrip==TRUE)
        {
//            self.arrData = [[NSMutableArray alloc]initWithObjects:[_dictSearchData valueForKey:@"multicountries"], nil];
//            self.arrData = [self.arrData objectAtIndex:0];
//            [self loadDataForIndexSelected:indexForCountrySelected];
        }
    }
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        btnAddCity.hidden = TRUE;
        btnSaveChanges.hidden = TRUE;
    }
    [collectionView reloadData];

    HIDE_AI;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //dispatch_async(dispatch_get_main_queue(), ^{
    // });
    [self loadDistance];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    repeatCnt = 0;
}

- (void)loadDistance
{
    if([self.strTripType isEqualToString:@"1"] || [self.strTripType isEqualToString:@"4"])
    {
        if(arrCityData.count>1)
        {
            NSArray *arr = [arrCityData valueForKey:@"rome2rio_name"];
            NSMutableArray *arr12 = [[NSMutableArray alloc]init];
            for(int i=0;i<arr.count;i++)
            {
                [arr12 addObject:[NSDictionary dictionaryWithObject:arr[i] forKey:@"name"]];
            }
            for(int i=0;i<arrCityData.count;i++)
            {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[arrCityData objectAtIndex:i]];
                            [dict removeObjectForKey:@"sortorder"];
                            [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                            [arrCityData replaceObjectAtIndex:i withObject:dict];
            }
            NSError *error;
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr12 options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            [self wsLoadCityDistance:jsonString];
        }
        else
        {
            [collectionView reloadData];
        }
    }
    else if([self.strTripType isEqualToString:@"2"])
    {
        if(arrCityData.count>1)
        {
            NSArray *arr = [arrCityData valueForKey:@"rome2rio_name"];
            NSMutableArray *arr12 = [[NSMutableArray alloc]init];
            
            for(int i=0;i<arr.count;i++)
            {
                [arr12 addObject:[NSDictionary dictionaryWithObject:arr[i] forKey:@"name"]];
            }
            NSError *error;
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr12 options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            
            [self wsLoadCityDistance:jsonString];
        }
        else
        {
            [collectionView reloadData];
        }
    }
    else if([self.strTripType isEqualToString:@"3"])
    {
            if(arrCityData.count>1)
            {
                NSArray *arr = [arrCityData valueForKey:@"rome2rio_name"];
                NSMutableArray *arr12 = [[NSMutableArray alloc]init];
                
                for(int i=0;i<arr.count;i++)
                {
                    [arr12 addObject:[NSDictionary dictionaryWithObject:arr[i] forKey:@"name"]];
                }
                NSError *error;
                NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr12 options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [self wsLoadCityDistance:jsonString];
            }
            else
            {
                [collectionView reloadData];
                HIDE_AI;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];

//    HIDE_AI;
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)loadAllMultiCountryData
{
    for(int i=0;i<arrDataMultiCountryCityData.count;i++)
    {
        for(int j=0;j<self.arrCountryDataForOptSelected.count;j++)
        {
            NSString *strCountryIdSelected = [[self.arrCountryDataForOptSelected valueForKey:@"countryid"]objectAtIndex:j];

            if([[[arrDataMultiCountryCityData valueForKey:@"country_id"] objectAtIndex:i] isEqualToString:strCountryIdSelected])
            {
                [self.arrData addObject:[[arrDataMultiCountryCityData objectAtIndex:i]mutableCopy]];
            }
        }
    }
    NSLog(@"self.arrData : :: %@",self.arrData);
}

-(void)loadMultiCountryAllAttractions
{
    for(int i=0;i<self.arrData.count;i++)
    {
        NSMutableDictionary *objCountryData = [[self.arrData objectAtIndex:i]mutableCopy];
        NSMutableArray *arrDataForCity = [[objCountryData valueForKey:@"cityData"]mutableCopy];
        
        NSString *strCountryId = [objCountryData valueForKey:@"country_id"];
        strCountryId = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        strCountryId = [NSString stringWithFormat:@"\"country_id\":%@",strCountryId];
        
        for(int j=0;j<arrDataForCity.count;j++)
        {
            NSString *strCityIds = [[arrDataForCity valueForKey:@"id"]objectAtIndex:j];
            strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
            NSString *strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",strCountryId,strCityIds];
            [self wsLoadCityAttractions:strCityCountryId : @""];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
            dict = [[arrDataForCity objectAtIndex:j]mutableCopy];
            
            
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"country_id"] forKey:@"country_id"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"country_name"] forKey:@"country_name"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"continent_id"] forKey:@"continent_id"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"slug"] forKey:@"slug"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"country_total_days"] forKey:@"country_total_days"];
            [dict setObject:[dict valueForKey:@"rome2rio_name"] forKey:@"city_rome2rio_name"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"rome2rio_country_name"] forKey:@"country_rome2rio_name"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"country_id"] forKey:@"countryid"];
            [dict setObject:[[self.arrData objectAtIndex:i] valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
            
            [dict addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
                                             self.arrAttractionData ,@"filestore", nil]];
            [arrDataForCity replaceObjectAtIndex:j withObject:dict];
        }
        
        [objCountryData setObject:arrDataForCity forKey:@"cityData"];
        [self.arrData replaceObjectAtIndex:i withObject:objCountryData];
    }
    

}

-(void)loadDataForIndexSelected :(int)index
{
    self.arrCountryData = [self.arrData objectAtIndex:index];
    //[arrCityData removeAllObjects];
    arrCityData = [NSMutableArray arrayWithObject:[[self.arrCountryData valueForKey:@"cityData"]mutableCopy]];
    arrCityData = [arrCityData objectAtIndex:0];
    [self.arrDistanceBetweenCities removeAllObjects];

    if(arrCityData.count==[[self.arrCountryData valueForKey:@"noofcities"]intValue])
        btnAddCity.hidden = TRUE;
    else
        btnAddCity.hidden = FALSE;
    
    lblCountryName.text =[self.arrCountryData valueForKey:@"country_name"];
    txtCountryDetails.text = [self.arrCountryData valueForKey:@"country_conclusion"];

    NSString *strurl =[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_COUNTRY,[self.arrCountryData valueForKey:@"countryimage"]];
    strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:strurl];
    dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(qLogo, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        if(data)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgViewCoutryImage.image = img;
            });
        }
    });
    
    [self SetScrollViewData];
    
    NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
    NSArray *arr = [arrCityData valueForKey:@"id"];
    NSString *strCityIds = [arr componentsJoinedByString:@","];
    if([Helper getPREFint:@"isFromViewItinerary"]!=1)
    {
        [self wsAddCityForCountry:strCountryId :strCityIds];
    }
//    [self wsAddCityForCountry:strCountryId :strCityIds];
    
    if(_arrExtraCountryList.count>0)
        btnAddCity.hidden = FALSE;
    else
        btnAddCity.hidden = TRUE;
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        btnSaveChanges.hidden = TRUE;
    }
    else
    {
        btnSaveChanges.hidden = FALSE;
        [Helper setPREFint:0 :@"isFromViewItinerary"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBACTION METHOD
-(void)loadExtraCityView :(int)index
{
    lblCityNameSearch.text = [[self.arrExtraCountryList valueForKey:@"city_name"] objectAtIndex:indexForExtraCityList];
    lblCityDaysSearch.text = [NSString stringWithFormat:@"%@ Days",[[self.arrExtraCountryList valueForKey:@"total_days"] objectAtIndex:indexForExtraCityList]];
    
    NSURL *urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[[self.arrExtraCountryList valueForKey:@"cityimage"] objectAtIndex:indexForExtraCityList]]];
    
    dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(qLogo, ^{
        NSData *data = [NSData dataWithContentsOfURL:urlImg];
        UIImage *img = [[UIImage alloc] initWithData:data];
        if(data)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgSearchCity.image = img;
            });
        }
    });
}

- (IBAction)pressCloseAddCity:(id)sender
{
    viewAddCityView.hidden = TRUE;
}

-(IBAction)pressAddCity:(id)sender
{
    if([self.strTripType isEqualToString:@"3"])
    {
        indexForExtraCityList = 0;
        if(self.arrExtraCountryList.count>0)
        {
            [self loadExtraCityView:indexForExtraCityList];
            ViewAddExtraCityForSearch.hidden = FALSE;
        }
        else
            btnAddCity.hidden = true;
    }
    else
    {
//                NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
//                NSArray *arr = [arrCityData valueForKey:@"id"];
//                NSString *strCityIds = [arr componentsJoinedByString:@","];
//                [self wsAddCityForCountry:strCountryId :strCityIds];
//
//        if(_arrExtraCountryList.count>0)
//        {
            viewAddCityView.hidden = FALSE;

            [tblAddCity reloadData];
//        }
//        else
//        {
//            viewAddCityView.hidden = TRUE;
//            UIAlertController * alert=   [UIAlertController
//                                          alertControllerWithTitle:@""
//                                          message:@"No more city available!"
//                                          preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                //do something when click button
//            }];
//            [alert addAction:okAction];
//            [self presentViewController:alert animated:YES completion:nil];
//        }

    }
}

-(IBAction)pressSaveChanges:(id)sender
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self wsSaveTripData];
        });
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please log in to save the trip."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
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
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//-(NSMutableArray*)removeNotSelectedValues :(NSMutableArray*)arrToPass
//{
//    NSMutableArray *arrFileStoreData = [arrToPass valueForKey:@"filestore"];
//    
//    NSMutableArray *arrCopy = [[NSMutableArray alloc]init];
//    if([self.strTripType isEqualToString:@"3"])
//    {
//        for(int i=0;i<arrFileStoreData.count;i++)
//        {
//            NSObject *obj = [arrFileStoreData objectAtIndex:i];
//            if(!([[obj valueForKey:@"tempremoved"] intValue]==0 && [[obj valueForKey:@"isselected"] intValue]==0))
//            {
//                [arrCopy addObject:obj];
//            }
//        }
//    }
//    [arrToPass setValue:arrCopy forKey:@"filestore"];
//    return arrToPass;
//}

-(IBAction)pressShowAttraction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    if([self.strTripType isEqualToString:@"1"]||[self.strTripType isEqualToString:@"4"])
    {
            self.strCityIdSelected = [[arrCityData valueForKey:@"id"] objectAtIndex:i];
            self.strCityNameSelected = [[arrCityData valueForKey:@"city_name"] objectAtIndex:i];
            self.strCitySlugSelected = [[arrCityData valueForKey:@"cityslug"] objectAtIndex:i];
            self.strLatitudeCitySelected = [[arrCityData valueForKey:@"latitude"]objectAtIndex:i];
            self.strLongitudeCitySelected = [[arrCityData valueForKey:@"longitude"]objectAtIndex:i];
            arrDataforCity = [NSMutableArray arrayWithObject:[[arrCityData objectAtIndex:i]mutableCopy]];
            arrDataforCity = [arrDataforCity objectAtIndex:0];
            //arrDataforCity = [self removeNotSelectedValues:arrDataforCity];
            self.strCountryId = [self.arrCountryData valueForKey:@"country_id"];
    }
    else if([self.strTripType isEqualToString:@"2"])
    {
            arrCountryData = [self.arrData objectAtIndex:indexForCountrySelected];
            arrCityData  = [arrCountryData valueForKey:@"cityData"];
            //arrCityData = [arrCityData objectAtIndex:i];
            arrDataforCity = [NSMutableArray arrayWithObject:[[arrCityData objectAtIndex:i]mutableCopy]];
            arrDataforCity = [arrDataforCity objectAtIndex:0];

            //arrDataforCity = [self removeNotSelectedValues:arrDataforCity];

            self.strCityIdSelected = [[arrCityData valueForKey:@"id"] objectAtIndex:i];
            self.strCityNameSelected = [[arrCityData valueForKey:@"city_name"] objectAtIndex:i];
            self.strCitySlugSelected = [[arrCityData valueForKey:@"cityslug"] objectAtIndex:i];
            self.strLatitudeCitySelected = [[arrCityData valueForKey:@"latitude"]objectAtIndex:i];
            self.strLongitudeCitySelected = [[arrCityData valueForKey:@"longitude"]objectAtIndex:i];
            self.strCountryId = [self.arrCountryData valueForKey:@"country_id"];
    }
    else if([self.strTripType isEqualToString:@"3"])
    {
            self.strCityIdSelected = [[arrCityData valueForKey:@"id"] objectAtIndex:i];
            self.strCityNameSelected = [[arrCityData valueForKey:@"city_name"] objectAtIndex:i];
            self.strCitySlugSelected = [[arrCityData valueForKey:@"city_name"] objectAtIndex:i];
            self.strLatitudeCitySelected = [[arrCityData valueForKey:@"latitude"]objectAtIndex:i];
            self.strLongitudeCitySelected = [[arrCityData valueForKey:@"longitude"]objectAtIndex:i];
            self.strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            arrDataforCity = [NSMutableArray arrayWithObject:[[arrCityData objectAtIndex:i]mutableCopy]];
            arrDataforCity = [arrDataforCity objectAtIndex:0];
            //arrDataforCity = [self removeNotSelectedValues:arrDataforCity];
    }
    [self performSegueWithIdentifier:@"segueAttactionList" sender:self];
}

-(IBAction)deleteDetails:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Are you sure you want to delete this city?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    [arrDistanceBetweenCities removeAllObjects];
                                    //    if([self.strTripType isEqualToString:@"1"] || [self.strTripType isEqualToString:@"3"])
                                    {
                                        [arrCityData removeObjectAtIndex:i];
                                        
                                        if([self.strTripType isEqualToString:@"2"])
                                        {
                                            [self.arrCountryData setValue:arrCityData forKey:@"cityData"];
                                            [self.arrData replaceObjectAtIndex:indexForCountrySelected withObject:self.arrCountryData];
                                        }
                                        
                                        if(arrCityData.count==[[self.arrCountryData valueForKey:@"noofcities"]intValue])
                                            btnAddCity.hidden = TRUE;
                                        else
                                            btnAddCity.hidden = FALSE;
                                        
                                        if([self.strTripType isEqualToString:@"3"])
                                        {
                                            [self wsGetOtherCitiesForSearch];
                                        }
                                        if([self.strTripType isEqualToString:@"2"] || [self.strTripType isEqualToString:@"1"] || [self.strTripType isEqualToString:@"4"])
                                        {
                                            NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
                                            NSArray *arr = [arrCityData valueForKey:@"id"];
                                            NSString *strCityIds = [arr componentsJoinedByString:@","];
                                            if([Helper getPREFint:@"isFromViewItinerary"]!=1)
                                            {
                                                [self wsAddCityForCountry:strCountryId :strCityIds];
                                            }
                                        }
                                    }
                                    if(arrCityData.count>=1)
                                    {
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self loadDistance];
                                            [collectionView reloadData];
                                        });
                                    }
                                    else
                                        [collectionView reloadData];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pressNextCitySearch:(id)sender
{
    if ([self.arrExtraCountryList count] != 0)
    {
        if(self.arrExtraCountryList.count == 1)
        {
            indexForExtraCityList = 0;
            btnPreviousCity.hidden = TRUE;
            btnNextCity.hidden = TRUE;
        }
        else
        {
            btnNextCity.hidden = FALSE;
            btnPreviousCity.hidden = FALSE;
            NSInteger count = [self.arrExtraCountryList count];
            if(count-1 > indexForExtraCityList)
            {
                indexForExtraCityList++;
                if(count-1 == indexForExtraCityList)
                {
                    btnNextCity.hidden = TRUE;
                }
            }
            else
            {
                btnNextCity.hidden = TRUE;
            }
        }
        [self loadExtraCityView:indexForExtraCityList];
    }
}

- (IBAction)pressPreviousCitySearch:(id)sender
{
    if ([self.arrExtraCountryList count] != 0)
    {
        if(self.arrExtraCountryList.count == 1)
        {
            indexForExtraCityList = 0;
            //            pageCntrl.currentPage = index+1;
            btnPreviousCity.hidden = TRUE;
        }
        else
        {
            if(indexForExtraCityList != 0)
            {
                indexForExtraCityList--;
                btnPreviousCity.hidden = FALSE;
                btnNextCity.hidden = FALSE;
                
                if(indexForExtraCityList==0)
                    btnPreviousCity.hidden = TRUE;
            }
        }
        [self loadExtraCityView:indexForExtraCityList];
    }
}

- (IBAction)pressCancelAddCity:(id)sender
{
    ViewAddExtraCityForSearch.hidden = TRUE;
}

- (IBAction)pressAddCitySearch:(id)sender
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
    dict = [[self.arrExtraCountryList objectAtIndex:indexForExtraCityList]mutableCopy];
    [dict setValue:[dict valueForKey:@"city_name"] forKey:@"cityslug"];
    [dict setValue:[self.arrCountryData valueForKey:@"countryimage"] forKey:@"countryimage"];
    [dict setValue:[self.arrCountryData valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
    [dict setValue:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
    [dict setValue:[self.arrCountryData valueForKey:@"country_id"] forKey:@"country_id"];
    [dict setValue:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
//    [dict setValue:[dict valueForKey:@"total_days"] forKey:@"totaldaysneeded"];
    
    [dict setValue:@"0" forKey:@"ismain"];

    ViewAddExtraCityForSearch.hidden = true;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.tbl reloadData];
        
        NSString *strCityIds = [dict valueForKey:@"id"];
        strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
        
        NSString *strCountryIdForJSON = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        strCountryIdForJSON = [NSString stringWithFormat:@"\"country_id\":%@",strCountryIdForJSON];

        NSString *strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",strCountryIdForJSON,strCityIds];
        [self wsLoadCityAttractions:strCityCountryId : @""];
        
        NSMutableArray *arrCopy = [[NSMutableArray alloc]init]; //[self.arrAttractionData mutableCopy];
        if([self.strTripType isEqualToString:@"3"])
        {
            arrCopy  = [self.arrAttractionData mutableCopy];
        }
        else
        {
            for(int i=0;i<self.arrAttractionData.count;i++)
            {
                if([[[[self.arrAttractionData valueForKey:@"properties"] valueForKey:@"tag_star"] objectAtIndex:i] intValue] ==0)
                {
                    //  [self.arrAttractionData removeObjectAtIndex:i];
                }
                else
                {
                    [arrCopy addObject:[self.arrAttractionData objectAtIndex:i]];
                }
            }
        }
        [dict addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
                                         arrCopy ,@"filestore", nil]];

        [arrCityData addObject:dict];
        
        [self wsGetOtherCitiesForSearch];
        //[self loadCityAttractions];
        [self loadDistance];
        [collectionView reloadData];
    });
}

-(IBAction)pressBack:(id)sender
{
    if(self.isFirstTimeSaved==TRUE && self.strItineraryIdSelected.length>0)// || self.isFromEditTrip==true)
        [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)showCityListForCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    indexForCountrySelected = (int)i;
    [self SetScrollViewData];
    [self loadDataForIndexSelected:indexForCountrySelected];
}

- (IBAction)pressAddExtraCity:(id)sender
{
    ViewAddExtraCityForSearch.hidden = true;
}


#pragma mark - MULTI COUNTRY LIST SCROLL METHODS

-(void)SetScrollViewData
{
    NSArray *arr = scrollCountryList.subviews;
    for(int i=0;i<[arr count];i++)
    {
        [[arr objectAtIndex:i] removeFromSuperview];
    }
    
    int x = 10;
    int y = 10;
    
    for( int i = 0; i < self.arrData.count; i++)
    {
        NSString *strBtnTitle = [[self.arrData valueForKey:@"country_name"] objectAtIndex:i];
        CGSize stringsize = [strBtnTitle sizeWithAttributes:
                             @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
        btnCountryName = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCountryName.titleLabel.font =[UIFont systemFontOfSize:14];
        [btnCountryName setTitle:strBtnTitle forState:UIControlStateNormal];
        btnCountryName.titleLabel.backgroundColor = [UIColor clearColor];
        btnCountryName.tag = i;
        
        [btnCountryName addTarget:self action:@selector(showCityListForCountry:) forControlEvents:UIControlEventTouchUpInside];
        [btnCountryName setFrame:CGRectMake(x,y,stringsize.width+30,30)];
        btnCountryName.alpha = 1.0;
        btnCountryName.titleEdgeInsets = UIEdgeInsetsMake(5, 8,5, 8);
        
        [btnCountryName invalidateIntrinsicContentSize];
        [scrollCountryList addSubview:btnCountryName];
        
        if(i==indexForCountrySelected)
        {
            btnCountryName.alpha = 1.0;
            btnCountryName.backgroundColor = COLOR_ORANGE;
        }
        else{
            btnCountryName.backgroundColor = [UIColor grayColor];
        }
        x += stringsize.width +50;
    }
    scrollCountryList.contentSize = CGSizeMake(x + 100, 35);
    [collectionView reloadData];
}


#pragma mark- ==== WebServiceMethod =======

-(void)wsAddCityForCountry :(NSString*)strCountryId :(NSString*)strCityIdList
{
    @try{
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    strCountryId,@"country_id",
                                    strCityIdList,@"cityids",
                                    nil];
          //  SHOW_AI;
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ADD_CITY_LIST dicParams:Parameters];
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

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

                        //do something when click button
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
//                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
//                    dicResponce = [dict mutableCopy];
                    //dict = nil;

                    _arrExtraCountryList = [[NSMutableArray alloc]initWithObjects:[dicResponce valueForKey:@"data"], nil];
                    _arrExtraCountryList = [_arrExtraCountryList objectAtIndex:0];
                }
            };
            [wsLogin send];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

-(void)wsLoadCityDistance :(NSString*)strcityName
{
    @try{
        //    SHOW_AI;
        strcityName = [strcityName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    strcityName,@"rome2rio_name",
                                    nil];
        
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ROME2RIO_DISCTANCE dicParams:Parameters];
            wsLogin.isLogging=TRUE;
            wsLogin.isSync=TRUE;
            wsLogin.onSuccess=^(NSDictionary *dicResponce)
            {
                HIDE_AI;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
                NSString *strMessage = [dicResponce objectForKey:@"message"];
                if(strMessage.length==0)
                    strMessage = MSG_NO_MESSAGE;
                
                if(intStatus == 1)
                {
                    NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
                        dictData = [[dicResponce valueForKey:@"data"]copy];
                        self.arrDistanceBetweenCities = [[NSMutableArray alloc]init];
                        self.arrDistanceBetweenCities = [dictData mutableCopy];
                        dictData = nil;
                    
                    for(int i=0;i<arrCityData.count;i++)
                    {
                        NSObject *obj = [arrCityData objectAtIndex:i];
//                        if(self.arrDistanceBetweenCities.count>0 && (i < self.arrDistanceBetweenCities.count-1))
                        {
                            if(i==0)
                            {
                                [obj setValue:@"" forKey:@"nextdistance"];
                            }
                            else if(self.arrDistanceBetweenCities.count==1)
                            {
                                [obj setValue:[[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:0] forKey:@"nextdistance"] ;
                            }
                            else
                            {
                                [obj setValue:[[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i-1] forKey:@"nextdistance"] ;
                            }
                        }
                        [arrCityData replaceObjectAtIndex:i withObject:obj];
                    }
                        if(self.arrDistanceBetweenCities.count>0)
                        {
                            [self.arrDistanceBetweenCities insertObject:[NSDictionary dictionaryWithObject:@"" forKey:@"nextdistance"] atIndex:0];
                        }
                    [collectionView reloadData];
                }
            };
            [wsLogin send];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

-(void)wsGetOtherCitiesForSearch
{
    @try{
        NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
        strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
        for(int i=0;i<arrCityData.count;i++)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
            [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
            [dict setObject:[[arrCityData objectAtIndex:0] valueForKey:@"country_id"] forKey:@"country_id"];
            [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"total_days"];
            [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"latitude"] forKey:@"latitude"];
            [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"longitude"] forKey:@"longitude"];
            [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
            
//            if([[[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"]intValue]==0)
//                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"totaldaysneeded"];
//            else
//                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"] forKey:@"totaldaysneeded"];

            [dictCountryWiseCityData addObject:dict];
        }

        NSError *error;
        NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryWiseCityData options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
        jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    strInput,@"inputs",
                                    jsonCityDataString,@"cities",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ADD_DELETE_SEARCH_CITY dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
//            if([strMessage isEqualToString:@"No Extra City found"])
//                btnAddCity.hidden = true;

            if(intStatus == 0)
            {
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:strMessage
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                }];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
                NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                dicResponce = [dict mutableCopy];
                dict = nil;
                
                self.arrExtraCountryList = [[dicResponce valueForKey:@"data"]mutableCopy];
                if(self.arrExtraCountryList.count>0)
                    btnAddCity.hidden = FALSE;
                else
                    btnAddCity.hidden = TRUE;
            }
            else
            {
                NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                dicResponce = [dict mutableCopy];
                dict = nil;

                self.arrExtraCountryList = [[dicResponce valueForKey:@"data"]mutableCopy];
                if(self.arrExtraCountryList.count>0)
                    btnAddCity.hidden = FALSE;
                else
                    btnAddCity.hidden = TRUE;
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

-(void)wsLoadCityAttractions :(NSString*)strCityCountryId :(NSString*)isnew
{
    @try{
        NSString *str = [NSString stringWithFormat:@"%@",strCityCountryId];
        
        NSString *strInput;
        if(![self.strTripType isEqualToString:@"3"])
            strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
        else
            strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
        NSData* data = [strInput dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *strTags = [values valueForKey:@"searchtags"];
        strTags = [strTags stringByReplacingOccurrencesOfString:@"[" withString:@""];
        strTags = [strTags stringByReplacingOccurrencesOfString:@"]" withString:@""];
        strTags = [strTags stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        strTags = [strTags stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    str,@"countryidwithcityid",
                                    strTags,@"tags",
                                    isnew,@"isnew",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_ATTRACTION_CITY dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
         //   HIDE_AI;
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
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                self.arrAttractionData  = [[[dicResponce valueForKey:@"data"]objectAtIndex:0]mutableCopy];
                NSLog(@"self.arrAttractionData : : :%@",self.arrAttractionData);
                self.arrAttractionData = [self.arrAttractionData valueForKey:@"attractions"];
                self.arrAttractionData = [self.arrAttractionData valueForKey:@"filestore"];
                self.arrAttractionData = [self.arrAttractionData objectAtIndex:0];
                
                for(int i=0;i<self.arrAttractionData.count;i++)
                {
                    NSObject *obj = [self.arrAttractionData objectAtIndex:i];
                    
                    //[obj setValue:[NSNumber numberWithInt:1] forKey:@"isselected"];
                    [obj setValue:[NSNumber numberWithInt:i] forKey:@"order"];
                }
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

-(void)wsSaveTripData
{
    int type = [self.strTripType intValue];
    if(type==4)
        type = 1;
    // SEARCH FLOW
    if([self.strTripType isEqualToString:@"3"])
    {
        if(self.isFromEditTrip==FALSE) // SAVING FOR FIRST TIME
        {
            NSString *strMainCityId;
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            for(int i=0;i<arrCityData.count;i++)
            {
                NSString *strDistance;
                if(i==arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                
                if([[[arrCityData objectAtIndex:i]valueForKey:@"ismain"]isEqualToString:@"1"])
                    strMainCityId = [[arrCityData valueForKey:@"id"]objectAtIndex:i];

                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"total_days"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"latitude"] forKey:@"latitude"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"longitude"] forKey:@"longitude"];
                [dict setObject:[[arrCityData objectAtIndex:0] valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"cityid"] forKey:@"cityid"];
                [dict setObject:[[arrCityData objectAtIndex:0] valueForKey:@"countryimage"] forKey:@"countryimage"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
                [dict setObject:[[arrCityData objectAtIndex:0] valueForKey:@"country_name"] forKey:@"country_name"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"code"] forKey:@"code"];
//                if([[[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"]intValue]==0)
//                    [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"totaldaysneeded"];
//                else
//                    [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"] forKey:@"totaldaysneeded"];
                [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                [dict setObject:strDistance forKey:@"nextdistance"];

                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryWiseCityData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            ///////////////------------ATTRACTION DATA----------/////////////
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<arrCityData.count;i++)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                
                [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);

            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *strCountryId;
                strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput;
                if(![self.strTripType isEqualToString:@"3"])
                    strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                else
                    strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                
                [Parameters setObject:strMainCityId forKey:@"main_cityid"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SAVE_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                    dicResponce = [dict mutableCopy];
                    dict = nil;

                    //   HIDE_AI;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            self.isFromEditTrip = TRUE;
                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        }];
                        [alert addAction:MyTripAction];

                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
        else // EDIT SEARCH TRIP
        {
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            NSString *strMainCityId;

            for(int i=0;i<arrCityData.count;i++)
            {
                NSString *strDistance;
                if(i==arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                
                if([[[arrCityData objectAtIndex:i]valueForKey:@"ismain"]isEqualToString:@"1"])
                    strMainCityId = [[arrCityData valueForKey:@"id"]objectAtIndex:i];

                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"total_days"] forKey:@"total_days"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"latitude"] forKey:@"latitude"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"longitude"] forKey:@"longitude"];
                [dict setObject:[[arrCityData objectAtIndex:0] valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[self.arrCountryData valueForKey:@"countryimage"] forKey:@"countryimage"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
//                [dict setObject:@"" forKey:@"rome2rio_name"];
//                [dict setObject:@"" forKey:@"code"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"cityid"] forKey:@"cityid"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"code"] forKey:@"code"];
                [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"cityid"] forKey:@"cityid"];
                
                if([[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"] != nil)
                    [dict setObject:[[arrCityData objectAtIndex:i] valueForKey:@"totaldaysneeded"] forKey:@"totaldaysneeded"];
                else
                    [dict setObject:@"" forKey:@"totaldaysneeded"];
                [dict setObject:strDistance forKey:@"nextdistance"];

                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            // NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictCountryWiseCityData,[NSString stringWithFormat:@"%@",[self.arrCountryData valueForKey:@"country_id"]], nil];
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryWiseCityData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            ///////////////------------ATTRACTION DATA----------/////////////
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<arrCityData.count;i++)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                
                [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);

            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *strCountryId;
                strCountryId = [[arrCityData valueForKey:@"country_id"]objectAtIndex:0];
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput;
                    strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DESTI_DATA]];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                [Parameters setObject:strMainCityId forKey:@"main_cityid"];
                [Parameters setObject:self.strItineraryIdSelected forKey:@"itineraryid"];
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = true;
                            //self.isFromEditTrip = TRUE;
//                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        }];
                        [alert addAction:MyTripAction];

                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
    }
    else if([self.strTripType isEqualToString:@"1"] || [self.strTripType isEqualToString:@"4"]) //SINGLE COUNTRY
    {
        if(self.isFromEditTrip==FALSE) //FIRST TIME SAVE
        {
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            for(int i=0;i<arrCityData.count;i++)
            {
                NSObject *objCityData = [arrCityData objectAtIndex:i];
                NSString *strDistance;
                if(i==arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                [dict setObject:[self.arrCountryData valueForKey:@"slug"] forKey:@"slug"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
                [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                [dict setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [dict setObject:[NSNumber numberWithInt:[[objCityData valueForKey:@"sortorder"]intValue]] forKey:@"sortorder"];
                
                if([objCityData valueForKey:@"timetoreach"] != nil)
                    [dict setObject:[objCityData valueForKey:@"timetoreach"] forKey:@"timetoreach"];
                else
                    [dict setObject:@"" forKey:@"timetoreach"];

                if([objCityData valueForKey:@"actualtime"] != nil)
                    [dict setObject:[objCityData valueForKey:@"actualtime"] forKey:@"actualtime"];
                else
                    [dict setObject:@"" forKey:@"actualtime"];
                
                [dict setObject:strDistance forKey:@"nextdistance"];
                [dict setObject:[objCityData valueForKey:@"totaltags"] forKey:@"totaltags"];
//                [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];

                if([objCityData valueForKey:@"total_days"] != nil)
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                else
                    [dict setObject:@"" forKey:@"total_days"];

                
                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictCountryWiseCityData,[NSString stringWithFormat:@"%@",[self.arrCountryData valueForKey:@"country_id"]], nil];
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<arrCityData.count;i++)
            {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                    
                    [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            strCountryId = [self.arrCountryData valueForKey:@"country_id"];

            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SAVE_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                    dicResponce = [dict mutableCopy];
                    dict = nil;

                    //   HIDE_AI;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            //do something when click button
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            self.isFromEditTrip = TRUE;
                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [self loadInitialData];
//                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        }];
                        [alert addAction:MyTripAction];

                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
//                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
        else // EDIT SINGLE 
        {
            NSMutableArray *dictCountryWiseCityData = [[NSMutableArray alloc]init];
            for(int i=0;i<arrCityData.count;i++)
            {
//                if(isFirstTimeSaved==true)
//                    arrCityData = [[self.arrCountryData valueForKey:@"cityData"]mutableCopy];

                NSObject *objCityData = [arrCityData objectAtIndex:i];
                NSString *strDistance;
                if(i==arrCityData.count-1)
                    strDistance = @"";
                else
                    strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                [dict setObject:[self.arrCountryData valueForKey:@"slug"] forKey:@"slug"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_id"] forKey:@"country_id"];
                [dict setObject:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
                [dict setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [dict setObject:[NSNumber numberWithInt:[[objCityData valueForKey:@"sortorder"]intValue]] forKey:@"sortorder"];
                [dict setObject:strDistance forKey:@"nextdistance"];
//                if([[NSString stringWithFormat:@"%@",[objCityData valueForKey:@"totaltags"]]length]==0)
//                    [dict setObject:@"" forKey:@"totaltags"];
//                else
                
                if([objCityData valueForKey:@"totaltags"] != nil)
                    [dict setObject:[objCityData valueForKey:@"totaltags"] forKey:@"totaltags"];
                else
                    [dict setObject:@"" forKey:@"totaltags"];

                if([objCityData valueForKey:@"total_days"] != nil)
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                else
                    [dict setObject:@"" forKey:@"total_days"];

//                [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                if(self.isFirstTimeSaved)
                    [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                else //(!self.isFirstTimeSaved)
                    [dict setObject:[objCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                
//                [dict setObject:@"" forKey:@"timetoreach"];

                if([objCityData valueForKey:@"timetoreach"] != nil) 
                    [dict setObject:[objCityData valueForKey:@"timetoreach"] forKey:@"timetoreach"];
                else
                    [dict setObject:@"" forKey:@"timetoreach"];

                    
//                if([[NSString stringWithFormat:@"%@",[objCityData valueForKey:@"actualtime"]]length]==0)
                    [dict setObject:@"" forKey:@"actualtime"];
//                else
                if([objCityData valueForKey:@"actualtime"] != nil)
                    [dict setObject:[objCityData valueForKey:@"actualtime"] forKey:@"actualtime"];
                else
                    [dict setObject:@"" forKey:@"actualtime"];
                //[dict setObject:@"" forKey:@"rome2rio_country_name"];
                if(self.isFirstTimeSaved)
                    [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                else
                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                [dictCountryWiseCityData addObject:dict];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryWiseCityData);
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictCountryWiseCityData,[NSString stringWithFormat:@"%@",[self.arrCountryData valueForKey:@"country_id"]], nil];
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            ///////////////------------ATTRACTION DATA----------/////////////
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            for(int i=0;i<arrCityData.count;i++)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrCityData objectAtIndex:i]valueForKey:@"filestore"],[[arrCityData objectAtIndex:i]valueForKey:@"id"], nil];
                
                [arrCityWiseAttractionData addEntriesFromDictionary:dict];
            }
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error1;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *strCountryId;
            if([self.strTripType isEqualToString:@"1"])
            {
                strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            }
            else
            {
                strCountryId = [[self.arrCountryDataForOptSelected valueForKey:@"country_id"] objectAtIndex:indexForCountrySelected];
            }
            
            @try{
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                [Parameters setObject:self.strItineraryIdSelected forKey:@"itineraryid"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            //self.isFromEditTrip = TRUE;
                            //self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        }];
                        [alert addAction:MyTripAction];

                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];

//                        self.isFromEditTrip = TRUE;
//                        self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];

//                        [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
    }
    else if([self.strTripType isEqualToString:@"2"]) //MULTI COUNTRY
    {
        if(self.isFromEditTrip==FALSE) //FIRST TIME SAVE
        {
            NSMutableDictionary *dictCountryCitywiseData = [[NSMutableDictionary alloc]init];
            for(int i=0;i<self.arrData.count;i++)
            {
                NSMutableArray *arrDataForCity = [[NSMutableArray alloc]init];
                NSMutableDictionary *dict;
                NSMutableArray *objArrCityData = [[self.arrData valueForKey:@"cityData"] objectAtIndex:i];
                for(int j=0;j<objArrCityData.count;j++)
                {
                    NSObject *objCityData = [objArrCityData objectAtIndex:j];
                    NSString *strDistance;
                    //                    if(i==arrDataForCountryAtIndex.count-1)
                    strDistance = @"";
                    //                    else
                    //                        strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                    dict = [NSMutableDictionary dictionaryWithCapacity:20];
                    [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                    [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                    [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                    [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"citylatitude"];
                    [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"citylongitude"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"country_id"];
                    [dict setObject:[objCityData valueForKey:@"country_name"] forKey:@"country_name"];
                    [dict setObject:[objCityData valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
                    [dict setObject:[objCityData valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
                    [dict setObject:[objCityData valueForKey:@"continent_id"] forKey:@"continent_id"];
                    [dict setObject:[objCityData valueForKey:@"slug"] forKey:@"slug"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                    [dict setObject:[objCityData valueForKey:@"country_total_days"] forKey:@"country_total_days"];
                    [dict setObject:[objCityData valueForKey:@"city_rome2rio_name"] forKey:@"city_rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_rome2rio_name"] forKey:@"country_rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"countryid"] forKey:@"countryid"];
                    [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                    [dict setObject:strDistance forKey:@"nextdistance"];
                    [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                    [dict setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                    [arrDataForCity addObject:dict];
                }
                [dictCountryCitywiseData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:arrDataForCity,[NSString stringWithFormat:@"%@",[[arrDataForCity valueForKey:@"country_id"]objectAtIndex:0]], nil]];
                //                [dictCountryWiseCityData addObject:dictCountryCityData];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryCitywiseData);
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryCitywiseData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

            //============================COMBINATION============================
            
            NSString *strCountryId;
            if([self.strTripType isEqualToString:@"1"])
            {
                strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            }
            else
            {
                NSArray *arrCountryId = [self.arrCountryDataForOptSelected valueForKey:@"country_id"];
                strCountryId = [arrCountryId componentsJoinedByString:@"-"];
            }
            NSString *strEncodeKey = [self encodeStringTo64:strCountryId];
            strEncodeKey = [strEncodeKey stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
            strEncodeKey = [strEncodeKey stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            strEncodeKey = [strEncodeKey stringByReplacingOccurrencesOfString:@"=" withString:@"~"];
            
            //=======
            
            NSMutableArray *arrCombinationData = [[NSMutableArray alloc]init];
            NSMutableDictionary *dictCountryCityData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<self.arrData.count;i++)
            {
                NSMutableArray *arrDataForCountryAtIndex = [NSMutableArray arrayWithObject:[arrCountryDataForOptSelected objectAtIndex:i]];
                
                    NSObject *objCityData = [arrDataForCountryAtIndex objectAtIndex:0];
                    NSString *strDistance;
                    strDistance = @"";
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:20];
                    [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                    [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                    [dict setObject:[objCityData valueForKey:@"slug"] forKey:@"slug"];
                    [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"latitude"];
                    [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"longitude"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"country_id"];
                    [dict setObject:[objCityData valueForKey:@"country_name"] forKey:@"country_name"];
                    [dict setObject:[objCityData valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
                    [dict setObject:[objCityData valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                    [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"citylatitude"];
                    [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"citylongitude"];
                    [dict setObject:[objCityData valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
                    [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                    [dict setObject:[objCityData valueForKey:@"country_total_days"] forKey:@"country_total_days"];
                    [dict setObject:[objCityData valueForKey:@"city_rome2rio_name"] forKey:@"city_rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_rome2rio_name"] forKey:@"country_rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"countryid"] forKey:@"countryid"];
                    [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                    [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                    [dictCountryCityData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:dict,[NSString stringWithFormat:@"%d",i], nil]];
            }
            
            [dictCountryCityData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:strEncodeKey,@"encryptkey", nil]];
            [arrCombinationData addObject:dictCountryCityData];
            NSLog(@"arrCombinationData : : : %@",arrCombinationData);
            
            NSError *error1;
            NSData *jsonCombiData = [NSJSONSerialization dataWithJSONObject:arrCombinationData options:NSJSONWritingPrettyPrinted error:&error1];
            NSString *jsonCombiDataString = [[NSString alloc] initWithData:jsonCombiData encoding:NSUTF8StringEncoding];
            jsonCombiDataString = [jsonCombiDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //=======
            
            //=======------------ATTRACTION DATA----------=======//
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];

            for(int i=0;i<self.arrData.count;i++)
            {
                NSMutableDictionary *objCountryData = [[self.arrData objectAtIndex:i]mutableCopy];
                NSMutableArray *arrDataForCity = [[objCountryData valueForKey:@"cityData"]mutableCopy];
                
                for(int j=0;j<arrDataForCity.count;j++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrDataForCity objectAtIndex:j]valueForKey:@"filestore"],[[arrDataForCity objectAtIndex:j]valueForKey:@"id"], nil];
                    
                    [arrCityWiseAttractionData addEntriesFromDictionary:dict];
                }
            }
            
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error12;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error12];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

            //[self wsSaveTripData:jsonCityDataString :jsonAttrDataString];
            //}
            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                [Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonCombiDataString forKey:@"combinations"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SAVE_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                    dicResponce = [dict mutableCopy];
                    dict = nil;

                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            //do something when click button
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            self.isFromEditTrip = TRUE;
                            self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        }];
                        [alert addAction:MyTripAction];

                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];

//                        self.isFromEditTrip = TRUE;
//                        self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
//
////                        [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
//                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
        else
        {
            NSMutableDictionary *dictCountryCitywiseData = [[NSMutableDictionary alloc]init];
            for(int i=0;i<self.arrData.count;i++)
            {
                //                NSMutableArray *arrDataForCountryAtIndex = [NSMutableArray arrayWithObject:[arrCountryDataForOptSelected objectAtIndex:i]];
                NSMutableArray *arrDataForCity = [[NSMutableArray alloc]init];
                NSMutableDictionary *dict;
                NSMutableArray *objArrCityData = [[self.arrData valueForKey:@"cityData"] objectAtIndex:i];
                for(int j=0;j<objArrCityData.count;j++)
                {
                    NSObject *objCityData = [objArrCityData objectAtIndex:j];
                    NSString *strDistance;
                    //                    if(i==arrDataForCountryAtIndex.count-1)
                    strDistance = @"";
                    //                    else
                    //                        strDistance = [[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:i+1];
                    dict = [NSMutableDictionary dictionaryWithCapacity:20];
                    [dict setObject:[objCityData valueForKey:@"id"] forKey:@"id"];
                    [dict setObject:[objCityData valueForKey:@"city_name"] forKey:@"city_name"];
                    [dict setObject:[objCityData valueForKey:@"cityslug"] forKey:@"cityslug"];
                    [dict setObject:[objCityData valueForKey:@"latitude"] forKey:@"citylatitude"];
                    [dict setObject:[objCityData valueForKey:@"longitude"] forKey:@"citylongitude"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_name"] forKey:@"rome2rio_name"];
                    [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"country_id"];
                    [dict setObject:[objCityData valueForKey:@"country_name"] forKey:@"country_name"];
                    
                    if([objCityData valueForKey:@"countrylatitude"] != nil)
                        [dict setObject:[objCityData valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
                    else
                        [dict setObject:@"" forKey:@"countrylatitude"];

                    if([objCityData valueForKey:@"countrylongitude"] != nil)
                        [dict setObject:[objCityData valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
                    else
                        [dict setObject:@"" forKey:@"countrylongitude"];

                    if([objCityData valueForKey:@"continent_id"] != nil)
                        [dict setObject:[objCityData valueForKey:@"continent_id"] forKey:@"continent_id"];
                    else
                        [dict setObject:@"" forKey:@"continent_id"];

                    [dict setObject:[objCityData valueForKey:@"slug"] forKey:@"slug"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
                    //[dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];

                    if([objCityData valueForKey:@"total_days"] != nil)
                        [dict setObject:[objCityData valueForKey:@"total_days"] forKey:@"total_days"];
                    else
                        [dict setObject:@"" forKey:@"total_days"];

                    if([objCityData valueForKey:@"country_total_days"] != nil)
                        [dict setObject:[objCityData valueForKey:@"country_total_days"] forKey:@"country_total_days"];
                    else
                        [dict setObject:@"" forKey:@"country_total_days"];

                    if([objCityData valueForKey:@"city_rome2rio_name"] != nil)
                        [dict setObject:[objCityData valueForKey:@"city_rome2rio_name"] forKey:@"city_rome2rio_name"];
                    else
                        [dict setObject:@"" forKey:@"city_rome2rio_name"];

                    if([objCityData valueForKey:@"country_rome2rio_name"] != nil)
                        [dict setObject:[objCityData valueForKey:@"country_rome2rio_name"] forKey:@"country_rome2rio_name"];
                    else
                        [dict setObject:@"" forKey:@"country_rome2rio_name"];
                    
                    if([objCityData valueForKey:@"country_id"] != nil)
                        [dict setObject:[objCityData valueForKey:@"country_id"] forKey:@"countryid"];
                    else
                        [dict setObject:[objCityData valueForKey:@"countryid"] forKey:@"countryid"];
                    [dict setObject:[objCityData valueForKey:@"code"] forKey:@"code"];
                    [dict setObject:[objCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
                    [dict setObject:strDistance forKey:@"nextdistance"];
                    [dict setObject:[NSNumber numberWithInt:i] forKey:@"sortorder"];
                    [arrDataForCity addObject:dict];
                }
                [dictCountryCitywiseData addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:arrDataForCity,[NSString stringWithFormat:@"%@",[[arrDataForCity valueForKey:@"country_id"]objectAtIndex:0]], nil]];
                //                [dictCountryWiseCityData addObject:dictCountryCityData];
            }
            NSLog(@"dictCountryWiseCityData : : : %@",dictCountryCitywiseData);
            
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:dictCountryCitywiseData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

            //=======------------ATTRACTION DATA----------=======//
            
            NSMutableDictionary *arrCityWiseAttractionData = [[NSMutableDictionary alloc]init];
            
            for(int i=0;i<self.arrData.count;i++)
            {
                NSMutableDictionary *objCountryData = [[self.arrData objectAtIndex:i]mutableCopy];
                NSMutableArray *arrDataForCity = [[objCountryData valueForKey:@"cityData"]mutableCopy];
                
                for(int j=0;j<arrDataForCity.count;j++)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[arrDataForCity objectAtIndex:j]valueForKey:@"filestore"],[[arrDataForCity objectAtIndex:j]valueForKey:@"id"], nil];
                    
                    [arrCityWiseAttractionData addEntriesFromDictionary:dict];
                }
            }
            
            NSLog(@"arrCityWiseAttractionData : : : %@",arrCityWiseAttractionData);
            
            NSError *error12;
            NSData *jsonAttrData = [NSJSONSerialization dataWithJSONObject:arrCityWiseAttractionData options:NSJSONWritingPrettyPrinted error:&error12];
            NSString *jsonAttrDataString = [[NSString alloc] initWithData:jsonAttrData encoding:NSUTF8StringEncoding];
            jsonAttrDataString = [jsonAttrDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

            //[self wsSaveTripData:jsonCityDataString :jsonAttrDataString];
            //}
            
            NSString *strCountryId;
            if([self.strTripType isEqualToString:@"1"])
            {
                strCountryId = [self.arrCountryData valueForKey:@"country_id"];
            }
            else
            {
                NSArray *arrCountryId = [self.arrCountryDataForOptSelected valueForKey:@"country_id"];
                strCountryId = [arrCountryId componentsJoinedByString:@"-"];
            }

            @try{
                NSMutableDictionary *Parameters = [NSMutableDictionary dictionaryWithCapacity:8];
                NSString *strInput = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_INPUT_SEARCH_DATA]];
                strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                NSArray *arrCountryId = [self.arrData valueForKey:@"country_id"];
                strCountryId = [arrCountryId componentsJoinedByString:@"-"];

                [Parameters setObject:[Helper getPREF:PREF_UID] forKey:@"userid"];
                //[Parameters setObject:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
                [Parameters setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
                [Parameters setObject:[NSString stringWithFormat:@"%@",strCountryId] forKey:@"country_id"];
                [Parameters setObject:strInput forKey:@"inputs"];
                [Parameters setObject:jsonCityDataString forKey:@"countryidwithcities"];
                [Parameters setObject:jsonAttrDataString forKey:@"city_attractions"];
                [Parameters setObject:self.strItineraryIdSelected forKey:@"itineraryid"];

                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_TRIP dicParams:Parameters];
                wsLogin.isLogging=TRUE;
                wsLogin.isSync=TRUE;
                wsLogin.onSuccess=^(NSDictionary *dicResponce)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    //   HIDE_AI;
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
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            //do something when click button
                        }];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:strMessage
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            self.isFirstTimeSaved = FALSE;
                            //self.isFromEditTrip = TRUE;
                            //self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
                            //                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [self loadInitialData];
                            //                            });
                        }];
                        [alert addAction:okAction];
                        UIAlertAction *MyTripAction = [UIAlertAction actionWithTitle:@"My Trips" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        }];
                        [alert addAction:MyTripAction];

                        [self presentViewController:alert animated:YES completion:nil];
                        //[self performSegueWithIdentifier:@"segueShowTripList" sender:self];
                        //                        [self.navigationController popToRootViewControllerAnimated:YES];

//                        self.isFromEditTrip = TRUE;
//                        self.strItineraryIdSelected = [dicResponce valueForKey:@"itinerary_id"];
//
////                        [self performSegueWithIdentifier:@"segueShowTripList" sender:self];
//                        //                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                [wsLogin send];
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
            }
        }
    }
}

- (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}

#pragma mark - UITABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrExtraCountryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [[_arrExtraCountryList valueForKey:@"city_name"]objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;// UITableViewAutomaticDimension;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [[_arrExtraCountryList objectAtIndex:indexPath.row]mutableCopy];
    
    //if([self.strTripType isEqualToString:@"1"] || [self.strTripType isEqualToString:@"3"])
    {
        strCountryId = [self.arrCountryData valueForKey:@"country_id"];
        NSString *strCityIds = [dict valueForKey:@"id"];
        strCityIds = [NSString stringWithFormat:@"\"cityid\":%@",strCityIds];
        
        NSString *strCountryIdForJSON = [strCountryId stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        strCountryIdForJSON = [NSString stringWithFormat:@"\"country_id\":%@",strCountryIdForJSON];
        
        NSString *strCityCountryId = [NSString stringWithFormat:@"[{%@,%@}]",strCountryIdForJSON,strCityIds];
        [self wsLoadCityAttractions:strCityCountryId : @"1"];
        
        NSMutableArray *arrCopy = [[NSMutableArray alloc]init]; //[self.arrAttractionData mutableCopy];
        if([self.strTripType isEqualToString:@"3"])
        {
            arrCopy  = [self.arrAttractionData mutableCopy];
        }
        else
        {
            for(int i=0;i<self.arrAttractionData.count;i++)
            {
//                if([[[[self.arrAttractionData valueForKey:@"properties"] valueForKey:@"tag_star"] objectAtIndex:i] intValue] ==0)
//                {
//                    //  [self.arrAttractionData removeObjectAtIndex:i];
//                }
//                else
//                {
                
                NSObject *obj = [self.arrAttractionData objectAtIndex:i];
                if([[[[self.arrAttractionData valueForKey:@"properties"] valueForKey:@"tag_star"] objectAtIndex:i] intValue] ==0)
                {
                    [obj setValue:[NSNumber numberWithInt:0] forKey:@"isselected"];
                }
                [obj setValue:[NSNumber numberWithInt:i] forKey:@"order"];

                    [arrCopy addObject:obj];
//                }
            }
        }
        
        for(int i=0;i<arrCopy.count;i++)
        {
            NSObject *obj = [arrCopy objectAtIndex:i];
            
//            [obj setValue:[NSNumber numberWithInt:1] forKey:@"isselected"];
            [obj setValue:[NSNumber numberWithInt:i] forKey:@"order"];
        }
        
        [dict addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:
                                         arrCopy,@"filestore", nil]];
        if([self.strTripType isEqualToString:@"1"])
        {
            if([[arrCityData objectAtIndex:0] valueForKey:@"rome2rio_country_name"] != nil)
                [dict setObject:[arrCityData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
            else
                [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];

            if([[arrCityData objectAtIndex:0] valueForKey:@"rome2rio_code"] != nil)
                [dict setObject:[arrCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
            else
                [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];

//            [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
            //[dict setObject:[self.arrCountryData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
        }
        else if ([self.strTripType isEqualToString:@"2"])
        {
            [dict setObject:[self.arrCountryData valueForKey:@"country_id"] forKey:@"country_id"];
            [dict setObject:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
            [dict setObject:[self.arrCountryData valueForKey:@"countrylatitude"] forKey:@"countrylatitude"];
            [dict setObject:[self.arrCountryData valueForKey:@"countrylongitude"] forKey:@"countrylongitude"];
           // [dict setObject:[self.arrCountryData valueForKey:@"continent_id"] forKey:@"continent_id"];
            [dict setObject:[self.arrCountryData valueForKey:@"slug"] forKey:@"slug"];
            [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_country_name"] forKey:@"rome2rio_country_name"];
            [dict setObject:[self.arrCountryData valueForKey:@"country_total_days"] forKey:@"country_total_days"];
            [dict setObject:[dict valueForKey:@"rome2rio_name"] forKey:@"city_rome2rio_name"];
            [dict setObject:[dict valueForKey:@"rome2rio_country_name"] forKey:@"country_rome2rio_name"];
            [dict setObject:[dict valueForKey:@"country_id"] forKey:@"countryid"];
            if([[arrCityData objectAtIndex:0] valueForKey:@"rome2rio_code"] != nil)
                [dict setObject:[arrCityData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
            else
                [dict setObject:[self.arrCountryData valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];

            //[dict setObject:[[arrCityData objectAtIndex:0] valueForKey:@"rome2rio_code"] forKey:@"rome2rio_code"];
        }
        else if([self.strTripType isEqualToString:@"3"])
        {
            [dict setValue:@"0" forKey:@"ismain"];
            [dict setValue:[dict valueForKey:@"city_name"] forKey:@"cityslug"];
            [dict setValue:[self.arrCountryData valueForKey:@"countryimage"] forKey:@"countryimage"];
            [dict setValue:[self.arrCountryData valueForKey:@"country_conclusion"] forKey:@"country_conclusion"];
            [dict setValue:[self.arrCountryData valueForKey:@"country_name"] forKey:@"country_name"];
            [dict setValue:[self.arrCountryData valueForKey:@"country_id"] forKey:@"country_id"];
            [dict setValue:[Helper getPREF:@"strTokenId"] forKey:@"uniqueid"];
            [dict setValue:[dict valueForKey:@"cityid"] forKey:@"cityid"];
        }
    }
    [dict setObject:@"" forKey:@"total_days"];
    [dict setObject:@"" forKey:@"totaltags"];
    [dict setObject:@"" forKey:@"cityid"];

    [dict setObject:@"" forKey:@"timetoreach"];
    [dict setObject:@"" forKey:@"actualtime"];

    [arrCityData addObject:dict];
    
    if([self.strTripType isEqualToString:@"2"])
    {
        [self.arrCountryData setValue:arrCityData forKey:@"cityData"];
        [self.arrData replaceObjectAtIndex:indexForCountrySelected withObject:self.arrCountryData];
    }

    if([self.strTripType isEqualToString:@"2"] || [self.strTripType isEqualToString:@"1"])
    {
        NSString *strCountryId = [self.arrCountryData valueForKey:@"country_id"];
        NSArray *arr = [arrCityData valueForKey:@"id"];
        NSString *strCityIds = [arr componentsJoinedByString:@","];
        
        if([Helper getPREFint:@"isFromViewItinerary"]!=1)
        {
            [self wsAddCityForCountry:strCountryId :strCityIds];
        }
    }

    if([self.strTripType isEqualToString:@"3"])
    {
        
        [self wsGetOtherCitiesForSearch];
    }
    else //if([self.strTripType isEqualToString:@"1"])
    {
        if((arrCityData.count==[[self.arrCountryData valueForKey:@"noofcities"]intValue]) || (_arrExtraCountryList.count==0))
            btnAddCity.hidden = TRUE;
        else
            btnAddCity.hidden = FALSE;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self loadCityAttractions];
        [self loadDistance];
        [collectionView reloadData];
    });
    viewAddCityView.hidden = true;
}

#pragma mark - UICollectionViewDataSource methods

#pragma mark - CollectionView Method ===

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex
{
       return arrCityData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CitySwipeCollectionCell *cell = [collectionView1 dequeueReusableCellWithReuseIdentifier:@"CitySwipeCollectionCell" forIndexPath:indexPath];
    NSURL *url;
    NSString *strTitle;
    int sortOrder=0;
    NSString *strDisctance = @"";
    
    if([self.strTripType isEqualToString:@"1"] || [self.strTripType isEqualToString:@"4"])
    {//
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[[arrCityData valueForKey:@"cityimage"]objectAtIndex:indexPath.row]]];
        strTitle = [[arrCityData valueForKey:@"city_name"] objectAtIndex:indexPath.row];
        sortOrder = [[[arrCityData valueForKey:@"sortorder"] objectAtIndex:indexPath.row]intValue];
        if(self.arrDistanceBetweenCities.count>0 && (indexPath.row < self.arrDistanceBetweenCities.count-1))
        {
            strDisctance = [NSString stringWithFormat:@"%@ to %@\n",strTitle,[[arrCityData valueForKey:@"city_name"] objectAtIndex:indexPath.row+1]];
        }
        NSInteger totalCity = arrCityData.count;
        if(totalCity==1)
            cell.btnDelete.hidden = true;
        else
            cell.btnDelete.hidden = FALSE;
    }
    else if([self.strTripType isEqualToString:@"2"])
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[[arrCityData valueForKey:@"cityimage"]objectAtIndex:indexPath.row]]];
        strTitle = [[arrCityData valueForKey:@"city_name"] objectAtIndex:indexPath.row];
        sortOrder = [[NSString stringWithFormat:@"%li",indexPath.row]intValue];//[[[arrCityData valueForKey:@"sortorder"] objectAtIndex:indexPath.row]intValue];
        if(self.arrDistanceBetweenCities.count>0 && (indexPath.row < self.arrDistanceBetweenCities.count-1))
        {
            strDisctance = [NSString stringWithFormat:@"%@ to %@\n",strTitle,[[arrCityData valueForKey:@"city_name"] objectAtIndex:indexPath.row+1]];
        }
        NSInteger totalCity = arrCityData.count;
        if(totalCity==1)
            cell.btnDelete.hidden = true;
        else
            cell.btnDelete.hidden = FALSE;
    }
    else if([self.strTripType isEqualToString:@"3"])// && self.isFromEditTrip==FALSE)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[[arrCityData valueForKey:@"cityimage"]objectAtIndex:indexPath.row]]];
        strTitle = [[arrCityData valueForKey:@"city_name"] objectAtIndex:indexPath.row];
        sortOrder = [[NSString stringWithFormat:@"%li",indexPath.row]intValue];
        //sortOrder = [[[arrCountryData valueForKey:@"sortorder"] objectAtIndex:indexPath.row]intValue];
        if(self.arrDistanceBetweenCities.count>0 && (indexPath.row < self.arrDistanceBetweenCities.count-1))
        {
            strDisctance = [NSString stringWithFormat:@"%@ to %@\n",strTitle,[[arrCityData valueForKey:@"city_name"] objectAtIndex:indexPath.row+1]];
        }

        if([[[arrCityData valueForKey:@"ismain"]objectAtIndex:indexPath.row]intValue]==1)
        {
            cell.btnDelete.hidden = TRUE;
        }
        else
        {
            cell.btnDelete.hidden = FALSE;
        }
    }
    
    dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(qLogo, ^{
        /* Fetch the image from the server... */
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        if(data)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgView.image = img;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.taxidio.com/assets/images/cairo.jpg"]]];
            });
        }
    });
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.clipsToBounds = NO;
    
    cell.viewBg.layer.cornerRadius=5;
    cell.viewBg.layer.borderWidth=1.0;
    cell.viewBg.layer.masksToBounds = YES;
    
    cell.lblSortOrder.text = [NSString stringWithFormat:@"#%d",sortOrder+1];
    cell.lblTitle.text = strTitle;
    cell.lblTitle.textColor = [UIColor whiteColor];
    
    if(self.arrDistanceBetweenCities.count>0 && (indexPath.row < self.arrDistanceBetweenCities.count-1))
    {
        strDisctance = [NSString stringWithFormat:@"%@ %@",strDisctance,[[self.arrDistanceBetweenCities valueForKey:@"nextdistance"] objectAtIndex:indexPath.row+1]];
        cell.imgViewPlane.hidden = FALSE;
    }
    else
    {
        cell.imgViewPlane.hidden = TRUE;
        strDisctance = @"";
    }
    cell.lblDistance.text = strDisctance;
    cell.imgView.layer.cornerRadius = 10;
    cell.imgView.clipsToBounds = YES;
    [cell bringSubviewToFront:cell.btnDelete];
    
    [cell.btnDelete addTarget:self action:@selector(deleteDetails:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDelete setTag:indexPath.row];
    [cell.btnExploreCity addTarget:self action:@selector(pressShowAttraction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnExploreCity setTag:indexPath.row];
    
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        cell.btnDelete.hidden = TRUE;
    }

    BOOL walkthroughCity = [[NSUserDefaults standardUserDefaults] boolForKey: @"walkthroughCity"];

    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = window.safeAreaInsets.top;
    if(topPadding>0)
        topPadding = topPadding - 20;
    

    if(indexPath.row==0 && repeatCnt==0 && (![self.strTripType isEqualToString:@"3"]) && !walkthroughCity && ([Helper getPREFint:@"isFromViewItinerary"]!=1) && topPadding==0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"walkthroughCity"];
        repeatCnt++;
        
        NSInteger totalCity = arrCityData.count;

        CGRect coachmarkbtnCity = CGRectMake(collectionView.frame.origin.x+ cell.frame.origin.x, collectionView.frame.origin.y+220, cell.frame.size.width, cell.frame.size.height);
        
        CGRect coachmarkbtnDelete = CGRectMake(collectionView.frame.origin.x + cell.btnDelete.frame.origin.x, collectionView.frame.origin.y+220+cell.btnDelete.frame.origin.y, cell.btnDelete.frame.size.width, cell.btnDelete.frame.size.height);
        
        CGRect coachmarkbtnExploreCity = CGRectMake(collectionView.frame.origin.x + cell.btnExploreCity.frame.origin.x, collectionView.frame.origin.y+220+cell.btnExploreCity.frame.origin.y, cell.btnExploreCity.frame.size.width+10, cell.btnExploreCity.frame.size.height+10);

        NSArray *coachMarks = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkbtnCity],
                                    @"caption": @"Long press & drag the city to rearrange the order",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                                    //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                    @"showArrow":[NSNumber numberWithBool:YES]
                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkbtnExploreCity],
                                    @"caption": @"Let’s explore the city",
                                    @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                    @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT_BOTTOM],
                                    //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                    @"showArrow":[NSNumber numberWithBool:YES]
                                  }
                                ];
        NSArray *coachMarks1 = @[
                                    @{
                                      @"rect": [NSValue valueWithCGRect:coachmarkbtnDelete],
                                      @"caption": @"Tap this to remove the city",
                                      @"shape": [NSNumber numberWithInteger:SHAPE_SQUARE],
                                      @"position":[NSNumber numberWithInteger:LABEL_POSITION_LEFT],
                                      //                                        @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_LEFT],
                                      @"showArrow":[NSNumber numberWithBool:YES]
                                      }
                                    ];
        NSArray *newArray;
        if(totalCity>1)
            newArray =[coachMarks arrayByAddingObjectsFromArray:coachMarks1];
        else
            newArray =[coachMarks mutableCopy];

        MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.view.bounds coachMarks:newArray];
        [self.view addSubview:coachMarksView];
        [coachMarksView start];
    }
    return cell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {

    }
    else
    {
        NSObject *obj;
        obj = [arrCityData [fromIndexPath.item]mutableCopy];
        [arrCityData removeObjectAtIndex:fromIndexPath.item];
        [arrCityData insertObject:obj atIndex:toIndexPath.item];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if(self.isFromEditTrip==TRUE && ([Helper getPREFint:@"isFromViewItinerary"]==1))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"did end drag");
    [self loadDistance];
}

-(void)getLineStartPoint:(CGPoint*)startPoint
             andEndPoint:(CGPoint*)endPoint
     fromCellAtIndexPath:(NSIndexPath*)fromIndexPath
       toCellAtIndexPath:(NSIndexPath*)toIndexPath
{
    UICollectionViewLayoutAttributes* fromAttributes =
    [collectionView layoutAttributesForItemAtIndexPath:fromIndexPath];
    
    UICollectionViewLayoutAttributes* toAttributes = [collectionView layoutAttributesForItemAtIndexPath:toIndexPath];
    
    *startPoint = fromAttributes.center;
    *endPoint = toAttributes.center;
}

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueShowTripList"])
    {
        MyTripsVC *viewController = (MyTripsVC*)[segue destinationViewController];
    }
    else if([[segue identifier] isEqualToString:@"segueAttactionList"])
    {
        CityLocationSwipeVC *detail = (CityLocationSwipeVC *)[segue destinationViewController];
        detail.strCountryId = self.strCountryId;
        detail.arrData = arrDataforCity;
        detail.strTripType = self.strTripType;
        detail.strCityName = self.strCityNameSelected;
        detail.strLatitude = self.strLatitudeCitySelected;
        detail.strLongitude = self.strLongitudeCitySelected;
        detail.strCitySlug = self.strCitySlugSelected;
        detail.strCityId = self.strCityIdSelected;
        detail.arrCityData = arrCityData;
        detail.arrCountryData = arrCountryData;
        detail.isFirstTimeSaved = self.isFirstTimeSaved;
        detail.isFromEditTrip = self.isFromEditTrip;
        detail.strItineraryIdSelected = self.strItineraryIdSelected;
        detail.arrCountryDataForOptSelected = self.arrCountryDataForOptSelected;
        detail.arrMultiCountryData = self.arrData;
    }
}

@end
