//
//  ViewController.h
//  Photo Kooky
//
//  Created by David Johnston on 2/20/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMControllerDelegate.h"
#import <YelpKit/YelpKit.h>


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
{
    //GPS variables
    CLLocationManager *missLocationManager;

}

@property (strong, nonatomic)  NSString *searchLatString;
@property (strong, nonatomic)  NSString *searchLonString;

//
//Methods for GPS updates, gets called to update new location
//
- (void)startLocationUpdates;


//part of CLLocationDelegate necessary code
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

// don't think I need this..
//-(void)updatePersonalCoordinates: (CLLocationCoordinate2D)newCoordinate;





@property (strong, nonatomic) CLLocation *currentLocation;


-(IBAction)unwindToSearchTableView:(UIStoryboardSegue *)segue;


@end
