//
//  MNCalendarViewCell.h
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

// calendar color dictionary keys
extern NSString *const kMNCalendarColorHeaderBackground;
extern NSString *const kMNCalendarColorCellBackground;
extern NSString *const kMNCalendarColorCellSeparator;
extern NSString *const kMNCalendarColorCellHighlight;
extern NSString *const kMNCalendarColorCellHighlightRange;
extern NSString *const kMNCalendarColorValidTextHighlight;
extern NSString *const kMNCalendarColorValidText;
extern NSString *const kMNCalendarColorInvalidText;

@interface MNCalendarViewCell : UICollectionViewCell

@property(nonatomic,strong) NSCalendar *calendar;

@property(nonatomic,assign,getter = isEnabled) BOOL enabled;

@property(nonatomic,strong) UIColor *separatorColor;
@property(nonatomic,strong,readonly) UILabel *titleLabel;
@property(nonatomic,strong,readonly) NSDictionary *colors;

- (void)updateColors:(NSDictionary *)colors;

@end
