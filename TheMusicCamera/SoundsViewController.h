//
//  SoundsViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundsRecordViewController.h"

@interface SoundsViewController : UIViewController<RecordDelegate>
{
    __weak IBOutlet UILabel *soundsName;
    __weak IBOutlet UILabel *repeatName;
    UIImageView *fadeImage;
    
}

@end
