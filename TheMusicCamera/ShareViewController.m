//
//  ShareViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "ShareViewController.h"
#import "DataManager.h"
#import "Line.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    dataManager = [DataManager sharedManager];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"]intValue]==1) {
        shareImage.hidden = NO;
        threeShareImg.hidden = YES;
        shareImage.image = dataManager.shareImg;
    }
    else
    {
        shareImage.hidden = YES;
        threeShareImg.hidden = NO;
        threeShareImg.image = dataManager.shareImg;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
//    [self navgationImage:@"header_share"];
    [self navgationImage:[NSString stringWithFormat:@"%@header_share",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];

    dataManager = [DataManager sharedManager];

    UIButton *btn = [self navgationButton:@"button_top" andFrame:CGRectMake(250, 10, 62, 31)];
    [btn addTarget:self action:@selector(topBtuuon) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareVC:) name:@"SHAREVC" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) shareVC: (NSNotification*) aNotification
{
    dataManager = [DataManager sharedManager];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"]intValue]==1) {
        shareImage.hidden = NO;
        threeShareImg.hidden = YES;
        shareImage.image = dataManager.shareImg;
    }
    else
    {
        shareImage.hidden = YES;
        threeShareImg.hidden = NO;
        threeShareImg.image = dataManager.shareImg;
    }
}

- (void)topBtuuon
{
    NSLog(@"topBtuuon");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];

}

- (IBAction)emailBtn:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate =self;
    [picker setSubject:@"文件分享"];
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@""];
    
    [picker setToRecipients:toRecipients];
    NSData *imageData = UIImageJPEGRepresentation(dataManager.shareImg, 1);    // jpeg
    
    [picker addAttachmentData:imageData mimeType:@"" fileName:@"image.jpg"];
    
    NSString *emailBody =[NSString stringWithFormat:@"我分享了图片给您"] ;
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (IBAction)faceBookBtn:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
    slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [slComposerSheet setInitialText:@"this is facebook"];
    [slComposerSheet addImage:dataManager.shareImg];
    [slComposerSheet addURL:[NSURL URLWithString:@"http://www.facebook.com/"]];
    [self.navigationController presentViewController:slComposerSheet animated:YES completion:nil];
    }
    else
    {
        

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请设置facebook账号信息，这里需要改"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

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
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposerSheet setInitialText:@"this is ios6 twitter"];
        [slComposerSheet addImage:dataManager.shareImg];
        [slComposerSheet addURL:[NSURL URLWithString:@"http://www.twitter.com/"]];
        [self.navigationController presentViewController:slComposerSheet animated:YES completion:nil];
    }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请设置twitter账号信息，这里需要改"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
//            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"prefs:root=TWITTER"]];

        }
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
    if ([self checkIfLineInstalled]) {
        [Line shareImage:dataManager.shareImg];
    }
}

- (BOOL)checkIfLineInstalled {
    BOOL isInstalled = [Line isLineInstalled];
    
    if (!isInstalled) {
        [[[UIAlertView alloc] initWithTitle:@"Line is not installed." message:@"Please download Line from App Store, and try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return isInstalled;
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
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail have been Sent"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;

        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail  Not Sent"
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
