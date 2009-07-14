//
//  CrayonBallDemoAppDelegate.m
//  CrayonBallDemo
//
//  Created by 黄文俊 on 09-6-20.
//  本Demo借用的图片和音频归原作者所有
//

#import "AppDelegate.h"
#import "ShowLayer.h"

@implementation AppDelegate
@synthesize window;
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[window setUserInteractionEnabled:NO];
	[window setMultipleTouchEnabled:NO];
	
	Director* ccDirector = [Director sharedDirector];
	
	//设置横向显示
	[ccDirector setLandscape:YES];
	//设定每秒60帧
	[ccDirector setAnimationInterval:1.0f/60.0f];
	[ccDirector attachInWindow:window];
	
	//主scene
	Scene* mainScene = [Scene node];
	//背景Layer
	Layer* bgLayer = [Layer node];
	
	//背景Sprite
	Sprite* bgSprite = [Sprite spriteWithFile:@"back.png"];
	bgSprite.position =ccp(480.f/2,320.f/2); 
	[bgLayer addChild:bgSprite z:0];
	[mainScene addChild:bgLayer z:0];
	
	//显示层
	ShowLayer* showLayer = [ShowLayer node];
	[mainScene addChild:showLayer z:1];
	//将主Scene添加到Director
	[ccDirector runWithScene:mainScene];
	[window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];

    [super dealloc];
}


@end
