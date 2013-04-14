//
//  RottenTomatoes.m
//  Reume
//
//  Created by Helene Brooks on 4/7/13.
//  Copyright (c) 2013 Hubert Kunnemeyer. All rights reserved.
//
#define ROTTEN_TOMATOES_KEY @"e7tgyb29c6m7vdrgnz2ymrzd"

#import "RottenTomatoes.h"
#import "HKConnection.h"

@implementation RottenTomatoes

//http://api.rottentomatoes.com/api/public/v1.0/lists/movies.json?apikey=[your_api_key]
- (id)init{
    self = [super init];
    if(self) {
    }
    return self;

}
- (void)rottenTomatoesForMovie:(MovieListType)movieType{
    
   
        NSString *URL = [NSString stringWithFormat:@"http:api.rottentomatoes.com/api/public/v1.0/lists/movies.json?apikey=%@",ROTTEN_TOMATOES_KEY];
        HKConnection *connection;
        connection = [[HKConnection alloc]initWithURL:[NSURL URLWithString:URL] callback:^(NSData *resultData, NSError *error) {
           
            if (resultData) {
                NSError *jsonError;
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&jsonError];
                NSLog(@"MOVIE LIST:%@",[JSON valueForKey:@"links"]);
                NSDictionary *links = [JSON valueForKey:@"links"];
                NSString *link;
                switch (movieType) {
                    case BoxOffice:
                        link = [links valueForKey:@"box_office"];
                        break;
                    case InTheaters:
                        link = [links valueForKey:@"in_theaters"];
                        break;
                    case Opening:
                        link = [links valueForKey:@"opening"];
                        break;
                    case Upcoming:
                        link = [links valueForKey:@"upcoming"];
                        break;
                        
                    default:
                        break;
                }
               NSString *URLString = [NSString stringWithFormat:@"%@?apikey=%@",link,ROTTEN_TOMATOES_KEY];
                [self sendRequestWithURL:URLString];
                
            }
            if (error) {
                NSLog(@"ERROR:%@",error);
            }
            

        }];
}

- (void)sendRequestWithURL:(NSString*)URLString{
    HKConnection *connection;
    connection = [[HKConnection alloc]initWithURL:[NSURL URLWithString:URLString] callback:^(NSData *resultData, NSError *error) {
        
        if (resultData) {
            NSError *jsonError;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&jsonError];
            [_delegate RottenTomatoes:self didFinishWithInformation:JSON];
        }

    }];
}

@end
