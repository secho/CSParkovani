//
//  ChartView.m
//  CSParkovani
//
//  Created by Viktor Smidl on 16/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "ChartView.h"

#define SPACING_TOP 20.
#define SPACING_BOTTOM 40.
#define HOUR_LABEL_FONT [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.]

@interface ChartView ()

@property (nonatomic, retain) NSArray *hourViews;
@property (nonatomic, retain) NSArray *hourLabels;

@end

@implementation ChartView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUpHourViews];
    [self setUpHourLabels];
}

- (void)setUpHourViews
{
    NSMutableArray *newHourViews = [NSMutableArray array];
    
    NSInteger hoursCount = 24;
    CGFloat frameWidth = self.bounds.size.width;
    CGFloat bottomLine = self.bounds.size.height - SPACING_BOTTOM;
    CGFloat hourViewWidth = frameWidth / (2. * hoursCount - 1.);
    
    for (NSInteger i = 0; i < hoursCount; ++i)
    {
        UIView *hourView = [[UIView alloc] initWithFrame:CGRectMake(2. * i * hourViewWidth, bottomLine, hourViewWidth, 0)];
        hourView.backgroundColor = self.tintColor;
        hourView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [newHourViews addObject:hourView];
        [self addSubview:hourView];
    }
    
    self.hourViews = [newHourViews copy];
}

- (void)setUpHourLabels
{
    NSMutableArray *newHourLabels = [NSMutableArray array];
    
    NSInteger labelsCount = 24;
    CGFloat frameWidth = self.bounds.size.width;
    CGFloat bottomLine = self.bounds.size.height - SPACING_BOTTOM;
    CGFloat hourLabelWidth = frameWidth / (2. * labelsCount + 2.);
    
    for (NSInteger i = 0; i <= labelsCount; i += 4)
    {
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(2. * i * hourLabelWidth - hourLabelWidth, bottomLine, 4 * hourLabelWidth, SPACING_BOTTOM)];
        hourLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        hourLabel.text = [NSString stringWithFormat:@"%d", (int)(i * (24. / labelsCount))];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        hourLabel.font = HOUR_LABEL_FONT;
        
        [newHourLabels addObject:hourLabel];
        [self addSubview:hourLabel];
    }
    
    self.hourLabels = [newHourLabels copy];
}

- (void)setStats:(NSArray *)stats
{
    _stats = stats;
    
    [self redrawChart];
}

- (void)setTotalParkingSlots:(NSInteger)totalParkingSlots
{
    _totalParkingSlots = totalParkingSlots;
    
    [self redrawChart];
}

- (void)redrawChart
{
    CGFloat bottomLine = self.bounds.size.height - SPACING_BOTTOM;
    
    void (^hideAnimation) (void) = ^(void){
        
        for (UIView *hourView in self.hourViews)
        {
            CGRect newFrame = hourView.frame;
            newFrame.origin.y = bottomLine;
            newFrame.size.height = 0.;
            hourView.frame = newFrame;
        }
        
    };
    
    void (^showAnimation) (void) = ^(void){
        
        for (NSInteger i = 0; i < self.stats.count; ++i)
        {
            UIView *hourView = self.hourViews[i];
            ParkingStatistics *stat = self.stats[i];
            
            CGRect newFrame = hourView.frame;
            newFrame.size.height = (stat.free.doubleValue / self.totalParkingSlots) * (self.bounds.size.height - SPACING_TOP - SPACING_BOTTOM);
            if (newFrame.size.height < 0.) newFrame.size.height = 0.;
            newFrame.origin.y = bottomLine - newFrame.size.height;
            hourView.frame = newFrame;
        }
        
    };
    
    //hide old values, then show new
    [UIView animateWithDuration:.3 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:hideAnimation completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:showAnimation completion:nil];
        
    }];
}

@end
