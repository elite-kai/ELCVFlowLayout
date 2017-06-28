//
//  ViewController.m
//  ElCVFlowLayout
//
//  Created by Parkin on 2017/6/27.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ViewController.h"
#import "ELCVFlowLayout.h"

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

//数据源数组
@property (nonatomic, strong) NSMutableArray* dateArray;

//日历视图
@property (nonatomic, strong) UICollectionView* collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dateArray = [@[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13] mutableCopy];
    //横向滚动
    ELCVFlowLayout *horizontalLayout = [[ELCVFlowLayout alloc] init];

    horizontalLayout.itemSize = CGSizeMake(kScreenWidth/3.0, kScreenWidth/4.0);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, kScreenWidth) collectionViewLayout:horizontalLayout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor blueColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 9;
    }
    else if (section == 1) {
        return 17;
    }
    else if (section == 2) {
        return 25;
    }
    return 1;
    
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    label.textColor = [UIColor blueColor];
    label.numberOfLines = 0;
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section %ld  row --- %ld",indexPath.section, indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
