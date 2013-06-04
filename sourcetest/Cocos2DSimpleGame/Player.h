//
//  Player.h
//  Cocos2DSimpleGame
//
//  Created by apple on 5/29/13.
//  Copyright 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class HelloWorldLayer;
@interface Player : CCSprite {
    HelloWorldLayer * _layer;
}
@property (nonatomic, assign) BOOL isRotating;
@property (nonatomic, assign) int shootFar;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int cost;
@property (nonatomic, assign) int attack;
@property (nonatomic, assign) int defend;
@property (nonatomic, assign) int percentcorrect;
@property (nonatomic, assign) int level;
- (id)initWithFile:(NSString *)file andLayer:(HelloWorldLayer *) l;
-(void) addCircleAvailable;
-(void) addCircleNotAvailable;
-(void) addCircleinformation;
-(void) upgrade;
-(void) sale;
@end
