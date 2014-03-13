//
//  AddParkingTableCell.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//



@interface AddParkingTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *parkingType;
@property (weak, nonatomic) IBOutlet UISwitch *isSelected;

@end
