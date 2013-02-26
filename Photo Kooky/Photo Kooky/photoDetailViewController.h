//
//  photoDetailViewController.h
//  Photo Kooky
//
//  Created by David Johnston on 2/21/13.
//  Copyright (c) 2013 David Johnston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoDetailViewController : UIViewController{
    UIImage* imageToShow;
}
@property (weak, nonatomic) IBOutlet UIImageView *detailImageUIImage;
@property UIImage* imageToShow;
@end
