//
//  DownloadTool.h
//  NSURLSession-Download
//
//  Created by admin on 22/11/2016.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadTool : NSObject<NSURLSessionDownloadDelegate>

@property (nonatomic) CGFloat progress;


- (void)downloadFileWithUrl:(NSURL *)url;

- (void)downloadFileWithResumeData:(NSData *)resumeData;

- (NSData *)pauseDownload;

@end
