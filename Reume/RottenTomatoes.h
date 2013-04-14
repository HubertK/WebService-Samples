//
//  RottenTomatoes.h
//  Reume
//
//  Created by Helene Brooks on 4/7/13.
//  Copyright (c) 2013 Hubert Kunnemeyer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RottenTomatoes;

@protocol RottenTomatoesDelegate <NSObject>

- (void)RottenTomatoes:(RottenTomatoes*)rottenTomatoes didFinishWithInformation:(NSDictionary*)RottenTomatoesData;

@end


typedef enum {
    BoxOffice,
    InTheaters,
    Opening,
    Upcoming
}MovieListType;

typedef enum {
    TopRentals,
    CurrentRelease,
    NewRelease,
    UpcomingRelease
}DVDListType;


@interface RottenTomatoes : NSObject

@property (weak) id <RottenTomatoesDelegate> delegate;

- (void)rottenTomatoesForMovie:(MovieListType)movieType;
@end
