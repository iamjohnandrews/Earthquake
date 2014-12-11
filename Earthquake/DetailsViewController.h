//
//  ViewController.h
//  Earthquake
//
//  Created by John Andrews on 12/4/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Earthquake.h"

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Earthquake *selectedEarthquake;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissModalButton;
- (IBAction)dismissModalButtonPressed:(id)sender;

@end
