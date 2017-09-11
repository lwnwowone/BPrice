//
//  PictureCollectionView.m
//  TestMyCollectionView
//
//  Created by Alanc Liu on 7/18/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "PictureCollectionView.h"

@interface PictureCollectionView ()

@property NSMutableArray *imageArray;

@end

@implementation PictureCollectionView

static NSString * cellIdentifier = @"MyCell";

-(void)InitThis{
    self.imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"main.png"],
                       [UIImage imageNamed:@"large.png"],
                       [UIImage imageNamed:@"small.png"],
                       [UIImage imageNamed:@"mSmall.png"],
                       nil];
    
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];\
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
}


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imgV.image = [self.imageArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:imgV];
    imgV.layer.cornerRadius = 5;
    imgV.layer.masksToBounds = YES;
    return cell;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//}

//返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

@end
