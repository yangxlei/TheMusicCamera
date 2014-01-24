//
//  VPImageCropperViewController.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end



@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
}

// And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

#import "VPImageCropperViewController.h"
#import "DataManager.h"
#import "Public.h"

#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface VPImageCropperViewController ()

@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;

@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *frame ;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect latestFrame;

@end

@implementation VPImageCropperViewController

- (void)dealloc {
    self.originalImage = nil;
    self.showImgView = nil;
    self.editedImage = nil;
    self.overlayView = nil;
    self.ratioView = nil;
  self.frame = nil;
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio {
    self = [super init];
    if (self) {
//        self.cropFrame = cropFrame;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"imageSize"];

        self.cropFrame = CGRectMake(10, 10, 300, 300);
        self.limitRatio = limitRatio;
        self.originalImage = originalImage.fixOrientation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self navgationImage:@"header.png"];
  UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
  [btn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
  
  UIButton* cropBtn = [self navgationButton:@"button_OK.png" andFrame:CGRectMake(250, 10, 62, 31)];
  [cropBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
  
  
  onebtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-45, 28, 28)];
  //      onebtn.backgroundColor = [UIColor redColor];
  onebtn.titleLabel.textColor = [UIColor whiteColor];
  //      [changebtn setTitle:@"4:3" forState:UIControlStateNormal];
  [onebtn setImage:[UIImage imageNamed:@"trimming_1_1_off"] forState:UIControlStateNormal];
  [onebtn setImage:[UIImage imageNamed:@"trimming_1_1_on"] forState:UIControlStateSelected];
  [onebtn addTarget:self action:@selector(oneEvent:) forControlEvents:UIControlEventTouchUpInside];
  onebtn.selected = YES;
  [self.view addSubview:onebtn];
  
  fourbtn = [[UIButton alloc] initWithFrame:CGRectMake(48, self.view.frame.size.height-45, 28, 35)];
  //      fourbtn.backgroundColor = [UIColor redColor];
  fourbtn.titleLabel.textColor = [UIColor whiteColor];
  //      [changebtn setTitle:@"4:3" forState:UIControlStateNormal];
  [fourbtn setImage:[UIImage imageNamed:@"trimming_4_3_off"] forState:UIControlStateNormal];
  [fourbtn setImage:[UIImage imageNamed:@"trimming_4_3_on"] forState:UIControlStateSelected];
  [fourbtn addTarget:self action:@selector(fourEvent:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:fourbtn];
  
//  sizeFlag = NO;
  
  self.frame = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, self.view.frame.size.height-100)];
  self.frame.clipsToBounds = YES;
  [self.view addSubview:self.frame];
    [self initView];
//    [self initControlBtn];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (void)initView {
  
    self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 300, 480)];
    [self.showImgView setMultipleTouchEnabled:YES];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setImage:self.originalImage];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setMultipleTouchEnabled:YES];
    
    // scale to fit the screen
    CGFloat oriWidth = self.cropFrame.size.width;
    CGFloat oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);
    CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;
    self.showImgView.frame = self.oldFrame;
    
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
    
    [self addGestureRecognizers];
//    [self.view addSubview:self.showImgView];
  [self.frame addSubview:self.showImgView];
  
    self.overlayView = [[UIView alloc] initWithFrame:self.frame.bounds];
    self.overlayView.alpha = .5f;
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.userInteractionEnabled = NO;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.frame addSubview:self.overlayView];
    
    
    NSLog(@"%f--%f--%f--%f",self.cropFrame.origin.x,self.cropFrame.origin.y,self.cropFrame.size.width,self.cropFrame.size.height);
    self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
    self.ratioView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.ratioView.layer.borderWidth = 1.0f;
    self.ratioView.autoresizingMask = UIViewAutoresizingNone;
    [self.frame addSubview:self.ratioView];
    
    [self overlayClipping];
}

//- (void)initControlBtn {
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0f, 100, 50)];
//    cancelBtn.backgroundColor = [UIColor blackColor];
//    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
//    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
//    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [cancelBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [cancelBtn.titleLabel setNumberOfLines:0];
//    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
//    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
//    
//    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, self.view.frame.size.height - 50.0f, 100, 50)];
//    confirmBtn.backgroundColor = [UIColor blackColor];
//    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
//    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
//    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
//    [confirmBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
//    [confirmBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [confirmBtn.titleLabel setNumberOfLines:0];
//    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
//    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confirmBtn];
//    
//    UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    oneBtn.frame = CGRectMake(0, 0 , 100, 50);
//    [oneBtn setTitle:@"1:1" forState:UIControlStateNormal];
//    [oneBtn addTarget:self action:@selector(oneEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:oneBtn];
// 
//    UIButton *fourBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    fourBtn.frame = CGRectMake(150, 0 , 100, 50);
//    [fourBtn setTitle:@"3:4" forState:UIControlStateNormal];
//    [fourBtn addTarget:self action:@selector(fourEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:fourBtn];
//
//}

- (void)oneEvent:(UIButton *)button
{
    [self.ratioView removeFromSuperview];
    [self.overlayView removeFromSuperview];
    [self.showImgView removeFromSuperview];
    
    onebtn.selected = YES;
    fourbtn.selected = NO;

    self.cropFrame = CGRectMake(10, 10, 300, 300);

    [self initView];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"imageSize"];

}

- (void)fourEvent:(UIButton *)button
{
    [self.ratioView removeFromSuperview];
    [self.overlayView removeFromSuperview];
    [self.showImgView removeFromSuperview];

    onebtn.selected = NO;
    fourbtn.selected = YES;

    self.cropFrame = CGRectMake(10, 10, 300, 400);
    if (iPhone5) {
        self.cropFrame = CGRectMake(10, 10, 300, 400);
    }
    else
    {
        self.cropFrame = CGRectMake(25, 10, 270, 360);
    }
    [self initView];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:3] forKey:@"imageSize"];

}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropperDidCancel:self];
    }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropper:self didFinished:[self getSubImage]];
    }
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.ratioView.frame.origin.x,
                                        self.overlayView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
                                        0,
                                        self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
                                        self.overlayView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.overlayView.frame.size.width,
                                        self.ratioView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
                                        self.overlayView.frame.size.width,
                                        self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

// register all gestures
- (void) addGestureRecognizers
{
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
        CGFloat newW = self.originalImage.size.width;
        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.originalImage.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    NSLog(@"smallImage.imageOrientation ====%d",smallImage.imageOrientation);
    return smallImage.fixOrientation;
}


@end
