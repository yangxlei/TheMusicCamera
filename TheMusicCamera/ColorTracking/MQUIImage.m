
#import "MQUIImage.h"


@interface __stretch_index : NSObject
{
    NSString* path;
    NSInteger leftCap;
    NSInteger topCapHeight;
}
@property (nonatomic, retain) NSString* path;
@property (nonatomic) NSInteger leftCapWidth;
@property (nonatomic) NSInteger topCapHeight;
@end

@implementation __stretch_index
@synthesize path;
@synthesize leftCapWidth;
@synthesize topCapHeight;
//-(void)dealloc
//{
//    [path release];
//    [super dealloc];
//}
-(BOOL)isEqual:(id)object
{
    if ([object isMemberOfClass:[__stretch_index class]])
    {
        return leftCapWidth==[object leftCapWidth]&&topCapHeight==[object topCapHeight]&&[path isEqualToString:[object path]];
    }
    return YES;
}
@end


@implementation UIImage(MQUIImage)

- (NSData*) getBMPImageDataToSize:(CGSize)size
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData = NULL;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = size.width;
    size_t height = size.height;
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace)
    {
        return nil;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData)
    {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    //Create bitmap context
    context = CGBitmapContextCreate(bitmapData, 
                                    width, 
                                    height, 
                                    bitsPerComponent, 
                                    bytesPerRow, 
                                    colorSpace, 
                                    1);	// RGBA
    if(!context)
    {
        free(bitmapData);
        bitmapData = NULL;
    }
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGColorSpaceRelease(colorSpace);
    
    if(!context)
    {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, self.CGImage);
    
    // Get a pointer to the data	
    unsigned char *bitmapData1 = (unsigned char *)CGBitmapContextGetData(context);
    
    // Copy the data and release the memory (return memory allocated with new)
    bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    
    NSData* newData = nil;
    
    if(bitmapData1)
    {
        int len = 54 + sizeof(unsigned char) * bytesPerRow * height;
        int area = width*height;
        newData = [[NSMutableData alloc] initWithLength:len];
        unsigned char* newBitmap = (unsigned char*)[newData bytes];
        
        height = -height;
        
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
    }
    
    CGContextRelease(context);
    free(bitmapData);
    
//    return [newData autorelease];
  return newData;
  
}

- (NSData*) getBMPImageData
{
    return [self getBMPImageDataToSize:self.size];
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) 
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    CGContextRestoreGState(ctx);
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)subImage:(UIImage *)image x:(float)_x y:(float)_y w:(float)_w h:(float)_h
{
    UIGraphicsBeginImageContext(CGSizeMake(_w, _h));
    [image drawInRect:CGRectMake(_x, _y, image.size.width, image.size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

- (UIImage*)scaleTo:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(5, 5));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    [color set];
    UIRectFill(CGRectMake(0, 0, 5, 5));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)topAndLeftPartImage:(UIImage *)image w:(CGFloat)_w h:(CGFloat)_h
{
    CGFloat image_w = image.size.width;
    CGFloat image_h = image.size.height;
    
    CGFloat w = image_w / _w;
    CGFloat h = image_h / _h;
    
    CGFloat scale = MIN(w, h);
    
    UIImage *_image = [image scaleTo:CGSizeMake(image_w / scale, image_h / scale)];
    _image = [UIImage subImage:_image x:0 y:0 w:_w h:_h];

    return _image;
}



- (UIImage*)blur
{
    // 高斯矩阵
    int gauss[] = { 1, 2, 1, 2, 4, 2, 1, 2, 1 };
    
    int width = [self size].width;
    int height = [self size].height;
    
    int pixR = 0;
    int pixG = 0;
    int pixB = 0;
        
    int newR = 0;
    int newG = 0;
    int newB = 0;
    
    int delta = 16; // 值越小图片会越亮，越大则越暗
    
    int idx = 0;
    unsigned char* pixels =  (unsigned char*)malloc(width*height*sizeof(unsigned char)*4);
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //Create bitmap context
    context = CGBitmapContextCreate(pixels,
                                    width,
                                    height,
                                    8,
                                    width*4,
                                    colorSpace,
                                    1);	// RGBA
    if(!context)
    {
        free(pixels);
        pixels = NULL;
    }
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGColorSpaceRelease(colorSpace);
    
    if(!context)
    {
        return nil;
    }

    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, self.CGImage);
    
    for (int i = 1, length = height - 1; i < length; i++)
    {
        for (int k = 1, len = width - 1; k < len; k++)
        {
            idx = 0;
            for (int m = -1; m <= 1; m++)
            {
                for (int n = -1; n <= 1; n++)
                {
                    int offset = ((i + m) * width + k + n)<<2;
                    pixR = pixels[offset+0];
                    pixG = pixels[offset+1];
                    pixB = pixels[offset+2];
                    //pixels[offset+3];//A
                    
                    newR = newR + (int) (pixR * gauss[idx]);
                    newG = newG + (int) (pixG * gauss[idx]);
                    newB = newB + (int) (pixB * gauss[idx]);
                    idx++;
                }
            }
            
            newR /= delta;
            newG /= delta;
            newB /= delta;
            
            newR = newR>255?255:newR;
            newG = newG>255?255:newG;
            newB = newB>255?255:newB;
            
            int offset = (i * width + k)<<2;
            pixels[offset+0] = newR;
            pixels[offset+1] = newG;
            pixels[offset+2] = newB;
            
            newR = 0;
            newG = 0;
            newB = 0;
        }
    }
        
    CGImageRef cgimg = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CFRelease(cgimg);
    CGContextRelease(context);
    free(pixels);

    return img;
}


- (UIImage*)blur:(double)sigma
{
    //
    sigma = sigma > 0 ? sigma : -sigma;
    //高斯核矩阵的大小为(6*sigma+1)*(6*sigma+1)
    //ksize为奇数
    int ksize = ceil(sigma * 3) * 2 + 1;
    
    //cout << "ksize=" <<ksize<<endl;
    //  dst.create(src.size(), src.type());
    if(ksize == 1)
    {
        return self;
    }
    
    //计算一维高斯核
    double *kernel = malloc(sizeof(double)*ksize);
    
    double scale = -0.5/(sigma*sigma);
    const double PI = 3.141592653;
    double cons = 1/sqrt(-scale / PI);
    
    double sum = 0;
    int kcenter = ksize/2;
    int i = 0;
    for(i = 0; i < ksize; i++)
    {
        int x = i - kcenter;
        *(kernel+i) = cons * exp(x * x * scale);//一维高斯函数
        sum += *(kernel+i);
        
    }
    //归一化,确保高斯权值在[0,1]之间
    for(i = 0; i < ksize; i++)
    {
        *(kernel+i) /= sum;
    }
    
    
    int width = [self size].width;
    int height = [self size].height;

    unsigned char* srcData =  (unsigned char*)malloc(width*height*sizeof(unsigned char)*4);
    unsigned char* tempData =  (unsigned char*)malloc(width*height*sizeof(unsigned char)*4);
    
    
    //ios代码，获取rgba颜色序列
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //Create bitmap context
    context = CGBitmapContextCreate(srcData,
                                    width,
                                    height,
                                    8,
                                    width*4,
                                    colorSpace,
                                    1);	// RGBA
    if(!context)
    {
        free(srcData);
        srcData = NULL;
        free(tempData);
        tempData = NULL;
        free(kernel);
        kernel = nil;
    }
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGColorSpaceRelease(colorSpace);
    
    if(!context)
    {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, self.CGImage);
    
    
    //x方向一维高斯模糊
    for(int y = 0; y < height; y++)
    {
        for(int x = 0; x < width; x++)
        {
            sum = 0;
            double bmul = 0, gmul = 0, rmul = 0;
            for(i = -kcenter; i <= kcenter; i++)
            {
                if((x+i) >= 0 && (x+i) < width)
                {
                    int offset = (y * width + x + i)<<2;

                    bmul += *(srcData+offset + 2)*(*(kernel+kcenter+i));
                    gmul += *(srcData+offset + 1)*(*(kernel+kcenter+i));
                    rmul += *(srcData+offset + 0)*(*(kernel+kcenter+i));
                    sum += (*(kernel+kcenter+i));
                }
            }
            int offset = (y * width + x)<<2;
            *(tempData+offset+2) = bmul/sum;
            *(tempData+offset+1) = gmul/sum;
            *(tempData+offset+0) = rmul/sum;
        }
    }
    
    
    //y方向一维高斯模糊
    for(int x = 0; x < width; x++)
    {
        for(int y = 0; y < height; y++)
        {
            sum = 0;
            double bmul = 0, gmul = 0, rmul = 0;
            for(i = -kcenter; i <= kcenter; i++)
            {
                if((y+i) >= 0 && (y+i) < height)
                {
                    int offset = ((y+i) * width + x)<<2;
                    
                    bmul += *(tempData+offset + 2)*(*(kernel+kcenter+i));
                    gmul += *(tempData+offset + 1)*(*(kernel+kcenter+i));
                    rmul += *(tempData+offset + 0)*(*(kernel+kcenter+i));
                    sum += (*(kernel+kcenter+i));
                }
            }
            int offset = (y * width + x)<<2;
            *(srcData+offset+2) = bmul/sum;
            *(srcData+offset+1) = gmul/sum;
            *(srcData+offset+0) = rmul/sum;
        }
    }
        
    CGImageRef cgimg = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(context);
    CFRelease(cgimg);
    
    free(srcData);
    free(tempData);
    free(kernel);
    
    return img;

};

@end
