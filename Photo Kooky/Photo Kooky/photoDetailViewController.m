//
//  photoDetailViewController.m
//  Photo Kooky
//
//  Created by David Johnston on 2/21/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import "photoDetailViewController.h"

@interface photoDetailViewController ()

@end

@implementation photoDetailViewController

@synthesize imageToShow;
@synthesize detailImageUIImage;

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
    [self detailImageUIImage].image = imageToShow;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
