//
//  APIViewController.m
//  Reume
//
//  Created by Hubert Kunnemeyer on 9/8/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//
#define WEATHER_API_ENDPOINT @"http://free.worldweatheronline.com/feed/weather.ashx?key=61fbce3227215807120809&q=%@&num_of_days=5&format=json"

#import "APIViewController.h"
#import "MBProgressHUD.h"
#import "SMXMLDocument.h"
#import "Weather.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface APIViewController ()<MBProgressHUDDelegate>

@property (strong, nonatomic) NSMutableData *weatherData;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableArray *forecast;
@end

@implementation APIViewController
@synthesize longitudeLabel;
@synthesize latitudeLabel;
@synthesize weatherTable;
@synthesize currentCondition;
@synthesize currentTemp;
@synthesize humidity;
@synthesize precip;
@synthesize contitionImage;
@synthesize weatherData = _weatherData;
@synthesize HUD;
@synthesize forecast = _forecast;

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
    self.weatherTable.backgroundView = [[UIView alloc]init];
    self.weatherTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark-blue-noise.jpg"]];
    _forecast = [NSMutableArray array];
	[self findLocation];
}

- (void)viewDidUnload
{
    [self setLongitudeLabel:nil];
    [self setLatitudeLabel:nil];
    [self setWeatherTable:nil];
    [self setCurrentCondition:nil];
    [self setCurrentTemp:nil];
    [self setHumidity:nil];
    [self setPrecip:nil];
    [self setContitionImage:nil];
    [self setContentView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)findLocation{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Finding your location";
    HUD.detailsLabelText = @"This may take a few seconds";
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location.png"]];
    HUD.mode = MBProgressHUDModeCustomView;

    LocationManager *lm = [[LocationManager alloc]init];
    if ([lm isLocationManagerAvailable]) {
        
         lm.delegate = self;
        [lm startLocationServices];
    }
    else{
         NSLog(@"No Location Services");
    }
   
    
}

#pragma -mark
#pragma mark LocationManager Delegate
- (void)locationManagerFailedWithError:(NSError *)error{
    
}

- (void)locationManagerdidFindLocation:(CLLocation *)location{
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
     self.latitudeLabel.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    
     NSLog(@"\nFound Location\n___________________________\nLongitude:------%f\n___________________________\nLatitude:------%f\n___________________________",location.coordinate.longitude,location.coordinate.latitude);
}

- (void)foundPlacees:(NSArray *)places{
    NSString *pc;
    for (CLPlacemark *place in places) {
        NSLog(@"Place found:%@",place.postalCode);
        pc = place.postalCode;
        break;
    }
    if ([pc length]) {
        [self getWeatherForLocation:pc];
    }
}
- (void)reverseGeocodingFailed:(NSError *)error{
     NSLog(@"Reverse Geocoding failed-----%@",error);
}


-(void)getWeatherForLocation:(NSString*)postCode{
    self.weatherData = [NSMutableData data];
    NSString *query = [NSString stringWithFormat:WEATHER_API_ENDPOINT,postCode];
     NSLog(@"Query String:%@",query);
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:query];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    [HUD hide:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    HUD.labelText = @"Retriebing Your Local Forecast";
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Weather-Icon.png"]];
    HUD.mode = MBProgressHUDModeCustomView;

    HUD.userInteractionEnabled = NO;

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (data) {
        
    [_weatherData appendData:data];
        
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [HUD hide:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    HUD.labelText = @"Whoops!";
    HUD.detailsLabelText = @"An Error Occured with the connection";
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status-warning.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];

     NSLog(@"Connection Error:%@",error);
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [HUD hide:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Success";
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status-done.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];
    [self parseWeather];

}
- (void)parseWeather{
    
    NSError *error;
    
//    SMXMLDocument *document = [SMXMLDocument documentWithData:self.weatherData error:&error];
//     NSLog(@"WEATHER:%@",document);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_weatherData options:NSJSONReadingMutableLeaves error:&error];
    
     NSLog(@"JSON:%@",json);
    if ([[[json valueForKey:@"data"]valueForKey:@"current_condition"]count]) {
        
    
    NSDictionary *current = [[[json valueForKey:@"data"]valueForKey:@"current_condition"]objectAtIndex:0];
    NSString *currentHumidity = [current valueForKey:@"humidity"];
     NSString *temp = [current valueForKey:@"temp_F"];
    NSString *precipitation = [current valueForKey:@"precipMM"];
    NSString *pressure = [current valueForKey:@"pressure"];
    NSString *URL = [[[current valueForKey:@"weatherIconUrl"]lastObject]valueForKey:@"value"];
    NSString *cond = [[[current valueForKey:@"weatherDesc"]lastObject]valueForKey:@"value"];

        self.currentCondition.text = cond;
        self.humidity.text = currentHumidity;
        self.currentTemp.text = temp;
        self.precip.text = precipitation;
        NSURL *url = [NSURL URLWithString:URL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *icon = [UIImage imageWithData:data];
        self.contitionImage.image = icon;
     NSLog(@"\nConditions:%@\nHumidity: %@\nTempature: %@\nPrecipitation: %@\nPressure: %@",cond,humidity,temp,precip,pressure);
    }
    
    NSArray *weatherArray = [[json valueForKey:@"data"]valueForKey:@"weather"];
    for (NSDictionary *dict in weatherArray) {
        NSString *min = [dict valueForKey:@"tempMinF"];
        NSString *max = [dict valueForKey:@"tempMaxF"];
        NSString *aprecip = [dict valueForKey:@"precipMM"];
        NSString *date = [dict valueForKey:@"date"];
        
        
        NSString *desc = [[[dict valueForKey:@"weatherDesc"]lastObject]valueForKey:@"value"];
       
        NSString *url = [[[dict valueForKey:@"weatherIconUrl"]lastObject]valueForKey:@"value"];
        
        Weather *weather;
        weather = [[Weather alloc]initWithDate:date precip:aprecip tempMax:max tempMin:min desc:desc andIconURL:url];
         NSLog(@"Weather\nDATE::%@\nPRECIP:%@\nMAX:%@\nMIN:%@\nDESC:%@\nURL:%@",weather.date,weather.precip,weather.tempMAX,weather.tempMIN,weather.weatherDesc,weather.iconURL);
        [_forecast addObject:weather];
    }
        [self.weatherTable reloadData];
}


#pragma -mark
#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_forecast count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    Weather *weather = [_forecast objectAtIndex:indexPath.section];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"Weather Conditions: %@",weather.weatherDesc];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"Maximum Temp: %@",weather.tempMAX];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"Minumum Temp: %@",weather.tempMIN];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"Precipitation: %@",weather.precip];
            break;
        default:
            break;
    }
    
    if (indexPath.row == 0) {

        [cell.imageView setImageWithURL:[NSURL URLWithString:weather.iconURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                success:^(UIImage *image, BOOL cached) {
                                }
                                failure:^(NSError *error) {
                                    
            }];
        
    }
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     Weather *weather = [_forecast objectAtIndex:section];
    return weather.date;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     Weather *weather = [_forecast objectAtIndex:section];
    CGRect labelFrame = CGRectMake(10,10,200,44);
	
	UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
	
	myLabel.backgroundColor = [UIColor clearColor];
	myLabel.textColor = [UIColor colorWithRed:0.95f green:0.96f blue:0.84f alpha:1.00f];
	myLabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:24.0f];
    myLabel.textAlignment = UITextAlignmentCenter;
	myLabel.numberOfLines = 0;
	myLabel.text = weather.date;
	
	return myLabel;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

@end
