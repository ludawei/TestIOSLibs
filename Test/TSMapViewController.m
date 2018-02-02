//
//  TSMapViewController.m
//  Test
//
//  Created by 卢大维 on 15/3/20.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "TSMapViewController.h"
#import <MapKit/MapKit.h>

@interface TSMapViewController ()<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;

@end

@implementation TSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
