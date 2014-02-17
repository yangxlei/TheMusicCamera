//
//  TextLayoutLabel.h
//  LatinDemo
//
//  Created by yy on 13-10-24.
//  Copyright (c) 2013年 PICOOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextLayoutLabel : UILabel
{
    @private
    CGFloat characterSpacing_;         //字间距
    long linesSpacing_;
}

@property (nonatomic, assign) CGFloat characterSpacing;
@property (nonatomic, assign) long linesSpacing;

@end
