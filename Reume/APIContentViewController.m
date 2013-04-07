//
//  APIContentViewController.m
//  Reume
//
//  Created by Hubert Kunnemeyer on 10/24/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import "APIContentViewController.h"
#import "APIViewController.h"
#import "ShotsViewController.h"

@interface APIContentViewController ()
//Picker
@property (weak, nonatomic) IBOutlet UISegmentedControl *APIPicker;

//ViewControllers
@property (strong, nonatomic) APIViewController *weatherViewController;
@property (strong, nonatomic) ShotsViewController *dribbleViewController;

@property (strong, nonatomic) UIViewController *lastViewController;

//Methods
- (IBAction)didChangeAPISelection:(id)sender;
@end

@implementation APIContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    _weatherViewController = [storyboard instantiateViewControllerWithIdentifier:@"WeatherView"];
    _dribbleViewController = [storyboard instantiateViewControllerWithIdentifier:@"DribbleView"];
	[_APIPicker setSelectedSegmentIndex:0];
    [self.contentView addSubview:_weatherViewController.view];
    _lastViewController = _weatherViewController;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setAPIPicker:nil];
    [super viewDidUnload];
}
- (IBAction)didChangeAPISelection:(id)sender {
    
    [self switchView:_APIPicker.selectedSegmentIndex];
}

- (void)switchView:(APIView)viewToShow{
    [_lastViewController.view removeFromSuperview];
    switch (viewToShow) {
        case Weather:    
            [self.contentView addSubview:_weatherViewController.view];
            _lastViewController = _weatherViewController;
            break;
        case Dribble:    
            [self.contentView addSubview:_dribbleViewController.view];
            _lastViewController = _dribbleViewController;
            break;
        case NYTimes:    
            
            break;
            
        default:
            break;

    }
}























@end
