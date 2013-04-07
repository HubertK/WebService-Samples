//
//  Weather.m
//  Reume
//
//  Created by Hubert Kunnemeyer on 9/8/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import "Weather.h"

@implementation Weather
//@synthesize date,tempMAX,tempMIN,weatherDesc,iconURL,precip;
@synthesize date = _date;
@synthesize tempMAX = _tempMAX;
@synthesize tempMIN = _tempMIN;
@synthesize weatherDesc = _weatherDesc;
@synthesize iconURL = _iconURL;
@synthesize precip = _precip;


- (id)initWithDate:(NSString *)date precip:(NSString *)precip tempMax:(NSString *)max tempMin:(NSString *)min desc:(NSString *)weatherDesc andIconURL:(NSString *)url{
    self = [super init];
    if (!self) {
        return nil;
    }
    _date = date;
    _tempMIN = min;
    _tempMAX = max;
    _precip = precip;
    _weatherDesc = weatherDesc;
    _iconURL = url;


    return self;
}
@end
