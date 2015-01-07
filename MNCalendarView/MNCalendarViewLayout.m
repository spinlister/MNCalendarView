//
//  MNCalendarViewLayout.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewLayout.h"

@implementation MNCalendarViewLayout

- (id)init {
  if (self = [super init]) {
    self.sectionInset = UIEdgeInsetsZero;
    self.minimumInteritemSpacing = 0.f;
    self.minimumLineSpacing = 0.f;
    self.headerReferenceSize = CGSizeMake(0.f, 44.f);
    self.footerReferenceSize = CGSizeZero;
  }
  return self;
}

// pasta from http://blog.radi.ws/post/32905838158/sticky-headers-for-uicollectionview-using
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;

    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }

    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];

        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];

        [answer addObject:layoutAttributes];

    }];

    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {

        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {

            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];

            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];

            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];

            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN( MAX( contentOffset.y, (CGRectGetMinY(firstCellAttrs.frame) - headerHeight) ), (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight));

            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };

        }

    }

    return answer;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {

    return YES;

}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {

  NSArray *array =
    [super layoutAttributesForElementsInRect:({
      CGRect bounds = self.collectionView.bounds;
      bounds.origin.y = proposedContentOffset.y - self.collectionView.bounds.size.height/2.f;
      bounds.size.width *= 1.5f;
      bounds;
    })];
  
  CGFloat minOffsetY = CGFLOAT_MAX;
  UICollectionViewLayoutAttributes *targetLayoutAttributes = nil;

  for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
    if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
      CGFloat offsetY = fabs(layoutAttributes.frame.origin.y - proposedContentOffset.y);

      if (offsetY < minOffsetY) {
        minOffsetY = offsetY;

        targetLayoutAttributes = layoutAttributes;
      }
    }
  }

  if (targetLayoutAttributes) {
    return targetLayoutAttributes.frame.origin;
  }

  return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
}

@end
