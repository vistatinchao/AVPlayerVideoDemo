//
//  ViewController.m
//  AVPlayerVideoDemo
//
//  Created by zouchao on 2019/7/22.
//  Copyright © 2019 zouchao. All rights reserved.
//

#import "ViewController.h"

#import "FullViewController.h"
#import "playVideoView.h"

@interface ViewController ()<PlayVideoViewDelegate>

/**fullVc*/
@property (nonatomic,strong) FullViewController *fullVc;

/**playView*/
@property (nonatomic,weak) UIView *playView;

@end

@implementation ViewController

- (void)viewDidLoad {
    /**
     https://oss-test.hezhiiot.com/hezhi/dc2b2916-9a60-4b7b-bb40-03e7d4371a9e.mp4
     http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
     */
    [super viewDidLoad];//
    PlayVideoView *videoView = [[PlayVideoView alloc]init];
    [self.view addSubview:videoView];
    CGFloat videoViewW = self.view.bounds.size.width;
    videoView.frame = CGRectMake(0, 0, videoViewW, videoViewW*9/16);
    videoView.url = @"https://oss-test.hezhiiot.com/hezhi/dc2b2916-9a60-4b7b-bb40-03e7d4371a9e.mp4";
    videoView.delegate = self;
    self.playView = videoView;
    // Do any additional setup after loading the view.
}

- (void)playVideoViewExitFullScreen:(PlayVideoView *)playVideoView {
    [self.fullVc dismissViewControllerAnimated:YES completion:^{
        self.playView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view addSubview:self.playView];
    }];
}

- (void)playVideoViewShowFullScreen:(PlayVideoView *)playVideoView {
    [self presentViewController:self.fullVc animated:YES completion:^{
        self.playView.frame = self.fullVc.view.bounds;
        [self.fullVc.view addSubview:self.playView];
    }];
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        self.fullVc = [[FullViewController alloc] init];
    }
    
    return _fullVc;
}

@end
