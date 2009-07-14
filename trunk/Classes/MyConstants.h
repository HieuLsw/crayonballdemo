/*
 *  MyConstants.h
 *  CrayonBallDemo
 *
 *  Created by rick on 09-7-11.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef MyConstants_H
#define MyConstants_H

//碰撞状态
enum ContactState
{
	e_contactAdded,
	e_contactPersisted,
	e_contactRemoved,
};

//物理物体类型
enum BodyType{
	kTagBoosterBodyType,
	kTagBallBodyType,
	kTagSpinnerBodyType,
	kTagFlipFlopBodyType,
	kTagTipperBodyType,
	kTagFlipperBodyType,
	kTagStaticBodyType
};

/**
 * 每个图片的AtlasSpriteManager的Tag
 */
enum SpriteManagerTag{
	kTagSpinnerAtlasSpriteManager = 1,
	kTagBallsAtlasSpriteManager = 2,
	kTagFlipFlopSpriteManager = 3,
	kTagTipperSpriteManager = 4,
	kTagFlipperSpriteManager = 5
};
#endif