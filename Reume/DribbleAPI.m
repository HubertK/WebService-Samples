//
//  DribbleAPI.m
//  Dribble
//
//  Created by Hubert Kunnemeyer on 9/11/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//
#define DRIBBLE_ENDPOINT @" http://api.dribbble.com/"
#define DRIBBLE_SHOT @"http://api.dribbble.com/shots/%@"//ShotID
#define DRIBBLE_PLAYERS_SHOTS @"http://api.dribbble.com/players/%@/shots"//playerName/ID
#define DRIBBLE_SHOTS_FOR_TYPE @"http://api.dribbble.com/shots/%@"//ShotType
#define DRIBBLE_COMMENTS @"http://api.dribbble.com/shots/%@/comments"//ID

#import "DribbleAPI.h"
#import "Player.h"
#import "Shots.h"
#import "Comments.h"

@implementation DribbleAPI
@synthesize hudView = _hudView;
@synthesize results = _results;
@synthesize delegate = _delegate;

- (id)init{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _results = [NSMutableArray array];
    
    return self;
}
- (void)commentsForShot:(Shots*)shot{
    [_results removeAllObjects];
    
    NSString *URLString = [NSString stringWithFormat:DRIBBLE_COMMENTS,shot.shotID];
    HKConnection *connection;
    connection = [[HKConnection alloc]initWithURL:[NSURL URLWithString:URLString] progressHudView:_hudView callback:^(NSData *resultData, NSError *error) {
        
        if (resultData) {
             NSError *jsonError;
             NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&jsonError];
            
            if (JSON) {
               
                _results = [self parseComments:JSON];
                [_delegate dribbleAPI:self didFinishGatheringComments:_results];
            }
            
        }
        
    }];
}

//Shots
- (void)shotsForType:(ShotTypes)type page:(NSInteger)page{
    
    NSString *theType;
    switch (type) {
        case kShotsTypeEveryone:
            theType = @"everyone";
            break;
        case kShotTypeDebuts:
            theType = @"debuts";
            break;
        case kShotTypePopular:
            theType = @"popular";
            break;
            
        default:
            break;
    }
    NSString *URLString = [NSString stringWithFormat:DRIBBLE_SHOTS_FOR_TYPE,theType];
    HKConnection *connection;
    
    connection = [[HKConnection alloc]initWithURL:[NSURL URLWithString:URLString] progressHudView:_hudView callback:^(NSData *resultData, NSError *error) {
        if (error) {
             NSLog(@"ERROR WITH CALL TO GET ALL SHOTS");
            [_delegate dribleAPI:self didFailWithError:error];
        }
        else{
            NSError *jsonError;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&jsonError];
            if (!jsonError) {
                 NSLog(@"\nSHOTS FROM %@\n------------------------\n%@",theType,JSON);
                _results = [self parseShots:JSON];
                 
                [_delegate driblleAPI:self didFinishGatheringShots:_results];
            }
            if (jsonError) {
                [_delegate dribleAPI:self didFailWithError:jsonError];
            }
        }
        
    }];
}


- (NSMutableArray*)parseShots:(NSDictionary*)shots{
    NSArray *array = [shots valueForKey:@"shots"];
    NSMutableArray *allshots = [NSMutableArray array];

    for (NSDictionary *shot in array) {
        Shots *aShot = [[Shots alloc]initWithDictionary:shot];
        [allshots addObject:aShot];
    }
    
    return allshots;
}

- (NSMutableArray*)parseComments:(NSDictionary*)comments{
    NSArray *array = [comments valueForKey:@"comments"];
    NSMutableArray *allComments = [NSMutableArray array];
    
    for (NSDictionary *aCom in array) {
        Comments *coms = [[Comments alloc]initWithDictionary:aCom];
        [allComments addObject:coms];
    }
    
    return allComments;
}













@end
