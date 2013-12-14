//
//  CameraController.h
//  TheMusicCamera
//
//  Created by yanglei on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton* backBtn;
@property (nonatomic, strong) IBOutlet UIButton* flashBtn;
@property (nonatomic, strong) IBOutlet UIButton* kirikaeBtn;
@property (nonatomic, strong) IBOutlet UIButton* sizeBtn;
@property (nonatomic, strong) IBOutlet UIButton* cameraBtn;
@property (nonatomic, strong) IBOutlet UIView* cameraView;

@end
