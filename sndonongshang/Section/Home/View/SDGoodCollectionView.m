//
//  SDGoodCollectionView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodCollectionView.h"
#import "SDGoodsCollectionCell.h"
#import "SDHomeDataManager.h"

@interface SDGoodCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation SDGoodCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (void)initConfig{
    self.delegate = self;
    self.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"SDGoodsCollectionCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([SDGoodsCollectionCell class])];
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
    [self layoutIfNeeded];
    [self updateContentViewHeight];
}
- (void)updateContentViewHeight{
//    CGFloat maxHeight = SCREEN_HEIGHT - 74;
    CGFloat currentHeight = self.contentSize.height;
//    CGFloat height = currentHeight < maxHeight ? currentHeight : maxHeight;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, currentHeight);
}
#pragma mark Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(108,168);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SDGoodsCollectionCell class]) forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDGoodModel *goodModel = [self.dataArray objectAtIndex:indexPath.row];
    [SDStaticsManager umEvent:kdetail_recommend_item attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type}];
    [SDHomeDataManager recommedGoodToGoodDetail:goodModel];
}
@end
