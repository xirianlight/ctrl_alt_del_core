//
//  photoDetailViewController.m
//  Photo Kooky
//
//  Created by David Johnston on 2/21/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import "photoDetailViewController.h"

@interface photoDetailViewController ()
{
        __weak IBOutlet MKMapView *myMapView;
    __weak IBOutlet MKMapView *detailMapView;
    __weak IBOutlet UILabel *photoTitleLabel;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self detailImageUIImage].image = imageToShow;
        //This doesn't work yet, but will eventually take the
        //name of the picture from the selected row & display it
    photoTitleLabel.text = self.photoNameForLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
