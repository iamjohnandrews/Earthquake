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
#import "DetailsViewController.h"


@interface MapViewController ()
@property (strong, nonatomic) NSMutableArray *earthquakePinsArray;
@property (strong, nonatomic) NSArray *earthquakeObjectsArray;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) EarthquakeNetworking *networkingManger;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.networkingManger = [[EarthquakeNetworking alloc] init];

    [self.networkingManger fetchEarthquakeDataFrom:[self getDateFromOneYearAgo:[NSDate date]]
                                                to:[self formateDate:[NSDate date]]
                                    forMagnitudeOf:[NSNumber numberWithInt:3]
                                        completion:^(NSArray *data) {
                                            self.earthquakeObjectsArray = data;
                                        }];
    
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
}

- (void)setEarthquakeObjectsArray:(NSArray *)earthquakeObjectsArray
{
    _earthquakeObjectsArray = earthquakeObjectsArray;
    NSArray *mapAnnotations = [self convertEarthquakeObjectsIntoCoordinates:self.earthquakeObjectsArray];
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
    MKAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"earthquake"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"earthquake"];
        aView.canShowCallout = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.rightCalloutAccessoryView = rightButton;
    }
    
    aView.annotation = annotation;
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"MapToEarthquakeDetailsSegue" sender:view];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[MKAnnotationView class]]) {
        NSInteger index = [self.earthquakePinsArray indexOfObject:((MKAnnotationView *)sender).annotation];
        Earthquake *earthquake = self.earthquakeObjectsArray[index];
        
        if([segue.identifier isEqualToString:@"MapToEarthquakeDetailsSegue"]) {
            DetailsViewController *detailsVC = (DetailsViewController *)segue.destinationViewController;
            detailsVC.selectedEarthquake = earthquake;
        }
    }
}


@end
