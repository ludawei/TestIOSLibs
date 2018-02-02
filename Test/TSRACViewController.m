//
//  TSRACViewController.m
//  Test
//
//  Created by 卢大维 on 15/3/5.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "TSRACViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TSRACViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSArray *datas;

@end

@implementation TSRACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];

#if 1
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 35)];
    textField.placeholder = @"this is a test textField";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.text = [NSString stringWithFormat:@"%C", 0xe415];
    [self.view addSubview:textField];
    self.textField = textField;
    
//    [RACObserve(self, textField.text) subscribeNext:^(NSString *newName) {
//        NSLog(@"%@", newName);
//    }];
    [[textField rac_textSignal] subscribeNext:^(NSString *newName) {
        NSLog(@"%@", newName);
    }];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 140, 100, 35)];
    [button setTitle:@"click" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        NSLog(@"%@", x);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Alert" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
            if ([indexNumber intValue] == 1) {
                NSLog(@"you touched NO");
            } else {
                NSLog(@"you touched YES");
            }
        }];
        [alertView show];
    }];
#else
    self.datas = [UIFont familyNames];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
#endif
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    NSString *fontName = self.datas[indexPath.item];
    
    cell.textLabel.font = [UIFont fontWithName:fontName size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:fontName size:16];
    cell.textLabel.text = @"中国气象";
    cell.detailTextLabel.text = fontName;
    return cell;
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

@end
