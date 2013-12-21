
#import "TileBG.h"

@implementation TileBG
@synthesize image = _image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithImage:(UIImage *) aImage
{
    CGSize size = [aImage size];
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.image = aImage;
    return self;
}

//- (void) dealloc
//{
//    [_image release];
//    [super dealloc];
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.image)
    {
        // Drawing code
        CGSize size = self.image.size;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGRect a = self.bounds;
        CGContextClipToRect(context, a);//设置要平铺的区域
        //该项目中我们一般只使用2X的背景平铺图
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawTiledImage(context, CGRectMake(0, 0, size.width, size.height), self.image.CGImage);
        //CGContextDrawTiledImage(context, CGRectMake(0, 0, size.width/2, size.height/2), self.image.CGImage);
        CGContextRestoreGState(context);
    }
}

- (void)setFrame:(CGRect)_frame
{
    CGRect rc = self.frame;
    [super setFrame:_frame];
    if ((int)rc.size.width != (int)_frame.size.width || (int)rc.size.height != (int)_frame.size.height)
    {
        [self setNeedsDisplay];
    }
}

- (void) setImage:(UIImage *)image
{
    if (_image != image)
    {
//        [_image release];
//        _image = [image retain];
        [self setNeedsDisplay];
    }
}
@end
