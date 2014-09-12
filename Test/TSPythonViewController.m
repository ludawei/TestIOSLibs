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

@interface TSPythonViewController ()

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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://127.0.0.1:8000/test_json" parameters:@{@"question" : @"1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        self.contentLbl.text = [responseObject objectForKey:@"answer"];
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:8000/%@", [responseObject objectForKey:@"image"]]]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
