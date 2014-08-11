//
//  TSAnimViewController.m
//  Test
//
//  Created by 卢大维 on 14-8-11.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSAnimViewController.h"
#import <FastAnimationWithPOP/FastAnimationWithPop.h>

@interface TSAnimViewController ()

@property (nonatomic,strong) IBOutlet UIView *contentView;

@end

@implementation TSAnimViewController

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
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.contentView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.contentView.hidden = NO;
    
    NSArray *animNames = @[@"BounceRight", @"BounceUp", @"BounceDown", @"BounceLeft"];
    for (UIView *sub in self.contentView.subviews) {
        
        int rand = arc4random_uniform(animNames.count);
        sub.animationType = animNames[rand];
//        sub.animationParams[@"velocity"] = @-3000;
        sub.delay = [self.contentView.subviews indexOfObject:sub] * 0.3 + 0.3;
        [sub startFAAnimation];
    }
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

-(IBAction)clickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
