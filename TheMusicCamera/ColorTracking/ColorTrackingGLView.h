//
//  ColorTrackingGLView.h
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/7/2010.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#define FRAME_BUFFER_OBJECT_HEIGHT [UIScreen mainScreen].bounds.size.height
#define FRAME_BUFFER_OBJECT_WIDTH 320

@interface ColorTrackingGLView : UIView 
{
	/* The pixel dimensions of the backbuffer */
	GLint backingWidth, backingHeight;
	
EAGLContext *context;
	
	/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
	GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL texture capture renderbuffer and framebuffer */
    GLuint DegenFBO;
    GLuint DegenTexture;
    CGSize captureSize;
}

@property(nonatomic, assign) UIDeviceOrientation image_orientation;

// OpenGL drawing
- (BOOL)createFramebuffers;
- (void)destroyFramebuffer;
- (void)setDisplayFramebuffer;
- (BOOL)presentFramebuffer;

- (void)beginTextureCapture:(CGSize)size;
- (UIImage*)endTextureCapture;
@end
