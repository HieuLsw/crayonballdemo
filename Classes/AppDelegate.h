//
//  CrayonBallDemoAppDelegate.h
//  CrayonBallDemo
//
//  Created by 黄文俊 on 09-6-20.
//  本Demo借用的图片和音频归原作者所有
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "AtlasSpriteManager.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
@private
	UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

