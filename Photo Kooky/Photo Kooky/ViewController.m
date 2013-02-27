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
    
    __weak IBOutlet UITextField *searchTextField;
    __weak IBOutlet UITableView *photoTableView;
    __weak IBOutlet UIActivityIndicatorView *activityWheel;
        
}

- (IBAction)searchButton:(id)sender;


@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

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
    
    UIView *textLabel1 = [myCustomCell viewWithTag:51];
    UILabel *textLabel = (UILabel *) textLabel1;
    textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
    textLabel.text = [dictionaryForSinglePhoto valueForKey:@"title"];
    
    return myCustomCell;
    
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
        
        photoDetailViewController *phvc = [segue destinationViewController];
        phvc.photoIdForDetailVC = idStringToPass;
        phvc.photoLongitudeForDetailVC = photoLongitude;
        phvc.photoLatitudeForDetailVC = photoLatitude;
        phvc.imageToShow = imageToTransfer;
        
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
        //Request pictures matching search query
        //Please note that lat/lon/radius are hard-coded for now
    
    
    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&lat=41.894032&lon=-87.634742&radius=3&extras=geo&accuracy=14&tags=%@&format=json&nojsoncallback=1", searchText];
    
    /*
    //preparing search URL to take current location - need to create searchLatString and searchLonString variables...........
     
     PART OF WHAT TO DO NEXT!
     
        NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&lat=%@&lon=%@&radius=3&extras=geo&accuracy=14&tags=%@&format=json&nojsoncallback=1",searchLatString, searchLonString, searchText];
    */
    
    
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
             
             [activityWheel stopAnimating];
             [photoTableView reloadData];
             
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
