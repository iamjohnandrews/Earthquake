//
//  ViewController.m
//  Earthquake
//
//  Created by John Andrews on 12/4/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.selectedEarthquake.title;
    self.dateAndTimeLabel.text = [self.selectedEarthquake.dateAndTime stringValue];
    self.magnitudeLabel.text = [self.selectedEarthquake.magnitude stringValue];
    self.placeLabel.text = self.selectedEarthquake.place;
}

@end
