//
//  Weather.h
//  Reume
//
//  Created by Hubert Kunnemeyer on 9/8/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *precip;
@property (strong, nonatomic) NSString *tempMAX;
@property (strong, nonatomic) NSString *tempMIN;
@property (strong, nonatomic) NSString *weatherDesc;
@property (strong, nonatomic) NSString *iconURL;

- (id)initWithDate:(NSString*)date precip:(NSString*)precip tempMax:(NSString*)max tempMin:(NSString*)min desc:(NSString*)weatherDesc andIconURL:(NSString*)url;
@end
