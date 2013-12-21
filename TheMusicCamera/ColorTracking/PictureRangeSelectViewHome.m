
#import "PictureRangeSelectViewHome.h"
#import "AppDelegate.h"

@implementation PictureRangeSelectViewHome
@synthesize centerPoint;
@synthesize image;
@synthesize raduisV;
@synthesize orginRaduis;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor]; 
        bDisappear = NO;
    }
    return self;
}

//- (void)dealloc
//{
//    [image release];
//    [super dealloc];
//}

- (BOOL) drawImage:(NSTimeInterval)curTime
{
    if ( bDisappear) {
        return YES;
    }
    raduis = curTime*raduisV+orginRaduis;
    if ( (pow(self.frame.origin.x - centerPoint.x,2) + pow( self.frame.origin.y - centerPoint.y, 2) < pow( raduis, 2))
        && (pow(self.frame.origin.x +self.frame.size.width - centerPoint.x,2) + pow( self.frame.origin.y - centerPoint.y, 2) < pow( raduis, 2)) 
        &&( pow(self.frame.origin.x+self.frame.size.width - centerPoint.x,2) + pow( self.frame.origin.y+self.frame.size.height - centerPoint.y, 2) < pow( raduis, 2)) 
        && (pow(self.frame.origin.x - centerPoint.x,2) + pow( self.frame.origin.y+self.frame.size.height - centerPoint.y, 2) < pow( raduis, 2))) {
        bDisappear = YES;
    }
    [self setNeedsDisplay];
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect rc = self.frame;
    rc.origin = CGPointZero;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);

    //截屏幕
    [image drawInRect:rc];
    //扣洞
    CGContextSetBlendMode(contextRef, kCGBlendModeDestinationIn);
    CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
    
    CGContextFillEllipseInRect(contextRef, CGRectMake(centerPoint.x - raduis, centerPoint.y-raduis, raduis*2, raduis*2));
    CGContextRestoreGState(contextRef);
}

@end
