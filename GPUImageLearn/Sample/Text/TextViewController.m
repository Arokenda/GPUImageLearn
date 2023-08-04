//
//  TextViewController.m
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/17.
//

#import "TextViewController.h"
#import "TextView.h"

@interface TextViewController ()

@property (nonatomic, strong) TextView *textView;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor purpleColor];
    [self setupDefault];
}

- (void)setupDefault
{
    self.textView = [[TextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.textView addGestureRecognizer:tap];
    
    TextView *textView2 = [[TextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:textView2];
    textView2.frame = CGRectMake(0, self.textView.frame.origin.y + self.textView.frame.size.height + 200, textView2.frame.size.width, textView2.frame.size.height);
    
}

- (void)onTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
        [[self displayLink] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)displayLinkCallback:(CADisplayLink *)sender
{
    [self.textView updateTime:sender.timestamp];
}

@end
