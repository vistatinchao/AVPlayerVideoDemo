//
//  PlayVideoView.h
//  AVPlayerVideoDemo
//
//  Created by zouchao on 2019/7/22.
//  Copyright © 2019 zouchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayVideoView;
NS_ASSUME_NONNULL_BEGIN

@protocol PlayVideoViewDelegate <NSObject>

@optional;
- (void)playVideoViewShowFullScreen:(PlayVideoView *)playVideoView;
- (void)playVideoViewExitFullScreen:(PlayVideoView *)playVideoView;
@end

@interface PlayVideoView : UIView

/**播放链接*/
@property (nonatomic ,copy) NSString *url;

+ (instancetype)playVideoViewWithUrl:(NSString *)url;

/**delegate*/
@property (nonatomic,weak) id<PlayVideoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
