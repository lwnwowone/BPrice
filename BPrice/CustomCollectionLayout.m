//
//  CustomCollectionLayout.m
//  TestMyCollectionView
//
//  Created by Alanc Liu on 7/18/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "CustomCollectionLayout.h"

const int ITEM_SIZE = 200;
const int ACTIVE_DISTANCE = 200;
const float ZOOM_FACTOR = 1;

@implementation CustomCollectionLayout

-(void)initThisWith:(float)collectionWidth and:(float)collectionHeight{
    self.itemSize = CGSizeMake(78,98);
    self.minimumLineSpacing = 60;
    float leftMargin = (collectionWidth - self.itemSize.width)/2;
    float topMargin = (collectionHeight - self.itemSize.height)/2;
    self.sectionInset = UIEdgeInsetsMake(topMargin,leftMargin,topMargin,leftMargin);//上左下右
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
//    self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
//    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.sectionInset = UIEdgeInsetsMake(200,0,200,0);
//    self.minimumLineSpacing = 50;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return true;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    var array = base.LayoutAttributesForElementsInRect (rect);
    NSArray<UICollectionViewLayoutAttributes *> *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (CGRectIntersectsRect(attributes.frame , rect)) {
            float distance = CGRectGetMidX(visibleRect)  - attributes.center.x;
            float normalizedDistance = distance / ACTIVE_DISTANCE;
            if (fabs(distance) < ACTIVE_DISTANCE) {
                float zoom = 1 + ZOOM_FACTOR * (1 - fabs (normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    float offSetAdjustment = MAXFLOAT;
    float horizontalCenter = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    CGRect targetRect = CGRectMake (proposedContentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    for(UICollectionViewLayoutAttributes *layoutAttributes in array) {
        float itemHorizontalCenter = layoutAttributes.center.x;
        if (fabs(itemHorizontalCenter - horizontalCenter) < fabs(offSetAdjustment)) {
            offSetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake (proposedContentOffset.x + offSetAdjustment, proposedContentOffset.y);
}

@end
