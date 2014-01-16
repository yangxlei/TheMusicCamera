
#import "MQEditField.h"
@implementation MQEditField
@synthesize placeHolderColor;

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

-(void) drawPlaceholderInRect:(CGRect)rect
{
  if (placeHolderColor) {
    [placeHolderColor setFill];
    int offset;
//    if([UIDevice isIos7])
//        offset = 6;
//    else
        offset = 0;
    CGRect target = CGRectMake(rect.origin.x, rect.origin.y+offset, rect.size.width, rect.size.height);
    [self.placeholder drawInRect:target withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
  }
  else
  {
    [super drawPlaceholderInRect:rect];
  }
}
//
//-(void) dealloc
//{
//  [placeHolderColor release];
//  [super dealloc];
//}

@end
