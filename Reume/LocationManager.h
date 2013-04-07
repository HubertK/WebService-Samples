//
//  LocationManager.h
//  Reume
//
//  Created by Hubert Kunnemeyer on 9/8/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol LocationManagerDelegate <NSObject>

- (void)locationManagerFailedWithError:(NSError*)error;
- (void)locationManagerdidFindLocation:(CLLocation*)location;

- (void)foundPlacees:(NSArray*)places;
- (void)reverseGeocodingFailed:(NSError*)error;

@end

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation  *currentLocation;
@property (nonatomic, assign) BOOL isLocationManagerAvailable;
@property (strong, nonatomic)  CLLocation *bestEffortAtLocation;

@property (weak, nonatomic) id <LocationManagerDelegate> delegate;

- (BOOL)isLocationManagerAvailable;
- (void)startLocationServices;
@end
