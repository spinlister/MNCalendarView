//
//  MNCalendarViewCell.h
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

// we put these declarations here because they're the LCD in the import tree

// calendar color dictionary keys
extern NSString *const kMNCalendarColorHeaderBackground;
extern NSString *const kMNCalendarColorHeaderText;
extern NSString *const kMNCalendarColorCellBackground;
extern NSString *const kMNCalendarColorCellSeparator;
extern NSString *const kMNCalendarColorCellHighlight;
extern NSString *const kMNCalendarColorCellHighlightSingle; // color or image name
extern NSString *const kMNCalendarColorCellHighlightRange; // color or image name
extern NSString *const kMNCalendarColorCellHighlightRangeFill;
extern NSString *const kMNCalendarColorValidTextHighlight;
extern NSString *const kMNCalendarColorValidText;
extern NSString *const kMNCalendarColorInvalidText;

typedef NS_OPTIONS(NSInteger, MNCalendarSelectType) {
	MNCalendarSelectionTypeNone = 0,
	MNCalendarSelectionTypeSingle = 1 << 0,
	MNCalendarSelectionTypeStart = 1 << 1,
	MNCalendarSelectionTypeEnd = 1 << 2,
	MNCalendarSelectionTypeFill = 1 << 3
};

@interface MNCalendarViewCell : UICollectionViewCell

@property(nonatomic,strong) NSCalendar *calendar;

@property(nonatomic,assign,getter = isEnabled) BOOL enabled;
@property(nonatomic,assign) MNCalendarSelectType position;

@property(nonatomic,strong,readonly) UILabel *titleLabel;
@property(nonatomic,strong,readonly) NSDictionary *colors;

- (void)updateColors:(NSDictionary *)colors;

@end
