//
//  TSFaceDetectorViewController.m
//  Test
//
//  Created by 卢大维 on 14/12/19.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSFaceDetectorViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TSFaceDetectorViewController ()
{
    AVAssetReader *_movieReader;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic) int buttonCount;

@end

@implementation TSFaceDetectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.buttonCount = 0;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize buttonSize = CGSizeMake(96, 128);
    
    self.scrollView.frame = self.view.bounds;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = (UIButton *)obj;
        button.frame = CGRectMake((buttonSize.width+10)*idx, 60, buttonSize.width, buttonSize.height);
    }];
    [self.scrollView setContentSize:CGSizeMake(CGRectGetMaxX([self.scrollView.subviews.lastObject frame]), 0)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    [self generateImage];
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

-(void)generateImage
{
    CGSize buttonSize = CGSizeMake(96, 128);
    
    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    CGFloat totalTime = CMTimeGetSeconds(asset.duration);
    NSInteger fps = clipVideoTrack.naturalTimeScale;//asset.duration.timescale;
    fps = MIN(fps, 3);
    
    NSMutableArray *times = [NSMutableArray array];
    for (int i=0; i<totalTime; i++) {
        for (int j=0; j<fps; j++) {
            [times addObject:[NSValue valueWithCMTime:CMTimeMake(j+i*fps, (int)fps)]];
        }
    }
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
//        [button setImage:[UIImage imageWithCGImage:im] forState:UIControlStateNormal];
//        thumbImg=[[UIImage imageWithCGImage:im] retain];
//        [generator release];
        UIImage *img = [UIImage imageWithCGImage:im];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((buttonSize.width+10)*self.buttonCount, 60, buttonSize.width, buttonSize.height)];
            [button setImage:img forState:UIControlStateNormal];
            button.backgroundColor = [UIColor grayColor];
            button.alpha = 1;
            [self.scrollView addSubview:button];
            
            self.buttonCount++;
            
            [self.scrollView setContentSize:CGSizeMake(CGRectGetMaxX(button.frame), 0)];
        });
        
    };
    
    CGSize maxSize = CGSizeMake(640, 480);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
}
@end
