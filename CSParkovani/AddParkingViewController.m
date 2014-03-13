//
//  AddParkingViewController.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "AddParkingViewController.h"
#import "AddParkingTableCell.h"
#import "Parking.h"

@interface AddParkingViewController ()

- (void)addParking:(id)sender indexPath:(NSIndexPath *)indexPath;

@end

@implementation AddParkingViewController {

}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}
**/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [Parking parkingsDictionary].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddParkingTableCell";
    AddParkingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[AddParkingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddParkingTableCell"];
    }

    cell.parkingType.text = ((Parking *)[[Parking parkingsDictionary].allValues objectAtIndex:indexPath.row]).truncatedName;
    cell.location.text = ((Parking *)[[Parking parkingsDictionary].allValues objectAtIndex:indexPath.row]).parkingObject.name;
    cell.isSelected.on = [[Parking trackedParkingsDictionary].allValues
            containsObject:((Parking *)[[Parking parkingsDictionary].allValues objectAtIndex:indexPath.row])];
    cell.isSelected.accessibilityIdentifier = [NSString stringWithFormat:@"%i",indexPath.row];
    [cell.isSelected addTarget:self action:@selector(trackParking:)  forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (void) trackParking:(id)sender{
    UISwitch *uiSwitch = sender;
    NSLog( @"The switch is %@", uiSwitch.on ? @"ON" : @"OFF" );
    NSLog(@"row: %@", uiSwitch.accessibilityIdentifier);

    NSNumber *row = @([uiSwitch.accessibilityIdentifier intValue]);


    if (uiSwitch.on) {
        [Parking trackParkingWithParkingId:((Parking *)[[Parking parkingsDictionary].allValues objectAtIndex:row.integerValue]).parkingId
                                    objectId:((Parking *)[[Parking parkingsDictionary].allValues objectAtIndex:row.integerValue]).objectId];
    } else {
        [Parking untrackParkingWithParkingId:((Parking *)[[Parking parkingsDictionary].allValues objectAtIndex:row.integerValue]).parkingId
                                    objectId:((Parking *)[[Parking parkingsDictionary].allValues objectAtIndex:row.integerValue]).objectId];
    }

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
