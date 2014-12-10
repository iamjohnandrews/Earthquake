//
//  Earthquake.h
//  Earthquake
//
//  Created by John Andrews on 12/6/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Earthquake : NSObject

@property (strong, nonatomic) NSNumber *magnitude;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSNumber *dateAndTime;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@end
