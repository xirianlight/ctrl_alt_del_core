//
//  photoDetailViewController.h
//  Photo Kooky
//
//  Created by David Johnston on 2/21/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"
//#import <MapKit/MapKit.h>
#import "MMControllerDelegate.h"

@interface photoDetailViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
{
    UIImage* imageToShow;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *detailImageUIImage;
@property UIImage* imageToShow;
@property (strong, nonatomic) NSString *photoIdForDetailVC;
@property (strong, nonatomic) NSString *photoLatitudeForDetailVC;
@property (strong, nonatomic) NSString *photoLongitudeForDetailVC;
@property (strong, nonatomic) NSString * photoNameForLabel;

//We must implement these two methods to be a corlactionManagerDelegate

-(void) locationUpdate: (CLLocation *) location;
-(void) locationError: (NSError *) error;

@end
