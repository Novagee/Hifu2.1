//
//  YXMeAvatarSettingViewController.m
//  HiFu
//
//  Created by Yin Xu on 7/2/14.
//  Copyright (c) 2014 HiFuInc. All rights reserved.
//

#import "YXMeAvatarSettingViewController.h"
#import "YXAvatarCollectionCell.h"

@interface YXMeAvatarSettingViewController ()

@end

@implementation YXMeAvatarSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];
    [self.collectionView registerNib:[YXAvatarCollectionCell cellNib] forCellWithReuseIdentifier:[YXAvatarCollectionCell reuseIdentifier]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXAvatarCollectionCell *cell = (YXAvatarCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[YXAvatarCollectionCell reuseIdentifier] forIndexPath:indexPath];
    cell.avatarImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    cell.avatarImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userAvatarSelected" object:@(indexPath.row + 1)];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
