//
//  PlayVideoView.h
//  AVPlayerVideoDemo
//
//  Created by zouchao on 2019/7/22.
//  Copyright © 2019 zouchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayVideoView : UIView

/**播放链接*/
@property (nonatomic ,copy) NSString *url;

+ (instancetype)playVideoViewWithUrl:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
