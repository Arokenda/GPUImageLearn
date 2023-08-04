//
//  OpenGLHelper.h
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLHelper : NSObject

+ (instancetype)shareInstance;
- (GLuint)genAndBindTextureWithImage:(UIImage *)image;
- (GLuint)genAndBindTextureWithText:(NSString *)text maxWidth:(CGFloat)maxWidth outWidth:(CGFloat *)outWidth outHeight:(CGFloat *)outHeight;
- (GLuint)createTextureFromText:(NSString*)txt;

@end

NS_ASSUME_NONNULL_END
