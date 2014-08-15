//
//  TSCollViewController.m
//  Test
//
//  Created by 卢大维 on 14-8-7.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSCollViewController.h"
#import "TSCollectionViewLayout.h"

@interface TSCollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;

@end

@implementation TSCollViewController

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
    // Do any additional setup after loading the view.
    
    self.collectionView.collectionViewLayout = [[TSCollectionViewLayout alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 400;
}

static NSString *CellIdentifier = @"cellIdentifier";
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    otherCell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:arc4random_uniform(101)/100.0];
   
    if (otherCell.subviews) {
        [otherCell.subviews.lastObject removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:otherCell.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.clipsToBounds = YES;
    label.text = [NSString stringWithFormat:@"%d", indexPath.row];
    [otherCell addSubview:label];
    
    otherCell.layer.cornerRadius = 5;
    
    return otherCell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize textSize = [[NSString stringWithFormat:@"%d", indexPath.row] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13] }];
//    CGFloat width = MAX(10+arc4random_uniform(101), textSize.width);
//    CGFloat height = MAX(10+arc4random_uniform(101), textSize.height);
//    return CGSizeMake(width, height);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 20, 0);
}
@end
