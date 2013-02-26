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
    
    __weak IBOutlet UITextField *searchTextField;
    
    __weak IBOutlet UITableView *photoTableView;
    __weak IBOutlet UIActivityIndicatorView *activityWheel;
    
    //__weak IBOutlet UIActivityIndicatorView *activityIndicatorWheel;
    
}

- (IBAction)searchButton:(id)sender;


@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];


    
}


// NUMBER OF ROWS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (photosDictionary == nil) {
        return 0;
    }else{
        //NSArray *arrayForPhotosArray = [photosDictionary valueForKey:@"photo"];
         //NSLog(@"%@", arrayForPhotosArray);
        
        
        return 20;
        //return [arrayForPhotosArray count];
        //int arrayCount = [arrayForPhotosArray count];
        //NSLog(@"%i", arrayCount);
        
    }
}


// NUMBER OF CELLS
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[activityIndicatorWheel startAnimating];
    [activityWheel startAnimating];
    
    //setting up my reusable cell
    UITableViewCell *myCustomCell =[tableView dequeueReusableCellWithIdentifier:@"photoCellReuseID"];
    
    
    //collecting all the data from photosDictionary
    //NSArray *arrayForPhotosArray = [photosDictionary valueForKey:@"photo"];
    NSDictionary *dictionaryForSinglePhoto = [arrayForPhotosArray objectAtIndex:indexPath.row];
    NSString *farmString = [dictionaryForSinglePhoto valueForKey:@"farm"];
    NSString *serverString = [dictionaryForSinglePhoto valueForKey:@"server"];
    NSString *idString = [dictionaryForSinglePhoto valueForKey:@"id"];
    NSString *secretString = [dictionaryForSinglePhoto valueForKey:@"secret"];
    NSString *titleString  = [dictionaryForSinglePhoto valueForKey:@"title"];
    NSLog(@"%@", titleString);
    
    //making that info into a request for a photo
    //.................................................................................
    //NSString *newText = [NSString stringWithFormat:@"%@%@", word1, word2];
    
    NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_m.jpg", farmString, serverString, idString, secretString];
    NSURL *photoURL = [NSURL URLWithString:photoURLString];
    //NSMutableURLRequest *photoURLRequest = [NSMutableURLRequest requestWithURL:photoURL];
    
    
    //making the request online for the photo
    
    
    //NSString *spyPictureString =[spyDictionary valueForKey:@"avatar_url"];
    //NSURL *spyPictureURL = [NSURL URLWithString:spyPictureString];
    
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    UIImage *photoImage = [UIImage imageWithData:photoData];
    
    myCustomCell.imageView.image = photoImage;
    myCustomCell.textLabel.text = titleString;
    
        
    [activityWheel stopAnimating];
    
    return myCustomCell;
    
    
    
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchTextField resignFirstResponder];
    return YES;
}
         
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)rewind:(UIStoryboardSegue *)segue{
    
}
////put the manual seque stuff in here
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
//    // Access accessory View  as below.
//    //UIView * myCellAccessoryView = myCell.accessoryView;
//
//    imageToTransfer =  myCell.imageView.image;
//    
//
//
//        //photoDetailViewController *phvc = (photoDetailViewController *)[segue destinationViewController];
//    
//    //[self performSegueWithIdentifier:@"toDetailSegue" sender:self];
//
//    
//    //TargetViewController *targetVC =
//    
//    //(TargetViewController*)segue.destinationViewController;
//    //targetVC.string1 = string1;
//    
//    //photoDetailViewController *phvc = [segue destinationViewController];
//    //phvc.detailImageUIImage.image = imageToTransfer;
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDetailSegue"]) {
        UITableViewCell *myCell = (UITableViewCell*)sender;
        imageToTransfer =  myCell.imageView.image;
        
        photoDetailViewController *phvc = [segue destinationViewController];
      
        phvc.imageToShow = imageToTransfer;
    
        
    }
}

- (IBAction)searchButton:(id)sender {
    
    
    
    searchText = searchTextField.text;

    
    //temp removal for testing bbox
//    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&tags=%@&format=json&nojsoncallback=1", searchText];
    
    //adding for bbox
//     NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&bbox-86.634741,41.894031,-86.634743,41.894033&accuracy=14&tags=%@&format=json&nojsoncallback=1", searchText];
 
    NSString *flickrURLString =[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4a287d18b3f7398ffb4ab9f1b961e22&lat=41.894032&lon=-87.634742&radius=3&accuracy=14&tags=%@&format=json&nojsoncallback=1", searchText];
    
    
    NSURL *flickrURL = [NSURL URLWithString:flickrURLString];
    NSMutableURLRequest *flickrURLRequest = [NSMutableURLRequest requestWithURL:flickrURL];
    
    //put a GET header on the urlRequest
    flickrURLRequest.HTTPMethod = @"GET";
    
    //now connect.....
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^void(NSURLResponse *myResponse, NSData *myData, NSError *myError)
     {
         if (myError) {
             NSLog(@"%@", myError.localizedDescription);
         }else{
             NSError *jsonError;
             id  genericObjectWeKnowIsDictionary = [NSJSONSerialization JSONObjectWithData:myData
                                                                                   options:NSJSONReadingAllowFragments
                                                                                     error:&jsonError];
             
             //this is "type casting.  It takes the unknown id variable "generic.." and converts it to an NSArray pointer type and sets it to vokalSpies.
             photosDictionary = (NSMutableDictionary *) genericObjectWeKnowIsDictionary;
             NSMutableDictionary *secondDictionary = [photosDictionary valueForKey:@"photos"];
             arrayForPhotosArray = [secondDictionary valueForKey:@"photo"];
             
             
             
             //NSLog(@"%@",vokalSpies);
             NSLog(@"%@", [photosDictionary valueForKey:@"pages"]);
             
             //reload data and stop animating MUST FIGURE THIS OUT
             [photoTableView reloadData];
             
         }
     }];


    
}
@end
