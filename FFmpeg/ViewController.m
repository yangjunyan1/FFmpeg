//
//  ViewController.m
//  FFmpeg
//
//  Created by funsun on 2019/2/18.
//  Copyright © 2019年 FFmpeg. All rights reserved.
//

#import "ViewController.h"
#import "XYQMovieObject.h"
#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

@interface ViewController ()
@property (retain, nonatomic) UIImageView *ImageView;
@property (retain, nonatomic) UILabel *fps;
@property (retain, nonatomic) UIButton *playBtn;
@property (retain, nonatomic) UIButton *TimerBtn;
@property (retain, nonatomic) UILabel *TimerLabel;
@property (nonatomic, strong) XYQMovieObject *video;
@property (nonatomic, assign) float lastFrameTime;
@end

@implementation ViewController

@synthesize ImageView, fps, playBtn, video;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ImageView = ({
        UIImageView *b = [UIImageView new];
        b.frame = CGRectMake(0, 100, 100, 100);
        b.backgroundColor = [UIColor blueColor];
        [self.view addSubview:b];
        b;
    });
    
    self.fps = ({
        UILabel *b = [UILabel new];
        b.frame = CGRectMake(110, 100, 100, 100);
        b.backgroundColor = [UIColor blackColor];
        b.textColor = [UIColor whiteColor];
        [self.view addSubview:b];
        b;
    });
    
    self.playBtn = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        b.frame = CGRectMake(0, 210, 100, 100);
        [b setTitle:@"play" forState:UIControlStateNormal];
        [b addTarget:self action:@selector(PlayClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
        b;
    });
    
    self.TimerBtn = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setTitle:@"TimerBtn" forState:UIControlStateNormal];
        [b addTarget:self action:@selector(TimerCilick:) forControlEvents:UIControlEventTouchUpInside];
        b.frame = CGRectMake(110, 210, 100, 100);
        [self.view addSubview:b];
        b;
    });
    
    self.TimerLabel = ({
        UILabel *b = [UILabel new];
        b.backgroundColor = [UIColor blackColor];
        b.textColor = [UIColor whiteColor];
        b.frame = CGRectMake(220, 100, 100, 100);
        [self.view addSubview:b];
        b;
    });
    
    //播放网络视频
//    self.video = [[XYQMovieObject alloc] initWithVideo:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
    self.video = [[XYQMovieObject alloc] initWithVideo:@"http://mvvideo11.meitudata.com/5ba0666f5e38a9611.mp4"];
    
    
    //播放本地视频
    //  self.video = [[XYQMovieObject alloc] initWithVideo:[NSString bundlePath:@"Dalshabet.mp4"]];
    //  self.video = [[XYQMoiveObject alloc] initWithVideo:@"/Users/king/Desktop/Stellar.mp4"];
    //  self.video = [[XYQMoiveObject alloc] initWithVideo:@"/Users/king/Downloads/Worth it - Fifth Harmony ft.Kid Ink - May J Lee Choreography.mp4"];
    //  self.video = [[XYQMoiveObject alloc] initWithVideo:@"/Users/king/Downloads/4K.mp4"];
    
    //播放直播
//      self.video = [[XYQMovieObject alloc] initWithVideo:@"http://www.huya.com/189ad06f-d1d1-4fb6-ac5d-76b0e47b426e"];
    
    
    //设置video
    //  video.outputWidth = 800;
    //  video.outputHeight = 600;
    //  self.audio = [[XYQMovieObject alloc] initWithVideo:@"/Users/king/Desktop/Stellar.mp4"];
    //  NSLog(@"视频总时长>>>video duration: %f",video.duration);
    //  NSLog(@"源尺寸>>>video size: %d x %d", video.sourceWidth, video.sourceHeight);
    //  NSLog(@"输出尺寸>>>video size: %d x %d", video.outputWidth, video.outputHeight);
    //
    //  [self.audio seekTime:0.0];
    //  SJLog(@"%f", [self.audio duration])
    //  AVPacket *packet = [self.audio readPacket];
    //  SJLog(@"%ld", [self.audio decode])
    int tns, thh, tmm, tss;
    tns = video.duration;
    thh = tns / 3600;
    tmm = (tns % 3600) / 60;
    tss = tns % 60;
    
    
    //    NSLog(@"fps --> %.2f", video.fps);
    ////        [ImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
    //    NSLog(@"%02d:%02d:%02d",thh,tmm,tss);
}

- (void)PlayClick:(UIButton *)sender {
    
    [playBtn setEnabled:NO];
    _lastFrameTime = -1;
    
    // seek to 0.0 seconds
    [video seekTime:0.0];
    
    
    [NSTimer scheduledTimerWithTimeInterval: 1 / video.fps
                                     target:self
                                   selector:@selector(displayNextFrame:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)TimerCilick:(id)sender {
    
    //    NSLog(@"current time: %f s",video.currentTime);
    //    [video seekTime:150.0];
    //    [video replaceTheResources:@"/Users/king/Desktop/Stellar.mp4"];
    if (playBtn.enabled) {
        [video redialPaly];
        [self PlayClick:playBtn];
    }
    
}

-(void)displayNextFrame:(NSTimer *)timer {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    //    self.TimerLabel.text = [NSString stringWithFormat:@"%f s",video.currentTime];
    self.TimerLabel.text  = [self dealTime:video.currentTime];
    if (![video stepFrame]) {
        [timer invalidate];
        [playBtn setEnabled:YES];
        return;
    }
    ImageView.image = video.currentImage;
    float frameTime = 1.0 / ([NSDate timeIntervalSinceReferenceDate] - startTime);
    if (_lastFrameTime < 0) {
        _lastFrameTime = frameTime;
    } else {
        _lastFrameTime = LERP(frameTime, _lastFrameTime, 0.8);
    }
    [fps setText:[NSString stringWithFormat:@"fps %.0f",_lastFrameTime]];
}

- (NSString *)dealTime:(double)time {
    
    int tns, thh, tmm, tss;
    tns = time;
    thh = tns / 3600;
    tmm = (tns % 3600) / 60;
    tss = tns % 60;
    
    
    //        [ImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
    return [NSString stringWithFormat:@"%02d:%02d:%02d",thh,tmm,tss];
}

@end
