# OTPlayerCache

> AVPlayer的缓存组件，你可以用它来缓存AVPlayer播放过的视频，下次就无需重新下载了



## 安装方法

### 手动安装

> 直接将OTPlayerCache的文件拖入项目中

### CocoaPods

> 目前没有提供CocoaPods或者其他的安装方式，后续会补上，欢迎star和watch

## 使用方法

```objective-c
if ([OTVideoCacheService savedVideoExistsWithURL:self.videoURL]) {
    NSURL * playPathURL = [NSURL fileURLWithPath:[OTVideoCacheService savedVideoPathWithURL:self.videoURL]];
    self.videoURLAsset = [AVURLAsset URLAssetWithURL:playPathURL options:nil];
} else {
    // some code ...
    OTAssetLoaderDelegate *resourceLoader = [OTAssetLoaderDelegate new];
    NSURL *playUrl = [OTVideoDownloadModel getSchemeVideoURL:self.videoURL];
    [self.videoURLAsset.resourceLoader setDelegate:resourceLoader queue:dispatch_get_main_queue()];
    // some code ...
}
```

### 其他

> 目前demo还不完善，后面会添加更多的使用方法进去，非常抱歉。
>
> 需要帮助的同学可以联系我的邮箱：irobbin1024@gmail.com