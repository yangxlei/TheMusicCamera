#import <QuartzCore/QuartzCore.h>
#import "MQCropImageView.h"
//#import "DictionaryExtending.h"
#import "MQCropPatView.h"

@interface TouchInfo : NSObject {
    CGPoint point;
} 
@property (nonatomic, assign) CGPoint point;
-(id)initWithInfo:(CGPoint)p;
@end

@implementation TouchInfo
@synthesize point;

-(id)initWithInfo:(CGPoint)p
{
    self = [super init];
    if ( self) {
        point = p;
    }  
    return self;
}
@end

@implementation MQCropImageView
@synthesize cropPatView;
@synthesize cropSizeInImage;
@synthesize cropSizeInScreen;

//-(void) dealloc
//{
//    [srcImageView removeFromSuperview];
//    [cropPatView release];
//    [srcImageView release];
//    [dicTouches release];
//    [super dealloc];
//}

-(void) initialize
{
    self.backgroundColor = [UIColor clearColor];
    CGRect frame = self.frame;
    srcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    srcImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:srcImageView];
    dicTouches = [[NSMutableDictionary alloc] initWithCapacity:10];
    cropSizeInScreen = CGRectZero;
    cropSizeInImage = CGRectZero;
     [self sendSubviewToBack:srcImageView];
    self.multipleTouchEnabled = YES;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
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

-(void) setCropPatView:(MQCropPatView *)_cropPatView
{
    if (_cropPatView != cropPatView)
    {
        [cropPatView removeFromSuperview];
//        [cropPatView release];
//        cropPatView = [_cropPatView retain];
      cropPatView = _cropPatView;
        [self addSubview:cropPatView];
         [self sendSubviewToBack:srcImageView];
    }
}

-(void) setCropSizeInScreen:(CGRect)_cropSizeInScreen
{
    cropSizeInScreen = _cropSizeInScreen;
    CGRect rc = srcImageView.frame;
    UIImage *image = srcImageView.image;
    
    if (image)
    {
        CGFloat scaleX = cropSizeInScreen.size.width / image.size.width;
        CGFloat scaleY = cropSizeInScreen.size.height / image.size.height;
        CGFloat initialScaleFactor = MAX(scaleX, scaleY);
        
        rc.size.width = initialScaleFactor * image.size.width;
        rc.size.height = initialScaleFactor * image.size.height;
        rc.origin.x = 0/*cropSizeInScreen.origin.x + (abs(cropSizeInScreen.size.width - rc.size.width)) * 0.5*/;
        rc.origin.y =0 /*cropSizeInScreen.origin.y + (abs(cropSizeInScreen.size.height - rc.size.height)) * 0.5*/;
        srcImageView.frame = rc;
    }
}

-(void) setCropImageSource:(UIImage*)image
{
    srcImageView.image = image;

    CGFloat cropDimens = MAX(image.size.width, image.size.height);
    cropSizeInImage = CGRectMake(0, 0, cropDimens, cropDimens);
    
    CGRect rc = srcImageView.frame;
    if (image)
    {
        CGFloat scaleX = cropSizeInScreen.size.width / image.size.width;
        CGFloat scaleY = cropSizeInScreen.size.height / image.size.height;
        CGFloat initialScaleFactor = MAX(scaleX, scaleY);
        rc.size.width = initialScaleFactor * image.size.width;
        rc.size.height = initialScaleFactor * image.size.height;
        rc.origin.x = 0/*cropSizeInScreen.origin.x + (abs(cropSizeInScreen.size.width - rc.size.width)) * 0.5*/;
        rc.origin.y = (self.frame.size.height-rc.size.height)/2 + 5/*cropSizeInScreen.origin.y + (abs(cropSizeInScreen.size.height - rc.size.height)) * 0.5*/;
        if(rc.origin.y+rc.size.height<(cropSizeInScreen.origin.y+cropSizeInScreen.size.height)){
            rc.origin.y = cropSizeInScreen.origin.y;
        }
        srcImageView.frame = rc;
    }
   [self sendSubviewToBack:srcImageView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  for ( UITouch * t in touches) {
    TouchInfo * info = [[TouchInfo alloc] initWithInfo:[t locationInView:self.superview]];
    [dicTouches setValue:info forKey:[NSString stringWithFormat:@"%lx", (long)t]];
//    [info release];
  }
} 
#define BLOCK(x)  ((x)*(x))
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  if ( [[dicTouches allKeys] count] == 1) {
    for ( UITouch * t in touches) {
      TouchInfo * info = [dicTouches objectForKey:[NSString stringWithFormat:@"%lx", (long)t]];
      if ( info) {
        CGPoint oldPoint = info.point;
        CGPoint newPoint = [t locationInView:self.superview];
        info.point = newPoint;
        srcImageView.center = CGPointMake( srcImageView.center.x + newPoint.x - oldPoint.x, srcImageView.center.y+newPoint.y-oldPoint.y);
      }
      else
      {
        TouchInfo * info = [[TouchInfo alloc] initWithInfo:[t locationInView:self.superview]];
        [dicTouches setValue:info forKey:[NSString stringWithFormat:@"%lx", (long)t]];
//        [info release];
      }
    }
    
  }
  else
  {
    UITouch * firstTouch = nil;
    UITouch * secondTouch = nil;
    for ( UITouch * t in touches) {
      if ( [dicTouches objectForKey:[NSString stringWithFormat:@"%lx", (long)t]])
      {
        if ( !firstTouch) {
          firstTouch = t;
        } else {
          secondTouch = t;
        }
      }
    }
    
    if ( firstTouch == nil) {
      return;
    }
    TouchInfo * foinfo = [dicTouches objectForKey:[NSString stringWithFormat:@"%lx", (long)firstTouch]];
    TouchInfo * soinfo = nil;
    CGPoint fnpose = [firstTouch locationInView:self.superview];
    CGPoint snpose =  CGPointZero;
    if ( secondTouch) {
      soinfo = [dicTouches objectForKey:[NSString stringWithFormat:@"%lx", (long)secondTouch]];
      snpose = [secondTouch locationInView:self.superview];
    }
    else
    {
      for ( TouchInfo * tinfo in [dicTouches allValues]) {
        if ( tinfo != foinfo) {
          soinfo = tinfo;
          break;
        }
      }
      if (soinfo) snpose = soinfo.point;
    }
    CGPoint fopose = foinfo.point;
    CGPoint sopose = CGPointZero;
    if (soinfo) sopose = soinfo.point;
    foinfo.point = fnpose;
    soinfo.point = snpose;
    
    CGFloat scale = sqrtf( sqrt((BLOCK(fnpose.x - snpose.x) + BLOCK( fnpose.y-snpose.y))/(BLOCK(fopose.x - sopose.x) + BLOCK( fopose.y-sopose.y))));
    
    srcImageView.center = CGPointMake( (fnpose.x+snpose.x)/2-((fopose.x+sopose.x)/2-srcImageView.center.x)*scale, (fnpose.y+snpose.y)/2-((fopose.y+sopose.y)/2-srcImageView.center.y)*scale);
    srcImageView.transform = CGAffineTransformScale( srcImageView.transform, scale, scale);
  }
  
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self touchesEnded:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [dicTouches removeAllObjects];
  CGRect rect = srcImageView.frame;
  CGFloat scaleX = cropSizeInScreen.size.width / rect.size.width;
  CGFloat scaleY = cropSizeInScreen.size.height / rect.size.height;
  
  CGFloat maxScale = MAX(scaleX, scaleY);
  
  if ((int) maxScale >= 1)
  {
    rect.size.width *= maxScale;
    rect.size.height *= maxScale;
  }
  
  if(rect.origin.x < cropSizeInScreen.origin.x && rect.origin.x + rect.size.width < cropSizeInScreen.origin.x + cropSizeInScreen.size.width)
  {
    CGFloat diffX = (cropSizeInScreen.origin.x + cropSizeInScreen.size.width) - (rect.origin.x+rect.size.width);
    rect.origin.x += diffX;
  }
  else if (rect.origin.x > cropSizeInScreen.origin.x && rect.origin.x+rect.size.width > cropSizeInScreen.origin.x + cropSizeInScreen.size.width)
  {
    rect.origin.x = cropSizeInScreen.origin.x;
  }
  
  if (rect.origin.y < cropSizeInScreen.origin.y && rect.origin.y + rect.size.height < cropSizeInScreen.origin.y + cropSizeInScreen.size.height)
  {
    CGFloat diffY = (cropSizeInScreen.origin.y + cropSizeInScreen.size.height) - (rect.origin.y + rect.size.height);
    rect.origin.y = diffY;
  }
  else if (rect.origin.y > cropSizeInScreen.origin.y && rect.origin.y + rect.size.height > cropSizeInScreen.origin.y+cropSizeInScreen.size.height)
  {
    rect.origin.y = cropSizeInScreen.origin.y;
  }
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.4];
  srcImageView.frame = rect;
  [UIView commitAnimations];
  
}

-(UIImage*) sourceImage
{
    return srcImageView.image;
}
-(CGRect) resultRectInSrcImage
{
    if (!srcImageView.image)
    {
        return CGRectZero;
    }
    CGRect virsualRect = [self.cropPatView convertRect:cropSizeInScreen toView:srcImageView];
    UIImage *image = srcImageView.image;
    CGFloat s = image.size.width/srcImageView.frame.size.width;
    CGAffineTransform t = CGAffineTransformConcat(srcImageView.transform, CGAffineTransformMakeScale(s, s));
    return CGRectApplyAffineTransform(virsualRect, t);
}

-(BOOL) getCropResult:(CGRect*)cropRectInImage crppedImage:(UIImage **) reslutImage type:(SelectType)type
{
    if (!srcImageView.image)
    {
        return NO;
    }
    CGRect virsualRect = [self.cropPatView convertRect:cropSizeInScreen toView:srcImageView];
    UIImage *image = srcImageView.image;
    CGFloat s = image.size.width/srcImageView.frame.size.width;
    CGAffineTransform t = CGAffineTransformConcat(srcImageView.transform, CGAffineTransformMakeScale(s, s));
    *cropRectInImage = CGRectApplyAffineTransform(virsualRect, t);
//    *oldImage = image;
    
    
    
    UIView * tempBackView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height)];
    if (self.cropPatView.fixOutSize.width >0 || self.cropPatView.fixOutSize.height > 0)
    {
        tempBackView.frame = CGRectMake( 0, 0, self.cropPatView.fixOutSize.width, self.cropPatView.fixOutSize.height);
    }
    else
    {
        tempBackView.frame = CGRectMake( 0, 0, cropRectInImage->size.width, cropRectInImage->size.height);
    } 
   
    CGFloat scale = tempBackView.frame.size.width/cropRectInImage->size.width;
    UIImageView * tempImgView = [[UIImageView alloc] initWithImage:srcImageView.image];
    [tempBackView addSubview:tempImgView];
    tempImgView.frame = CGRectMake( -cropRectInImage->origin.x*scale, -cropRectInImage->origin.y*scale, image.size.width*scale, image.size.height*scale) ;
    UIImage * cutImage;
    
    if (type == SelectRectangl)
    {
        if (tempBackView.frame.size.width > 400)
        {
            CGRect rc = tempBackView.frame;
            rc.size = CGSizeMake(400, 400);
        }
    }
    else if(type == SelectRound)
    {
        if (tempBackView.frame.size.width > 200)
        {
            CGRect rc = tempBackView.frame;
            rc.size = CGSizeMake(200, 200);
        }
    }
    UIGraphicsBeginImageContext(tempBackView.frame.size); 
    [tempBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    cutImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
//    [tempImgView release];
//    [tempBackView release];
  
    *reslutImage = cutImage;
    
    return YES;
}

@end
