//
//  DetailViewController.m
//  myVita
//
//  Created by Marco Velluto on 27/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "DetailViewController.h"
#import "Database.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self = [super initWithStyle:UITableViewStyleGrouped];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    arrayNameInfo = [[NSMutableArray alloc] init];
    [arrayNameInfo addObject:@"Nome"];
    [arrayNameInfo addObject:@"Disponibilità"];
    [arrayNameInfo addObject:@"Posizione"];
    [arrayNameInfo addObject:@"Indirizzo"];
    [arrayNameInfo addObject:@"Riferimento"];
    [arrayNameInfo addObject:@"Telefono Punto Blu"];
    
    arrayValueTV = [[NSMutableArray alloc] init];
    [arrayValueTV addObject:[_dicInfo valueForKey:KEY_NOME]];
    [arrayValueTV addObject:[_dicInfo valueForKey:KEY_DISPONIBILITA]];
    [arrayValueTV addObject:[_dicInfo valueForKey:KEY_LOCALITA]];
    [arrayValueTV addObject:[_dicInfo valueForKey:KEY_INDIRIZZO]];
    if ([_dicInfo valueForKey:KEY_RIFERIMENTO]) {
        [arrayValueTV addObject:[_dicInfo valueForKey:KEY_RIFERIMENTO]];
    }
    
    [arrayValueTV addObject:[_dicInfo valueForKey:KEY_TEL_PUNTO_BLU]];
    
//    [arrayValueTV addObject:[_arrayInfo objectAtIndex:13]];
//    [arrayValueTV addObject:[_arrayInfo objectAtIndex:5]];
//    [arrayValueTV addObject:[_arrayInfo objectAtIndex:3]];
//    [arrayValueTV addObject:[_arrayInfo objectAtIndex:7]];
//    [arrayValueTV addObject:[_arrayInfo objectAtIndex:17]];
//    [arrayValueTV addObject:[_arrayInfo objectAtIndex:23]];



    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
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
    //return _arrayInfo.count;
    return arrayValueTV.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setEditing:NO];
        [cell setSelected:NO];
    }
    
    //cell.detailTextLabel.text = [_arrayInfo objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [arrayNameInfo objectAtIndex:indexPath.row];
    cell.textLabel.text = [arrayValueTV objectAtIndex:indexPath.row];
    
    /*
    if (indexPath.row < arrayNameInfo.count) {
        cell.textLabel.text = [arrayNameInfo objectAtIndex:indexPath.row];

    }
     */
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
    if (indexPath.row == 0) {
        //
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
