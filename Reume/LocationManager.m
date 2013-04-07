//
//  LocationManager.m
//  Reume
//
//  Created by Hubert Kunnemeyer on 9/8/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager
@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize isLocationManagerAvailable;
@synthesize delegate = _delegate;
@synthesize bestEffortAtLocation;

- (id)init{
    
    self = [super init];
        if (!self) {
            return nil;
        }
    
    return self;
}


- (BOOL)isLocationManagerAvailable{
    
    return [CLLocationManager locationServicesEnabled];
}

- (void)startLocationServices {
	_locationManager = [[CLLocationManager alloc] init];
	_locationManager.delegate = self;
    
	if ([CLLocationManager locationServicesEnabled]) {
         NSLog(@"Location services enabled");
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [_locationManager startUpdatingLocation];
        [self performSelector:@selector(stopUpdatingLocationState:) withObject:@"Timed Out" afterDelay:6];
	} else {
		NSLog(@"Location services is not enabled");
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
             NSLog(@"Found Best Location");
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
             [self stopUpdatingLocationState:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocationState:) object:nil];
           
        }
    }
    // update the display with the new location data
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocationState:NSLocalizedString(@"Error", @"Error")];
        [_delegate locationManagerFailedWithError:error];
    }
}

- (void)stopUpdatingLocationState:(NSString*)state{
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
    if ([state isEqualToString:@"Acquired Location"]) {
        
        NSLog(@"Lat:%f\nLon:%f",self.bestEffortAtLocation.coordinate.latitude,self.bestEffortAtLocation.coordinate.longitude);
        [_delegate locationManagerdidFindLocation:self.bestEffortAtLocation];
    
    CLGeocoder *reverse = [[CLGeocoder alloc]init];
    [reverse reverseGeocodeLocation:self.bestEffortAtLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    
        if(error){
            [_delegate reverseGeocodingFailed:error];
        }
        if(placemarks){
            [_delegate foundPlacees:placemarks];
            
        }
        [reverse cancelGeocode];
    }];
    }
 
}






@end
