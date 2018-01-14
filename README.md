# OTPlayerCache

> AVPlayer的缓存组件，你可以用它来缓存AVPlayer播放过的视频，下次就无需重新下载了



## 安装方法

### 手动安装

> 直接将OTPlayerCache的文件拖入项目中

### CocoaPods

> 目前没有提供CocoaPods或者其他的安装方式，后续会补上，欢迎star和watch

## 使用方法

```objective-c
// 获取磁盘空间大小
unsigned long long diskSize = [OTVideoCacheService getDiskFreeSize];
NSURL *playUrl;
OTAssetLoaderDelegate *resourceLoader = [OTAssetLoaderDelegate new];
self.resourceLoader = resourceLoader;

// 如果当前磁盘空间大于某个常量且开启缓存才会走缓存策略
if (diskSize > kFreeDiskCanDoCache && self.needCache) {
    playUrl = [OTVideoDownloadModel getSchemeVideoURL:self.videoURL];
} else {
    playUrl = self.videoURL;
}

self.videoURLAsset = [AVURLAsset URLAssetWithURL:playUrl options:nil];

if (diskSize > kFreeDiskCanDoCache && self.needCache) {
  	// 设置好代理
    [self.videoURLAsset.resourceLoader setDelegate:resourceLoader queue:dispatch_get_main_queue()];
}
```

### 其他

> 目前demo还不完善，后面会添加更多的使用方法进去，非常抱歉。
>
> 需要帮助的同学可以联系我的邮箱：irobbin1024@gmail.com