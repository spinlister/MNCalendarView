//
//  MNCalendarView.m
//  MNCalendarView
//
//  Created by Min Kim on 7/23/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarView.h"
#import "NSDate+MNAdditions.h"

#define DAYS_IN_A_WEEK 7

@interface MNCalendarView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout *layout;

@property(nonatomic,strong) NSArray *monthDates;
@property(nonatomic,strong) NSArray *weekdaySymbols;

@property(nonatomic,assign) NSUInteger daysInWeek;

@property(nonatomic,strong) NSDate *selectedStartDate;
@property(nonatomic,strong) NSDate *selectedEndDate;

@property(nonatomic,strong) NSIndexPath *selectedStartPath;
@property(nonatomic,strong) NSIndexPath *selectedEndPath;

@property(nonatomic,strong) NSDateFormatter *monthFormatter;

- (NSDate *)firstVisibleDateOfMonth:(NSDate *)date;
- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date;

- (BOOL)dateEnabled:(NSDate *)date;
- (BOOL)canSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MNCalendarView

- (void)commonInit {

  self.autoresizesSubviews = YES;

  self.calendar   = NSCalendar.currentCalendar;
  self.fromDate   = [NSDate.date mn_beginningOfDay:self.calendar];
  self.toDate     = [self.fromDate dateByAddingTimeInterval:MN_YEAR * 4];

  self.selectType = MNCalendarSelectionTypeSingle;

  self.headerViewClass  = MNCalendarHeaderView.class;
  self.weekdayCellClass = MNCalendarViewWeekdayCell.class;
  self.dayCellClass     = MNCalendarViewDayCell.class;

  // color defaults
  self.colors = [@{
      kMNCalendarColorHeaderBackground: [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f],
      kMNCalendarColorCellBackground: [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f],
      kMNCalendarColorCellSeparator: [UIColor colorWithRed:.85f green:.85f blue:.85f alpha:1.f],
      kMNCalendarColorCellHighlightSingle: [UIColor colorWithRed:0.23f green:0.61f blue:1.f alpha:1.f],
      kMNCalendarColorCellHighlight: [UIColor colorWithRed:0.23f green:0.61f blue:1.f alpha:1.f],
      kMNCalendarColorCellHighlightRange: [UIColor colorWithRed:0.23f green:0.61f blue:1.f alpha:1.f],
      kMNCalendarColorCellHighlightRangeFill: [UIColor colorWithRed:0.13f green:0.51f blue:.9f alpha:1.f],
      kMNCalendarColorValidText: [UIColor darkTextColor],
      kMNCalendarColorValidTextHighlight: [UIColor whiteColor],
      kMNCalendarColorInvalidText: [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f],
    } mutableCopy];

  [self addSubview:self.collectionView];
  [self reloadData];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder: aDecoder];
  if ( self ) {
    [self commonInit];
  }

  return self;
}

- (UICollectionView *)collectionView {
  if (nil == _collectionView) {
    MNCalendarViewLayout *layout = [[MNCalendarViewLayout alloc] init];

    _collectionView =
      [[UICollectionView alloc] initWithFrame:self.bounds
                         collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    [self registerUICollectionViewClasses];
  }
  return _collectionView;
}

#pragma mark - Setter overrides

- (void)setSeparatorColor:(UIColor *)separatorColor {
  _colors[kMNCalendarColorCellSeparator] = separatorColor;
}

- (void)setCalendar:(NSCalendar *)calendar {
  _calendar = calendar;

  self.monthFormatter = [[NSDateFormatter alloc] init];
  self.monthFormatter.calendar = calendar;
  self.weekdaySymbols = self.monthFormatter.shortWeekdaySymbols;

  [self.monthFormatter setDateFormat:@"MMMM yyyy"];
}

- (void)setSelectedStartDate:(NSDate *)selectedDate {
  _selectedStartDate = [selectedDate mn_beginningOfDay:self.calendar];
}
- (void)setSelectedEndDate:(NSDate *)selectedDate {
  _selectedEndDate = [selectedDate mn_beginningOfDay:self.calendar];
}

- (void)setSelectType:(MNCalendarSelectType)type
{
  _selectType = type;
  switch(_selectType)
  {
    case MNCalendarSelectionTypeNone:
      _collectionView.allowsSelection = NO;
      break;

    default:
    case MNCalendarSelectionTypeSingle:
      _collectionView.allowsSelection = YES;
      _collectionView.allowsMultipleSelection = NO;
      break;

    case MNCalendarSelectionTypeStart:
    case MNCalendarSelectionTypeEnd:
      _collectionView.allowsSelection = YES;
      _collectionView.allowsMultipleSelection = YES;
  }
}

#pragma mark -

- (void)reloadData {
  NSMutableArray *monthDates = @[].mutableCopy;
  MNFastDateEnumeration *enumeration =
    [[MNFastDateEnumeration alloc] initWithFromDate:[self.fromDate firstDateOfMonthWithCalendar:self.calendar]
                                             toDate:[self.toDate lastDateOfMonthWithCalendar:self.calendar]
                                           calendar:self.calendar
                                               unit:NSMonthCalendarUnit];
  for (NSDate *date in enumeration)
    [monthDates addObject:date];

  if (self.inversed)
      self.monthDates = [[monthDates reverseObjectEnumerator] allObjects];
  else
      self.monthDates = monthDates;

  [self.collectionView reloadData];
}

- (void)registerUICollectionViewClasses {
  [_collectionView registerClass:self.dayCellClass
      forCellWithReuseIdentifier:MNCalendarViewDayCellIdentifier];

  [_collectionView registerClass:self.headerViewClass
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:MNCalendarHeaderViewIdentifier];
}

- (NSDate *)firstVisibleDateOfMonth:(NSDate *)date {

    return [[date firstDateOfMonthWithCalendar:self.calendar] firstDateOfWeekWithCalendar:self.calendar];
}

- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date {

    return [[date lastDateOfMonthWithCalendar:self.calendar] lastDateOfWeekWithCalendar:self.calendar];
}

- (BOOL)dateEnabled:(NSDate *)date {
  if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
    return [self.delegate calendarView:self shouldSelectDate:date];
  }

  return YES;
}

- (BOOL)canSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  MNCalendarViewCell *cell = (MNCalendarViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];

  BOOL enabled = cell.enabled;

  if ([cell isKindOfClass:MNCalendarViewDayCell.class] && enabled) {
    MNCalendarViewDayCell *dayCell = (MNCalendarViewDayCell *)cell;
    enabled = [self dateEnabled:dayCell.date];
  }

  return enabled;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.monthDates.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  MNCalendarHeaderView *headerView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:MNCalendarHeaderViewIdentifier
                                              forIndexPath:indexPath];

  headerView.backgroundColor = _colors[kMNCalendarColorHeaderBackground];

  NSDictionary *textAttributes = @{ NSForegroundColorAttributeName: _colors[kMNCalendarColorInvalidText] };
  NSString *title = [self.monthFormatter stringFromDate:self.monthDates[indexPath.section]];
  headerView.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:textAttributes];

  [headerView setLabels:self.weekdaySymbols attributes:@{
    NSForegroundColorAttributeName: _colors[kMNCalendarColorInvalidText],
    NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12],
  }];

  return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  NSDate *monthDate = self.monthDates[section];

  NSDateComponents *components =
    [self.calendar components:NSDayCalendarUnit
                     fromDate:[self firstVisibleDateOfMonth:monthDate]
                       toDate:[self lastVisibleDateOfMonth:monthDate]
                      options:0];

  return components.day + 1;
}

- (MNCalendarSelectType)selectionTypeForIndexPath:(NSIndexPath *)indexPath
{
  if (!_selectedStartPath && !_selectedEndPath)
    return MNCalendarSelectionTypeNone;
    
  NSComparisonResult startPath = [indexPath compare:_selectedStartPath];
  NSComparisonResult endPath = [indexPath compare:_selectedEndPath];

  if (startPath == NSOrderedSame && endPath == NSOrderedSame)
    return MNCalendarSelectionTypeSingle;

  else if (startPath == NSOrderedSame)
    return MNCalendarSelectionTypeStart;
  
  else if (endPath == NSOrderedSame)
    return MNCalendarSelectionTypeEnd;
  
  else if (_selectedStartPath && startPath == NSOrderedDescending && 
           _selectedEndPath && endPath == NSOrderedAscending)
    return MNCalendarSelectionTypeFill;
  
  else
    return MNCalendarSelectionTypeNone;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  MNCalendarViewDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MNCalendarViewDayCellIdentifier
                                                                          forIndexPath:indexPath];


  cell.position = [self selectionTypeForIndexPath:indexPath];
  [cell updateColors:_colors];

  NSDate *monthDate = self.monthDates[indexPath.section];
  NSDate *firstDateInMonth = [self firstVisibleDateOfMonth:monthDate];

  NSUInteger day = indexPath.item;

  if (self.inversed)
  {
    NSInteger numberOfDaysInMonth = ([self.collectionView numberOfItemsInSection:indexPath.section] - DAYS_IN_A_WEEK) - 1;
    NSInteger r = day / DAYS_IN_A_WEEK;
    NSInteger c = day % DAYS_IN_A_WEEK;
    day = numberOfDaysInMonth - (r * DAYS_IN_A_WEEK + (DAYS_IN_A_WEEK - c)) + 1;
  }

  NSDateComponents *components = [self.calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                  fromDate:firstDateInMonth];
  components.day += day;

  NSDate *date = [self.calendar dateFromComponents:components];
  [cell setDate:date month:monthDate calendar:self.calendar];

  if (cell.enabled)
    [cell setEnabled:[self dateEnabled:date]];

  return cell;
}

- (MNCalendarViewCell *)cellForDate:(NSDate *)date
{
  NSDate *firstDateInMonth = [self firstVisibleDateOfMonth:date];
  NSDateComponents *components = [self.calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                  fromDate:firstDateInMonth];

  NSInteger row = components.day;
  const NSUInteger paths[2] = { MAX(0,(components.month % 12) - 1), row};
  NSIndexPath *path = [NSIndexPath indexPathWithIndexes:paths length:2];
  return (MNCalendarViewCell *)[_collectionView cellForItemAtIndexPath:path];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self canSelectItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self canSelectItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
  [collectionView reloadData];
  return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  MNCalendarViewDayCell *cell = (MNCalendarViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];

  // Deselect any previously selected cell
  if (_selectedStartPath && _selectType == MNCalendarSelectionTypeStart)
    self.selectedStartPath = nil;

  else if (_selectedEndPath && _selectType == MNCalendarSelectionTypeEnd)
    self.selectedEndPath = nil;

  switch (_selectType)
  {
    case MNCalendarSelectionTypeStart:
      cell.position = MNCalendarSelectionTypeStart;
      self.selectedStartPath = indexPath; 
      self.selectedStartDate = [cell.date mn_beginningOfDay:self.calendar];
      break;
    case MNCalendarSelectionTypeEnd:
      cell.position = MNCalendarSelectionTypeEnd;
      self.selectedEndPath = indexPath;   
      self.selectedEndDate = cell.date;
      break;
  }
   
  if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)])
    [self.delegate calendarView:self didSelectDate:cell.date];

  if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectCell:)])
    [self.delegate calendarView:self didSelectCell:cell];

  [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

  CGFloat width      = self.bounds.size.width;
  CGFloat itemWidth  = roundf(width / DAYS_IN_A_WEEK);
  CGFloat itemHeight = itemWidth;

  NSUInteger weekday = indexPath.item % DAYS_IN_A_WEEK;

  if (weekday == DAYS_IN_A_WEEK - 1) {
    itemWidth = width - (itemWidth * (DAYS_IN_A_WEEK - 1));
  }

  return CGSizeMake(itemWidth, itemHeight);
}

@end
