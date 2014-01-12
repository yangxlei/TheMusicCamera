//
//  ShareViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>
@class DataManager;

@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    SLComposeViewController *slComposerSheet;
    IBOutlet UIImageView *shareImage;
    __weak IBOutlet UIImageView *shareB;
    
    DataManager *dataManager;
    
}

@end
