//
//  SceneKitViewController.m
//  GPUImageLearn
//
//  Created by Arokenda on 2022/1/17.
//

#import "SceneKitViewController.h"
#import <SceneKit/SceneKit.h>
#import <GPUImage/GLProgram.h>

@interface SceneKitViewController ()
@property (nonatomic, strong) SCNView * scnView;
@property (nonatomic, assign) CGFloat   lastWidthRatio;
@property (nonatomic, assign) CGFloat   lastHeightRatio;
@property (nonatomic, strong) GLProgram *p;

@end

@implementation SceneKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}
- (void)createView {
    // 添加scenekit 游戏专用视图SCNView
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scnView ];
    self.scnView = scnView;
//    [self.view addSubview: self.scnView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scnView.autoenablesDefaultLighting = YES;
    self.scnView.allowsCameraControl = YES;
    
    self.scnView.scene = [SCNScene scene];

    SCNScene * scene = [SCNScene sceneNamed:@"art.scnassets/outward.dae"];
//    scene.rootNode.transform = SCNMatrix4MakeScale(0.8, 0.8, 0.8);
//    scene.rootNode.position = SCNVector3Make(0, 0, 0);
    
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    
    cameraNode.camera = camera;
//    cameraNode.camera.automaticallyAdjustsZRange = YES;
    cameraNode.position = SCNVector3Make(0, 0, 100);
    [self.scnView.scene.rootNode addChildNode:cameraNode];
//    cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -15); //the -15 here will become the rotation radius
//    SCNScene * rootScene = [[SCNScene alloc] init];
    for (SCNNode *node in scene.rootNode.childNodes) {
//            SCNBox *box1 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//            box1.firstMaterial.diffuse.contents = [UIImage imageNamed:@"bb.jpg"];
//        node.geometry = box1;
        [scnView.scene.rootNode addChildNode:node];
    }
//    [rootScene.rootNode addChildNode: cameraNode];
//    self.scnView.scene = rootScene;
    
//    [scnView.scene.rootNode addChildNode:scene.rootNode];
    
//    SCNBox *box1 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//    box1.firstMaterial.diffuse.contents = [UIImage imageNamed:@"bb.jpg"];
//    SCNNode *boxNode1 =[SCNNode node];
//    boxNode1.geometry = box1;
//    [scnView .scene.rootNode addChildNode:boxNode1];
//
//    SCNBox *box2 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//    box2.firstMaterial.diffuse.contents = [UIImage imageNamed:@"xx.jpeg"];
//    SCNNode *boxNode2 =[SCNNode node];
//    boxNode2.position = SCNVector3Make(0, 10, -20);
//    boxNode2.geometry = box2;
//    [scnView .scene.rootNode addChildNode:boxNode2];
    
//    self.scnView.scene.rootNode.
//    self.scnView.scene.rootNode.eulerAngles = SCNVector3Make(-100, -100, -100);

//SCNNode *cameraNode = [[SCNNode alloc] init];
//cameraNode.camera = [[SCNCamera alloc] init];
//    SCNNode *node = scene.rootNode;
//    NSArray * array = node.childNodes;
//cameraNode.position = SCNVector3Make(100, 500, 100);
//    [self.scnView.scene.rootNode addChildNode: cameraNode];
//    self.scnView.pointOfView = cameraNode.camera;
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scnViewPanGesture:)];
    [self.scnView addGestureRecognizer: panGesture];

}

- (void)scnViewPanGesture:(UIPanGestureRecognizer *)pan {
    

    UIView * panView = pan.view;
    //转换的位置
    CGPoint translation = [pan translationInView: panView];
    
    //左右方向的比例
    CGFloat widthRatio = translation.x / panView.frame.size.width + self.lastWidthRatio;

    CGFloat heightRatio = translation.y / panView.frame.size.height + self.lastHeightRatio;

    //上下方向的比例
//    let heightRatio = Float(translation.y) / Float(panView.frame.size.height) + lastHeightRatio
    //上下旋转
    //self.scenceView?.scene?.rootNode.eulerAngles.x = Float(-Double.pi) * heightRatio

    //左右旋转
    CGFloat ys = ((CGFloat)2 * M_PI) * widthRatio;
    CGFloat xs = (-M_PI) * heightRatio;
//    self.scnView.scene.rootNode.camera = SCNVector3Make(0, ys, 0);

    self.scnView.scene.rootNode.eulerAngles = SCNVector3Make(xs, ys, self.scnView.scene.rootNode.eulerAngles.z);

//    CGFloat temp = SCNVector3Make(0, 0, 0);
//    SCNVector3 * temp = [self.scnView.scene.rootNode eulerAngles];
    
//        SCNNode *rootBode = self.scnView.scene.rootNode;
//        [rootBode eulerAngles].y = ys;
//        self.scnView.scene.rootNode = rootBode;
//    self.scnView.scene.rootNode.eulerAngles.y = 2.f;
//    2((CGFloat)2 * M_PI) * widthRatio;

    if (pan.state == UIGestureRecognizerStateEnded) {
        self.lastWidthRatio = widthRatio;
        self.lastHeightRatio = heightRatio;
    }

}

@end
