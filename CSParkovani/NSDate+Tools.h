//
//  NSDate+Tools.h
//  CSParkovani
//
//  Created by Viktor Smidl on 14/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tools)

- (NSDate *)midnightDate;
- (NSDate *)dateWithDayOffset:(NSInteger)dayOffset;
- (NSString *)toStringWithFormat:(NSString *)dateFormat;
- (NSDate *)firstDayOfTheWeek;
- (NSInteger)dayOfWeek;

@end
