//
//  MMYelpMapVC.m
//  Photo Kooky
//
//  Created by David Johnston on 3/4/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import "MMYelpMapVC.h"
    

@interface MMYelpMapVC ()
{
    
    __weak IBOutlet MKMapView *yelpMap;
    NSMutableDictionary *yelpSearchResultsDictionary;
    NSMutableDictionary *singlePhotoDictionary;
    NSArray *arrayForPhotosArray;
    NSString *searchText;
    UIImage *imageToTransfer;
    NSString *idStringToPass;
    NSString *photoLatitude;
    NSString *photoLongitude;
    NSString *photoName;        //This is to pass to the second viewController


}

@end

@implementation MMYelpMapVC

//.......NEW YELP SEARCH CODE..........3/4/13

@synthesize currentLocation;
@synthesize searchLonString;
@synthesize searchLatString;



- (void) submitYelpSearch
{
    //[activityWheel startAnimating];
    //Set search text field as search query text.
    
    
    
    searchText = @"food";
    
    
    
    
    //searchTextField.text;
    //Request pictures matching search query
    
    //old search string without lat and lon
    //    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&lat=41.894032&lon=-87.634742&radius=3&extras=geo&accuracy=14&tags=%@&format=json&nojsoncallback=1", searchText];
    
    
    //preparing search URL to take current location - need to create searchLatString and searchLonString variables.......
    //add newLocation.coordinate.latitude, newLocation.coordinate.longitude
    
    NSLog(@"searchlon = %@ searchlat = %@", searchLonString, searchLatString);
    
    
    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=restaurant&lat=41.894032&long=-87.634742&radius=10&limit=5&ywsid=ylWkpXJFz6-ZI3PvDG519A"];
    
    //COME BACK TO THIS ONE!!!!! 3/4/13
    //NSString *flickrURLString =[NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%@&long=%@&radius=10&limit=5&ywsid=ylWkpXJFz6-ZI3PvDG519A", searchText, searchLatString, searchLonString];


                                
                                
                                
                                
                                
                                
                                
                                
                                //@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&lat=%@&lon=%@&radius=3&extras=geo&accuracy=14&tags=%@&format=json&nojsoncallback=1",searchLatString, searchLonString, searchText];
    
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
             

             // NSMutableDictionary *secondDictionary = [photosDictionary valueForKey:@"photos"];
            // arrayForPhotosArray = [secondDictionary valueForKey:@"photo"];
             

             
             
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
             
             //The following line does not work: passes the object in without unpackint it as an array.  Used arrayWithArray instead.
             //businessesArray = [NSMutableArray arrayWithObject:[yelpSearchResultsDictionary objectForKey:@"businesses"]];
             
             businessesArray = [NSMutableArray arrayWithArray:[yelpSearchResultsDictionary objectForKey:@"businesses"]];
             
             
             //NSLog(@"%@, %@", [businessesArray objectAtIndex:0], [businessesArray objectAtIndex:1]);
             
                int numberOfBusiness = businessesArray.count;
             NSLog(@" number of buisniesses %d", numberOfBusiness);
             
             
                for (int i = 0; i < numberOfBusiness; i++)
                {
                    NSDictionary *businessDictionary = [NSDictionary dictionaryWithDictionary:[businessesArray objectAtIndex:i]];
                    
                    NSString *businessLatitudeString = [businessDictionary valueForKey:@"latitude"];
                    NSString *businessLongitudeString = [businessDictionary valueForKey:@"longitude"];
                    
                    float businessLatitude = [businessLatitudeString floatValue];
                    float businessLongitude = [businessLongitudeString floatValue];
                    
                    
                    
                    NSLog(@"lat %f lon %f", businessLatitude, businessLongitude);
                    
                    
                    
                    
                 }
                
             }
             //[activityWheel stopAnimating];
             //[photoTableView reloadData];
//
     }];

             














//..........END OF NEW YELP SEARCH CODE...... 3/4/13



}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self submitYelpSearch];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
