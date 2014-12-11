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
    
    [self setupUI];
}

- (IBAction)dismissModalButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI
{
    self.titleLabel.text = self.selectedEarthquake.title;
    self.dateAndTimeLabel.text = [self.selectedEarthquake.dateAndTime stringValue];
    self.magnitudeLabel.text = [self.selectedEarthquake.magnitude stringValue];
    self.placeLabel.text = self.selectedEarthquake.place;
    
    self.dismissModalButton.layer.cornerRadius = 8;
    self.dismissModalButton.layer.borderWidth = 2;
    self.dismissModalButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.dismissModalButton.backgroundColor = [UIColor cyanColor];
}

@end
