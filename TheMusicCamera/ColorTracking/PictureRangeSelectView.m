
#import "PictureRangeSelectView.h"

@implementation PictureRangeSelectView
@synthesize bRound;
@synthesize raduis;
@synthesize center;

@synthesize max_radius;
@synthesize min_radius;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setupGestures];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect rc = self.frame;
    rc.origin = CGPointZero;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    CGContextSetFillColorWithColor(contextRef, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor);
    CGContextFillRect(contextRef, rc);

    if (bRound)
    {
        //画周围白圈
        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
        CGContextFillEllipseInRect(contextRef, CGRectMake(center.x - raduis-1, center.y-raduis-1, raduis*2+2, raduis*2+2));
        
        //扣洞
        CGContextSetBlendMode(contextRef, kCGBlendModeDestinationIn);
        CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
        
        CGContextFillEllipseInRect(contextRef, CGRectMake(center.x - raduis, center.y-raduis, raduis*2, raduis*2));
    }
    else
    {
        //画周围白圈
        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
        CGContextFillRect(contextRef, CGRectMake(center.x - raduis-1, center.y-raduis-1, raduis*2+2, raduis*2+2));
        
        //扣洞
        CGContextSetBlendMode(contextRef, kCGBlendModeDestinationIn);
        CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
        
        CGContextFillRect(contextRef, CGRectMake(center.x - raduis, center.y-raduis, raduis*2, raduis*2));
    }
    
    
    CGContextRestoreGState(contextRef);
}

@end
