//
//  ShowLayer.h
//  CrayonBallDemo
//
//  Created by 黄文俊 on 09-6-20.
//  本Demo借用的图片和音频归原作者所有
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AtlasSpriteManager.h"
#import "Box2D.h"
#import "PASoundMgr.h"
#import "PASoundSource.h"

#import "MyContactListener.h"
#import "MyDestructionListener.h"
#import "MyBoundaryListener.h"

@interface ShowLayer : Layer {
@private
	b2World* mWorld;
	b2Body* mStaticBody;
	PASoundSource* bgTrack;
	
	MyContactListener* mContactListener;
	MyDestructionListener* mDestructionListener;
	MyBoundaryListener* mBoundaryListener;
}

@end
