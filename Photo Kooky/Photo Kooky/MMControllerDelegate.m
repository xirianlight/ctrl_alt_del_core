//
//  MMControllerDelegate.m
//  Photo Kooky
//
//  Created by David Johnston on 2/26/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//


#import "MMControllerDelegate.h"

@implementation MMControllerDelegate

@synthesize mrLocationManager;

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.mrLocationManager = [[CLLocationManager alloc]init];
        //send data to myself
        self.mrLocationManager.delegate = self;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
{
    //self.delegate = our viewcontroller.m - we can call methods from here
    [self.delegate locationUpdate:newLocation];
    
}



- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    //self.delegate = our viewcontroller.m
    [self.delegate locationError:error];
}

@end
