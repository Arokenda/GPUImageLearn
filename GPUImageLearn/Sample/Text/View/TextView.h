//
//  TextView.h
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/18.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextView : OpenGLView

- (void)updateTime:(NSTimeInterval)dt;

@end

NS_ASSUME_NONNULL_END
