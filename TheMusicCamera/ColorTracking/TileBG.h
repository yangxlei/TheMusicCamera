
#import <UIKit/UIKit.h>
#define FLAT_IMAGE_HEIGHT 32.0f

@interface TileBG : UIView
{
    UIImage *_image;
}

@property (nonatomic, retain) UIImage *image;

- (id)initWithImage:(UIImage *) aImage;

@end
