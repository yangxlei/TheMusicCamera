
#import <UIKit/UIKit.h>

@interface PictureRangeSelectViewHome : UIView <UIGestureRecognizerDelegate> {
    CGFloat raduis;
    BOOL bDisappear;
}
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic) CGFloat raduisV;
@property (nonatomic) CGFloat orginRaduis;

- (BOOL) drawImage:(NSTimeInterval)curTime;
@end
