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

NSString *titleFooter = @"";

BOOL viewAll = YES;

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
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenColor1.png"]]]; //Red as an example.

    arrayDefibrillatori = [[[NSMutableArray alloc] init] autorelease];
    arraySort = [[[NSMutableArray alloc] init] autorelease];
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
            CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:
                                        coordinate.latitude longitude:coordinate.longitude];
            if (viewAll) {
                if ([[LibLocation location] distanceFromLocation:tempLocation] < 100000) {
                    [arrayDefibrillatoriToView addObject:tempArray];
                }
            }
        }
    }
    self.navigationItem.title = @"Lista Defibrillatori";
    titleFooter = [NSString stringWithFormat:@"%i/%i su 356 - <100.000 km", arrayDefibrillatoriToView.count,arrayDefibrillatori.count];
        
    int k =0;
}

- (void)viewWillAppear:(BOOL)animated {
    
    arraySort = [Database sortWithArray:arrayDefibrillatoriToView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_buttonSelect release];
    [super dealloc];
    [arrayDefibrillatoriToView release];
    [arrayDefibrillatori release];
}

- (NSMutableArray *)sortWithArray:(NSMutableArray *)mArray {
    
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:mArray.copy] autorelease];
    CLLocation *location = [LibLocation location];
    NSLog(@"INIZIO + sortWithArray Info");
    while (tempArray.count != 0) {
        int index = [self minInArray:tempArray withI:0 withZ:tempArray.count - 1 withCurrentPosition:location];
        [returnArray addObject:[tempArray objectAtIndex:index]];
        [tempArray removeObjectAtIndex:index];
    }
    NSLog(@"FINE");
    
    return returnArray;
}

- (int)minInArray:(NSArray *)array withI:(int)i withZ:(int)z withCurrentPosition:(CLLocation *)currentPosition{
    
    if (i==z) {
        return i;
    }
    if (z == i+1) {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:i] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:i] objectAtIndex:10] doubleValue]];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:i+1] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:i+1] objectAtIndex:10] doubleValue]];
        
        if ([currentPosition distanceFromLocation:location1] < [currentPosition distanceFromLocation:location2]){
            return i;
        }
        else {
            return i+1;
        }
    }
    else {
        int m = (i + z) / 2;
        int sx = [self minInArray:array withI:i withZ:m withCurrentPosition:currentPosition];
        int dx = [self minInArray:array withI:m+1 withZ:z withCurrentPosition:currentPosition];
        
        CLLocation *locationDX = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:dx] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:dx] objectAtIndex:10] doubleValue]];
        CLLocation *locationSX = [[CLLocation alloc] initWithLatitude:[[[array objectAtIndex:sx] objectAtIndex:8] doubleValue] longitude:[[[array objectAtIndex:sx] objectAtIndex:10] doubleValue]];

        if ([currentPosition distanceFromLocation:locationDX] < [currentPosition distanceFromLocation:locationSX])
            return dx;
        else
            return sx;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return titleFooter;
    
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
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath]; //arrayDefibrillatoriToView
        NSArray *tempArray = [arraySort objectAtIndex:indexPath.row - 1];
        
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

//**********************************************
#pragma mark - Action Methods
//**********************************************

- (IBAction)pressButtonSelect:(id)sender {
    if ([self.buttonSelect.title isEqual: @"Tutti"]) {
        self.buttonSelect.title = @"< 1 km";
        viewAll = NO;
    }
    else {
        self.buttonSelect.title = @"Tutti";
        viewAll = YES;
    }
    [self.tableView reloadData];
}

- (IBAction)pressButtonRefresh:(id)sender {
    
    
}
@end
