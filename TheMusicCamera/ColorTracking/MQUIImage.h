
#import <UIKit/UIImage.h>


@interface UIImage(MQUIImage)

- (NSData*) getBMPImageDataToSize:(CGSize)size;
- (NSData*) getBMPImageData;

- (UIImage *)fixOrientation;

+ (UIImage *)subImage:(UIImage *)image x:(float)_x y:(float)_y w:(float)_w h:(float)_h;
- (UIImage*)scaleTo:(CGSize)size;

+ (UIImage *)imageFromColor:(UIColor *)color;

+ (UIImage *)topAndLeftPartImage:(UIImage *)image w:(CGFloat)_w h:(CGFloat)_h;

- (UIImage*)blur;
- (UIImage*)blur:(double)sigma;

@end
