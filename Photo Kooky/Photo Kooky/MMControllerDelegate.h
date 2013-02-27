//
//  MMControllerDelegate.h
//  Photo Kooky
//
//  Created by David Johnston on 2/26/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

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

