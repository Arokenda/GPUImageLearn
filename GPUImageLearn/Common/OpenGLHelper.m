//
//  OpenGLHelper.m
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/18.
//

#import "OpenGLHelper.h"
#import <GLKit/GLKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>



//from bit twiddling hacks
uint32_t nextPowerOfTwo(uint32_t v)
{
    v--;
    v |= v >> 1;
    v |= v >> 2;
    v |= v >> 4;
    v |= v >> 8;
    v |= v >> 16;
    v++;
    return v;
}

@implementation OpenGLHelper

+ (instancetype)shareInstance;
{
    static dispatch_once_t pred;
    static OpenGLHelper *instance = nil;
    
    dispatch_once(&pred, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


- (GLuint)genAndBindTextureWithImage:(UIImage *)image
{
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = image.CGImage;
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    // rgba共4个byte
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
    CGContextRef spriteContext =
    CGBitmapContextCreate(spriteData,
                          width,    //单位为像素
                          height,   //单位为像素
                          8,        //内存中像素的每个组件的位数
                          width * 4,//每一行在内存所占的比特数
                          CGImageGetColorSpace(spriteImage),
                          kCGImageAlphaPremultipliedLast);
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext,
                       CGRectMake(0, 0, width, height),
                       spriteImage);
    CGContextRelease(spriteContext);
    
    // 4绑定纹理到默认的纹理ID
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    // 纹理放大时，使用线性过滤(GL_NEAREST使用邻近过滤)
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    // 纹理缩小时，使用线性过滤
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // 纹理环绕方式
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);
    return texture;
}

- (GLuint)genAndBindTextureWithText:(NSString *)text maxWidth:(CGFloat)maxWidth outWidth:(nonnull CGFloat *)outWidth outHeight:(nonnull CGFloat *)outHeight
{
    //文字相关的属性都是由NSMutableAttributedString来设置的
    NSString *theString = @"君不见，黄河之水天上来，奔流到海不复回。君不见，高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。烹羊宰牛且为乐，会须一饮三百杯。岑夫子，丹丘生，将进酒，杯莫停。与君歌一曲，请君为我倾耳听。钟鼓馔玉不足贵，但愿长醉不复醒。古来圣贤皆寂寞，惟有饮者留其名。陈王昔时宴平乐，斗酒十千恣欢谑。主人何为言少钱，径须沽取对君酌。五花马，千金裘，呼儿将出换美酒，与尔同销万古愁。";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{
        NSForegroundColorAttributeName : [UIColor yellowColor],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:30]
    }];
//    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(4, 5)];
//    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:35] range:NSMakeRange(11, 4)];
//    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(3, 4)];
    
    //排版
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(maxWidth, CGFLOAT_MAX), NULL);
    
//    int imageWidth = nextPowerOfTwo(ceil(suggestedSize.width));
    int imageWidth = ceil(suggestedSize.width);
//    int imageHeight = nextPowerOfTwo(ceil(suggestedSize.height));
    int imageHeight = ceil(suggestedSize.height);
    *outWidth = imageWidth;
    *outHeight = imageHeight;
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast|kCGImageByteOrder32Big;
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    int bitsPerComponent = 8;
    int bytesPerPixel = 4;
    int bytesPerRow = imageWidth * bytesPerPixel;
    void *rawData = calloc(imageHeight * imageWidth * bytesPerPixel, sizeof(uint8_t));
    CGContextRef context = CGBitmapContextCreate(rawData, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, rgbColorSpace, bitmapInfo);
        
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//        //向上平移一个视图高度的距离
//    CGContextTranslateCTM(context, 0, rect.size.height);
//        //围绕x轴的翻转
//    CGContextScaleCTM(context, 1.0, -1.0);
      
        // 创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, imageWidth, imageHeight));
        
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        
    UIGraphicsPushContext(context);
//    CGContextSetFillColorWithColor(context, [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor);
//    CGContextFillRect(context, CGRectMake(0, 0, imageWidth, imageHeight));
        //整个区域绘制
    CTFrameDraw(frame, context);
    UIGraphicsPopContext();
    
//    CGImageRef imageRef = CGBitmapContextCreateImage(context);
//    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    
    GLuint textureID;
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, imageWidth, imageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, rawData);
        
        //释放
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    free(rawData);
    
    return textureID;
//    
//
//    
//    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, rect);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil);
//    int imageWidth = nextPowerOfTwo(ceil(CGRectGetWidth(rect)));
//    int imageHeight = nextPowerOfTwo(ceil(CGRectGetHeight(rect)));
////    GLubyte * rawData = (GLubyte *) calloc(imageWidth * imageHeight * 4, sizeof(GLubyte));
////    void *rawData = malloc(imageWidth * imageHeight * 4);
//    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast|kCGImageByteOrder32Big;
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    int bitsPerComponent = 8;
//    int bytesPerPixel = 4;
//    int bytesPerRow = imageWidth * bytesPerPixel;
//    void *rawData = calloc(imageHeight * imageWidth * bytesPerPixel, sizeof(uint8_t));
//    CGContextRef context = CGBitmapContextCreate(rawData, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, rgbColorSpace, bitmapInfo);
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CTFrameDraw(NULL, context);
//    UIGraphicsEndImageContext();
//    
////    UIImage *sprite = [UIImage imageNamed:@"xx.jpeg"];
////    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height),sprite.CGImage);
//    
//    
////    UIImage
////    CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL, rawData, imageWidth * imageHeight * 4 * sizeof(GLubyte), NULL);
////    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, bitsPerComponent, 8, bytesPerRow, rgbColorSpace, bitmapInfo, providerRef, nil, false, kCGRenderingIntentDefault);
////    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
//    //end UIImage
//    
//    GLuint textureID;
//    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
//    glGenTextures(1, &textureID);
//
//    glBindTexture(GL_TEXTURE_2D, textureID);
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, imageWidth, imageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, rawData);
//    
//    free(rawData);
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
//    return textureID;
    
}

- (GLuint)createTextureFromText:(NSString*)txt
//(const char* text, const sRGBA &rgba, int &out_width, int &out_height)
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:32.0f];

    CGSize renderedSize = [txt sizeWithFont:font];

    const uint32_t height = nextPowerOfTwo((int)renderedSize.height); //out_height = height;
    const uint32_t width = nextPowerOfTwo((int) renderedSize.width); //out_width = width;
    const int bitsPerElement = 8;
    int sizeInBytes = height*width*4;
    int texturePitch = width*4;
//    uint8_t *data = new uint8_t[sizeInBytes];
    uint8_t *data = malloc(sizeInBytes);
    memset(data, 0x00, sizeInBytes);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerElement, texturePitch, colorSpace, kCGImageAlphaPremultipliedLast);

    CGContextSetTextDrawingMode(context, kCGTextFillStroke);

    CGFloat components[4] = { 1.0, 0.0, 0.0, 1.0 };
    CGColorRef color = CGColorCreate(colorSpace, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetFillColorWithColor(context, color);
    CGColorRelease(color);
    CGContextTranslateCTM(context, 0.0f, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    UIGraphicsPushContext(context);

    [txt drawInRect:CGRectMake(0, 0, width, height) withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];

    UIGraphicsPopContext();
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    GLuint textureID;
    glGenTextures(1, &textureID);

    glBindTexture(GL_TEXTURE_2D, textureID);

    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);

    free(data);

    return textureID;
}


@end
