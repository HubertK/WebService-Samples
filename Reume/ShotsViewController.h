//
//  ShotsViewController.h
//  Dribble
//
//  Created by Hubert Kunnemeyer on 9/11/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DribbleAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>


@interface ShotsViewController : UITableViewController<DribbleAPIDelegate>
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *comments;

@property (nonatomic) NSInteger pointOfInsertion;
@end
