//
//  MNCalendarViewCell.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewCell.h"

NSString *const MNCalendarViewCellIdentifier = @"MNCalendarViewCellIdentifier";

// calendar color dictionary keys
NSString *const kMNCalendarColorHeaderBackground = @"kMNCalendarColorHeaderBackground";
NSString *const kMNCalendarColorCellBackground = @"kMNCalendarColorCellBackground";
NSString *const kMNCalendarColorCellSeparator = @"kMNCalendarColorCellSeparator";
NSString *const kMNCalendarColorCellHighlight = @"kMNCalendarColorCellHighlight";
NSString *const kMNCalendarColorCellHighlightRange = @"kMNCalendarColorCellHighlightRange";
NSString *const kMNCalendarColorValidTextHighlight = @"kMNCalendarColorValidTextHighlight";
NSString *const kMNCalendarColorValidText = @"kMNCalendarColorValidText";
NSString *const kMNCalendarColorInvalidText = @"kMNCalendarColorInvalidText";

@property(nonatomic,strong,readwrite) UILabel *titleLabel;

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSDictionary *colors;
@property(nonatomic,strong) CALayer *separatorLayer;
@end

@implementation MNCalendarViewCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.titleLabel.userInteractionEnabled = NO;
    self.titleLabel.backgroundColor = [UIColor clearColor];

    // FIXME deprecated, update for ios6+
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.titleLabel];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    CGFloat separatorHeight = 1.0f / [UIScreen mainScreen].scale;
    self.separatorLayer = [CALayer layer];
    _separatorLayer.frame = CGRectMake(0,
                                       CGRectGetHeight(self.bounds) - separatorHeight,
                                       CGRectGetWidth(self.bounds),
                                       separatorHeight);
    [self.layer addSublayer:_separatorLayer];
  }
  return self;
}

- (void)updateColors:(NSDictionary *)colors
{
  self.colors = colors;

  self.backgroundColor = colors[kMNCalendarColorCellBackground];
  self.separatorColor = colors[kMNCalendarColorCellSeparator];

  self.titleLabel.textColor = colors[kMNCalendarColorValidText];
  self.titleLabel.highlightedTextColor = colors[kMNCalendarColorValidTextHighlight];

  self.separatorLayer.backgroundColor = ((UIColor *)colors[kMNCalendarColorCellSeparator]).CGColor;
  self.selectedBackgroundView.backgroundColor = colors[kMNCalendarColorCellHighlight];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.contentView.frame = self.bounds;
  self.selectedBackgroundView.frame = self.bounds;

  CGFloat separatorHeight = 1.0f / [UIScreen mainScreen].scale;
  _separatorLayer.frame = CGRectMake(0,
                                     CGRectGetHeight(self.bounds) - separatorHeight,
                                     CGRectGetWidth(self.bounds),
                                     separatorHeight);
}

@end
