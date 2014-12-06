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

NSString * const EarthquakeRSSFeed = @"ba09703c363c9c64279b1a1f4a2d196a";


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

- (void)getEarthquakeData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:EarthquakeRSSFeed]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Receieved %lu bytes of XML data.", (unsigned long)[(NSData *)responseObject length]);
        [self parseEarthquakeRssResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    [requestOperation start];
    
}

- (void)parseEarthquakeRssResponse:(NSData *)data
{
    RXMLElement *rootElement = [RXMLElement elementFromXMLData:data];
    
    NSMutableArray *feedItems = [NSMutableArray array];
    [rootElement iterateWithRootXPath:@"//item"
                           usingBlock:^(RXMLElement *rssItem) {
                               RSSFeedItem *newItem = [[RSSFeedItem alloc] init];
                               newItem.itemTitle = [[rssItem child:@"title"] text];
                               newItem.itemDescription = [[rssItem child:@"description"] text];
                               newItem.itemUrl = [[rssItem child:@"link"] text];
                               [feedItems addObject:newItem];
                           }];
}

@end
