//
//  HKConnection.h
//  RestConnection
//
//  Created by Hubert Kunnemeyer on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

typedef void (^HKConnectionBlock)(NSData* resultData, NSError *error);

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface HKConnection : NSObject<MBProgressHUDDelegate>

@property (strong, nonatomic) NSMutableData *requestdata;
@property (copy, nonatomic) HKConnectionBlock callBackBlock;
@property (strong, nonatomic) MBProgressHUD *HUD;


- (id)initWithURL:(NSURL*)URL progressHudView:(UIView*)HUDdisplayView callback:(HKConnectionBlock)block;
@end
