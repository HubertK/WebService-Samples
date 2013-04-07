//
//  SelectAPIViewController.m
//  Reume
//
//  Created by Helene Brooks on 3/28/13.
//  Copyright (c) 2013 Hubert Kunnemeyer. All rights reserved.
//

#import "SelectAPIViewController.h"

@interface SelectAPIViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dribbbleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestsellersLabel;

@end

@implementation SelectAPIViewController

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

    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern02.png"]];
    _dribbbleLabel.font = [UIFont fontWithName:@"HandsomeBold" size:34.0f];
    _weatherLabel.font = [UIFont fontWithName:@"Aller" size:26.0f];
    _bestsellersLabel.font = [UIFont fontWithName:@"Aller" size:26.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    if (section == 0) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellGreenTint.png"]];
    }
    else if (section == 1) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellPurpleTint.png"]];
    }
    else{
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBlueTint.png"]];
    }
}




- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 41)];
    
    if (section == 0) {
        aView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GreenHeader.png"]];
    }
    else if (section == 1) {
        aView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PurpleHeader.png"]];
    }
    else{
        aView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HeaderBackground.png"]];
    }
    
    CGRect labelFrame = CGRectMake(10,0,768-10,41);
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.textColor = [UIColor whiteColor];
    myLabel.font = [UIFont fontWithName:@"Aller-Bold" size:17.0f];
    myLabel.numberOfLines = 1;
    myLabel.shadowColor = [UIColor darkGrayColor];
    myLabel.shadowOffset = CGSizeMake(1.0,1.0);
    myLabel.textAlignment = NSTextAlignmentCenter;
    NSString *textForHeader = [NSString string];
    
    switch (section) {
        case 0:
            textForHeader = @"See your local weather forcast";
            break;
        case 1:
            textForHeader = @"View dribbble popular shots";
            break;
        case 2:
            textForHeader = @"See the current bestsellers";
            break;
            
        default:
            break;
    }
    
    myLabel.text = textForHeader;
    
    
    [aView addSubview:myLabel];
    
      return aView;
    
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 41.0f;
    
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setDribbbleLabel:nil];
    [self setWeatherLabel:nil];
    [self setBestsellersLabel:nil];
    [super viewDidUnload];
}
@end
