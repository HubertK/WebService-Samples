//
//  ShotsViewController.m
//  Dribble
//
//  Created by Hubert Kunnemeyer on 9/11/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import "ShotsViewController.h"
#import "Dribble Cell.h"
#import "Shots.h"
#import "Player.h"
//#import "ViewController.h"
#import "MBProgressHUD.h"
#import "Comments.h"
#import "Cell.h"

@interface ShotsViewController ()
@property (nonatomic) BOOL isResized;
@property (nonatomic) NSInteger lastIndex;
@property (strong, nonatomic) UIImageView *largeView;
@property (strong, nonatomic) UIView *shadeView;
@property (strong, nonatomic) UIButton *returnButton;
@property (strong, nonatomic) UIButton *closeImageButton;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *shotTypePicker;
@property (nonatomic) ShotTypes shotType;

- (IBAction)didChangeShotType:(id)sender;

@end

@implementation ShotsViewController
@synthesize results = _results;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lastIndex = 999999999; 
    _pointOfInsertion = 99999;
    _shadeView = [[UIView alloc]initWithFrame:self.tableView.frame];
    _shadeView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.900];
    
    [self queryDibbbleForShot:kShotTypePopular]; //Begin with Popular shots
   

}
- (void)queryDibbbleForShot:(ShotTypes)shotType{
    [_results removeAllObjects]; //Remove any previous shot objects if any
    
    DribbleAPI *da = [[DribbleAPI alloc]init];
    [da setHudView:self.view]; //MBProgressView HUD
    da.delegate = self;
    [da shotsForType:shotType page:0];
    
    NSString *title = [NSString string];
    switch (shotType) {
        case kShotTypePopular:
            title = @"Popular";
            break;
        case kShotTypeDebuts:
            title = @"Debuts";
            break;
        case kShotsTypeEveryone:
            title = @"Everyone";
            break;
            
        default:
            title = @"";
            break;
    }
    [self.navigationItem setTitle:title];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_results count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _pointOfInsertion) {
        return [_comments count]+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    if (indexPath.row == 0) {
    static NSString *CellIdentifier = @"Dribble Cell";
    Dribble_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Shots *shot = [_results objectAtIndex:indexPath.section];

    
    
    
    cell.userName.text = shot.title;
    cell.viewsCount.text = [NSString stringWithFormat:@"%@", shot.views_count];
    cell.likesCount.text = [NSString stringWithFormat:@"%@", shot.likes_count];
    cell.commentCount.text =[NSString stringWithFormat:@"%@", shot.comments_count];
        
    [cell.previewImage setImageWithURL:[NSURL URLWithString:shot.image_teaser_url]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
    cell.previewButton.tag = indexPath.section;
    cell.commentButton.tag = indexPath.section;
    cell.eyeBallButton.tag = indexPath.section;
        
    [cell.commentButton addTarget:self action:@selector(showComments:) forControlEvents:UIControlEventTouchUpInside];
    [cell.previewButton addTarget:self action:@selector(enlargePreview:) forControlEvents:UIControlEventTouchUpInside];
    [cell.eyeBallButton addTarget:self action:@selector(enlargePreview:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    }
    
    if (indexPath.section == _pointOfInsertion) {
        [tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        Cell *aCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        Comments *com = [_comments objectAtIndex:indexPath.row-1];
       
        aCell.comment.text = com.body;
        NSString *numberOfLikes = [NSString stringWithFormat:@"Likes:%@", com.likes];
        if ([numberOfLikes isEqualToString:@"Likes:(null)"]) {
            numberOfLikes = @"0";
        }
       
        aCell.likes.text = numberOfLikes;
        return aCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _pointOfInsertion) {
        if (indexPath.row == 0) {
            return 170;
        }
        else{
        return 113;
        }
    }
    return 170;
}
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    Shots *shot = [_results objectAtIndex:section];
//    return shot.player.userName;
//}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    Shots *shot = [_results objectAtIndex:section];
    Player *player = shot.player;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerView.backgroundColor  = [UIColor clearColor];
    
    NSURL *avatarURL = [NSURL URLWithString:player.avatarURL];
    UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(50, 26, 45, 45)];
    avatar.layer.cornerRadius = 5.0f;
    avatar.layer.masksToBounds = YES;
    avatar.layer.borderWidth = 2.0;
    avatar.layer.borderColor = [UIColor grayColor].CGColor;
    [avatar setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    NSString *playerName = player.userName;
    
    CGRect labelFrame = CGRectMake(105, 36, 500, 40);
	UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
	myLabel.backgroundColor = [UIColor clearColor];
	myLabel.textColor = [UIColor whiteColor];
	myLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:18.0];
	myLabel.text = playerName;
	
    [headerView addSubview:avatar];
    [headerView addSubview:myLabel];
    
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 80;
    }
    return 80;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _pointOfInsertion) {
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:0.381 green:0.511 blue:0.427 alpha:1.00f];
        }
        else{
            cell.backgroundColor = [UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1.0];
        }
    }
    else{
   cell.backgroundColor = [UIColor colorWithRed:0.381 green:0.511 blue:0.427 alpha:1.00f];
    }
}


#pragma -mark
#pragma mark DribbleAPI Delegate
- (void)dribleAPI:(DribbleAPI *)API didFailWithError:(NSError *)error{
    
}

- (void)driblleAPI:(DribbleAPI *)API didFinishGatheringShots:(NSArray *)shots{
    _results = [shots mutableCopy];
    [self.tableView reloadData];
    NSLog(@"SHOTS:%@",shots);
}
- (void)dribbleAPI:(DribbleAPI *)API didFinishGatheringComments:(NSArray *)comments{
    _comments = [comments mutableCopy];
     NSLog(@"Comments:%@",_comments);
    NSMutableArray *paths = [NSMutableArray array];
    for (int i = 0; i < [_comments count]; i++) {
        [paths addObject:[NSIndexPath indexPathForRow:i+1 inSection:_pointOfInsertion]];
        
    }
    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma -mark
#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath  *idxPath = [self.tableView indexPathForSelectedRow];

}



- (IBAction)showComments:(id)sender{
    if (_pointOfInsertion == [sender tag] || [_comments count]) {
        NSMutableArray *paths = [NSMutableArray array];

        for (int i = 0; i < [_comments count]; i++) {
            [paths addObject:[NSIndexPath indexPathForRow:i+1 inSection:_pointOfInsertion]];
            
        }
       
        [_comments removeAllObjects];
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        if (_pointOfInsertion == [sender tag]) {
             _pointOfInsertion = 999999;
            return;
        }
        
        
       
    }
     NSLog(@"TAG:%d",[sender tag]);
    _pointOfInsertion = [sender tag];
    Shots *shot = [_results objectAtIndex:[sender tag]];
    DribbleAPI *da = [[DribbleAPI alloc]init];
    [da setHudView:self.view];
    da.delegate = self;
    [da commentsForShot:shot];

    
}
- (IBAction)enlargePreview:(id)sender{
    if ([_comments count]) {
        [self showComments:sender];
    }
   CGRect cellFrame = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[sender tag]]];
    Shots *shot = [_results objectAtIndex:[sender tag]];
    NSString *bigShotURL= shot.image_url;
    float width = [shot.width floatValue];
    float height = [shot.height floatValue];
    
    _largeView = [[UIImageView alloc]initWithFrame: CGRectMake(cellFrame.origin.x + 65, cellFrame.origin.y + 20 , 128, 128)];
    _largeView.contentMode = UIViewContentModeScaleAspectFit;
    

    [self.view addSubview:_largeView];
    

    
    [UIView animateWithDuration:0.5 animations:^{
        _largeView.frame = CGRectMake(self.view.frame.size.width/2 - (width/2), self.view.frame.size.height/2 - (height/2) + self.tableView.contentOffset.y, width, height);
        [_largeView setImageWithURL:[NSURL URLWithString:bigShotURL]];
    }
         completion:^(BOOL finished) {
             
              [UIView animateWithDuration:0.5 animations:^{
                      //Add a close button to the enlarged image
                  _closeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                  [_closeImageButton addTarget:self action:@selector(returnLargeView:) forControlEvents:UIControlEventTouchUpInside];
                  
                  _closeImageButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50,50 + self.tableView.contentOffset.y ,100 ,32);
                  [_closeImageButton setTitle:@"Close" forState:UIControlStateNormal];
                  _closeImageButton.alpha = 0.0f;
                  [self.view addSubview:_closeImageButton];
                  _closeImageButton.userInteractionEnabled = YES;
                  _closeImageButton.alpha = 1.0;
              }];
         }];
    
    
        //Background overlay(Shade) for looks and interaction prevention...
    _shadeView.frame = CGRectMake(0, self.tableView.contentOffset.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:_shadeView belowSubview:_largeView];
    
          
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnButton.frame = _largeView.frame;
        _returnButton.tag = [sender tag];
        [_returnButton addTarget:self action:@selector(returnLargeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_returnButton aboveSubview:_largeView];
    self.tableView.scrollEnabled = NO;
    _lastIndex = [sender tag];
   
}

- (IBAction)returnLargeView:(id)sender{
    CGRect cellFrame = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_lastIndex]];
    [_closeImageButton removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        _largeView.frame = CGRectMake(cellFrame.origin.x + 65, cellFrame.origin.y + 20 , 128, 128);
    }
                     completion:^(BOOL finished) {
                         
                         [_largeView removeFromSuperview];
                         [_shadeView removeFromSuperview];
                         [_returnButton removeFromSuperview];
                         self.tableView.scrollEnabled = YES;
                     }];

}

- (IBAction)didChangeShotType:(id)sender {
        //The selected index of the segmentedControl coresponds to the ShotType enumeration in the DribbleAPI Class
        //0 = Popular
        //1 = Debuts
        //2 = Everyone
        //So all we gotta do is query the selected index
    [self queryDibbbleForShot:_shotTypePicker.selectedSegmentIndex];
}


- (void)viewDidUnload {
    [self setShotTypePicker:nil];
    [super viewDidUnload];
}







@end
