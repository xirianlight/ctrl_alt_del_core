//
//  ViewController.m
//  Photo Kooky
//
//  Created by David Johnston on 2/20/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import "ViewController.h"
#import "photoDetailViewController.h"


@interface ViewController ()
{
    NSMutableDictionary *photosDictionary;
    NSMutableDictionary *singlePhotoDictionary;
    NSArray *arrayForPhotosArray;
    NSString *searchText;
    UIImage *imageToTransfer;
    NSString *idStringToPass;
    NSString *photoLatitude;
    NSString *photoLongitude;
    NSString *photoName;        //This is to pass to the second viewController

    
    Annotation *myAnnotation;

    __weak IBOutlet UITextField *searchTextField;
    __weak IBOutlet UITableView *photoTableView;
    __weak IBOutlet UIActivityIndicatorView *activityWheel;
    __weak IBOutlet MKMapView *currentLocationMap;
}

- (IBAction)searchButton:(id)sender;


@end

@implementation ViewController

@synthesize currentLocation;
@synthesize searchLonString;
@synthesize searchLatString;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLocationUpdates];
    
    CLLocationCoordinate2D mmCoordinate =
    {
        //.latitude = 37.78
        //.longitude = -122.40
        
        .latitude = 41.894032f,
        .longitude = -87.634742f
    };
    
    //mmCoordinate.latitude = 41.894032f;
    //mmCoordinate.longitude = -87.634742f;
    
    
    MKCoordinateSpan defaultSpan =
    {
        .latitudeDelta = 0.002f,
        .longitudeDelta = 0.002f
    };
    
    MKCoordinateRegion myRegion = {mmCoordinate, defaultSpan};
    Annotation *myCurrentLocation = [[Annotation alloc] init];
    myCurrentLocation.annotationType = @"currentLocation";
    myCurrentLocation.title = @"You are here.";
    myCurrentLocation.coordinate = mmCoordinate;     
    (MKUserLocation *) myCurrentLocation;

    [currentLocationMap addAnnotation:myCurrentLocation];
    

     [currentLocationMap setRegion:myRegion];

}

//Attempt to make you are here a blue dot


#pragma UITableView methods

    // NUMBER OF ROWS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (photosDictionary == nil)
    {
        return 0;
    }
    else
    {
        return 20;
    }
}

    // NUMBER OF CELLS
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        //setting up my reusable cell
    UITableViewCell *myCustomCell =[tableView dequeueReusableCellWithIdentifier:@"photoCellReuseID"];    
    [arrayForPhotosArray count];
    
    if ([arrayForPhotosArray count] == 0)
    {
        searchTextField.text = @"";
        return myCustomCell;
    }
    else
    {
    
        //collecting all the data from photosDictionary
    NSDictionary *dictionaryForSinglePhoto = [arrayForPhotosArray objectAtIndex:indexPath.row];
    NSString *farmString = [dictionaryForSinglePhoto valueForKey:@"farm"];
    NSString *serverString = [dictionaryForSinglePhoto valueForKey:@"server"];
    NSString *idString = [dictionaryForSinglePhoto valueForKey:@"id"];
        //The following (idString) bay be removable, since we made it to originally look up photo GPS data.
    idStringToPass = idString;
    NSString *secretString = [dictionaryForSinglePhoto valueForKey:@"secret"];
    NSString *titleString  = [dictionaryForSinglePhoto valueForKey:@"title"];    
        //New code to include photo Longitude and Latitude as outputs.
    photoLatitude = [dictionaryForSinglePhoto valueForKey:@"latitude"];
    photoLongitude = [dictionaryForSinglePhoto valueForKey:@"longitude"];
            //Logs out the titles of photos as they load. Nice
    NSLog(@"%@", titleString);
        //making that info into a request for a photo
    NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_m.jpg", farmString, serverString, idString, secretString];
    NSURL *photoURL = [NSURL URLWithString:photoURLString];    
        //making the request online for the photo
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    UIImage *photoImage = [UIImage imageWithData:photoData];
        //Set textfield and images to data from the flickr array
        //Hide both fields to allow for custom textField and picture
    myCustomCell.imageView.image = photoImage;
    myCustomCell.imageView.hidden = YES;
    myCustomCell.textLabel.text = titleString;
    myCustomCell.textLabel.hidden = YES;
        //Find label/pics with tags and populate
    UIView *pictureViewToImage = [myCustomCell viewWithTag:50];
    UIImageView *picture2display = (UIImageView *) pictureViewToImage;
    picture2display.image = photoImage;
        //render the cell
    UIView *textLabel1 = [myCustomCell viewWithTag:51];
    UILabel *textLabel = (UILabel *) textLabel1;
    textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
    textLabel.text = [dictionaryForSinglePhoto valueForKey:@"title"];        //Start annotation code here
        Annotation *newAnnotation;
        newAnnotation = [[Annotation alloc]init];
        newAnnotation.title = titleString;

        float photosLatitude = [photoLatitude floatValue];
        float photosLongitude = [photoLongitude floatValue];
        CLLocationCoordinate2D newCoordinate =
        {
            .latitude = photosLatitude,
            .longitude = photosLongitude
        };
        newAnnotation.coordinate = newCoordinate;
        
        [currentLocationMap addAnnotation:newAnnotation];

        return myCustomCell;
    
    }
    
}

#pragma User Interface buttons and keyboard

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchTextField resignFirstResponder];
    [self submitFlickrSearch];
    return YES;
}

#pragma Storyboard and segues

-(IBAction)unwindToSearchTableView:(UIStoryboardSegue *)segue{
    //Leave this blank, just to unwind the segue
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDetailSegue"])
    {
        UITableViewCell *myCell = (UITableViewCell*)sender;
        imageToTransfer =  myCell.imageView.image;
        photoName = myCell.textLabel.text;
        
        photoDetailViewController *phvc = [segue destinationViewController];
        phvc.photoIdForDetailVC = idStringToPass;
        phvc.photoLongitudeForDetailVC = photoLongitude;
        phvc.photoLatitudeForDetailVC = photoLatitude;
        phvc.imageToShow = imageToTransfer;
        phvc.photoNameForLabel = photoName;
        phvc.searchWord = searchTextField.text;
        
        
        NSLog(@"the latitude is %@", photoLatitude);
        NSLog(@"the longitude is %@", photoLongitude);
        
    }
}

#pragma Flickr Specific

- (void) submitFlickrSearch
{
    [activityWheel startAnimating];
        //Set search text field as search query text.
    searchText = searchTextField.text;
    
    //String conversion to turn spaces into escape characters.

        NSString *searchText_safe = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchText = searchText_safe;
    
    
    //old search string without lat and lon
//    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&lat=41.894032&lon=-87.634742&radius=3&extras=geo&accuracy=14&tags=%@&format=json&nojsoncallback=1", searchText];
    
    
    //preparing search URL to take current location - need to create searchLatString and searchLonString variables.......
    //add newLocation.coordinate.latitude, newLocation.coordinate.longitude
    
    NSLog(@"searchlon = %@ searchlat = %@", searchLonString, searchLatString);
    
    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&lat=%@&lon=%@&radius=3&extras=geo&accuracy=14&tags=%@&format=json&nojsoncallback=1",searchLatString, searchLonString, searchText];
    
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
             photosDictionary = (NSMutableDictionary *) genericObjectWeKnowIsDictionary;
             NSMutableDictionary *secondDictionary = [photosDictionary valueForKey:@"photos"];
             arrayForPhotosArray = [secondDictionary valueForKey:@"photo"];
             
             NSLog(@"%@", [photosDictionary valueForKey:@"pages"]);
             
        
             if ([arrayForPhotosArray count]==0)
             {
                     UIAlertView *noResultsAlert;
                     noResultsAlert = [[UIAlertView alloc]
                                       initWithTitle:@"No results"
                                       message:@"0 results for that search in this area"
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                      otherButtonTitles: nil];
                    [noResultsAlert show];
             }
             [activityWheel stopAnimating];
             [photoTableView reloadData];
             
         }
     }];
}


//this is the "necessary code" for running the MMControllerDelegate, pasted over from MapView.xcodeproj

- (void)startLocationUpdates
{
    if (missLocationManager == nil)
    {
        missLocationManager =[[CLLocationManager alloc]init];
        
    }
    
    missLocationManager.delegate = self;
    
    //turn on the data
    [missLocationManager startMonitoringSignificantLocationChanges];
    
    //or turn it on with this to save battery:
    //will update when it sees we've moved some amount...
    //[missLocationManager startUpdatingLocation];
    
    //this one is accurate enough, and not so battery draining
    missLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
}


//part of CLLocationDelegate necessary code
//method for GPS updated, gets called to update new location
//
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"%@", [newLocation description]);
    
    NSLog(@"lat:%f - lon:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //NSLog(@"%@", [newLocation description]);
    
    //this places the pin
    [self updatePersonalCoordinates:newLocation.coordinate];
    
    //this places the map view center
    [self UpdateMapViewWithNewCenter:newLocation.coordinate];
    
    NSString *latAsString = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    NSString *lonAsString = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    self.searchLatString = latAsString;
    self.searchLonString = lonAsString;
    
}



//THIS IS THE STUFF ADDED IMPERFECTLY THURS, 2/28..............

- (void)UpdateMapViewWithNewCenter: (CLLocationCoordinate2D)newCoordinate
{
    
    //    MKCoordinateSpan defaultSpan =
    //    {
    //        .latitudeDelta = 0.002f,
    //        .longitudeDelta = 0.002f
    //    };
    
    //MKCoordinateRegion newRegion = {newCoordinate, defaultSpan};
    
    MKCoordinateRegion newRegion = {newCoordinate, currentLocationMap.region.span};
    
    [currentLocationMap setRegion:newRegion];
    
    
}


-(void)updatePersonalCoordinates: (CLLocationCoordinate2D)newCoordinate
{
    myAnnotation.coordinate = newCoordinate;
}



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



//END ADDITIONS THURS 2/28.....................






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
