//
//  ParkingMasterTableCell.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingMasterTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *parkingType;
@property (weak, nonatomic) IBOutlet UILabel *freePlaces;
@property (weak, nonatomic) IBOutlet UILabel *timeToFull;

@end
