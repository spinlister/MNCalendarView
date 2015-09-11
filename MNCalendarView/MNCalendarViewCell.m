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
NSString *const kMNCalendarColorHeaderText = @"kMNCalendarColorHeaderText";
NSString *const kMNCalendarColorCellBackground = @"kMNCalendarColorCellBackground";
NSString *const kMNCalendarColorCellSeparator = @"kMNCalendarColorCellSeparator";
NSString *const kMNCalendarColorCellHighlight = @"kMNCalendarColorCellHighlight";
NSString *const kMNCalendarColorCellHighlightSingle = @"kMNCalendarColorCellHighlightSingle";
NSString *const kMNCalendarColorCellHighlightRange = @"kMNCalendarColorCellHighlightRange";
NSString *const kMNCalendarColorCellHighlightRangeFill = @"kMNCalendarColorCellHighlightRangeFill";
NSString *const kMNCalendarColorValidTextHighlight = @"kMNCalendarColorValidTextHighlight";
NSString *const kMNCalendarColorValidText = @"kMNCalendarColorValidText";
NSString *const kMNCalendarColorInvalidText = @"kMNCalendarColorInvalidText";

NSString *const kMNCalendarImageRotation = @"MNCalendarImageRotation";

@interface MNCalendarViewCell()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSDictionary *colors;
@end

@implementation MNCalendarViewCell

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame])
  {
    self.layer.borderWidth = 0;
    self.position = MNCalendarSelectionTypeNone;

    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.titleLabel.userInteractionEnabled = NO;
    self.titleLabel.backgroundColor = [UIColor clearColor];

    // FIXME deprecated, update for ios6+
    self.titleLabel.font = [UIFont systemFontOfSize:19.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.titleLabel];

    self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  }
  return self;
}


- (void)setEnabled:(BOOL)enabled {
  _enabled = enabled;
}

- (void)updateColors:(NSDictionary *)colors
{
  if (!colors && !_colors)
    return;

  self.colors = colors;
  self.clipsToBounds = YES;

  self.titleLabel.textColor = colors[kMNCalendarColorValidText];
  self.titleLabel.highlightedTextColor = colors[kMNCalendarColorValidTextHighlight];

  self.contentView.layer.borderColor = ((UIColor *)colors[kMNCalendarColorCellSeparator]).CGColor;
  self.contentView.layer.borderWidth = 0.25f;

  UIImageView *backView = (UIImageView *)self.backgroundView;
  backView.image = nil;
  backView.transform = CGAffineTransformIdentity;
  backView.backgroundColor = colors[kMNCalendarColorCellBackground];

  switch(_position)
  {
    case MNCalendarSelectionTypeSingle:
      backView.image = [UIImage imageNamed:colors[kMNCalendarColorCellHighlightSingle]];
      break;

    case MNCalendarSelectionTypeFill:
      self.contentView.layer.borderWidth = 0;
      backView.backgroundColor = colors[kMNCalendarColorCellHighlightRangeFill];
      break;

    case MNCalendarSelectionTypeStart:
    case MNCalendarSelectionTypeEnd:
    {
      self.contentView.layer.borderColor = ((UIColor *)colors[kMNCalendarColorCellHighlightRangeFill]).CGColor;
      id rangeContent = colors[kMNCalendarColorCellHighlightRange];
      if ([rangeContent isKindOfClass:[NSString class]])
      {
        backView.image = [UIImage imageNamed:rangeContent];
        backView.contentMode = UIViewContentModeScaleToFill;
      }
      else
        backView.backgroundColor = (UIColor *)rangeContent;
      break;
    }
    default:
    case MNCalendarSelectionTypeNone:
      break;
  }

  switch(_position)
  {
    case MNCalendarSelectionTypeEnd:
      backView.transform = CGAffineTransformMakeRotation(M_PI);
    default:
      break;
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  self.contentView.frame = self.bounds;
  self.backgroundView.frame = self.bounds;
}

@end
