//
//  MapViewController.m
//  Earthquake
//
//  Created by John Andrews on 12/4/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()
@property (strong, nonatomic) NSMutableArray *hotelPinsArray;
@property (strong, nonatomic) UIImage *originalImage;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ListViewController *listVC = [[self.tabBarController viewControllers] firstObject];
    self.hotelInfo = listVC.hotelInfo;
    
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    
    NSArray *mapAnnotations = [self convertHotelObjectsIntoCoordinates:self.hotelInfo];
    [self.mapView addAnnotations:mapAnnotations];
    [self.mapView showAnnotations:mapAnnotations animated:YES];
}


- (NSArray *)convertHotelObjectsIntoCoordinates:(NSArray *)hotelObjects
{
    self.hotelPinsArray = [NSMutableArray array];
    
    for (Hotel *hotel in hotelObjects) {
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)[hotel.latitude doubleValue], (CLLocationDegrees)[hotel.longitude doubleValue]);
        myAnnotation.title = hotel.name;

        [self.hotelPinsArray addObject:myAnnotation];
    }
    
    return (NSArray *)self.hotelPinsArray;
}

#pragma MapKit Delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"hotel"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hotel"];
        aView.canShowCallout = YES;
        
        UIImageView *hotelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46.0f, 46.0f)];
        aView.leftCalloutAccessoryView = hotelImageView;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.rightCalloutAccessoryView = rightButton;
    }
    
    aView.annotation = annotation;
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"MapToHotelDetailsSegue" sender:view];
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSInteger index = [self.hotelPinsArray indexOfObject:view.annotation];
    Hotel *hotel = self.hotelInfo[index];

    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *hotelImageView = (UIImageView *)view.leftCalloutAccessoryView;
        [hotelImageView sd_setImageWithURL:[NSURL URLWithString:hotel.thumbnailURL]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     self.originalImage = image;
                                     hotelImageView.image = self.originalImage;
                                 }];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[MKAnnotationView class]]) {
        NSInteger index = [self.hotelPinsArray indexOfObject:((MKAnnotationView *)sender).annotation];
        Hotel *hotel = self.hotelInfo[index];
        
        if([segue.identifier isEqualToString:@"MapToHotelDetailsSegue"]) {
            ModalHotelViewController *modalHotelVC = (ModalHotelViewController *)segue.destinationViewController;
            modalHotelVC.selectedHotel = hotel;
            modalHotelVC.originalImage = self.originalImage;
        }
    }
}


@end
