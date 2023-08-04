#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CubeCameraESRenderer.h"
#import "CubeCameraES2Renderer.h"
#import "GPUImage.h"

@interface CubeCameraViewController : UIViewController
{
    CGPoint lastMovementPosition;
@private
    CubeCameraES2Renderer *renderer;
    GPUImageTextureInput *textureInput;
    GPUImageFilter *filter;
    
    NSDate *startTime;
}

- (void)drawView:(id)sender;

@end
