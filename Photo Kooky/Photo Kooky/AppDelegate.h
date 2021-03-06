//
//  AppDelegate.h
//  Photo Kooky
//
//  Created by David Johnston on 2/20/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    //NSManagedObjectContext *managedObjectContext;
}

@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) UIWindow *window;

@end
