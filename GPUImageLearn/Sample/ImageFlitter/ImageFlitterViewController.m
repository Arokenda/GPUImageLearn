//
//  ImageFlitterViewController.m
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/12.
//

#import "ImageFlitterViewController.h"

#import <GPUImage/GPUImage.h>

#import "MyGrayFilter.h"

@interface ImageFlitterViewController ()

@end

@implementation ImageFlitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDefault];
}

- (void)setupDefault
{
    // 获取一张图片

    UIImage *inputImage = [UIImage imageNamed:@"xx.jpeg"];

    // 创建图片输入组件

    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    
    GPUImageZoomBlurFilter *zoomBlurFilter = [[GPUImageZoomBlurFilter alloc] init];
    [sourcePicture addTarget:zoomBlurFilter];

    // 创建素描滤镜

    MyGrayFilter *sketchFilter = [[MyGrayFilter alloc] init];

    // 把素描滤镜串联在图片输入组件之后

    [zoomBlurFilter addTarget:sketchFilter];

    // 创建ImageView输出组件

    GPUImageView *imageView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2.0)];

    [self.view addSubview:imageView];

    // 把ImageView输出组件串在滤镜链末尾

    [sketchFilter addTarget:imageView];
    
    GPUImageCannyEdgeDetectionFilter *toonFilter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    [sourcePicture addTarget:toonFilter];
    GPUImageView *imageView2 = [[GPUImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 2.0, self.view.frame.size.width, self.view.frame.size.height / 2.0)];

    [self.view addSubview:imageView2];
    [toonFilter addTarget:imageView2];

    // 调用图片输入组件的process方法，渲染结果就会绘制到imageView上

    [sourcePicture processImage];
}

@end
