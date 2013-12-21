//
//  ColorTrackingGLView.m
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/7/2010.
//

#import "ColorTrackingGLView.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>

@implementation ColorTrackingGLView

@synthesize image_orientation = _image_orientation;

#pragma mark -
#pragma mark Initialization and teardown

// Override the class method to return the OpenGL layer, as opposed to the normal CALayer
+ (Class) layerClass 
{
	return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		// Do OpenGL Core Animation layer setup
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		// Set scaling to account for Retina display	
//		if ([self respondsToSelector:@selector(setContentScaleFactor:)])
//		{
//			self.contentScaleFactor = [[UIScreen mainScreen] scale];
//		}
		_image_orientation = UIDeviceOrientationPortrait;
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		
		if (!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffers]) 
		{
			return nil;
		}
		
        // Initialization code
    }
    return self;
}


#pragma mark -
#pragma mark OpenGL drawing

- (BOOL)createFramebuffers
{	
	glEnable(GL_TEXTURE_2D);
	glDisable(GL_DEPTH_TEST);

	// Onscreen framebuffer object
	glGenFramebuffers(1, &viewFramebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
	
	glGenRenderbuffers(1, &viewRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
	
	[context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
	
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
	NSLog(@"Backing width: %d, height: %d", backingWidth, backingHeight);
	
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
	
	if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) 
	{
		NSLog(@"Failure with framebuffer generation");
		return NO;
	}
	
	GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) 
	{
		NSLog(@"Incomplete FBO: %d", status);
        exit(1);
    }
	
	
	
	return YES;
}

- (void)destroyFramebuffer;
{	
	if (viewFramebuffer)
	{
		glDeleteFramebuffers(1, &viewFramebuffer);
		viewFramebuffer = 0;
	}
	
	if (viewRenderbuffer)
	{
		glDeleteRenderbuffers(1, &viewRenderbuffer);
		viewRenderbuffer = 0;
	}
}

- (void)setDisplayFramebuffer;
{
    if (context)
    {
//        [EAGLContext setCurrentContext:context];
        
        if (!viewFramebuffer)
		{
            [self createFramebuffers];
		}
        
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        
        glViewport(0, 0, backingWidth, backingHeight);
    }
}

- (BOOL)presentFramebuffer;
{
    BOOL success = FALSE;
    
    if (context)
    {
        glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
        
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
    }
    
    return success;
}

- (void)beginTextureCapture:(CGSize)size
{
    captureSize = size;
	glGenTextures(1, &DegenTexture);
	glBindTexture(GL_TEXTURE_2D, DegenTexture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, captureSize.width, captureSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	glGenFramebuffers(1, &DegenFBO);
	glBindFramebuffer(GL_FRAMEBUFFER, DegenFBO);
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, DegenTexture, 0);
    
    glBindFramebuffer(GL_FRAMEBUFFER, DegenFBO);
    glViewport(0, 0, captureSize.width, captureSize.height);
}

- (UIImage*)endTextureCapture
{
    uint32_t *bitmapData = NULL;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    int width = captureSize.width;
    int height = captureSize.height;
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData)
    {
        return nil;
    }
    
    // Get a pointer to the data	
    unsigned char *bitmapData1 = (unsigned char *)bitmapData;
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, bitmapData);
    
    NSData* newData = nil;
    
    if(bitmapData1)
    {
        int len = 54 + sizeof(unsigned char) * bytesPerRow * height;
        int area = width*height;
        newData = [[NSMutableData alloc] initWithLength:len];
        unsigned char* newBitmap = (unsigned char*)[newData bytes];
        
        //height = -height;
        
        memset(newBitmap, 0, 54);
        newBitmap[0] = 'B';
        newBitmap[1] = 'M';
        memcpy(newBitmap+2, &len, 4);
        newBitmap[10] = 54;
        newBitmap[14] = 0x28;
        memcpy(newBitmap + 18, &width, 4);
        memcpy(newBitmap + 22, &height, 4);
        newBitmap[26] = 1;
        newBitmap[28] = 32;
        
        if(newBitmap) 
        {	// Copy the data
            for (int i = 0; i < area; i++)
            {
                int offset = i<<2;
                newBitmap[54+offset+0] = bitmapData1[offset+2];//B
                newBitmap[54+offset+1] = bitmapData1[offset+1];//G
                newBitmap[54+offset+2] = bitmapData1[offset+0];//R
                newBitmap[54+offset+3] = bitmapData1[offset+3];//A
            }
        }
    }
    else
    {
        NSLog(@"Error getting bitmap pixel data\n");
    }
    
    free(bitmapData);
    
    UIImage* img = [UIImage imageWithData:newData];
    glDeleteTextures(1, &DegenTexture);
    glDeleteFramebuffers(1, &DegenFBO);

    DegenTexture = 0;
    DegenFBO = 0;
    
    // 如果是横屏，则旋转图片
    if (_image_orientation == UIDeviceOrientationLandscapeLeft || 
        _image_orientation == UIDeviceOrientationLandscapeRight) {

        CGSize rotatedSize = CGSizeMake(img.size.height, img.size.width);

        UIGraphicsBeginImageContext(rotatedSize);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(ctx, rotatedSize.width / 2, rotatedSize.height / 2);
        CGContextRotateCTM(ctx, _image_orientation == UIDeviceOrientationLandscapeLeft ? -M_PI_2 : M_PI_2);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextDrawImage(ctx, CGRectMake(-img.size.width / 2, 
                                           -img.size.height / 2,
                                           img.size.width, 
                                           img.size.height), img.CGImage);
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
         
        return newImage;
    }
    
    return img;
}

@end
