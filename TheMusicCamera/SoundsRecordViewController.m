//
//  SoundsRecordViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsRecordViewController.h"
#import "DataManager.h"
#import "DataManager.h"

@interface SoundsRecordViewController ()

@end

@implementation SoundsRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataManager = [DataManager sharedManager];

    self.hidesBottomBarWhenPushed = YES;

    [self navgationImage:@"header_recording"];
    
    UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveBtn = [self navgationButton:@"button_save" andFrame:CGRectMake(260, 10, 52, 28)];
    [saveBtn addTarget:self action:@selector(saveBtuuon) forControlEvents:UIControlEventTouchUpInside];

    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtuuon
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtuuon
{
    
}

- (IBAction)recordVoice:(id)sender {
    NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];

    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/11.caf", savePath];
    recordedFile = [NSURL fileURLWithPath:recorderFilePath];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
    [recorder prepareToRecord];
    [recorder record];


    
}

@end
