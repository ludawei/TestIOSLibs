//
//  TSPythonViewController.m
//  Test
//
//  Created by 卢大维 on 14-9-12.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSPythonViewController.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TSPythonViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView1,*scrollView2;
}
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation TSPythonViewController

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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://127.0.0.1:8000/test_json" parameters:@{@"question" : @"1"} progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        self.contentLbl.text = [responseObject objectForKey:@"answer"];
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:8000/%@", [responseObject objectForKey:@"image"]]]];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 200, 100, 300)];
    scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(130, 200, 100, 300)];
    
    scrollView1.backgroundColor = [UIColor blueColor];
    scrollView2.backgroundColor = [UIColor orangeColor];
    scrollView2.contentSize = scrollView1.contentSize = CGSizeMake(100, 1000);
    scrollView1.delegate = self;

    [self.view addSubview:scrollView1];
    [self.view addSubview:scrollView2];
    
    for (int i=0; i<50; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, i*20, 100, 20)];
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"Test text %d", i+1];
        [scrollView1 addSubview:lbl];
    }
    
    for (int i=0; i<50; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, i*20, 100, 20)];
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"Test text %d", i+1];
        [scrollView2 addSubview:lbl];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView2.contentOffset = scrollView.contentOffset;
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

@end
