//
//  MNCalendarView.h
//  MNCalendarView
//
//  Created by Min Kim on 7/23/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MNCalendarViewLayout.h"
#import "MNCalendarViewDayCell.h"
#import "MNCalendarViewWeekdayCell.h"
#import "MNCalendarHeaderView.h"
#import "MNFastDateEnumeration.h"

#define MN_MINUTE 60.f
#define MN_HOUR   MN_MINUTE * 60.f
#define MN_DAY    MN_HOUR * 24.f
#define MN_WEEK   MN_DAY * 7.f
#define MN_YEAR   MN_DAY * 365.f

@protocol MNCalendarViewDelegate;

@interface MNCalendarView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong,readonly) UICollectionView *collectionView;

@property(nonatomic,weak) id<MNCalendarViewDelegate> delegate;

@property(nonatomic,strong)   NSCalendar *calendar;
@property(nonatomic,strong)   NSDate     *fromDate;
@property(nonatomic,strong)   NSDate     *toDate;

@property(nonatomic,assign) MNCalendarSelectType selectType;

// Deprecated
@property(nonatomic,strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR; // default is the standard separator gray

@property(nonatomic,strong) NSMutableDictionary *colors;

@property(nonatomic,strong) Class headerViewClass;
@property(nonatomic,strong) Class weekdayCellClass;
@property(nonatomic,strong) Class dayCellClass;

@property(nonatomic, assign) BOOL inversed;

- (void)reloadData;
- (void)registerUICollectionViewClasses;

- (MNCalendarViewCell *)cellForDate:(NSDate *)date;

@end

@protocol MNCalendarViewDelegate <NSObject>

@optional

- (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
- (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date;
- (void)calendarView:(MNCalendarView *)calendarView didSelectCell:(MNCalendarViewCell *)cell;

@end
