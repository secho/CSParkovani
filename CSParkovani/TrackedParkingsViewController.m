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
{
    
    UIRefreshControl *refresher;
    
}

@synthesize trackedParkingTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    refresher = [[UIRefreshControl alloc] init];
    [refresher addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresher;

    // Getting parkings here
    // TODO: this has to be cleaned
    
    if ([Parking parkingsDictionary].count > 0)
    {
        [Parking updateTrackedParkings];
    }
    else
    {
        [Parking parkings:^(NSArray *parkings) {
            
            [Parking setDelegateForAllParkings:self];
            [Parking trackParkingWithParkingId:@5 objectId:@15];
            [Parking trackParkingWithParkingId:@3 objectId:@6];
            [Parking updateAllStatuses];
            
        } onError:^(NSError *error) {
            
            NSLog(@"Error: %@", error.description);
            
        }];
    }
}

- (void)refresh
{
    NSLog(@"refreshing ...");
    [Parking updateTrackedParkings];
}

#pragma mark - Helper

- (Parking *)parkingModelForIndexPath:(NSIndexPath *)indexPath
{
    return [[Parking trackedParkingsDictionary].allValues objectAtIndex:indexPath.row];
}

#pragma mark - Delegates

#pragma mark Parking

- (void)didUpdatedStatus:(Parking *)parking
{
    // Add logic (if any) for particular parking status update
}

- (void)didUpdatedStatusesForAllParkings
{
    NSLog(@"Did updated all statuses in dictionary, now reloading table");
    
    if (self.refreshControl.refreshing)
    {
        [refresher endRefreshing];
    }
    
    [trackedParkingTable reloadData];
}

#pragma mark Table view data source

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
    
    if (cell == nil)
    {
        cell = [[ParkingMasterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ParkingMasterTableCell"];
    }

    Parking *parkingModel = [self parkingModelForIndexPath:indexPath];
    cell.parkingType.text = parkingModel.truncatedName;
    cell.location.text = parkingModel.parkingObject.name;
    cell.freePlaces.text = parkingModel.status.freePlaces.description;

//    cell.nameLabel.text = ((Parking *)[[Parking trackedParkingsDictionary].allValues objectAtIndex:indexPath.row]).status.limitTotal.description;
//    cell.gameLabel.text = ((Parking *)[[Parking trackedParkingsDictionary].allValues objectAtIndex:indexPath.row]).status.presentTotal.description;
    
    return cell;

}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDetailView"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"Performing Segue %@", segue.identifier);

        Parking *parkingModel = [self parkingModelForIndexPath:indexPath];
        ParkingDetailViewController *parkingDetail = (ParkingDetailViewController *)segue.destinationViewController;
        parkingDetail.parking = parkingModel;
    }
}



@end
