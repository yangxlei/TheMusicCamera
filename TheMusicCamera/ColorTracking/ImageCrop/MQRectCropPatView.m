
#import "MQRectCropPatView.h"

@implementation MQRectCropPatView

-(void)initialize
{
    [super initialize];
    cropRect = CGRectMake(0, 68, 320, 297);
    fixOutSize = CGSizeMake(640, 594);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0xaa/255 green:0xaa/255 blue:0xaa/255 alpha:0.5].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xaa/255 green:0xaa/255 blue:0xaa/255 alpha:0.5].CGColor);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddRect(context, self.frame);
    CGContextClosePath(context);
    
    CGContextAddRect(context, cropRect);
    CGContextClosePath(context);
    
    CGContextEOFillPath(context);
    
    CGContextBeginPath(context);
    CGContextAddRect(context, cropRect);;
    CGContextClosePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}


@end
