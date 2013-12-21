
#import "MQCropPatView.h"

@implementation MQCropPatView
@synthesize cropRect;
@synthesize fixOutSize;

-(void) initialize
{
    CGRect frame = self.frame;
    CGFloat cropWidth = 280;
    cropRect = CGRectMake((frame.size.width - cropWidth) * 0.5, (frame.size.height - cropWidth) * 0.5, cropWidth, cropWidth);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    fixOutSize = CGSizeZero;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];        
    }
    return  self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initialize];
    }
    return self;
}

-(void) setCropRect:(CGRect)_cropRect
{
    cropRect = _cropRect;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    /************ sub class should implements this method to decede its appearence *****/
    
    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0xaa/255 green:0xaa/255 blue:0xaa/255 alpha:0.5].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xaa/255 green:0xaa/255 blue:0xaa/255 alpha:0.5].CGColor);
//    CGFloat centerX = cropRect.origin.x + 0.5 * cropRect.size.width;
//    CGFloat centerY = cropRect.origin.y + 0.5 * cropRect.size.height;
//    CGFloat radius = 0.5 * cropRect.size.width;
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddRect(context, self.frame);
//    CGContextClosePath(context);
//    
//    CGContextAddArc(context, centerX, centerY, radius, 0, 2*M_PI, NO);
//    CGContextClosePath(context);
//    
//    CGContextEOFillPath(context);
//    
//    CGContextBeginPath(context);
//    CGContextAddArc(context, centerX, centerY, radius, 0, 2*M_PI, NO);
//    CGContextClosePath(context);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor);
//    CGContextSetAllowsAntialiasing(context, YES);
//    CGContextDrawPath(context, kCGPathStroke);
//    
//    CGContextRestoreGState(context);
}


@end
