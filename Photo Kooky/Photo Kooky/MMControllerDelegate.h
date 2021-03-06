//
//  MMControllerDelegate.h
//  Photo Kooky
//
//  Created by David Johnston on 2/26/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//


//THIS IS A DELEGATE THAT HANDLES LOCTIONS FROM THE APPLE LOCATION API

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@protocol  MMControllerDelegate <NSObject>

@required
//to be a delegate of me, you must implement these two methods
-(void) locationUpdate: (CLLocation *) location;
-(void) locationError: (NSError *) error;

@end



@interface MMControllerDelegate : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *mrLocationManager;
    id delegate;
}

@property CLLocationManager *mrLocationManager;
@property id <MMControllerDelegate> delegate;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


@end

