//
//  CropperController.m
//  TheMusicCamera
//
//  Created by yanglei on 14-1-3.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "CropperController.h"

@interface CropperController ()

@end

@implementation CropperController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  UIImageView* header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 51)];
  header.image = [UIImage imageNamed:@"header.png"];
  [self.view addSubview:header];
  
  cropImageView = [[KICropImageView alloc] initWithFrame:CGRectMake(0, 51, 320, self.view.frame.size.height-51)];
  
  [cropImageView setCropSize:CGSizeMake(300, 300)];
  [self.view addSubview:cropImageView];
  
  UIButton* resizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  resizeBtn.frame = CGRectMake(30, self.view.frame.size.height-60, 50, 30);
  [resizeBtn setTitle:@"4:3" forState:UIControlStateNormal];
  [resizeBtn addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:resizeBtn];
  
  self.view.backgroundColor = [UIColor grayColor];
}

-(void) resize:(UIButton*) sender
{
  CGSize size = CGSizeZero;
  if (! resizeFlag)
  {
    size = CGSizeMake(300, 400);
    resizeFlag = YES;
    
    [sender setTitle:@"1:1" forState:UIControlStateNormal];
  }
  else
  {
    size = CGSizeMake(300, 300);
    resizeFlag = NO;
    [sender setTitle:@"4:3" forState:UIControlStateNormal];
  }
  
  [cropImageView setCropSize:size];
}

-(void) begin
{
  UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  imagePicker.allowsEditing = NO;
  [self presentModalViewController:imagePicker animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
  [cropImageView setImage:image];
  [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissModalViewControllerAnimated:YES];
}

@end
