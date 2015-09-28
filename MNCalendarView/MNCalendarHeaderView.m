//
//  MNCalendarHeaderView.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarHeaderView.h"

NSString *const MNCalendarHeaderViewIdentifier = @"MNCalendarHeaderViewIdentifier";

@interface MNCalendarHeaderView()

@property(nonatomic,strong,readwrite) UILabel *titleLabel;

@end

@implementation MNCalendarHeaderView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame])
  {
    CGFloat itemWidth  = self.bounds.size.width;
    CGFloat itemHeight = self.bounds.size.height / 2;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, itemWidth, itemHeight)];
    self.titleLabel.backgroundColor = UIColor.clearColor;
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.titleLabel];
  }
  return self;
}

- (void)setDate:(NSDate *)date {
  _date = date;

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

  [dateFormatter setDateFormat:@"MMMM yyyy"];

  self.titleLabel.text = [dateFormatter stringFromDate:self.date];
}

#define DAYS_IN_A_WEEK 7

- (void)setLabels:(NSArray *)labels attributes:(NSDictionary *)attributes
{
  CGFloat width      = self.bounds.size.width;
  CGFloat itemWidth  = width / DAYS_IN_A_WEEK;
  CGFloat itemHeight = self.bounds.size.height / 2;

  for (int x = 0; x < DAYS_IN_A_WEEK; x++)
  {
    UILabel *label = (UILabel *)[self viewWithTag:x+1];
    if (!label)
    {
      label = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * x, itemHeight, itemWidth, itemHeight)];
      label.tag = x+1;
      label.textAlignment = NSTextAlignmentCenter; // FIXME use mutableparagraph
    }
    NSString *title = [labels[x] uppercaseString];
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [self addSubview:label];
  }
}

@end
