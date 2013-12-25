//
//  ShareViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "ShareViewController.h"
#import "DataManager.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

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
    self.hidesBottomBarWhenPushed = YES;
    [self navgationImage:@"header_share"];
    
    UIButton *btn = [self navgationButton:@"button_top" andFrame:CGRectMake(250, 10, 60, 28)];
    [btn addTarget:self action:@selector(topBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)topBtuuon
{
    NSLog(@"topBtuuon");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];

}

- (IBAction)emailBtn:(id)sender {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate =self;
    [picker setSubject:@"文件分享"];
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"first@qq.com"];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@qq.com",@"third@qq.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@qq.com"];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    //发送图片附件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0194" ofType:@"JPG"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:nil mimeType:@"image/jpeg" fileName:@"IMG_0194.JPG"];
    
    NSString *emailBody =[NSString stringWithFormat:@"我分享了文件给您，地址是"] ;
    [picker setMessageBody:emailBody isHTML:NO];
//    [self presentModalViewController:picker animated:YES];
    [self.navigationController presentViewController:picker animated:YES completion:nil];

}

- (IBAction)faceBookBtn:(id)sender {
    //  if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    //{
    slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [slComposerSheet setInitialText:@"this is facebook"];
    [slComposerSheet addImage:[UIImage imageNamed:@"ios6.jpg"]];
    [slComposerSheet addURL:[NSURL URLWithString:@"http://www.facebook.com/"]];
    [self.navigationController presentViewController:slComposerSheet animated:YES completion:nil];
    // }
    
    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"start completion block");
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        if (result != SLComposeViewControllerResultCancelled)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

- (IBAction)twitterBtn:(id)sender {
    slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [slComposerSheet setInitialText:@"this is ios6 twitter"];
    [slComposerSheet addImage:[UIImage imageNamed:@"ios6.jpg"]];
    [slComposerSheet addURL:[NSURL URLWithString:@"http://www.twitter.com/"]];
    [self.navigationController presentViewController:slComposerSheet animated:YES completion:nil];
    //        }

    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"start completion block");
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        if (result != SLComposeViewControllerResultCancelled)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];

}

- (IBAction)lineBtn:(id)sender {
    
}

-  (void)mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error
{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send e-mail Cancel"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        case MFMailComposeResultSaved:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail have been saved"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail Not Sent"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
    }
    //邮件视图消失
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
