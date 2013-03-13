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
    NSMutableDictionary *yelpSearchResultsDictionary;
}

@end

@implementation photoDetailViewController

@synthesize imageToShow;
@synthesize detailImageUIImage;
@synthesize photoIdForDetailVC;
@synthesize photoLatitudeForDetailVC;
@synthesize photoLongitudeForDetailVC;
@synthesize searchWord;


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
    myAnnotation.annotationType = @"currentLocation";
    
    //draws the map
    [detailMapView setRegion:myRegion];
    
    //drops the pin
    [detailMapView addAnnotation:myAnnotation];
    
    [self submitYelpSearch];
    
    
    //..........end of Trying to set the map to the photo lat and lon................
    
}


//Bonus annotation customization code
//
// Turn this back on and give it an image resource to show on the map view
//
-(MKPinAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MKPinAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    }
    
    [detailButton addTarget:self
                     action:@selector(showDetail)
           forControlEvents:UIControlEventTouchUpInside];
    annotationView.canShowCallout = YES;
    //annotationView.image = [UIImage imageNamed:@"mobile-makers-logo.png"];
    annotationView.rightCalloutAccessoryView = detailButton;
    if ([((Annotation *)annotation).annotationType isEqual: @"currentLocation"])
    {
        annotationView.pinColor = MKPinAnnotationColorGreen;

    }
    else{
        annotationView.pinColor = MKPinAnnotationColorRed;
    }

    
    return annotationView;
}
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


//YELP STUFF ADDED 3/6/13


- (void) submitYelpSearch
{
    
    float photosLatitude = [photoLatitudeForDetailVC floatValue];
    float photosLongitude = [photoLongitudeForDetailVC floatValue];
    
    NSLog(@"searchlon = %f searchlat = %f", photosLatitude, photosLongitude);
    
    //url with search string
    //    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.yelp.com/business_review_search?&term=%@lat=%f&long=%f&radius=1&limit=5&ywsid=ylWkpXJFz6-ZI3PvDG519A",searchWord, photosLatitude, photosLongitude ];
    
    //url witouth search string
    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.yelp.com/business_review_search?&lat=%f&long=%f&radius=.025&limit=20&ywsid=ylWkpXJFz6-ZI3PvDG519A", photosLatitude, photosLongitude ];
    
    
    //Code to go from URL string to JSON request
    NSURL *flickrURL = [NSURL URLWithString:flickrURLString];
    NSMutableURLRequest *flickrURLRequest = [NSMutableURLRequest requestWithURL:flickrURL];
    flickrURLRequest.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^void(NSURLResponse *myResponse, NSData *myData, NSError *myError)
     {
         if (myError)
         {
             NSLog(@"%@", myError.localizedDescription);
         }
         else
         {
             NSError *jsonError;
             id  genericObjectWeKnowIsDictionary =
             [NSJSONSerialization JSONObjectWithData:myData
                                             options:NSJSONReadingAllowFragments
                                               error:&jsonError];
             //Extract usable search results from raw JSON data
             yelpSearchResultsDictionary = (NSMutableDictionary *) genericObjectWeKnowIsDictionary;
             
             NSLog(@"%@", [yelpSearchResultsDictionary description]);
             
             
             //             if ([arrayForPhotosArray count]==0)
             //             {
             //                 UIAlertView *noResultsAlert;
             //                 noResultsAlert = [[UIAlertView alloc]
             //                                   initWithTitle:@"No results"
             //                                   message:@"0 results for that search in this area"
             //                                   delegate:self
             //                                   cancelButtonTitle:@"OK"
             //                                   otherButtonTitles: nil];
             //                 [noResultsAlert show];
             //             }
             
             // NSArray *businessesArray = [[NSArray alloc] initWithObjects:[yelpSearchResultsDictionary objectForKey:@"businesses"], nil];
             
             NSMutableArray *businessesArray = [[NSMutableArray alloc]init];
             
                         
             businessesArray = [NSMutableArray arrayWithArray:[yelpSearchResultsDictionary objectForKey:@"businesses"]];
             
                       
             int numberOfBusiness = businessesArray.count;
             NSLog(@" number of buisniesses %d", numberOfBusiness);
             
             
             for (int i = 0; i < numberOfBusiness; i++)
             {
                 NSDictionary *businessDictionary = [NSDictionary dictionaryWithDictionary:[businessesArray objectAtIndex:i]];
                 
                 NSString *businessLatitudeString = [businessDictionary valueForKey:@"latitude"];
                 NSString *businessLongitudeString = [businessDictionary valueForKey:@"longitude"];
                 NSString *businessTitle = [businessDictionary valueForKey:@"name"];
                 NSString *businessCity = [businessDictionary valueForKey:@"city"];
                 
                 
                 //we will have to convert this from a string to an NSURL before use
                 NSString *businessUrl = [businessDictionary valueForKey:@"url"];
                 
                 
                 //we will have to convert this from a string to an NSURL then a UIImage before use
                 NSString *businessThumbnail = [businessDictionary valueForKey:@"photo_url_small"];
                 
                 
                 
                 
                 float businessLatitude = [businessLatitudeString floatValue];
                 float businessLongitude = [businessLongitudeString floatValue];
                 
                 
                 
                 NSLog(@"lat %f lon %f", businessLatitude, businessLongitude);
                 
                 Annotation *newAnnotation;
                 newAnnotation = [[Annotation alloc]init];
                 
                 CLLocationCoordinate2D newCoordinate =
                 {
                     .latitude = businessLatitude,
                     .longitude = businessLongitude
                 };
                 newAnnotation.coordinate = newCoordinate;
                 newAnnotation.title = businessTitle;
                 newAnnotation.subtitle = businessCity;
                 
                 [detailMapView addAnnotation:newAnnotation];
                 
                 
             }
             
         }
     }];

}








//END OF YELP STUFF ADDED 3/6/13





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
