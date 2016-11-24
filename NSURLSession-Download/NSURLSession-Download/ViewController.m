//
//  ViewController.m
//  NSURLSession-Download
//
//  Created by admin on 21/11/2016.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "DownloadTool.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (nonatomic, strong) NSData *pauseData;
@property (nonatomic) BOOL flag;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.slider.value = 0;
    self.progressView.progress = 0;
    self.Cview.progressLabel.text = @"0.00%";
    self.flag = YES;
    CycleView *cv = [CycleView sharedCycleViewWithWidth:240];
    [self.view addSubview:cv];
}


- (IBAction)sliderAction:(id)sender {
    NSLog(@"view = %@\n,sel.view = %@",[CycleView sharedCycleViewWithWidth:240],self.Cview);
    [[CycleView sharedCycleViewWithWidth:240] drawProgress:self.slider.value];
}

- (IBAction)downloadAction:(id)sender {
    DownloadTool *tool = [[DownloadTool alloc]init];
    
    if (self.flag == YES) {
        self.flag = NO;
        self.downloadBtn.selected = YES;
        [tool downloadFileWithUrl:[NSURL URLWithString:@"https://codeload.github.com/CodeZheng/AsyncSocketChat/zip/master"]];
    }else {
        if (self.downloadBtn.selected == YES) {
            self.downloadBtn.selected = NO;
            self.pauseData = [tool pauseDownload];
        }else {
            self.downloadBtn.selected = YES;
            [tool downloadFileWithResumeData:self.pauseData];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
