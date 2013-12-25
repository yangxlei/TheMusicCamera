//
//  BeautifiedPictureViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQCropImageView.h"
#import "MQCropPatView.h"
#import "MQRectCropPatView.h"
#import "ProcessGLView.h"
// A simple 2D image
typedef struct {
	GLuint texID;
	GLsizei wide, high;	// Texture dimensions
	GLfloat s, t;		// Texcoords to show full image, taking any POT padding into account
} Image;


@interface BeautifiedPictureViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet MQCropImageView* cropImageView;

@property (nonatomic) SelectType seletType;
@property (nonatomic, assign) GLuint frameTexture;
@property (nonatomic, assign) CGSize videoFrameSize;

- (IBAction)cancelClick:(id)sender;
- (IBAction)useClick:(id)sender;

- (UIImage *)saveImageFromGLView;

- (void)beginEdit:(SelectType)type;
@end
