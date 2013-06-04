//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright Razeware LLC 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
@class Monster;
@class Player;
// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray * _monsters;
    NSMutableArray * _projectiles;
    int _monstersDestroyed;
    CCSprite *_nextProjectile;
    
    Player * selSprite;
    Player * selPlayer;
    NSMutableArray * movableSprites;
    NSMutableArray * playerArrs;
//     CCTMXTiledMap *_tileMap;
        CCTMXLayer *_bgLayer;
    CCSpriteBatchNode *_batchNode;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(BOOL)isGoAtTileCoord:(CGPoint)tileCoord;
-(BOOL)isEndAtTileCoord:(CGPoint)tileCoord;
- (BOOL)isWallAtTileCoord:(CGPoint)tileCoord;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (CGPoint)positionForTileCoord:(CGPoint)tileCoord;
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;
-(void) showWinFail:(BOOL) win;
@end
