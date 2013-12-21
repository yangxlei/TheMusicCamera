
#import "MQRoundPatView.h"

@implementation MQRoundPatView

-(void)initialize
{
    [super initialize];
    fixOutSize = CGSizeZero;
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
    CGFloat centerX = cropRect.origin.x + 0.5 * cropRect.size.width;
    CGFloat centerY = cropRect.origin.y + 0.5 * cropRect.size.height;
    CGFloat radius = 0.5 * cropRect.size.width;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddRect(context, self.frame);
    CGContextClosePath(context);

    CGContextAddArc(context, centerX, centerY, radius, 0, 2*M_PI, NO);
    CGContextClosePath(context);

    CGContextEOFillPath(context);

    CGContextBeginPath(context);
    CGContextAddArc(context, centerX, centerY, radius, 0, 2*M_PI, NO);
    CGContextClosePath(context);

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextDrawPath(context, kCGPathStroke);

    CGContextRestoreGState(context);
}

@end
