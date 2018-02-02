//
//  TSSunAnimViewController.m
//  Test
//
//  Created by 卢大维 on 15/3/17.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "TSSunAnimViewController.h"
#import "TSNewSunAnimView.h"

@interface TSSunAnimViewController ()

@property (nonatomic,strong) UIView *circleView,*tsView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) NSInteger count;

@end

@implementation TSSunAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 300, 300)];
//    view.layer.cornerRadius = view.bounds.size.width/2;
//    view.layer.borderWidth = 0.5;
//    view.layer.borderColor = [UIColor grayColor].CGColor;
//    view.clipsToBounds = YES;
//    [self.view addSubview:view];
//    self.circleView = view;
    
//    UIView *tsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
//    tsView.backgroundColor = [UIColor orangeColor];
//    [view addSubview:tsView];
//    self.tsView = tsView;
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 450, 100, 40)];
//    [button setTitle:@"click" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
////    maximum_temperature
//    CGFloat x = 150 - sqrt(150*150 - 50*50);
//    
//    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maximum_temperature"]];
//    self.imageView.center = CGPointMake(20+x, 200);
////    self.imageView.layer.anchorPoint = CGPointMake(150, 150);
//    [self.view addSubview:self.imageView];
    
    
    TSNewSunAnimView *tsAnimView = [[TSNewSunAnimView alloc] initWithFrame:CGRectMake(20, 80, 200, 80)];
//    tsAnimView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tsAnimView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)click
{
//    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        if (self.tsView.bounds.size.width == 0) {
//            self.tsView.frame = CGRectMake(0, 0, 300, 100);
//            self.imageView.transform = CGAffineTransformMakeRotation(atan2(sqrt(150*150 - 50*50), 50)*2);
//        }
//        else
//        {
//            self.tsView.frame = CGRectMake(0, 0, 0, 100);
//            self.imageView.transform = CGAffineTransformIdentity;
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(timeDidFired) userInfo:nil repeats:YES];
}

-(void)timeDidFired
{
    if (self.count >= 180) {
        [self.timer invalidate];
        self.timer = nil;
        self.count = 0;
        return;
    }
    self.count++;
//    self.tsView.frame = CGRectMake(0, 0, 300/180.0*self.count, 100);
    self.imageView.transform = CGAffineTransformMakeRotation(atan2(sqrt(150*150 - 50*50), 50)*2/180.0*self.count);
    
}
@end
