//
//  MNCalendarViewDayCell.m
//  MNCalendarView
//
//  Created by Min Kim on 7/28/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewDayCell.h"

NSString *const MNCalendarViewDayCellIdentifier = @"MNCalendarViewDayCellIdentifier";

@interface MNCalendarViewDayCell()

@property(nonatomic,strong,readwrite) NSDate *date;
@property(nonatomic,strong,readwrite) NSDate *month;
@property(nonatomic,assign,readwrite) NSUInteger weekday;

@end

@implementation MNCalendarViewDayCell

- (void)setDate:(NSDate *)date
          month:(NSDate *)month
       calendar:(NSCalendar *)calendar {

  self.date     = date;
  self.month    = month;
  self.calendar = calendar;

  NSDateComponents *components =
  [self.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                   fromDate:self.date];

  NSDateComponents *monthComponents =
  [self.calendar components:NSMonthCalendarUnit
                   fromDate:self.month];

  self.enabled = monthComponents.month == components.month;
  self.weekday = (components.weekday + self.calendar.firstWeekday - 1) % 7;
  self.titleLabel.hidden = components.month != monthComponents.month;
  self.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)components.day];
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];

  if (self.colors)
    self.titleLabel.textColor = self.enabled ? self.colors[kMNCalendarColorValidText] : self.colors[kMNCalendarColorInvalidText];
}

@end
