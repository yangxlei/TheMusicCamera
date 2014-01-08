//
//  TextFontViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 14-1-8.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFontVCDelegate

- (void)selectColor:(UIColor *)color andFont:(UIFont *)fontStr;
- (void)selectTextView:(UITextView *)textView;

@end

@interface TextFontViewController : UIViewController
{
    __weak IBOutlet UIView *colorView;

    __weak IBOutlet UIView *fontView;

    __weak IBOutlet UITextView *textView;
}

@property (nonatomic, strong) id<TextFontVCDelegate> delegate;

@end
