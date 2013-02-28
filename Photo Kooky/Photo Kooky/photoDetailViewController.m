//
//  photoDetailViewController.m
//  Photo Kooky
//
//  Created by David Johnston on 2/21/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import "photoDetailViewController.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"


@interface photoDetailViewController ()
{
    __weak IBOutlet MKMapView *detailMapView;
    //__weak IBOutlet MKMapView *myMapView;

    __weak IBOutlet UILabel *photoTitleLabel;
    __weak IBOutlet UIImageView *mapBlackImageCover;
}

@end

@implementation photoDetailViewController

@synthesize imageToShow;
@synthesize detailImageUIImage;
@synthesize photoIdForDetailVC;
@synthesize photoLatitudeForDetailVC;
@synthesize photoLongitudeForDetailVC;


/*

http://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&photo_id=5856017477&format=json&nojsoncallback=1

*/

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self)
//    {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self detailImageUIImage].image = imageToShow;
        //This doesn't work yet, but will eventually take the
        //name of the picture from the selected row & display it
    photoTitleLabel.text = self.photoNameForLabel;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    mapBlackImageCover.alpha = 0;
    [UIView commitAnimations];
    
    
    
    //..................Trying to set the map to the photo lat and lon.............
    
    
    
    //finding the location on the map by coordinates and drawing the map:
    
    float photosLatitude = [photoLatitudeForDetailVC floatValue];
    float photosLongitude = [photoLongitudeForDetailVC floatValue];
    
    NSLog(@"in detail, lat is %@ and lon is %@", photoLatitudeForDetailVC, photoLongitudeForDetailVC);

    
    CLLocationCoordinate2D mmCoordinate =
    {
        //.latitude = 41.894032f,
        //.longitude = -87.634742f
        
        
            .latitude = photosLatitude,
              .longitude = photosLongitude
    };

//    CLLocationCoordinate2D mmCoordinate =
//    {
//        .latitude = 41.894032f,
//        .longitude = -87.634742f
//        
//        
//        //        .latitude = photosLatitude,
//        //        .longitude = photosLongitude
//    };
    
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.002f,
        .longitudeDelta = 0.002f
    };
    
    
    MKCoordinateRegion myRegion = {mmCoordinate, span};
    
    //instantiating the pin  with the Annotation object file
     Annotation *myAnnotation = [[Annotation alloc] init];
    myAnnotation.title = [NSString stringWithFormat:@"%@", photoTitleLabel.text];
    //myAnnotation.subtitle = @"and Don's nose";
    myAnnotation.coordinate = mmCoordinate;
    
    //draws the map
    [detailMapView setRegion:myRegion];
    
    //drops the pin
    [detailMapView addAnnotation:myAnnotation];
    
    
    //..........end of Trying to set the map to the photo lat and lon................
    
}
    //Bonus annotation customization code

//
// Turn this back on and give it an image resource to show on the map view
//
//-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
//    
//    if (annotationView == nil) {
//        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//    }
//    
//    [detailButton addTarget:self
//                     action:@selector(showDetail)
//           forControlEvents:UIControlEventTouchUpInside];
//    //pinView.pinColor = MKAnnotationColorPurple;
//    annotationView.canShowCallout = YES;
//    annotationView.image = [UIImage imageNamed:@"mobile-makers-logo.png"];
//    annotationView.rightCalloutAccessoryView = detailButton;
//    
//    return annotationView;
//}
//
//
//    //Detail Disclosure button behavior
//-(void)showDetail
//{
//    NSLog(@"Detail disclosure button pressed");
//}



//...........................................................................
//We must implement these two methods to be a corlactionManagerDelegate
//these are methods we can call from the CorelocationManager.m to set our location (with the self.delegate lines)
-(void) locationUpdate: (CLLocation *) location;
{
    NSLog(@"%@", [location description]);
    
}

-(void) locationError: (NSError *) error;
{
    NSLog(@"%@", [error description]);
}

//..........................................



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
