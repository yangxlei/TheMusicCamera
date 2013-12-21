
#import <UIKit/UIKit.h>

@interface MQCropPatView : UIView
{
    CGRect cropRect;
    CGSize fixOutSize;// x,y小于等于零表示该方向不限定输出尺寸
}
@property(nonatomic) CGRect cropRect;
@property(nonatomic) CGSize fixOutSize;

-(void) initialize;
@end
