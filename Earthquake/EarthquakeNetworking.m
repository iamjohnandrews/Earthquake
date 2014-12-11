//
//  EarthquakeNetworking.m
//  Earthquake
//
//  Created by John Andrews on 12/6/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "EarthquakeNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "Earthquake.h"

NSString * const EarthquakeAPI = @"http://comcat.cr.usgs.gov/fdsnws/event/1/query?";

@interface EarthquakeNetworking ()
@property (strong, nonatomic) AFHTTPSessionManager *session;

@end

@implementation EarthquakeNetworking

+ (instancetype) sharedManager
{
    static EarthquakeNetworking *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedManager = [[self alloc] init];
//        sharedManager.session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:EarthquakeAPI]];
        sharedManager.session.responseSerializer = [AFJSONResponseSerializer serializer];
        
    });
    
    return sharedManager;
}

- (NSArray *)fetchEarthquakeDataFrom:(NSString *)startDate to:(NSString *)endDate forMagnitudeOf:(NSNumber *)magnitude
{
    __block NSArray *earquakesArray;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://comcat.cr.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2011-12-04&endtime=2014-12-04&minmagnitude=6"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             earquakesArray = [[NSArray alloc] initWithArray:[self parseEarthquakeResponse:responseObject]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return earquakesArray;
}

- (NSMutableArray *)parseEarthquakeResponse:(NSDictionary *)data
{
    NSMutableArray *earthquakeItems = [NSMutableArray array];

    NSArray *collectiveEarthquakesArray = [data objectForKey:@"features"];
    
    for (NSDictionary *IndividualEarthquakeDict in collectiveEarthquakesArray) {
        NSDictionary *earthquakeStatsDict = [IndividualEarthquakeDict objectForKey:@"properties"];
        Earthquake *earthquake = [[Earthquake alloc] init];
        earthquake.magnitude = [earthquakeStatsDict objectForKey:@"mag"];
        earthquake.place = [earthquakeStatsDict objectForKey:@"place"];
        earthquake.dateAndTime = [earthquakeStatsDict objectForKey:@"time"];
        earthquake.url = [earthquakeStatsDict objectForKey:@"url"];
        earthquake.title = [earthquakeStatsDict objectForKey:@"title"];
        
        NSDictionary *earthquakeLocationDict = [IndividualEarthquakeDict objectForKey:@"geometry"];
        NSArray *earthquakeCoordinatesArray = [earthquakeLocationDict objectForKey:@"coordinates"];
        earthquake.longitude = [earthquakeCoordinatesArray firstObject];
        earthquake.latitude = [earthquakeCoordinatesArray objectAtIndex:2];
        
        [earthquakeItems addObject:earthquake];
    }

    return earthquakeItems;
}



@end
