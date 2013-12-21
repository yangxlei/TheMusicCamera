
#import "ColorTrackingGLView.h"

#import "MQCameraFocusView.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define kCGImageAlphaPremultipliedLast  (kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast)
#else
#define kCGImageAlphaPremultipliedLast  kCGImageAlphaPremultipliedLast
#endif

@interface ProcessGLView : ColorTrackingGLView
{
    GLuint directDisplayProgram;
    
    GLuint commonProgram;   //原图
    BOOL _backVideo;
    
    // focus related
    MQCameraFocusView *_cameraFocusView;
}
- (void)drawGL:(const CGFloat*)squareVertices frameTexture:(GLuint)frameTexture;
- (BOOL)loadVertexShader:(NSString *)vertexShaderName fragmentShader:(NSString *)fragmentShaderName forProgram:(GLuint *)programPointer index:(int)nIndex;
- (GLuint)setupTexture:(NSString *)fileName;
- (GLuint)setupTextureFromImageRef:(CGImageRef)spriteImage;
- (void)clearScreenAndDraw;

@property(nonatomic,assign) BOOL backVideo;

+ (ProcessGLView*) sharedProcessGLView;

@end


