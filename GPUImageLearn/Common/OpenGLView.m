//
//  OpenGLView.m
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/17.
//

#import "OpenGLView.h"
#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>
#import <GPUImage/GLProgram.h>

@interface OpenGLView()
{
    // The pixel dimensions of the CAEAGLLayer.
    GLint _backingWidth;
    GLint _backingHeight;
    
    GLuint _frameBufferHandle;
    GLuint _colorBufferHandle;
}
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLProgram *program;

@end

@implementation OpenGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupGL];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupGL];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    glViewport(0, 0, _backingWidth, _backingHeight);
}

- (void)setupGL
{
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking :[NSNumber numberWithBool:NO],
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8};
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    EAGLContext *preContext = [self useCurrentContext];
    
    glGenFramebuffers(1, &_frameBufferHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferHandle);
    
    glGenRenderbuffers(1, &_colorBufferHandle);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferHandle);
    
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBufferHandle);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
    glViewport(0, 0, _backingWidth, _backingHeight);
    [self restoreContext:preContext];
}

- (void)setupProgram:(GLProgram *)program
{
    self.program = program;
    [self.program link];
    [self.program use];
}

- (void)showRenderbuffer
{
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferHandle);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)render
{
    
}

- (EAGLContext *)useCurrentContext
{
    EAGLContext *preContext = [EAGLContext currentContext];
    [EAGLContext setCurrentContext:_context];
    return preContext;
}

- (void)restoreContext:(EAGLContext *)context
{
    [EAGLContext setCurrentContext:context];
}


@end
