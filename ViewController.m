//
//  ViewController.m
//  ARKitVR
//
//  Created by arplanet on 2017/11/6.
//  Copyright © 2017年 Walter. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<ARSCNViewDelegate,ARSessionDelegate,SCNSceneRendererDelegate>{
    SCNNode *_cameraNode;
    matrix_float4x4 _transform;
}

@end

@implementation ViewController
#pragma mark- Init
-(ARSCNView *)arSCNView{
    if(_arSCNView != nil)
        return _arSCNView;
    _arSCNView = [[ARSCNView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _arSCNView.automaticallyUpdatesLighting = YES;
    _arSCNView.showsStatistics = YES;
    _arSCNView.delegate = self;
    _arSCNView.session.delegate = self;
    return _arSCNView;
}

-(ARConfiguration *)arConfiguration{
    if(_arConfiguration != nil)
        return _arConfiguration;
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
//    configuration.lightEstimationEnabled  =YES;
//    configuration.planeDetection = ARPlaneDetectionHorizontal;
    _arConfiguration = configuration;
    return _arConfiguration;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:self.arSCNView];
    [self.arSCNView.session runWithConfiguration:self.arConfiguration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    SCNScene *ARScene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
//    self.arSCNView.scene = ARScene;
    
    // VR init
    SCNScene *VRScene = [SCNScene sceneNamed:@"art.scnassets/CubeScene.scn"];
    self.arSCNView.scene = VRScene;
    _cameraNode = [SCNNode node];
//    _cameraNode.camera = [SCNCamera camera];
    _cameraNode.camera = self.arSCNView.scene.rootNode.camera;
    [_cameraNode setPosition:SCNVector3Make(0, 0, 0)];
//    [VRScene.rootNode addChildNode:_cameraNode];
    [self.arSCNView.scene.rootNode addChildNode:_cameraNode];
    
    SCNNode *cameraNodeLeft = [SCNNode node];
    cameraNodeLeft.camera = [SCNCamera camera];
    [cameraNodeLeft.camera setZNear:0.001f];
    [cameraNodeLeft setPosition:SCNVector3Make(-0.05, 0, 0)];
    [_cameraNode addChildNode:cameraNodeLeft];
    
    SCNNode *cameraNodeRight = [SCNNode node];
    cameraNodeRight.camera = [SCNCamera camera];
    [cameraNodeRight.camera setZNear:0.001f];
    [cameraNodeRight setPosition:SCNVector3Make(0.05, 0, 0)];
    [_cameraNode addChildNode:cameraNodeRight];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
    
    SCNView *scnViewLeft = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, screenWidth * 0.5, screenHeight)];
    scnViewLeft.pointOfView = cameraNodeLeft;
//    scnViewLeft.scene = VRScene;
    scnViewLeft.scene = self.arSCNView.scene;
//    scnViewLeft.backgroundColor = [UIColor blueColor];
    [self.arSCNView addSubview:scnViewLeft];
    
    SCNView *scnViewRight = [[SCNView alloc] initWithFrame:CGRectMake(screenWidth * 0.5, 0, screenWidth * 0.5, screenHeight)];
    scnViewRight.pointOfView = cameraNodeRight;
//    scnViewRight.scene = VRScene;
    scnViewRight.scene = self.arSCNView.scene;
//    [scnViewRight setBackgroundColor:[UIColor blackColor]];
    [self.arSCNView addSubview:scnViewRight];
    
    scnViewLeft.delegate = self;
    scnViewRight.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.arSCNView.session pause];
}

#pragma mark- ARSCNViewDelegate
-(void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame{
    _transform = frame.camera.transform;
    [_cameraNode setTransform:SCNMatrix4FromMat4(_transform)];
}
@end
