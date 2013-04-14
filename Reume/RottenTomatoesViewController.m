//
//  RottenTomatoesViewController.m
//  Reume
//
//  Created by Helene Brooks on 4/8/13.
//  Copyright (c) 2013 Hubert Kunnemeyer. All rights reserved.
//

#import "RottenTomatoesViewController.h"

@interface RottenTomatoesViewController ()
@property (strong, nonatomic) NSMutableDictionary *movies;
@end

@implementation RottenTomatoesViewController

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
    _movies = [NSMutableDictionary dictionary];
   RottenTomatoes *rottenTom = [[RottenTomatoes alloc]init];;
    rottenTom.delegate = self;
    [rottenTom rottenTomatoesForMovie:InTheaters];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_movies valueForKey:@"movies"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[[_movies valueForKey:@"movies"]valueForKey:@"title"]objectAtIndex:indexPath.row];;
    NSString *rating = [[[[_movies valueForKey:@"movies"]valueForKey:@"ratings"]valueForKey:@"critics_rating"]objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = rating;
    UIImage *cellImage;
    if ([rating isEqualToString:@"Fresh"]) {
        cellImage = [UIImage imageNamed:@"fresh"];
    }
   else if ([rating isEqualToString:@"Rotten"]) {
         cellImage = [UIImage imageNamed:@"rotten"];
    }
   else if ([rating isEqualToString:@"Certified Fresh"]) {
       cellImage = [UIImage imageNamed:@"CertifiedFresh"];
   }
   else{
       cellImage = nil;
   }
    cell.imageView.image = cellImage;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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


#pragma mark - RottenTomatoes Delegate
- (void)RottenTomatoes:(RottenTomatoes *)rottenTomatoes didFinishWithInformation:(NSDictionary *)RottenTomatoesData{
    NSLog(@"JSON Data:%@",RottenTomatoesData);
    _movies = [RottenTomatoesData mutableCopy];
    [self.tableView reloadData];
    NSLog(@"Movies:%@",[[RottenTomatoesData valueForKey:@"movies"]valueForKey:@"title"]);
}

@end
