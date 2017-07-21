//
//  ELCVFlowLayout.m
//  ElCVFlowLayout
//
//  Created by Parkin on 2017/6/27.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELCVFlowLayout.h"

@interface ELCVFlowLayout ()

@property (nonatomic, copy) NSMutableDictionary *sectionDic;
@property (strong, nonatomic) NSMutableArray *allAttributes;

@end

@implementation ELCVFlowLayout


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}


- (void)prepareLayout
{
    [super prepareLayout];
    
    _sectionDic = [NSMutableDictionary dictionary];
    self.allAttributes = [NSMutableArray array];
    //获取section的数量
    NSUInteger section = [self.collectionView numberOfSections];
    
    for (int sec = 0; sec < section; sec++) {
        //获取每个section的cell个数
        NSUInteger count = [self.collectionView numberOfItemsInSection:sec];
        
        for (NSUInteger item = 0; item<count; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:sec];
            //重新排列
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.allAttributes addObject:attributes];

        }
    }

}

- (CGSize)collectionViewContentSize
{

    //每个section的页码的总数
    NSInteger actualLo = 0;
    for (NSString *key in [_sectionDic allKeys]) {
        actualLo += [_sectionDic[key] integerValue];
    }
    
    
    return CGSizeMake(actualLo*self.collectionView.frame.size.width, self.collectionView.contentSize.height);
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    
    if(attributes.representedElementKind != nil)
    {
        return;
    }
    
    /*修改by lixinkai 2017.6.30
    下面这两个方法 itemW、itemH
     解决了同一个UICollectionView使用不同UICollectionViewCell的问题
     */
    //attributes 的宽度
    CGFloat itemW = attributes.frame.size.width;
    //attributes 的高度
    CGFloat itemH = attributes.frame.size.height;
    
    //collectionView 的宽度
    CGFloat width = self.collectionView.frame.size.width;
    //collectionView 的高度
    CGFloat height = self.collectionView.frame.size.height;
    //每个attributes的下标值 从0开始
    NSInteger itemIndex = attributes.indexPath.item;
    
    CGFloat stride = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? width : height;
    
    
    //获取现在的attributes是第几组
    NSInteger section = attributes.indexPath.section;
    //获取每个section的item的个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];

    
    CGFloat offset = section * stride;
    
    //计算x方向item个数
    NSInteger xCount = (width / itemW);
    //计算y方向item个数
    NSInteger yCount = (height / itemH);
    //计算一页总个数
    NSInteger allCount = (xCount * yCount);
    //获取每个section的页数，从0开始
    NSInteger page = itemIndex / allCount;
    
    //余数，用来计算item的x的偏移量
    NSInteger remain = (itemIndex % xCount);
    
    //取商，用来计算item的y的偏移量
    NSInteger merchant = (itemIndex-page*allCount)/xCount;


    //x方向每个item的偏移量
    CGFloat xCellOffset = remain * itemW;
    //y方向每个item的偏移量
    CGFloat yCellOffset = merchant * itemH;
    
    //获取每个section中item占了几页
    NSInteger pageRe = (itemCount % allCount == 0)? (itemCount / allCount) : (itemCount / allCount) + 1;
    //将每个section与pageRe对应，计算下面的位置
    [_sectionDic setValue:@(pageRe) forKey:[NSString stringWithFormat:@"%ld", section]];
    
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        NSInteger actualLo = 0;
        //将每个section中的页数相加
        for (NSString *key in [_sectionDic allKeys]) {
            actualLo += [_sectionDic[key] integerValue];
        }
        //获取到的最后的数减去最后一组的页码数
        actualLo -= [_sectionDic[[NSString stringWithFormat:@"%ld", [_sectionDic allKeys].count-1]] integerValue];
        xCellOffset += page*width + actualLo*width;

    } else {
        
        yCellOffset += offset;
    }
   
    attributes.frame = CGRectMake(xCellOffset, yCellOffset, itemW, itemH);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes  layoutAttributesForCellWithIndexPath:indexPath];
   UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    
    [self applyLayoutAttributes:attr];
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.allAttributes;
}

@end
