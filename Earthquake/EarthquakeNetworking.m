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
#import <RaptureXML/RXMLElement.h>

NSString * const EarthquakeRSSFeed = @"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.atom";


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
        sharedManager.session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:EarthquakeRSSFeed]];
        sharedManager.session.responseSerializer = [AFXMLParserResponseSerializer serializer];
    });
    
    return sharedManager;
}

- (NSArray *)getEarthquakeData
{
    __block NSArray *earquakesArray;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:EarthquakeRSSFeed]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Receieved %lu bytes of XML data.", (unsigned long)[(NSData *)responseObject length]);
        earquakesArray = [[NSArray alloc] initWithArray:[self parseEarthquakeRssResponse:responseObject]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    [requestOperation start];
    
    return earquakesArray;
}

- (NSMutableArray *)parseEarthquakeRssResponse:(NSData *)data
{
    RXMLElement *rootElement = [RXMLElement elementFromXMLData:data];
    
    NSMutableArray *earthquakeItems = [NSMutableArray array];
    
    [rootElement iterateWithRootXPath:@"//item"
                           usingBlock:^(RXMLElement *rssItem) {
                               RSSFeedItem *newItem = [[RSSFeedItem alloc] init];
                               newItem.itemTitle = [[rssItem child:@"title"] text];
                               newItem.itemDescription = [[rssItem child:@"description"] text];
                               newItem.itemUrl = [[rssItem child:@"link"] text];
                               [earthquakeItems addObject:newItem];
                           }];
    return earthquakeItems;
}

@end
