//
//  DribbleAPI.h
//  Dribble
//
//  Created by Hubert Kunnemeyer on 9/11/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//
typedef enum {
    kShotTypePopular,
    kShotTypeDebuts,
    kShotsTypeEveryone
}ShotTypes;


#import "HKConnection.h"
#import <Foundation/Foundation.h>
@class Shots;
@class DribbleAPI;


@protocol DribbleAPIDelegate <NSObject>

- (void)dribleAPI:(DribbleAPI*)API didFailWithError:(NSError*)error;
- (void)driblleAPI:(DribbleAPI*)API didFinishGatheringShots:(NSArray*)shots;
- (void)dribbleAPI:(DribbleAPI*)API didFinishGatheringComments:(NSArray*)comments;

@end

@interface DribbleAPI : NSObject

@property (strong, nonatomic) UIView *hudView;;
@property (strong, nonatomic) NSMutableArray *results;
@property (weak) id <DribbleAPIDelegate> delegate;



//Returns an array of Shot objects through the DribbleAPIDelegate
- (void)shotsForType:(ShotTypes)type page:(NSInteger)page;
- (void)commentsForShot:(Shots*)shot;
@end







