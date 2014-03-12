//
//  TrackedParkingsViewController.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "ParkingDelegate.h"
#import <UIKit/UIKit.h>

@interface TrackedParkingsViewController : UITableViewController <ParkingDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *trackedParkingTable;


@end
