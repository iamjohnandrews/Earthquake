//
//  EarthquakeNetworking.h
//  Earthquake
//
//  Created by John Andrews on 12/6/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EarthquakeDataRequestCompletion)(NSArray *data);

@interface EarthquakeNetworking : NSObject
+ (instancetype) sharedManager;
- (void)fetchEarthquakeDataFrom:(NSString *)startDate
                             to:(NSString *)endDate
                 forMagnitudeOf:(NSNumber *)magnitude
                     completion:(EarthquakeDataRequestCompletion)completion;

@end
