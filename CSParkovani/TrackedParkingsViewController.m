//
//  TrackedParkingsViewController.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "TrackedParkingsViewController.h"
#import "Parking.h"
#import "ParkingMasterTableCell.h"
#import "ParkingDetailViewController.h"

@interface TrackedParkingsViewController ()

@end

@implementation TrackedParkingsViewController

@synthesize trackedParkingTable;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Getting parkings here
    // TODO: this has to be cleaned
    
    if ([Parking parkingsDictionary].count > 0) {
        [Parking updateTrackedParkings];
    } else {
        [Parking parkings:^(NSArray *parkings) {
            NSLog(@"%d parkings loaded", [Parking parkingsDictionary].allValues.count);
            [Parking setDelegateForAllParkings:self];
            [Parking trackParkingWithParkingId:@5 objectId:@15];
            [Parking trackParkingWithParkingId:@3 objectId:@6];
            [Parking updateAllStatuses];
        }         onError:^(NSError *error) {
            NSLog(@"Chybova hlaska je: %@", error.description);
        }];
    }
    
}

#pragma mark - Parking protocol methods

- (void)didUpdatedStatus:(Parking *)parking {
    NSLog(@"parkoviste id: %@ v objektu: %@", parking.parkingId, parking.objectId);
    NSLog(@"jmeno objektu: %@", parking.parkingObject.name);
    NSLog(@"totalParkings: %@", parking.status.limitTotal);
}

- (void)didUpdatedStatusesForAllParkings {
    NSLog(@"Did updated all statuses in dictionary, now reloading table");
    [trackedParkingTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
**/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Parking trackedParkingsDictionary].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingMasterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingMasterTableCell"];
    
    if (cell == nil) {
        cell = [[ParkingMasterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ParkingMasterTableCell"];
    }
    
    NSLog(@"clen do tabulky> ");
    
    cell.textLabel.text = ((Parking *)[[Parking trackedParkingsDictionary].allValues objectAtIndex:indexPath.row]).truncatedName;
//    cell.nameLabel.text = ((Parking *)[[Parking trackedParkingsDictionary].allValues objectAtIndex:indexPath.row]).status.limitTotal.description;
//    cell.gameLabel.text = ((Parking *)[[Parking trackedParkingsDictionary].allValues objectAtIndex:indexPath.row]).status.presentTotal.description;
    
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
