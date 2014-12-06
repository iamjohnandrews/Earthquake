//
//  EarthquakeNetworking.h
//  Earthquake
//
//  Created by John Andrews on 12/6/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarthquakeNetworking : NSObject
+ (instancetype) sharedManager;
- (void)getEarthquakeData;

@end
