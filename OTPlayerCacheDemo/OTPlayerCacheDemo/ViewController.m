//
//  ViewController.m
//  OTPlayerCacheDemo
//
//  Created by irobbin on 2018/1/14.
//  Copyright © 2018年 irobbin. All rights reserved.
//

#import "ViewController.h"
#import "OTPlayerCache.h"
@import AVFoundation;

@interface ViewController ()

@property (nonatomic, strong) NSURL * videoURL;
@property (nonatomic, strong) AVURLAsset * videoURLAsset;
@property (nonatomic, strong) AVPlayerItem * playerItem;
@property (nonatomic, strong) OTAssetLoaderDelegate *resourceLoader;
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup video URL
    self.videoURL = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
    // 本地文件
    if ([self.videoURL.absoluteString hasPrefix:@"file://"] ||
        [self.videoURL.absoluteString hasPrefix:@"assets-library://"]) {
        
        self.videoURLAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    }
    // 本地有缓存
    else if ([OTVideoCacheService savedVideoExistsWithURL:self.videoURL]) {
        NSURL * playPathURL = [NSURL fileURLWithPath:[OTVideoCacheService savedVideoPathWithURL:self.videoURL]];
        self.videoURLAsset = [AVURLAsset URLAssetWithURL:playPathURL options:nil];
    }
    // 网络资源
    else {
        NSURL *playUrl;
        OTAssetLoaderDelegate *resourceLoader = [OTAssetLoaderDelegate new];
        self.resourceLoader = resourceLoader;
        
        playUrl = [OTVideoDownloadModel getSchemeVideoURL:self.videoURL];
        
        self.videoURLAsset = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        
        [self.videoURLAsset.resourceLoader setDelegate:resourceLoader queue:dispatch_get_main_queue()];
    }
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    // layer
    self.playerLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * ( 3 / 4.0));
    self.playerLayer.position = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer insertSublayer:_playerLayer atIndex:0];

    [self.player play];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"loadedTimeRanges"
                         options:NSKeyValueObservingOptionNew
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        [self observeValueForLoadedTimeRanges];
    }
    
}

- (void)observeValueForLoadedTimeRanges {
    // 计算缓冲进度
    NSTimeInterval timeInterval = [self availableDuration];
    CMTime duration             = self.playerItem.duration;
    CGFloat totalDuration       = CMTimeGetSeconds(duration);
    
    CGFloat progress = timeInterval / totalDuration;
    
    if (progress >= 1.0 ) {
        // 缓冲完成就开始合成
        [self.resourceLoader synthesizeVideoFile];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
