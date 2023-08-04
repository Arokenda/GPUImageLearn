//
//  OpenGLView.h
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/17.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GLProgram.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLView : UIView
@property (nonatomic, strong, readonly) EAGLContext *context;
@property (nonatomic, strong, readonly) GLProgram *program;

- (void)setupGL;
- (void)setupProgram:(GLProgram *)program;
- (void)showRenderbuffer;

- (EAGLContext *)useCurrentContext;
- (void)restoreContext:(EAGLContext *)context;

@end

NS_ASSUME_NONNULL_END
