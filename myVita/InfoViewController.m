//
//  InfoViewController.m
//  myVita
//
//  Created by Marco Velluto on 27/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "InfoViewController.h"
#import "FirstViewController.h"
#import "LibLocation.h"
#import "DetailViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
    
    arrayDefibrillatori = [[NSMutableArray alloc] init];
    
    FirstViewController *fvc = [self.tabBarController.viewControllers objectAtIndex:0];
    arrayDefibrillatori = [fvc.posizionrDef copy];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return arrayDefibrillatori.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = @"";
    NSString *detail = @"";
    static NSString *CellIdentifier = @"";
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        CellIdentifier = @"Cell_Legend";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        text = @"NOME POSTO";
        detail = @"DISTANZA";
        
        cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:25.0];
        cell.textLabel.textColor = [UIColor redColor];
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:25.0];
        cell.detailTextLabel.textColor = [UIColor redColor];

        cell.backgroundColor = [UIColor greenColor];
    }
    
    else {
        CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        /*
    MDefibrillatore *defibrillatore = [[MDefibrillatore alloc] init];
    defibrillatore = [arrayDefibrillatori objectAtIndex:indexPath.row - 1];
    
    cell.textLabel.text = defibrillatore.nome;
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:defibrillatore.latitudine longitude:defibrillatore.longitudine];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d m", [self calcoloDistanza:loc]];
    */
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 89;
    }
    else
        return 50;
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
    
     // ...
     // Pass the selected object to the new view controller.
    
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    //detailViewController.defibrillatore = [arrayDefibrillatori objectAtIndex:indexPath.row-1];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}


- (int)calcoloDistanza:(CLLocation *)location {
    
    float f = [[LibLocation findCurrentLocation] distanceFromLocation:location];
    return f;
}

@end
