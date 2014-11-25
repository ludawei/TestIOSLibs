//
//  TSViewController.m
//  Test
//
//  Created by 卢大维 on 14-7-31.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSViewController.h"
#import "BFPaperCheckbox.h"
#import "UIColor+BFPaperColors.h"
#import "TSView.h"
#import "AFViewShaker.h"
#import "TSDrawView.h"

@interface TSViewController ()<BFPaperCheckboxDelegate>

@property (nonatomic,strong) AFViewShaker * viewShaker;
@property (nonatomic,weak) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) UIImageView *changeImgView;
@property (nonatomic) int oldRand;

@end

@implementation TSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSArray *arry=[NSArray arrayWithObject:@"sss"];
//    NSLog(@"%@",[arry objectAtIndex:1]);
    
//    BFPaperCheckbox *paperCheckbox2 = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(100, 100, 25 * 2, 25 * 2)];
//    paperCheckbox2.delegate = self;
//    paperCheckbox2.rippleFromTapLocation = NO;
//    paperCheckbox2.tapCirclePositiveColor = [UIColor clearColor]; // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
//    paperCheckbox2.tapCircleNegativeColor = [UIColor clearColor];   // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
//    paperCheckbox2.checkmarkColor = [UIColor paperColorLightBlue];
//    [self.view addSubview:paperCheckbox2];
//
    TSView *tv = [TSView loadFromXib];
//    tv.backgroundColor = [UIColor grayColor];
    [self.view addSubview:tv];
    
    TSDrawView *dView     = [[TSDrawView alloc] init];
    dView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:dView];
    
    if ([tv respondsToSelector:@selector(addConstraint:)]) {

        
        tv.translatesAutoresizingMaskIntoConstraints = NO;
        dView.translatesAutoresizingMaskIntoConstraints = NO;
#if 0
        //首先，先对其按钮的左边和self.view左边的距离
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint
                                          constraintWithItem:tv
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeLeading
                                          multiplier:1.0f
                                          constant:0.f];
        [self.view addConstraint:constraint];
        
        //然后，先对其按钮的右边和self.view右边的距离
        constraint = [NSLayoutConstraint
                      constraintWithItem:tv
                      attribute:NSLayoutAttributeTrailing
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.view
                      attribute:NSLayoutAttributeTrailing
                      multiplier:1.0f
                      constant:0.f];
        [self.view addConstraint:constraint];
        
        //然后，先对其按钮的上边和self.view上边的距离
        
        constraint = [NSLayoutConstraint
                      constraintWithItem:tv
                      attribute:NSLayoutAttributeTop
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.view
                      attribute:NSLayoutAttributeTop
                      multiplier:1.0f
                      constant:200.f];
        [self.view addConstraint:constraint];
        
        //最后，先对其按钮的下边和self.view下边的距离
        constraint = [NSLayoutConstraint
                      constraintWithItem:tv
                      attribute:NSLayoutAttributeHeight
                      relatedBy:NSLayoutRelationEqual
                      toItem: nil
                      attribute:NSLayoutAttributeNotAnAttribute
                      multiplier:1.0f
                      constant:tv.bounds.size.height];
        
        [self.view addConstraint:constraint];
#else
        NSMutableArray * tempConstraints = [NSMutableArray array];
        
        [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tv]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tv)]];
        [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[tv(>=200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tv)]];
        
        [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[dView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dView)]];
        [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-340-[dView(>=120)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dView)]];
        
        [self.view addConstraints:tempConstraints];
#endif
    }
    
    self.viewShaker = [[AFViewShaker alloc] initWithView:self.view];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.changeImgView = [[UIImageView alloc] initWithFrame:self.imgView.frame];
    [self.view addSubview:self.changeImgView];
    self.changeImgView.image = self.changeImgView.image;
    
    [self changeImage];
    
    [self startAnim];
    
//    UIImage *img;
//    [img re]
}

-(void)changeImage
{
    int rand = arc4random_uniform(8) + 1;
    int count = 0;
    while (rand == self.oldRand || count <= 100) {
        rand = arc4random_uniform(8) + 1;
        count++;
    }
    self.oldRand = rand;
    self.imgView.image = self.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"local%d", rand]];
    self.changeImgView.alpha = 1.0f;
    self.imgView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.changeImgView.alpha = 0;
        self.imgView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self changeImage];
        }
    }];
    
    
}

-(void)startAnim{
    UIBezierPath *path1=[UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(10, 70)];
    [path1 addCurveToPoint:CGPointMake(20, 100) controlPoint1:CGPointMake(60, 100) controlPoint2:CGPointMake(200, 150)];
//    [path1 addLineToPoint:CGPointMake(0, size.height)];
    
//    [path1 closePath];
    CAShapeLayer *lineLayer=[CAShapeLayer layer];
    lineLayer.path=path1.CGPath;//46,169,230
    lineLayer.fillColor=[UIColor clearColor].CGColor;
    lineLayer.strokeColor=[UIColor orangeColor].CGColor;
    lineLayer.lineWidth = 3;
    lineLayer.masksToBounds = YES;
    lineLayer.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.layer addSublayer:lineLayer];

    [self drawLineAnimation:lineLayer];
}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    //    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    bas.duration=2;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclcko {
    //  [alert show];
#if 0
    [self.viewShaker shakeWithDuration:0.6 completion:^{
        NSLog(@"!");
    }];
#else
    [self.viewShaker shake];
#endif
//    NSArray *arry=[NSArray arrayWithObject:@"sss"];
//    NSLog(@"%@",[arry objectAtIndex:1]);
}

#pragma mark - BFPaperCheckbox Delegate
//- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
//{
//    
//}

@end
