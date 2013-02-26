//
//  Annotation.h
//  Photo Kooky
//
//  Created by David Johnston on 2/26/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
