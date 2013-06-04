//
//  Monster.h
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright 2012 Razeware LLC. All rights reserved.
//

#import "cocos2d.h"
#import <OpenAL/al.h>
#import "HealthBar.h"
@class HelloWorldLayer;
@interface Monster : CCSprite{
    HealthBar *healthBar;
    HelloWorldLayer * _layer;
    CCAnimation *_facingForwardAnimation;
    CCAnimation *_facingBackAnimation;
    CCAnimation *_facingLeftAnimation;
    CCAnimation *_facingRightAnimation;
    CCAnimation *_curAnimation;
    CCAnimate *_curAnimate;
@private
	NSMutableArray *spOpenSteps;
	NSMutableArray *spClosedSteps;
    NSMutableArray *shortestPath;
	CCAction *currentStepAction;
	ALuint currentPlayedEffect;
    NSValue *pendingMove;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int maxhp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;
//@property (nonatomic,retain) CCLayer *layer;

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration andLayer:(HelloWorldLayer *) l;
-(void) energize;
- (void)moveToward:(CGPoint)target;
@end

@interface WeakAndFastMonster : Monster
- (id)initWithLayer:(HelloWorldLayer *) l;
@end

@interface StrongAndSlowMonster : Monster
- (id)initWithLayer:(HelloWorldLayer *) l;
@end