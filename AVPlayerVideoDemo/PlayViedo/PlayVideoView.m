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

/**背景*/
@property (nonatomic,weak) UIImageView *coverImg;
/**底部View*/
@property (nonatomic,weak) UIView *bottomView;
/**播放按钮*/
@property (nonatomic,weak) UIButton *playBtn;
/**滑动View*/
@property (nonatomic,weak) UISlider *sliderView;
/**播放时间*/
@property (nonatomic,weak) UILabel *timeLab;
/**全屏按钮*/
@property (nonatomic,weak) UIButton *fullBtn;

/**定时器*/
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation PlayVideoView

#pragma mark - 初始化
+ (instancetype)playVideoViewWithUrl:(NSString *)url {
    PlayVideoView *videoView = [[self alloc]init];
    videoView.url = url;
    return videoView;
}

- (instancetype)init {
    if (self = [super init]) {
        
        [self setPlayVideoSubview];
        [self setPlayUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - 监听播放状态的改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
   
    if ([keyPath isEqualToString:@"status"]) {
        NSLog(@"dict:%@ status:%zd",change,self.playItem.status);
    }
}
/**
 播放完成
 */
- (void)moviePlayDidEnd:(NSNotification *)noti {
    self.playBtn.selected = NO;
    [self stopTimer];
    self.sliderView.value = 0.0;
    self.timeLab.text = @"00:00/00.00";
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - 定时器
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)updateProgressInfo {
    // 总时长
    NSTimeInterval totalTime  = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    [self setPlayTimeWithTotalTime:totalTime currentTime:currentTime];
    self.sliderView.value = currentTime/totalTime;
   
}

#pragma mark - 更新播放时间
- (void)setPlayTimeWithTotalTime:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime {
    int totalMin = totalTime/60;
    int totalSec = (int)totalTime % 60;
    int currentMin = currentTime/60;
    int currentSec = (int)currentTime % 60;
    NSString *timeText = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",currentMin,currentSec,totalMin,totalSec];
    self.timeLab.text = timeText;
}

#pragma mark - 设置UI
- (void)setPlayVideoSubview {
    // 背景
    UIImageView *coverView = [[UIImageView alloc]init];
    [self addSubview:coverView];
    coverView.image = [UIImage imageNamed:@"bg_media_default"];
    coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverImgClick)];
    [coverView addGestureRecognizer:tap];
    self.coverImg = coverView;
    
    // 底部播放View
    UIView *bottomView = [[UIView alloc]init];
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor blackColor];
    self.bottomView = bottomView;
    
    //播放按钮
    UIButton *playBtn = [[UIButton alloc]init];
    [bottomView addSubview:playBtn];
    [playBtn setImage:[UIImage imageNamed:@"full_play_btn_hl"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"full_pause_btn_hl"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn = playBtn;
    
    //进度条
    UISlider *slider = [[UISlider alloc]init];
    [bottomView addSubview:slider];
    [slider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    slider.value = 0;
    self.sliderView = slider;
    
    // 播放时间
    UILabel *timeLab = [[UILabel alloc]init];
    [bottomView addSubview:timeLab];
    timeLab.textColor = [UIColor whiteColor];
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.text = @"00:00/00.00";
    timeLab.textAlignment = NSTextAlignmentRight;
    self.timeLab = timeLab;
    
    // 全屏按钮
    UIButton *fullBtn = [[UIButton alloc]init];
    [bottomView addSubview:fullBtn];
    [fullBtn setImage:[UIImage imageNamed:@"full_minimize_btn_hl"] forState:UIControlStateNormal];
    [fullBtn setImage:[UIImage imageNamed:@"mini_launchFullScreen_btn_hl"] forState:UIControlStateSelected];
    [fullBtn addTarget:self action:@selector(fullBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.fullBtn = fullBtn;
    
}

#pragma mark - 设置播放player
- (void)setPlayUI {
    AVPlayer *player = [[AVPlayer alloc]init];
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.coverImg.layer addSublayer:playLayer];
    self.playLayer = playLayer;
    self.player = player;
    // 开始播放
//    [self.player play];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    NSURL *playUrl = [NSURL URLWithString:url];
    self.playItem = [AVPlayerItem playerItemWithURL:playUrl];
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
}



#pragma mark - 监听点击事件
- (void)sliderValueChange:(UISlider *)slider {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * slider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    [self setPlayTimeWithTotalTime:duration currentTime:currentTime];
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)playBtnClick:(UIButton *)playBtn {
    playBtn.selected = !playBtn.selected;
    if (playBtn.selected) {
         [self.player play];
        [self timer];
        
    }else{
        [self.player pause];
        [self stopTimer];
    }
   
}

-  (void)fullBtnClick:(UIButton *)fullBtn {
    fullBtn.selected = !fullBtn.selected;
    if (fullBtn.selected) { // 全屏
        if ([self.delegate respondsToSelector:@selector(playVideoViewShowFullScreen:)]) {
            [self.delegate playVideoViewShowFullScreen:self];
        }
    }else{ // 退出全屏
        if ([self.delegate respondsToSelector:@selector(playVideoViewExitFullScreen:)]) {
            [self.delegate playVideoViewExitFullScreen:self];
        }
    }
}

- (void)coverImgClick {
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.hidden = !self.bottomView.hidden;
    }];
}



#pragma mark - UI布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playLayer.frame = self.bounds;
    self.coverImg.frame = self.bounds;
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(50));
    }];
    
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bottomView);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.fullBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.bottomView);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullBtn.left).offset(-10);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    
    
    [self.sliderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.right).offset(10);
        make.right.equalTo(self.timeLab.left).mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}
@end
