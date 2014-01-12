//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"

#define kDuration 0.3

@implementation TSLocateView

@synthesize titleLabel;
@synthesize locatePicker;
@synthesize year;
@synthesize month;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
   }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 11;
            break;
        case 1:
            return 12;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
          year = row;
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker reloadComponent:1];
            break;
        case 1:
          month = row;
           break;
        default:
            break;
    }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}

@end
