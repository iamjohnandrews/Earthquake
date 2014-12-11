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

NSString * const EarthquakeBaseQueryAPI = @"http://comcat.cr.usgs.gov/fdsnws/event/1/query?";


@implementation EarthquakeNetworking

- (void)fetchEarthquakeDataFrom:(NSString *)startDate
                             to:(NSString *)endDate
                 forMagnitudeOf:(NSNumber *)magnitude
                     completion:(EarthquakeDataRequestCompletion)completion
{
    NSDictionary *parameters = @{@"starttime" : startDate,
                                 @"endtime" : endDate,
                                 @"minmagnitude" : magnitude,
                                 @"format" : @"geojson",
                                 @"latitude" : @"35.462244",
                                 @"longitude" : @"-97.384292",
                                 @"maxradiuskm" : @"2000"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager GET:EarthquakeBaseQueryAPI
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
             NSArray *earquakesArray = [[NSArray alloc] initWithArray:[self parseEarthquakeResponse:responseObject]];
             if (completion) {
                 completion(earquakesArray);
             }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
    
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
