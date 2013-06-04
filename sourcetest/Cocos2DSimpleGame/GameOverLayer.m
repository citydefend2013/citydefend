//
//  GameOverLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright 2012 Razeware LLC. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "LevelManager.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if (self = [super init]) {
        
//        NSString * message;
//        if (won) {
//            [[LevelManager sharedInstance] nextLevel];
//            Level * curLevel = [[LevelManager sharedInstance] curLevel];
//            if (curLevel) {
//                message = [NSString stringWithFormat:@"Get ready for level %d!", curLevel.levelNum];
//            } else {
//                message = @"You Won!";
//                [[LevelManager sharedInstance] reset];
//            }
//        } else {
//            message = @"You Lose :[";
//            [[LevelManager sharedInstance] reset];
//        }
//
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
//        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:16];
//        label.color = ccc3(0,0,0);
//        label.position = ccp(winSize.width/2, winSize.height/2);
//        [self addChild:label];
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            background = [CCSprite spriteWithFile:@"Default.png"];
            background.rotation = 90;
        } else {
            background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
        }
        background.position = ccp(size.width/2, size.height/2);
        
        // add the label as a child to this Layer
        [self addChild: background];
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
        }],
          nil]];
    }
    return self;
}

@end
