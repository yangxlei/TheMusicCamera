//
//  CropImageController.h
//  TheMusicCamera
//
//  Created by yanglei on 13-12-21.
//  Copyright (c) 2013年 songl. All rights reserved.
//

// A simple 2D image
typedef struct {
	GLuint texID;
	GLsizei wide, high;	// Texture dimensions
	GLfloat s, t;		// Texcoords to show full image, taking any POT padding into account
} Image;

@class CropImageController;

@protocol CropImageDelegate <NSObject>

- (void)cancelProcessPhoto;

- (void)useProcessPhoto:(NSDictionary*)dic;

@end

#import <UIKit/UIKit.h>
#import "MQCropImageView.h"
#import "MQCropPatView.h"
#import "MQRectCropPatView.h"
#import "ProcessGLView.h"
@class PictureRangeSelectView;
@interface CropImageController : UIViewController

@property (nonatomic, strong) IBOutlet MQCropImageView* cropImageView;

@property (nonatomic,strong) IBOutlet UIButton *rightBT;
@property (nonatomic,strong) IBOutlet UIButton *leftBT;
@property (nonatomic) SelectType seletType;
@property (nonatomic, assign) GLuint frameTexture;
@property (nonatomic, assign) CGSize videoFrameSize;
@property (nonatomic,assign) id<CropImageDelegate> delegate ;

- (IBAction)cancelClick:(id)sender;
- (IBAction)useClick:(id)sender;

- (UIImage *)saveImageFromGLView;

- (void)beginEdit:(SelectType)type;

@end
