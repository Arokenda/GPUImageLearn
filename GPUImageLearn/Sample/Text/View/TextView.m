//
//  TextView.m
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/18.
//

#import "TextView.h"
#import <GLKit/GLKit.h>
#import "OpenGLHelper.h"
#import <AVFoundation/AVUtilities.h>

@interface TextView()

@property (nonatomic, assign) GLuint texture;
@property (nonatomic, assign) CGSize presentationRect;

@end

@implementation TextView

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)setupGL
{
    self.backgroundColor = [UIColor clearColor];
    [super setupGL];
    EAGLContext *preContext = [self useCurrentContext];
    
    [self setupProgram:[[GLProgram alloc] initWithVertexShaderFilename:@"TextViewShader" fragmentShaderFilename:@"TextViewShader"]];
    
    [self.program addAttribute:@"TexCoordIn"];
    [self.program addAttribute:@"Position"];
    
//    UIImage *image = [UIImage imageNamed:@"heart.png"];
//    self.presentationRect = image.size;
//    self.texture = [[OpenGLHelper shareInstance] genAndBindTextureWithImage:image];

    CGFloat outWidth;
    CGFloat outHeight;
    self.texture = [[OpenGLHelper shareInstance] genAndBindTextureWithText:@"Arokenda is a hansome boy !!!!!,Test Test Test Test Test!!!!!" maxWidth:self.bounds.size.width outWidth:&outWidth outHeight:&outHeight];
    self.frame = CGRectMake(0, 200, outWidth, outHeight);
    self.presentationRect = CGSizeMake(outWidth, outHeight);
//    self.texture = [[OpenGLHelper shareInstance] createTextureFromText:@"Arokenda Arokenda is a hansome boy!!!!"];
    
    [self setupBuffers];
    
    [self render];
    [self restoreContext:preContext];
}

- (void)setupBuffers
{
    glDisable(GL_DEPTH_TEST);
    
    glEnableVertexAttribArray([self.program attributeIndex:@"Position"]);
    glVertexAttribPointer([self.program attributeIndex:@"Position"], 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), 0);
    
    glEnableVertexAttribArray([self.program attributeIndex:@"TexCoordIn"]);
    glVertexAttribPointer([self.program attributeIndex:@"TexCoordIn"], 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), 0);

}

- (void)render {
    glClearColor(1.0, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGRect vertexSamplingRect = AVMakeRectWithAspectRatioInsideRect(self.presentationRect, self.layer.bounds);
    
    // Compute normalized quad coordinates to draw the frame into.
    CGSize normalizedSamplingSize = CGSizeMake(0.0, 0.0);
    CGSize cropScaleAmount = CGSizeMake(vertexSamplingRect.size.width/self.layer.bounds.size.width, vertexSamplingRect.size.height/self.layer.bounds.size.height);
    
    // Normalize the quad vertices.
    if (cropScaleAmount.width > cropScaleAmount.height) {
        normalizedSamplingSize.width = 1.0;
        normalizedSamplingSize.height = cropScaleAmount.height/cropScaleAmount.width;
    }
    else {
        normalizedSamplingSize.width = 1.0;
        normalizedSamplingSize.height = cropScaleAmount.width/cropScaleAmount.height;
    }
    
    /*
     The quad vertex data defines the region of 2D plane onto which we draw our pixel buffers.
     Vertex data formed using (-1,-1) and (1,1) as the bottom left and top right coordinates respectively, covers the entire screen.
     */
    GLfloat quadVertexData [] = {
        -1 * normalizedSamplingSize.width, -1 * normalizedSamplingSize.height,
        normalizedSamplingSize.width, -1 * normalizedSamplingSize.height,
        -1 * normalizedSamplingSize.width, normalizedSamplingSize.height,
        normalizedSamplingSize.width, normalizedSamplingSize.height,
    };
    
    // Update attribute values.
    glVertexAttribPointer([self.program attributeIndex:@"Position"], 2, GL_FLOAT, 0, 0, quadVertexData);
    glEnableVertexAttribArray([self.program attributeIndex:@"Position"]);
    
    /*
     The texture vertices are set up such that we flip the texture vertically. This is so that our top left origin buffers match OpenGL's bottom left texture coordinate system.
     */
    CGRect textureSamplingRect = CGRectMake(0, 0, 1, 1);
    GLfloat quadTextureData[] =  {
        CGRectGetMinX(textureSamplingRect), CGRectGetMaxY(textureSamplingRect),
        CGRectGetMaxX(textureSamplingRect), CGRectGetMaxY(textureSamplingRect),
        CGRectGetMinX(textureSamplingRect), CGRectGetMinY(textureSamplingRect),
        CGRectGetMaxX(textureSamplingRect), CGRectGetMinY(textureSamplingRect)
    };
    
    glVertexAttribPointer([self.program attributeIndex:@"TexCoordIn"], 2, GL_FLOAT, 0, 0, quadTextureData);
    glEnableVertexAttribArray([self.program attributeIndex:@"TexCoordIn"]);
    
//    glEnable(GL_ALPHA);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [self showRenderbuffer];
    
}

#pragma mark - public

- (void)updateTime:(NSTimeInterval)dt
{
    GLint time = [self.program uniformIndex:@"Time"];
    glUniform1f(time, dt);
    [self render];
}

@end
