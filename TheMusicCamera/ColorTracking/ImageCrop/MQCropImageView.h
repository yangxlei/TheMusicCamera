
#import <UIKit/UIKit.h>
#include "ColorTracking.h"

@class MQCropPatView;
@interface MQCropImageView : UIView
{
    MQCropPatView *cropPatView;
    UIImageView *srcImageView;
    CGRect cropSizeInScreen;
    CGRect cropSizeInImage;
    NSMutableDictionary *dicTouches;
}
@property(nonatomic, retain)MQCropPatView *cropPatView;
@property(nonatomic)CGRect cropSizeInScreen;
@property(nonatomic, readonly)CGRect cropSizeInImage;

-(void) setCropImageSource:(UIImage*)image;
-(UIImage*) sourceImage;
-(BOOL) getCropResult:(CGRect*)cropRectInImage crppedImage:(UIImage **) reslutImage  type:(SelectType)type;
-(CGRect) resultRectInSrcImage;
@end
