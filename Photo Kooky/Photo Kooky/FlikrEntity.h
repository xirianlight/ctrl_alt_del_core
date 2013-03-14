//
//  FlikrEntity.h
//  Photo Kooky
//
//  Created by David Johnston on 3/13/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FlikrEntity : NSManagedObject

@property (nonatomic, retain) NSString * flikrPhotoURLThumb;
@property (nonatomic, retain) NSString * flikrPhotoUrlLarge;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * farm;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * secret;
@property (nonatomic, retain) NSString * server;
@property (nonatomic, retain) NSString * imageFileLocation;

@end
