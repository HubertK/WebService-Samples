//
//  APIViewController.h
//  Reume
//
//  Created by Hubert Kunnemeyer on 9/8/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface APIViewController : UIViewController<LocationManagerDelegate,NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UITableView *weatherTable;
@property (weak, nonatomic) IBOutlet UILabel *currentCondition;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *precip;
@property (weak, nonatomic) IBOutlet UIImageView *contitionImage;

@end
