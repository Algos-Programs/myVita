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
#import "Database.h"

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
    
    arrayDefibrillatori = [[[NSMutableArray alloc] init] autorelease];
    
    FirstViewController *fvc = [self.tabBarController.viewControllers objectAtIndex:0];
    arrayDefibrillatori = [fvc.posizionrDef copy];
    
    Database *db = [[Database alloc] init];
    [db openDB];
    
    [db createTableDefibrillatore];
    arrayDefibrillatori = (NSMutableArray *)[db allObjects];
    self.navigationItem.title = [NSString stringWithFormat:@"%i su 356", arrayDefibrillatori.count];
    
    arrayDefibrillatoriToView = [[NSMutableArray alloc] init];
    
    for (int i=0; i<arrayDefibrillatori.count; i++) {
        NSArray *tempArray = [[NSArray alloc] initWithArray:[arrayDefibrillatori objectAtIndex:i]];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[tempArray objectAtIndex:8] doubleValue];
        coordinate.longitude = [[tempArray objectAtIndex:10] doubleValue];
        
        if ((coordinate.longitude || coordinate.longitude) != 0) {
            CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            if ([[LibLocation location] distanceFromLocation:tempLocation] < 100000) {
                [arrayDefibrillatoriToView addObject:tempArray];
            }
        }


    }
    self.navigationItem.title = [NSString stringWithFormat:@"%i/%i su 356 - <100.000 km", arrayDefibrillatoriToView.count,arrayDefibrillatori.count];

    
    //-- Ordinamento
    /*
    NSMutableArray *rerturnArray = [[NSMutableArray alloc] init];
    double min = MAXFLOAT;
    int index = -1;
    for (int j=0; j<arrayDefibrillatori.count; j++) {
        for (int i=0; i<arrayDefibrillatori.count; i++) {
            NSMutableArray *tempArray = [arrayDefibrillatori objectAtIndex:i];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[tempArray objectAtIndex:8] doubleValue];
            coordinate.longitude = [[tempArray objectAtIndex:10] doubleValue];
            
            CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            double dist = [[LibLocation location] distanceFromLocation:tempLocation];
            if (dist < min) {
                min = dist;
                index = i;
            }
        }//end for interno
        
        [rerturnArray addObject:[arrayDefibrillatori objectAtIndex:index]];
    }
     */
int k =0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    [arrayDefibrillatoriToView release];
    [arrayDefibrillatori release];
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
    return arrayDefibrillatoriToView.count + 1;
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

        text = @"DISTANZA";
        detail = @"NOME POSTO";
        
        cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:25.0];
        cell.textLabel.textColor = [UIColor redColor];
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:25.0];
        cell.detailTextLabel.textColor = [UIColor redColor];

        cell.backgroundColor = [UIColor greenColor];
    }
    
    else {
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        
        
        CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSArray *tempArray = [arrayDefibrillatoriToView objectAtIndex:indexPath.row - 1];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[tempArray objectAtIndex:8] doubleValue];
        coordinate.longitude = [[tempArray objectAtIndex:10] doubleValue];
        
        if ((coordinate.longitude || coordinate.longitude) == 0) {
            cell.textLabel.text = @"N.D.";
        }
        else {
            CLLocation *tempLocation = [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] autorelease];
            
            NSNumber *distance = [[[NSNumber alloc] initWithFloat:[[LibLocation location] distanceFromLocation:tempLocation]] autorelease];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%i m",[distance intValue]];
            cell.detailTextLabel.text = [tempArray objectAtIndex:1];
        }
        
        
        
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
    detailViewController.arrayInfo = [arrayDefibrillatori objectAtIndex:indexPath.row-1];
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
