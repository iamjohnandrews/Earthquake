//
//  MapViewController.m
//  Earthquake
//
//  Created by John Andrews on 12/4/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "MapViewController.h"
#import "Earthquake.h"
#import "EarthquakeNetworking.h"


@interface MapViewController ()
@property (strong, nonatomic) NSMutableArray *earthquakePinsArray;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) EarthquakeNetworking *networkingManger;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.networkingManger = [[EarthquakeNetworking alloc] init];
    NSArray *initialMapViewPinsArray = [self.networkingManger fetchEarthquakeDataFrom:[self getDateFromOneYearAgo:[NSDate date]]
                                                                                   to:[ self formateDate:[NSDate date]]
                                                                       forMagnitudeOf:[NSNumber numberWithInt:5]];
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    
    NSArray *mapAnnotations = [self convertEarthquakeObjectsIntoCoordinates:initialMapViewPinsArray];
    [self.mapView addAnnotations:mapAnnotations];
    [self.mapView showAnnotations:mapAnnotations animated:YES];
}

- (NSString *)formateDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *usgsDateStyle = [formatter stringFromDate:date];
    
    return usgsDateStyle;
}

- (NSString *)getDateFromOneYearAgo:(NSDate *)today
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-1];
    
    NSDate *oneYearAgo = [currentCalendar dateByAddingComponents:offsetComponents toDate:today options:0];
    
    return [self formateDate:oneYearAgo];
}

- (NSArray *)convertEarthquakeObjectsIntoCoordinates:(NSArray *)earthquakeObjects
{
    self.earthquakePinsArray = [NSMutableArray array];
    
    for (Earthquake *earthquake in earthquakeObjects) {
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)[earthquake.latitude doubleValue], (CLLocationDegrees)[earthquake.longitude doubleValue]);
        myAnnotation.title = earthquake.title;

        [self.earthquakePinsArray addObject:myAnnotation];
    }
    
    return (NSArray *)self.earthquakePinsArray;
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
    NSInteger index = [self.earthquakePinsArray indexOfObject:view.annotation];
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
        NSInteger index = [self.earthquakePinsArray indexOfObject:((MKAnnotationView *)sender).annotation];
        Hotel *hotel = self.hotelInfo[index];
        
        if([segue.identifier isEqualToString:@"MapToHotelDetailsSegue"]) {
            ModalHotelViewController *modalHotelVC = (ModalHotelViewController *)segue.destinationViewController;
            modalHotelVC.selectedHotel = hotel;
            modalHotelVC.originalImage = self.originalImage;
        }
    }
}


@end
