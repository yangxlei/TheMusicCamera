//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "TSLocateView.h"

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property  (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;

@end
