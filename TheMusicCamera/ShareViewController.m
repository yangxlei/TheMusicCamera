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

- (void)viewWillAppear:(BOOL)animated
{
    shareImage.image = dataManager.shareImg;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"]intValue]==1) {
        shareB.frame = CGRectMake(shareB.frame.origin.x, shareB.frame.origin.y, 215, 215);
        shareB.image = [UIImage imageNamed:@"share_11_bg"];
        
        shareImage.frame = CGRectMake(shareImage.frame.origin.x, shareImage.frame.origin.y, 180, 180);
        //        imageView.frame = CGRectMake(0, 0, 300, 300);
    }
    else
    {
        shareB.frame = CGRectMake(shareB.frame.origin.x, shareB.frame.origin.y, 215, 305);
        shareB.image = [UIImage imageNamed:@"share_34_bg"];

        shareImage.frame = CGRectMake(shareImage.frame.origin.x, shareImage.frame.origin.y, 180, 240);
        //        imageView.frame = CGRectMake(0, 0, 300, 400);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    [self navgationImage:@"header_share"];
    dataManager = [DataManager sharedManager];

    UIButton *btn = [self navgationButton:@"button_top" andFrame:CGRectMake(250, 10, 62, 31)];
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
    NSArray *toRecipients = [NSArray arrayWithObject:@"317295583@qq.com"];
    
    [picker setToRecipients:toRecipients];
    NSData *imageData = UIImageJPEGRepresentation(shareImage.image, 1);    // jpeg
    
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
    [slComposerSheet addImage:shareImage.image];
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
        [slComposerSheet addImage:shareImage.image];
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
