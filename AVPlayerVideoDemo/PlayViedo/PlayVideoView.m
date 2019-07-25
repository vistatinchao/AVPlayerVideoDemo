//
//  PlayVideoView.m
//  AVPlayerVideoDemo
//
//  Created by zouchao on 2019/7/22.
//  Copyright © 2019 zouchao. All rights reserved.
//
#define MAS_SHORTHAND
#import "PlayVideoView.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoView()

/**playLayer*/
@property (nonatomic,strong) AVPlayerLayer *playLayer;
/**播放player*/
@property (nonatomic,strong) AVPlayer *player;
/**playItem*/
@property (nonatomic,strong) AVPlayerItem *playItem;
@end

@implementation PlayVideoView

+ (instancetype)playVideoViewWithUrl:(NSString *)url {
    PlayVideoView *videoView = [[self alloc]init];
    videoView.url = url;
    return videoView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setPlayUI];
        [self setPlayVideoSubview];
    }
    return self;
}

- (void)setPlayUI {
    NSURL *playUrl = [NSURL URLWithString:self.url];
//    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:playUrl];
//    self.playItem = playItem;

    AVPlayer *player = [AVPlayer playerWithURL:playUrl];
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.layer addSublayer:playLayer];

    self.playLayer = playLayer;
    self.player = player;
    // 开始播放
    [self.player play];
}

- (void)setPlayVideoSubview {
    UIView *coverView = [[UIView alloc]init];
    [self addSubview:coverView];
    
}

- (void)setUrl:(NSString *)url {
    _url = url;
}

- (void)layoutSubviews {
    [super layoutSubviews];
     self.playLayer.frame = self.bounds;
}
@end
