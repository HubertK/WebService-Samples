//
//  APIContentViewController.h
//  Reume
//
//  Created by Hubert Kunnemeyer on 10/24/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    Weather,
    Dribble,
    NYTimes
}APIView;


@interface APIContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@end
