//
//  DownloadTool.m
//  NSURLSession-Download
//
//  Created by admin on 22/11/2016.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DownloadTool.h"
#import "CycleView.h"

@interface DownloadTool ()

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) NSURLSession *session;


@end

@implementation DownloadTool
- (NSURLSession *)session {
    if (!_session) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (void)downloadFileWithUrl:(NSURL *)url {
    self.downloadTask = [self.session downloadTaskWithURL:url];
    [self.downloadTask resume];
}

- (void)downloadFileWithResumeData:(NSData *)resumeData {
    self.downloadTask = [self.session downloadTaskWithResumeData:resumeData];
    [self.downloadTask resume];
}

- (NSData *)pauseDownload {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
    return self.resumeData;
}

/*下载完成调用*/
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    [fileManger moveItemAtPath:location.path toPath:path error:nil];
    NSLog(@"path = %@",path);
}

/*每次写入沙盒完毕调用
    在这里监听下载进度，totalBytesWritten／totalBytesExpectedToWrite
    bytesWritten                这次写入的大小
    totoalBytesWritten          已经写入沙盒的大小
    totalBytesExpectedToWrite   文件总大小
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    [[CycleView sharedCycleViewWithWidth:240] drawProgress:1.0 * totalBytesWritten / totalBytesExpectedToWrite];
}

/*
 恢复下载后调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {

}

/*由于下载失败导致的下载中断会进入此协议方法，也可以得到用来恢复的数据*/
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    self.resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
}
@end
