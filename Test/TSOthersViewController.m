//
//  TSOthersViewController.m
//  Test
//
//  Created by 卢大维 on 15/3/20.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "TSOthersViewController.h"

@interface TSOthersViewController ()

@property (nonatomic,strong) NSArray *datas;

@end

@implementation TSOthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"others";
    
    self.datas = @[@"TSSunAnimViewController", @"TSMapViewController"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *identify = @"cell_other";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = self.datas[indexPath.item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *class = self.datas[indexPath.item];
    UIViewController *next = [[NSClassFromString(class) alloc] init];
    next.title = class;
    [self.navigationController pushViewController:next animated:YES];
}

@end
