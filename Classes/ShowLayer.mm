//
//  ShowLayer.m
//  CrayonBallDemo
//
//  Created by 黄文俊 on 09-6-20.
//  本Demo借用的图片和音频归原作者所有
//
//所有墙壁的摩擦系数
#define WALL_FRICTION 0.1f

#define PTM_RATIO 32
#include <set>
#import "ShowLayer.h"
#import "MyConstants.h"
#import "BodyUserData.h"
#import "MyAtlasSprite.h"

@implementation ShowLayer

/**
 创建spinner
  */
-(void) addSpinnerSpriteBodyX:(float) x y:(float) y{
	//初始化AtlasSpriteManager，并创建spinner的sprite
	Texture2D* textSpinner = [[TextureMgr sharedTextureMgr] addImage:@"spinner.png"];
	AtlasSpriteManager* altSptMgr = [AtlasSpriteManager  spriteManagerWithTexture:textSpinner];
	[self addChild:altSptMgr z:0 tag:kTagSpinnerAtlasSpriteManager];
	AtlasSprite* spinnerActor = [AtlasSprite spriteWithRect:CGRectMake(0,0,50,50) spriteManager:altSptMgr];
	spinnerActor.position = ccp(x,y);
	[altSptMgr addChild:spinnerActor z:0];
	
	//创建spinner的body
	{
		b2BodyDef bodyDef;
		bodyDef.position.Set(x/PTM_RATIO,y/PTM_RATIO);
		BodyType bodyType = kTagSpinnerBodyType;
		BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:bodyType AtlasSprite:spinnerActor AtlasSpriteManager:altSptMgr];
		bodyDef.userData = static_cast<void*> (userData);
		b2Body* body = mWorld->CreateBody(&bodyDef);
		
		b2PolygonDef sd;
		sd.density = 2.5f;
		sd.vertexCount = 3;
		
		//Shape1
		sd.vertices[0].Set(10.0f/PTM_RATIO,0.f);
		sd.vertices[1].Set(0.f,23.0f/PTM_RATIO);
		sd.vertices[2].Set(0.f,0.f);
		body->CreateShape(&sd);
		
		//Shape2
		sd.vertices[0].Set(0.f,-10.0f/PTM_RATIO);
		sd.vertices[1].Set(23.0f/PTM_RATIO,0.f);
		sd.vertices[2].Set(0.f,0.f);
		body->CreateShape(&sd);
		
		//Shape3
		sd.vertices[0].Set(-10.0f/PTM_RATIO,0.f);
		sd.vertices[1].Set(0.f,-23.f/PTM_RATIO);
		sd.vertices[2].Set(0.f,0.f);
		body->CreateShape(&sd);
		
		//Shape4
		sd.vertices[0].Set(0.f,10.f/PTM_RATIO);
		sd.vertices[1].Set(-23.f/PTM_RATIO,0.f);
		sd.vertices[2].Set(0.f,0.f);
		body->CreateShape(&sd);
		
		//根据shape来计算body的质量
		body->SetMassFromShapes();
		
		//创建转动轴,使得spinner能不断的旋转
		b2RevoluteJointDef jointDef;
		jointDef.Initialize(mStaticBody,body,body->GetWorldCenter());
		jointDef.motorSpeed = 4.0f;
		jointDef.maxMotorTorque = 70000.f;
		jointDef.enableMotor = true;
		mWorld->CreateJoint(&jointDef);
	}
}

-(void) addFlipflopSpriteBodyX:(float)x y:(float)y{
	Texture2D* textFlipflop = [[TextureMgr sharedTextureMgr] addImage:@"flip_flop.png"];
	AtlasSpriteManager* altSptMgr = [AtlasSpriteManager  spriteManagerWithTexture:textFlipflop];
	[self addChild:altSptMgr z:0 tag:kTagFlipFlopSpriteManager];
	AtlasSprite* flipFlopActor = [AtlasSprite spriteWithRect:CGRectMake(0,0,25,24) spriteManager:altSptMgr];
	flipFlopActor.position = ccp(x,y);
	[altSptMgr addChild:flipFlopActor z:0];
	
	{
		//定义flipflop的物理物体
		b2BodyDef bodyDef;
		bodyDef.position.Set(x/PTM_RATIO,y/PTM_RATIO);
		BodyType bodyType = kTagFlipFlopBodyType;
		BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:bodyType AtlasSprite:flipFlopActor AtlasSpriteManager:altSptMgr];
		bodyDef.userData = static_cast<void*> (userData);
		b2Body* body = mWorld->CreateBody(&bodyDef);
		
		//定义flipflop物体的shape
		//Shape1
		b2PolygonDef shapeDef;
		shapeDef.vertexCount = 4;
		shapeDef.density = 2.5f;
		shapeDef.vertices[0].Set(-1.5f/PTM_RATIO,0.f);
		shapeDef.vertices[1].Set(1.5f/PTM_RATIO,0.f);
		shapeDef.vertices[2].Set(1.5f/PTM_RATIO,12.f/PTM_RATIO);
		shapeDef.vertices[3].Set(-1.5f/PTM_RATIO,12.f/PTM_RATIO);
		body->CreateShape(&shapeDef);
		
		//Shape2
		shapeDef.vertices[0].Set(-12.f/PTM_RATIO,-1.5f/PTM_RATIO);
		shapeDef.vertices[1].Set(12.f/PTM_RATIO,-1.5f/PTM_RATIO);
		shapeDef.vertices[2].Set(12.f/PTM_RATIO,1.5f/PTM_RATIO);
		shapeDef.vertices[3].Set(-12.f/PTM_RATIO,1.5f/PTM_RATIO);
		body->CreateShape(&shapeDef);
		
		body->SetMassFromShapes();
		//创建flipflop的转动joint
		b2RevoluteJointDef jointDef;
		jointDef.Initialize(mStaticBody,body,body->GetWorldCenter());
		jointDef.maxMotorTorque = 0.f;
		jointDef.enableMotor = true;
		jointDef.enableLimit = true;
		jointDef.lowerAngle = CC_DEGREES_TO_RADIANS(-45.f);//最小转动角度为-45度
		jointDef.upperAngle = CC_DEGREES_TO_RADIANS(45.f);//最大转动角度为10度
		mWorld->CreateJoint(&jointDef);
	}
}

/**
  创建地图中所有的"墙壁"
  */
-(void) addStaticBodyWallShape{
	b2EdgeChainDef wallShapeDef;
	b2Vec2 points[2];
	wallShapeDef.friction = WALL_FRICTION;
	wallShapeDef.isALoop = false;
	wallShapeDef.vertices = points;
	wallShapeDef.vertexCount = 2;
	
	/*顶层的斜坡*/
	points[0].Set(442.f/PTM_RATIO,310.f/PTM_RATIO);
	points[1].Set(180.f/PTM_RATIO,300.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	//顶层斜坡右边的矮墙
	points[0].Set(442.f/PTM_RATIO,320.f/PTM_RATIO);
	points[1].Set(442.f/PTM_RATIO,310.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	//顶层斜坡左边的小斜坡
	points[0].Set(180.f/PTM_RATIO,300.f/PTM_RATIO);
	points[1].Set(160.f/PTM_RATIO,277.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	/*顶层通道*/
	points[0].Set(343.f/PTM_RATIO,243.f/PTM_RATIO);
	points[1].Set(282.f/PTM_RATIO,251.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	//通道左侧的墙壁
	points[0].Set(136.f/PTM_RATIO,263.f/PTM_RATIO);
	points[1].Set(136.f/PTM_RATIO,320.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	//通道右侧的墙壁
	points[0].Set(160.f/PTM_RATIO,277.f/PTM_RATIO);
	points[1].Set(160.f/PTM_RATIO,258.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);

	//底部喷射器通道
	points[0].Set(200.f/PTM_RATIO,213.f/PTM_RATIO);
	points[1].Set(172.f/PTM_RATIO,87.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	points[0].Set(147.f/PTM_RATIO,83.f/PTM_RATIO);
	points[1].Set(147.f/PTM_RATIO,60.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	points[0].Set(171.f/PTM_RATIO,51.f/PTM_RATIO);
	points[1].Set(147.f/PTM_RATIO,60.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);	
	
	/*底部的右边的通道*/
	points[0].Set(365.f/PTM_RATIO,285.f/PTM_RATIO);
	points[1].Set(365.f/PTM_RATIO,244.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	points[0].Set(440.f/PTM_RATIO,182.f/PTM_RATIO);
	points[1].Set(440.f/PTM_RATIO,128.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	points[0].Set(440.f/PTM_RATIO,128.f/PTM_RATIO);
	points[1].Set(283.f/PTM_RATIO,109.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	points[0].Set(239.f/PTM_RATIO,0.f/PTM_RATIO);
	points[1].Set(239.f/PTM_RATIO,129.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	points[0].Set(400.f/PTM_RATIO,42.f/PTM_RATIO);
	points[1].Set(239.f/PTM_RATIO,64.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
	
	points[0].Set(440.f/PTM_RATIO,56.f/PTM_RATIO);
	points[1].Set(440.f/PTM_RATIO,0.f/PTM_RATIO);
	mStaticBody->CreateShape(&wallShapeDef);
}

/**
 * 添加底部喷射器body
 */
-(void) addBoosterBody{
	b2BodyDef bodyDef;
	bodyDef.position.Set(199.f/PTM_RATIO,21.f/PTM_RATIO);
	BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:kTagBoosterBodyType AtlasSprite:nil AtlasSpriteManager:nil];
	bodyDef.userData = static_cast<void*>(userData);
	b2Body* body = mWorld->CreateBody(&bodyDef);

	b2EdgeChainDef shapeDef;
	shapeDef.friction = WALL_FRICTION;
	shapeDef.vertexCount = 2;
	shapeDef.isALoop = false;
	b2Vec2 points[2];
	points[0].Set(19.f/PTM_RATIO,0.f/PTM_RATIO);
	points[1].Set(-19.f/PTM_RATIO,0.f/PTM_RATIO);
	
	shapeDef.vertices = points;
	body->CreateShape(&shapeDef);
}


-(void) addTipperBodyX:(float)x y:(float) y{	
	//添加Sprite
	AtlasSpriteManager* altSptMgr = (AtlasSpriteManager*)[self getChildByTag:kTagTipperSpriteManager];
	if (altSptMgr==nil){
		Texture2D* texture = [[TextureMgr sharedTextureMgr] addImage:@"tipper.png"];
		altSptMgr = [AtlasSpriteManager spriteManagerWithTexture:texture];
		[self addChild:altSptMgr z:0 tag:kTagTipperSpriteManager];
	}
	AtlasSprite* sprite = [AtlasSprite spriteWithRect:CGRectMake(0,0,91,32) spriteManager:altSptMgr];
	[altSptMgr addChild:sprite z:0];
	
	//添加物理body
	b2BodyDef bodyDef;
	bodyDef.position.Set(x/PTM_RATIO,y/PTM_RATIO);
	BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:kTagTipperBodyType AtlasSprite:sprite AtlasSpriteManager:altSptMgr];
	bodyDef.userData = static_cast<void*>(userData);
	b2Body* tipperBody = mWorld->CreateBody(&bodyDef);
	
	b2EdgeChainDef shapeDef;
	b2Vec2 points[2];
	shapeDef.vertexCount = 2;
	shapeDef.isALoop = false;
	shapeDef.vertices = points;
	shapeDef.friction = WALL_FRICTION;
	points[0].Set(-45.5f/PTM_RATIO,-1.f/PTM_RATIO);
	points[1].Set(-45.5f/PTM_RATIO,16.f/PTM_RATIO);
	tipperBody->CreateShape(&shapeDef);
	
	b2PolygonDef shape1Def;
	shape1Def.SetAsBox(45.f/PTM_RATIO,2.f/PTM_RATIO,b2Vec2(0.f,-2.f/PTM_RATIO),0.f);
	shape1Def.density = 2.5f;
	tipperBody->CreateShape(&shape1Def);
	
	tipperBody->SetMassFromShapes();//计算物体的重量
	
	//添加转动轴，使得tipper可以绕转动轴转动
	b2RevoluteJointDef jointDef;
	jointDef.Initialize(mStaticBody,tipperBody,tipperBody->GetWorldPoint(b2Vec2(-45.5f/PTM_RATIO,-1.f/PTM_RATIO)));
	jointDef.enableLimit = true;
	jointDef.upperAngle = CC_DEGREES_TO_RADIANS(10.f);
	jointDef.lowerAngle = -1*CC_DEGREES_TO_RADIANS(45.f);
	jointDef.enableMotor = true;
	jointDef.motorSpeed = 0.5f;
	jointDef.maxMotorTorque = 60.f;
	mWorld->CreateJoint(&jointDef);
	
	//设置sprite的位置和转动角度
	sprite.position = ccp(x,y);	
}

/**
  * 添加一个Flipper
  */
-(void) addFlipperBodyX:(float)x y:(float) y{
	//添加Sprite
	AtlasSpriteManager* altSptMgr = (AtlasSpriteManager*)[self getChildByTag:kTagFlipperSpriteManager];
	if (altSptMgr==nil){
		Texture2D* texture = [[TextureMgr sharedTextureMgr] addImage:@"flipper.png"];
		altSptMgr = [AtlasSpriteManager spriteManagerWithTexture:texture];
		[self addChild:altSptMgr z:0 tag:kTagFlipperSpriteManager];
	}
	
	AtlasSprite* flipperSpt = [AtlasSprite spriteWithRect:CGRectMake(0,0,34,19) spriteManager:altSptMgr];
	[altSptMgr addChild:flipperSpt z:0];
	
	//添加物理Body
	b2BodyDef bodyDef;
	bodyDef.position.Set(x/PTM_RATIO,y/PTM_RATIO);
	BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:kTagFlipperBodyType AtlasSprite:flipperSpt AtlasSpriteManager:altSptMgr];
	bodyDef.userData = static_cast<void*>(userData);
	b2Body* body = mWorld->CreateBody(&bodyDef);
	
	b2PolygonDef shapeDef;
	shapeDef.density = 2.5f;
	shapeDef.vertexCount = 4;
	shapeDef.friction = WALL_FRICTION;
	shapeDef.vertices[0].Set(-7.9f/PTM_RATIO,0.f);
	shapeDef.vertices[1].Set(17.f/PTM_RATIO,9.f/PTM_RATIO);
	shapeDef.vertices[2].Set(17.f/PTM_RATIO,9.5f/PTM_RATIO);
	shapeDef.vertices[3].Set(-7.f/PTM_RATIO,9.5f/PTM_RATIO);
	
	body->CreateShape(&shapeDef);
	body->SetMassFromShapes();
	
	//增加转动轴
	b2RevoluteJointDef jointDef;
	jointDef.Initialize(mStaticBody,body,body->GetWorldPoint(b2Vec2(-7.f/PTM_RATIO,9.5f/PTM_RATIO)));
	jointDef.enableLimit = true;
	jointDef.lowerAngle = -1*CC_DEGREES_TO_RADIANS(90.f);
	jointDef.motorSpeed = 5.0f;
	jointDef.enableMotor = true;
	jointDef.maxMotorTorque = 2.5f;
	mWorld->CreateJoint(&jointDef);
	
	flipperSpt.position = ccp(x,y);
	flipperSpt.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());//Box2D的转动方向时逆时针为正，cocos2d为顺时针为正，所以需要×-1
}

-(void) addReversedFlipperBodyX:(float)x y:(float) y{
	//添加Sprite
	AtlasSpriteManager* altSptMgr = (AtlasSpriteManager*)[self getChildByTag:kTagFlipperSpriteManager];
	if (altSptMgr==nil){
		Texture2D* texture = [[TextureMgr sharedTextureMgr] addImage:@"flipper.png"];
		altSptMgr = [AtlasSpriteManager spriteManagerWithTexture:texture];
		[self addChild:altSptMgr z:0 tag:kTagFlipperSpriteManager];
	}
	
	AtlasSprite* flipperSpt = [AtlasSprite spriteWithRect:CGRectMake(0,0,34,19) spriteManager:altSptMgr];
	flipperSpt.flipX = YES;
	[altSptMgr addChild:flipperSpt z:0];
	
	//添加物理Body
	b2BodyDef bodyDef;
	bodyDef.position.Set(x/PTM_RATIO,y/PTM_RATIO);
	BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:kTagFlipperBodyType AtlasSprite:flipperSpt AtlasSpriteManager:altSptMgr];
	bodyDef.userData = static_cast<void*>(userData);
	b2Body* body = mWorld->CreateBody(&bodyDef);
	
	b2PolygonDef shapeDef;
	shapeDef.friction = WALL_FRICTION;
	shapeDef.vertexCount = 4;
	shapeDef.density = 2.5f;
	shapeDef.vertices[0].Set(7.f/PTM_RATIO,9.5f/PTM_RATIO);
	shapeDef.vertices[1].Set(-17.f/PTM_RATIO,9.5f/PTM_RATIO);
	shapeDef.vertices[2].Set(-17.f/PTM_RATIO,9.f/PTM_RATIO);
	shapeDef.vertices[3].Set(7.9f/PTM_RATIO,0.f);
	
	body->CreateShape(&shapeDef);
	body->SetMassFromShapes();
	
	//增加转动轴
	b2RevoluteJointDef jointDef;
	jointDef.Initialize(mStaticBody,body,body->GetWorldPoint(b2Vec2(7.f/PTM_RATIO,9.5f/PTM_RATIO)));
	jointDef.enableLimit = true;
	jointDef.upperAngle = CC_DEGREES_TO_RADIANS(90.f);
	jointDef.motorSpeed = -5.0f;
	jointDef.enableMotor = true;
	jointDef.maxMotorTorque = 2.5f;
	mWorld->CreateJoint(&jointDef);
	
	flipperSpt.position = ccp(x,y);
	flipperSpt.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());//Box2D的转动方向时逆时针为正，cocos2d为顺时针为正，所以需要×-1
}

-(id) init{
	if (self=[super init]){
		//初始化Box2D
		CGSize screenSize = [Director sharedDirector].winSize;
		
		//创建物理世界
		b2AABB worldRect;
		float borderSize = 96;//使得物理世界有96长度的缩进值
		worldRect.lowerBound.Set(-borderSize/PTM_RATIO,-borderSize/PTM_RATIO);
		worldRect.upperBound.Set((screenSize.width+borderSize)/PTM_RATIO,(screenSize.height+borderSize)/PTM_RATIO);

		b2Vec2 gravity(0.0f,-10.0f);//重力加速度，10牛
		bool doSleep = true;
		mWorld = new b2World(worldRect,gravity,doSleep);
		{
			//创建一个静态的body
			b2BodyDef bd;
			bd.position.Set(0.f,0.f);
			BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:kTagStaticBodyType];
			bd.userData = static_cast<void*>(userData);
			mStaticBody = mWorld->CreateBody(&bd);
		}
		mContactListener = new MyContactListener;
		mDestructionListener = new MyDestructionListener;
		mBoundaryListener = new MyBoundaryListener;
		mWorld->SetContactListener(mContactListener);
		mWorld->SetDestructionListener(mDestructionListener);
		mWorld->SetBoundaryListener(mBoundaryListener);
		
		[self addSpinnerSpriteBodyX:321 y:304];
		[self addFlipflopSpriteBodyX:148 y:210];
		[self addTipperBodyX:325.5 y:198];
		[self addStaticBodyWallShape];
		[self addBoosterBody];


		//添加flippers
		CGPoint flipperPos = ccp(90,170);
		for (int i=0;i<9;i++){
			CGPoint newFlipperPos = i==0?flipperPos:ccp(flipperPos.x,flipperPos.y-20*i);
			[self addFlipperBodyX:newFlipperPos.x y:newFlipperPos.y];
		}
		 
		flipperPos = ccp(124,170);
		for (int i=0;i<9;i++){
			CGPoint newFlipperPos = i==0?flipperPos:ccp(flipperPos.x,flipperPos.y-20*i);
			[self addReversedFlipperBodyX:newFlipperPos.x y:newFlipperPos.y];
		}

		
		// init sound manager/OpenAL support
		[PASoundMgr sharedSoundManager];
		// preload interface-like sounds
		bgTrack = [[PASoundMgr sharedSoundManager] addSound:@"loop" withExtension:@"ogg" position:CGPointZero looped:YES];
		[bgTrack retain];
		// lower music track volume and play it
		[bgTrack playAtListenerPosition];
	
		//每秒生成一个小球
		[self schedule:@selector(tickToAddBall:) interval:1];
		//每帧执行的函数
		[self schedule:@selector(tickToUpdateActors:)];
 
	}
	return self;
}

-(void) dealloc{
	//清除box2d的物理世界
	delete mWorld;
	mWorld = NULL;
	
	delete mContactListener;
	mContactListener = NULL;
	
	delete mDestructionListener;
	mDestructionListener = NULL;
	
	[bgTrack release];//清除声音引擎
	[super dealloc];
}

/**
 Cocos2d的调度函数，用于在绘制前更新状态（位置、角度等等）
 */
-(void) tickToUpdateActors:(ccTime) delta{
	mWorld->Step(delta,10,8);
	
	{
		//从记录的碰撞点中选出属于小球和booster碰撞的碰撞点，然后进行处理
		std::set<b2Body*> ballsToBoost;
		//记录所有参与碰撞的小球
		std::set<b2Body*> ballsHitStaticBody;
		const std::vector<ContactPoint>& cps = mContactListener->GetContactPoints();
		std::vector<ContactPoint>::const_iterator cpitr = cps.begin();
		for (;cpitr!=cps.end();cpitr++){
			b2Body* body1 = (*cpitr).shape1->GetBody();
			b2Body* body2 = (*cpitr).shape2->GetBody();
			if (body1==NULL||body2==NULL)
				continue;
			if (body1->GetUserData()==NULL||body2->GetUserData()==NULL)
				continue;
			BodyUserData* userData1 = static_cast<BodyUserData*>(body1->GetUserData());
			BodyUserData* userData2 = static_cast<BodyUserData*>(body2->GetUserData());
			
			//选出属于小球和boosterd的碰撞，并记录小球的body
			if (userData1.bodyType==kTagBallBodyType&&userData2.bodyType==kTagBoosterBodyType)
				ballsToBoost.insert(body1);
			else if (userData2.bodyType==kTagBallBodyType&&userData1.bodyType==kTagBoosterBodyType)
				ballsToBoost.insert(body2);
			
			//记录所有碰装固定body的小球body
			if (userData1.bodyType==kTagBallBodyType&&userData2.bodyType==kTagStaticBodyType)
				ballsHitStaticBody.insert(body1);
			else if (userData2.bodyType==kTagBallBodyType&&userData1.bodyType==kTagStaticBodyType)
				ballsHitStaticBody.insert(body2);
		}
		
		if (ballsToBoost.size()>0){
			std::set<b2Body*>::iterator itr = ballsToBoost.begin();
			while (itr!=ballsToBoost.end()){
				BodyUserData* userData = static_cast<BodyUserData*>((*itr)->GetUserData());
				b2Vec2 force = b2Vec2(0.2f,9.5f);
				b2Vec2 point = (*itr)->GetWorldPoint(b2Vec2(0.f,0.f));
				(*itr)->ApplyImpulse(force,point);
				
				//增加效果
				ParticleSun* emitter = [ParticleSun node];
				emitter.texture = [[TextureMgr sharedTextureMgr] addImage: @"fire.pvr"];
				[self addChild:emitter z:-1];
				emitter.position = userData.sprite.position;
				((MyAtlasSprite*)userData.sprite).emitter = emitter;
				itr++;
			}
		}
		
		//检查与static body碰撞的小球是否带有particlesystem。如果有，那么将其particlesystem去掉
		if (ballsHitStaticBody.size()>0){
			std::set<b2Body*>::iterator itr = ballsHitStaticBody.begin();
			for (;itr!=ballsHitStaticBody.end();itr++){
				BodyUserData* userData = static_cast<BodyUserData*>((*itr)->GetUserData());
				MyAtlasSprite* ballSpt = (MyAtlasSprite*)userData.sprite;
				if (ballSpt.emitter==nil)
					continue;
				else{
					[self removeChild:ballSpt.emitter cleanup:YES];
					ballSpt.emitter = nil;
				}
			}
		}
		mContactListener->Clear();//清除这次记录的碰撞点
	}

	//删除跳出范围的body
	mBoundaryListener->RemoveViolatedBodiesFromWorld(mWorld);
	
	//更新所有sprite的位置和转动角度,如果body的状态是frozen，那么清除它
	b2Body* bodyList = mWorld->GetBodyList();
	while (bodyList!=NULL){
		b2Body* nextBody = bodyList->GetNext();
		BodyUserData* userData = static_cast<BodyUserData*>(bodyList->GetUserData());
		if (userData!=nil){
			AtlasSprite* sprite = userData.sprite;
			sprite.position = CGPointMake( bodyList->GetPosition().x * PTM_RATIO, bodyList->GetPosition().y * PTM_RATIO);
			sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(bodyList->GetAngle());//Box2D的转动方向时逆时针为正，cocos2d为顺时针为正，所以需要×-1
		}
		bodyList = nextBody;
	}
}

/**
调度函数，用于定时增加一个小球 
*/
-(void) tickToAddBall:(ccTime) delta{
	//获取ball的spritemanager
	AtlasSpriteManager* ballsSptMgr = (AtlasSpriteManager*)[self getChildByTag:kTagBallsAtlasSpriteManager];
	if (ballsSptMgr==nil){
		//创建ball的spritemgr
		Texture2D* textBalls = [[TextureMgr sharedTextureMgr] addImage:@"balls.png" ];
		ballsSptMgr = [AtlasSpriteManager spriteManagerWithTexture:textBalls ];
		[self addChild:ballsSptMgr z:0 tag:kTagBallsAtlasSpriteManager];
	}
	
	int idx = CCRANDOM_0_1() * 1400 / 100;
	int x = (idx%4) * 22;
	int y = (idx/7) * 22;
	MyAtlasSprite* newBallSprite = [MyAtlasSprite spriteWithRect:CGRectMake(x,y,22,22) spriteManager:ballsSptMgr];
	
	float ballDensity = 2.5f;//ball的密度
	float ballRadius = 10.f/PTM_RATIO;//ball的半径
	
	//增加小球的物理球体
	b2BodyDef bodyDef;
	BodyType bodyType = kTagBallBodyType;
	BodyUserData* userData = [[BodyUserData alloc] initWithBodyType:bodyType AtlasSprite:newBallSprite AtlasSpriteManager:ballsSptMgr];
	bodyDef.userData = static_cast<void*> (userData);
	if ((CCRANDOM_0_1()*2)>1)
		bodyDef.position.Set(402.f/PTM_RATIO,352.f/PTM_RATIO);
	else
		bodyDef.position.Set(321.f/PTM_RATIO,352.f/PTM_RATIO);

	b2Body* ballBody = mWorld->CreateBody(&bodyDef);
	b2CircleDef shapeDef;
	shapeDef.radius = ballRadius;
	shapeDef.density = ballDensity;
	ballBody->CreateShape(&shapeDef);
	ballBody->SetMassFromShapes();
	
	[ballsSptMgr addChild:newBallSprite z:0];
}

@end
