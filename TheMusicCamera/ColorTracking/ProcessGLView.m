
#import "ProcessGLView.h"
#import "MQUIImage.h"
#import <OpenGLES/EAGLDrawable.h>

#import "ColorTrackingCamera.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

enum {
    UNIFORM_VIDEOFRAME,
    
    NUM_UNIFORMS
};

GLint uniforms[1][NUM_UNIFORMS];

enum {
    ATTRIB_VERTEX,
    ATTRIB_TEXTUREPOSITON,
    NUM_ATTRIBUTES
};


ProcessGLView* _glProcessView = nil;

@implementation ProcessGLView
@synthesize backVideo = _backVideo;

- (GLuint)setupTexture:(NSString *)fileName {    
    // 1
    CGImageRef spriteImage = [[UIImage imageNamed:fileName] fixOrientation].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    // 2
    GLuint texName;
    texName = [self setupTextureFromImageRef:spriteImage];
    return texName;    
}

- (GLuint)setupTextureFromImageRef:(CGImageRef)spriteImage {    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    if (width > 1024 || height > 1024) {
        if (width > height) {
            height = height*1024.0f/width;
            width = 1024;
        } else {
            width = width*1024.0f/height;
            height = 1024;
        }
    }
    
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), 1);
  
    //3
    CGContextTranslateCTM(spriteContext, 0, height);
    CGContextScaleCTM(spriteContext, 1.0, -1.0);

    CGContextTranslateCTM (spriteContext, width, 0);
    CGContextRotateCTM (spriteContext, radians (90));
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, height, width), spriteImage);
    
    CGContextRelease(spriteContext);
    
	// Create a new texture from the camera frame data, display that using the shaders
    GLuint texture;
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	// This is necessary for non-power-of-two textures
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	// Using BGRA extension to pull in video frame data directly
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData); 
    return texture;
}

- (void)clearScreenAndDraw
{
    glClearColor(0.0,0.0,0.0,0.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_STENCIL_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
        
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
    glClearColor(0.0,0.0,0.0,0.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_STENCIL_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
    if([EAGLContext currentContext]!= context){
        [EAGLContext setCurrentContext:context];
    }
}

-(void)clearScreen
{
    glClearColor(0.0,0.0,0.0,0.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_STENCIL_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
}

- (void)drawGL:(const CGFloat*)squareVertices frameTexture:(GLuint)frameTexture
{    
    [self clearScreen];
    
    // Replace the implementation of this method to do your own custom drawing.
    GLuint useProgram = commonProgram;
    
	glUseProgram(useProgram);
    
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, frameTexture);
	// Update uniform values
	glUniform1i(uniforms[0][UNIFORM_VIDEOFRAME], 0);
    
	// Update attribute values.
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    if (_backVideo) {
        
        static const GLfloat textureVertices[] = {
            1.0f, 1.0f,
            1.0f, 0.0f,
            0.0f,  1.0f,
            0.0f,  0.0f,
        };
        
        glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
        
    } else {
        
        static const GLfloat textureVertices[] = {
            1.0f, 0.0f,
            1.0f, 1.0f,
            0.0f,  0.0f,
            0.0f,  1.0f,
        };
        
        glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    }
	
	glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);
	
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    
    // check focus
    if ([[ColorTrackingCamera sharedInstance] isNeedFocusAdjusting]) {
        
        if (self.superview) {
            
            CGPoint focusPoint = [[ColorTrackingCamera sharedInstance] getFocusPoint]; 
            focusPoint = CGPointMake(focusPoint.x * self.frame.size.width, focusPoint.y * self.frame.size.height); 
            _cameraFocusView.center = [self.superview convertPoint:focusPoint fromView:self];  
            [self.superview addSubview:_cameraFocusView]; 
            
            if ([[ColorTrackingCamera sharedInstance] getCameraFocusMode] == AVCaptureFocusModeContinuousAutoFocus) {
                
                [_cameraFocusView playAutoAdjustFocusAnimation];
                
            } else {
                
                [_cameraFocusView playManualAdjustFocusAnimation]; 
            }            
        }         
        
    } 
}
//
//-(void)dealloc
//{
//    [_cameraFocusView release]; 
//    
//    [super dealloc];
//}
//

#pragma mark -
#pragma mark OpenGL ES 2.0 setup methods

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)loadVertexShader:(NSString *)vertexShaderName fragmentShader:(NSString *)fragmentShaderName forProgram:(GLuint *)programPointer index:(int)nIndex;
{
    GLuint vertexShader, fragShader;
	
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    *programPointer = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vertexShaderName ofType:@"txt"];
    if (![self compileShader:&vertexShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fragmentShaderName ofType:@"txt"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(*programPointer, vertexShader);
    
    // Attach fragment shader to program.
    glAttachShader(*programPointer, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(*programPointer, ATTRIB_VERTEX, "position");
    glBindAttribLocation(*programPointer, ATTRIB_TEXTUREPOSITON, "inputTextureCoordinate");
    
    // Link program.
    if (![self linkProgram:*programPointer])
    {
        NSLog(@"Failed to link program: %d", *programPointer);
        
        if (vertexShader)
        {
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (*programPointer)
        {
            glDeleteProgram(*programPointer);
            *programPointer = 0;
        }
        
        return FALSE;
    }
    
    // Get uniform locations.
    uniforms[nIndex][UNIFORM_VIDEOFRAME] = glGetUniformLocation(*programPointer, "videoFrame");
    
    // Release vertex and fragment shaders.
    if (vertexShader)
	{
        glDeleteShader(vertexShader);
	}
    if (fragShader)
	{
        glDeleteShader(fragShader);		
	}
    
    return TRUE;
}


- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (void)loadShaders
{
    [self loadVertexShader:@"none.vsh"
            fragmentShader:@"none.fsh"
                forProgram:&commonProgram
                    index:0];
}

- (void)setupGestures
{
    // gesture for mask
    UITapGestureRecognizer *aTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskTap:)];
    [self addGestureRecognizer:aTapGesture]; 
//    [aTapGesture release];     
}

- (void)onMaskTap:(UITapGestureRecognizer *)sender 
{
//    GLProcessConfig* config = [GLProcessConfig sharedInstance];
//    config.isDisplayDepthRange = YES;
//    [self convertDepthCenterToGLView:[sender locationInView:[sender view]]]; 
//    [self performSelector:@selector(resetDisp) withObject:config afterDelay:0.5];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
       // if ([[ColorTrackingCamera sharedInstance] isNeedFocusAdjusting]) {
            CGPoint touchPoint = [sender locationInView:[sender view]]; 
            
            touchPoint = [self convertPoint:touchPoint fromView:[sender view]]; 
            
            [[ColorTrackingCamera sharedInstance] setFocusPoint:CGPointMake(touchPoint.x/self.frame.size.width, touchPoint.y/self.frame.size.height)]; 
            
            if (self.superview) {
                [_cameraFocusView.layer removeAllAnimations];  
                
                CGPoint focusPoint = [[ColorTrackingCamera sharedInstance] getFocusPoint]; 
                focusPoint = CGPointMake(focusPoint.x * self.frame.size.width, focusPoint.y * self.frame.size.height); 
                _cameraFocusView.center = [self.superview convertPoint:focusPoint fromView:self];  
                [self.superview addSubview:_cameraFocusView]; 
                
                [_cameraFocusView playManualAdjustFocusAnimation];            
            }
        }             
    //}    
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupGestures];
        [self loadShaders];
        
        // focus view
        _cameraFocusView = [[MQCameraFocusView alloc] initWithFrame:CGRectZero]; 
        
    }
    return self;
}

+ (ProcessGLView*) sharedProcessGLView
{
    if (_glProcessView == nil)
    {
        _glProcessView = [[ProcessGLView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320, 480)];
    }
    return _glProcessView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
@end
