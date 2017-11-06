//
//  ViewController.h
//  ARKitVR
//
//  Created by arplanet on 2017/11/6.
//  Copyright © 2017年 Walter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ViewController : UIViewController

@property(nonatomic, strong)ARSCNView *arSCNView;
@property(nonatomic, strong)ARConfiguration *arConfiguration;

@end

