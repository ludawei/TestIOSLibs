//
//  TSVideoEditerController.m
//  Test
//
//  Created by 卢大维 on 14-11-17.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "TSVideoEditerController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TSVideoEditerController ()

@property AVPlayer *player;
@property AVPlayerLayer *playerLayer;

@end

@implementation TSVideoEditerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoURL]]; //
    
    self.playerLayer = [AVPlayerLayer layer];
    
    [self.playerLayer setPlayer:self.player];
    [self.playerLayer setFrame:CGRectMake(10, 120, 300, 200)];
    [self.playerLayer setBackgroundColor:[UIColor redColor].CGColor];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.view.layer addSublayer:self.playerLayer];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"local1"]];
    imgView.center = CGPointMake(self.view.bounds.size.width/2, CGRectGetMaxY(self.playerLayer.frame)+40);
    [self.view addSubview:imgView];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"local1"]];
    imgView2.center = CGPointMake(self.view.bounds.size.width/2, CGRectGetMaxY(self.playerLayer.frame)+100);
    [self.view addSubview:imgView2];
    
    CABasicAnimation *shark = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shark.fromValue = [NSNumber numberWithFloat:0];
    shark.toValue = [NSNumber numberWithFloat:2*M_PI];
    shark.duration = 1.0;
    shark.autoreverses = NO;
    shark.repeatCount = INT_MAX;
    [imgView.layer addAnimation:shark forKey:@"shakeAnimation"];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration=2.0;
    animation.repeatCount=INT_MAX;
    animation.autoreverses=YES;
    // rotate from 0 to 360
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
    [imgView2.layer addAnimation:animation forKey:@"shakeAnimation1"];
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

-(IBAction)clickPlay:(id)sender
{
    [self.player play];
}

-(IBAction)clickButton:(id)sender
{
    [self test1];
}

// 添加水印
-(void)test
{
    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    // 视频
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo  preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:clipVideoTrack
                                    atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    // 声音
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipAudioTrack = [videoAsset tracksWithMediaType:AVMediaTypeAudio][0];
    
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:clipAudioTrack
                                    atTime:kCMTimeZero error:nil];
    
    
    // 额外的声音
    NSString *audioURL = [[NSBundle mainBundle] pathForResource:@"Music" ofType:@"m4a"];
    AVAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:audioURL] options:nil];
    AVAssetTrack *newAudioTrack = [audioAsset tracksWithMediaType:AVMediaTypeAudio][0];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(10.0f, 30), videoAsset.duration)
                                        ofTrack:newAudioTrack
                                         atTime:kCMTimeZero error:nil];
    AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionCommentaryTrack];
    [mixParameters setVolumeRampFromStartVolume:1 toEndVolume:0 timeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)];
    
    
    CGSize videoSize = [videoAsset naturalSize];
    
    UIImage *myImage = [UIImage imageNamed:@"local3"];
    CALayer *aLayer = [CALayer layer];
    aLayer.contents = (id)myImage.CGImage;
    aLayer.frame = CGRectMake((videoSize.width-myImage.size.width)/2, videoSize.height-myImage.size.height, myImage.size.width, myImage.size.height); //Needed for proper display. We are using the app icon (57x57). If you use 0,0 you will not see it
    //    aLayer.opacity = 0.65; //Feel free to alter the alpha here
#if 1
    CABasicAnimation *shark = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shark.fromValue = [NSNumber numberWithFloat:0];
    shark.toValue = [NSNumber numberWithFloat:2*M_PI];
    shark.duration = 1.0;
    shark.autoreverses = NO;
    shark.repeatCount = INT_MAX;
    shark.beginTime = AVCoreAnimationBeginTimeAtZero;               // 这句很重要，不加会导致动画不执行
    [aLayer addAnimation:shark forKey:@"shakeAnimation"];
#else
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration=2.0;
    animation.repeatCount=5;
    animation.autoreverses=YES;
    // rotate from 0 to 360
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
    [aLayer addAnimation:animation forKey:@"shakeAnimation"];
#endif
    
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = @"my test";
    titleLayer.font = (__bridge CFTypeRef)(@"Helvetica");
    titleLayer.fontSize = videoSize.height / 6;
    //?? titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.frame = CGRectMake(0, videoSize.height-57-videoSize.height / 6, videoSize.width, videoSize.height / 6); //You may need to adjust this for proper display
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:aLayer];
    [parentLayer addSublayer:titleLayer]; //ONLY IF WE ADDED TEXT
    
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
    videoComp.frameDuration = CMTimeMake(1, 30);
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    /// instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComp.instructions = [NSArray arrayWithObject: instruction];
    
    AVAssetExportSession *_assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];//AVAssetExportPresetPassthrough
    _assetExport.videoComposition = videoComp;
    
    NSString* videoName = [NSString stringWithFormat:@"mynewwatermarkedvideo-%d.mov", arc4random()%1000];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:videoName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputURL])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputURL error:nil];
    }
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = [NSURL fileURLWithPath:outputURL];
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    //    [strRecordedFilename setString: exportPath];
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         //         [_assetExport release];
         //YOUR FINALIZATION CODE HERE
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         
         [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:outputURL] completionBlock:^(NSURL *assetURL, NSError *error){
             if (error) {
                 NSLog(@"Video could not be saved");
             }
             else
             {
                 NSLog(@"save OK!");
             }
         }];
     }
     ];
    
    //    [audioAsset release];
    //    [videoAsset release];
}

// 合成两个视频
-(void)test1
{
    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    // 视频
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo  preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:clipVideoTrack
                                    atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    // 声音
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipAudioTrack = [videoAsset tracksWithMediaType:AVMediaTypeAudio][0];
    
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:clipAudioTrack
                                    atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo  preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                         ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                          atTime:kCMTimeZero error:nil];
    
    [secondTrack setPreferredTransform:CGAffineTransformMakeScale(0.25f,0.25f)];
    
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = [videoAsset naturalSize];
    videoComp.frameDuration = CMTimeMake(1, 30);
//    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    /// instruction
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    //We will be creating 2 AVMutableVideoCompositionLayerInstruction objects.Each for our 2 AVMutableCompositionTrack.here we are creating AVMutableVideoCompositionLayerInstruction for out first track.see how we make use of Affinetransform to move and scale our First Track.so it is displayed at the bottom of the screen in smaller size.(First track in the one that remains on top).
    AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    CGAffineTransform Scale = CGAffineTransformMakeScale(0.7f,0.7f);
    CGAffineTransform Move = CGAffineTransformMakeTranslation(230,230);
    [FirstlayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
    
    //Here we are creating AVMutableVideoCompositionLayerInstruction for out second track.see how we make use of Affinetransform to move and scale our second Track.
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
    CGAffineTransform SecondScale = CGAffineTransformMakeScale(1.2f,1.5f);
    CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
    [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondScale,SecondMove) atTime:kCMTimeZero];
    
    //Now we add our 2 created AVMutableVideoCompositionLayerInstruction objects to our AVMutableVideoCompositionInstruction in form of an array.
    MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];
    
    videoComp.instructions = [NSArray arrayWithObject: MainInstruction];
    
    AVAssetExportSession *_assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];//AVAssetExportPresetPassthrough
    _assetExport.videoComposition = videoComp;
    
    NSString* videoName = [NSString stringWithFormat:@"mynewwatermarkedvideo-%d.mov", arc4random()%1000];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:videoName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputURL])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputURL error:nil];
    }
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = [NSURL fileURLWithPath:outputURL];
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    //    [strRecordedFilename setString: exportPath];
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         //         [_assetExport release];
         //YOUR FINALIZATION CODE HERE
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         
         [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:outputURL] completionBlock:^(NSURL *assetURL, NSError *error){
             if (error) {
                 NSLog(@"Video could not be saved");
             }
             else
             {
                 NSLog(@"save OK!");
             }
         }];
     }
     ];
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image andSize:(CGSize) size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) CFBridgingRetain(options),
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (void) writeImages:(NSArray *)imagesArray ToMovieAtPath:(NSString *) path withSize:(CGSize) size
          inDuration:(float)duration byFPS:(int32_t)fps{
    //Wire the writer:
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoSettings];
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    [videoWriter addInput:videoWriterInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //Write some samples:
    CVPixelBufferRef buffer = NULL;
    
    int frameCount = 0;
    
    NSInteger imagesCount = [imagesArray count];
    float averageTime = duration/imagesCount;
    int averageFrame = (int)(averageTime * fps);
    
    for(UIImage * img in imagesArray)
    {
        buffer = [self pixelBufferFromCGImage:[img CGImage] andSize:size];
        
        BOOL append_ok = NO;
        int j = 0;
        while (!append_ok && j < 30)
        {
            if (adaptor.assetWriterInput.readyForMoreMediaData)
            {
                printf("appending %d attemp %d\n", frameCount, j);
                
                CMTime frameTime = CMTimeMake(frameCount,(int32_t) fps);
                float frameSeconds = CMTimeGetSeconds(frameTime);
                NSLog(@"frameCount:%d,kRecordingFPS:%d,frameSeconds:%f",frameCount,fps,frameSeconds);
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                
                if(buffer)
                    [NSThread sleepForTimeInterval:0.05];
            }
            else
            {
                printf("adaptor not ready %d, %d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok) {
            printf("error appending image %d times %d\n", frameCount, j);
        }
        
        frameCount = frameCount + averageFrame;
    }
    
    //Finish the session:
    [videoWriterInput markAsFinished];
    [videoWriter finishWritingWithCompletionHandler:^{
        
    }];
    NSLog(@"finishWriting");
}
@end
