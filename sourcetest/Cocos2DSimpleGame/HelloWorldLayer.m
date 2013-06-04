//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright Razeware LLC 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"
#import "Monster.h"
#import "Player.h"
#import "LevelManager.h"
#import "AppDelegate.h"
#import "ModalAlert.h"
@interface HelloWorldLayer()

@property (strong) CCTMXTiledMap *tileMap;
@end
#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer
bool canPuts[16][24];

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    HelloWorldLayer *layer = [HelloWorldLayer node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}
//bool test = true;
- (void) addMonster {
    //    if(test){
    //        test = false;
    //    }else{
    //        return;
    //    }
    //
    //CCSprite * monster = [CCSprite spriteWithFile:@"monster.png"];
    Monster * monster = nil;
    if (arc4random() % 2 == 0) {
        monster = [[[WeakAndFastMonster alloc] initWithLayer:self] autorelease];
    } else {
        monster = [[[StrongAndSlowMonster alloc] initWithLayer:self] autorelease];
    }
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    CGPoint touchL = CGPointMake(8.0f, 169.0f);
    
    [monster moveToward:touchL];
    
    // Determine speed of the monster
    //    int minDuration = monster.minMoveDuration; //2.0;
    //    int maxDuration = monster.maxMoveDuration; //4.0;
    //    int rangeDuration = maxDuration - minDuration;
    //    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    //    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-monster.contentSize.width/2, actualY)];
    //    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
    //        [_monsters removeObject:node];
    //        [node removeFromParentAndCleanup:YES];
    //
    //        [self showWinFail:NO];
    //    }];
    //    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    [_monsters addObject:monster];
    
}

-(void)gameLogic:(ccTime)dt {
    [self addMonster];
}

CCSprite * tmpS = nil;
-(void) changeCircle:(BOOL) can{
    if(can){
        [tmpS setTexture:[[CCSprite spriteWithFile:@"circle.png"]texture]];
    }else{
        [tmpS setTexture:[[CCSprite spriteWithFile:@"circlenot.png"]texture]];
    }
}
- (id) init
{
    //    if ((self = [super initWithColor:[LevelManager sharedInstance].curLevel.backgroundColor])) {
    if ((self = [super initWithColor:[LevelManager sharedInstance].curLevel.backgroundColor])) {
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"test.tmx"];
        [self addChild:_tileMap z:-1];
        _bgLayer = [_tileMap layerNamed:@"Background"];
        for (int i=0 ; i < _tileMap.mapSize.width; i++) {
            for (int j = 0; j<_tileMap.mapSize.height; j++) {
                canPuts[i][j] = true;
            }
        }
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CatMaze.plist"];
        _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"CatMaze.png"];
        [_tileMap addChild:_batchNode];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        playerArrs = [[NSMutableArray alloc] init];
        
        
        tmpS = [[[CCSprite alloc ] initWithFile:@"circle.png"] autorelease];
        tmpS.position = ccp(tmpS.contentSize.width/2+200, winSize.height/2);
        tmpS.visible = FALSE;
        [self addChild:tmpS];
        
        [self schedule:@selector(gameLogic:) interval:[LevelManager sharedInstance].curLevel.secsPerSpawn];
        //        [self schedule:@selector(autoFire:) interval: .5f - [LevelManager sharedInstance].curLevel.levelNum*.1f];
        [self schedule:@selector(autoFire:) interval: 1.0f];
        [self setTouchEnabled:YES];
        
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        [self schedule:@selector(update:)];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        
        movableSprites = [[NSMutableArray alloc] init];
        NSArray *images = [NSArray arrayWithObjects:@"bird.png", @"cat.png", @"dog.png", @"turtle.png", nil];
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            sprite.tag = i+100;
            float offsetFraction = ((float)(i+1))/(images.count+1);
            sprite.position = ccp(winSize.width*offsetFraction, sprite.contentSize.height/2);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }
    }
    return self;
}
-(void)autoFire:(ccTime)dt {
    //    if (_nextProjectile != nil) return;
    for (Player *pl in playerArrs) {
        
        for (Monster *monster in _monsters) {
            
            if (ccpDistance(pl.position, monster.position)<150) {
                CGPoint location = monster.position;
                
                // Set up initial location of projectile
                CGSize winSize = [[CCDirector sharedDirector] winSize];
                CCSprite *projectile = [CCSprite spriteWithFile:@"projectile2.png"] ;
                projectile.position = ccp(pl.position.x, pl.position.y);
                
                // Determine offset of location to projectile
                CGPoint offset = ccpSub(location, projectile.position);
                float ratio;
                float realX;
                float realY;
                if (offset.x >= 0)
                {
                    if(fabsf(offset.x)>fabsf(offset.y)){
                        realX = winSize.width + projectile.contentSize.width/2;
                        ratio = (float) offset.y / (float) offset.x;
                        realY = ratio*(realX - projectile.position.x) + projectile.position.y;
                        //                        NSLog(@"111111111");
                    }else{
                        if (offset.y > 0) {
                            realY = winSize.height + projectile.contentSize.height/2;
                            ratio = (float) offset.x / (float) offset.y;
                            realX = ratio*(realY - projectile.position.y) + projectile.position.x;
                            //                            NSLog(@"22222222");
                        }else{
                            realY = - projectile.contentSize.height/2;
                            ratio = (float) offset.x / (float) offset.y;
                            realX = fabsf(ratio*(projectile.position.y - realY)) + projectile.position.x;
                            //                            NSLog(@"333333333");
                        }
                        
                    }
                } else {//offset.x < 0
                    if(fabsf(offset.x)>fabsf(offset.y)){
                        realX = - projectile.contentSize.width/2;
                        ratio = (float) offset.y / (float) offset.x;
                        realY = -1.0f*ratio*(projectile.position.x - realX) + projectile.position.y;
                        //                        NSLog(@"4444444444");
                    }else{
                        if (offset.y > 0) {
                            realY = winSize.height + projectile.contentSize.height/2;
                            ratio = (float) offset.x / (float) offset.y;
                            realX = projectile.position.x - (-1.0f)*ratio*(realY - projectile.position.y) ;
                            //                            NSLog(@"555555555");
                        }else{
                            realY = - projectile.contentSize.height/2;
                            ratio = (float) offset.x / (float) offset.y;
                            realX = projectile.position.x - fabsf(ratio*(projectile.position.y - realY));
                            //                            NSLog(@"666666666");
                        }
                        
                    }
                }
                CGPoint realDest = ccp(realX, realY);
                
                
                // Determine the length of how far you're shooting
                int offRealX = realX - projectile.position.x;
                int offRealY = realY - projectile.position.y;
                
                float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
                float velocity = 480/1; // 480pixels/1sec
                float realMoveDuration = length/velocity;
                
                // Determine angle to face
                //                float angleRadians = atanf((float)offRealY / (float)offRealX);
                //                float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
                //                float cocosAngle = -1 * angleDegrees;
                
                
                CGPoint shootVector = ccpSub(location, projectile.position);
                CGFloat shootAngle = ccpToAngle(shootVector);
                float cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
                
                float rotateDegreesPerSecond = 180.0f/0.5f ; // Would take 0.5 seconds to rotate 180 degrees, or half a circle
                float degreesDiff = fabs(pl.rotation - cocosAngle) > 180.0f ? 360.0f - fabs(pl.rotation - cocosAngle) :fabs(pl.rotation - cocosAngle);
                float rotateDuration = fabs(degreesDiff / rotateDegreesPerSecond);
                //                NSLog(@"vao day roi 11111111111");
                if(pl.isRotating){
                    
                }else{
                    pl.isRotating = TRUE;
                    [pl runAction:
                     [CCSequence actions:
                      [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                      [CCCallBlock actionWithBlock:^{
                         // OK to add now - rotation is finished!
                         pl.isRotating = FALSE;
                         if(pl.rotation != cocosAngle){
                             
                             pl.rotation = cocosAngle;
                         }
                         [self addChild:projectile];
                         [_projectiles addObject:projectile];
                         //                          NSLog(@"vao day roi 222222222 realMoveDuration %f", realMoveDuration);
                         // Move projectile to actual endpoint
                         [projectile runAction:
                          [CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallBlockN actionWithBlock:^(CCNode *node) {
                              [_projectiles removeObject:node];
                              [node removeFromParentAndCleanup:YES];
                          }],
                           nil]];
                     }],
                      nil]];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
                }
                break;
            }
        }
    }
}


- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        BOOL monsterHit = FALSE;
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for (Monster *monster in _monsters) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                monsterHit = TRUE;
                monster.hp --;
                [monster energize];
                if (monster.hp <= 0) {
                    [monstersToDelete addObject:monster];
                }
                break;
            }
        }
        
        for (CCSprite *monster in monstersToDelete) {
            
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
            
            _monstersDestroyed++;
            if (_monstersDestroyed > 30) {
                [self showWinFail:YES];
            }
        }
        
        if (monsterHit) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
        [monstersToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}
-(void) showWinFail:(BOOL) win{
    if(win){
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }else{
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [playerArrs release];
    playerArrs = nil;
    [movableSprites release];
    movableSprites = nil;
    [_monsters release];
    _monsters = nil;
    [_projectiles release];
    _projectiles = nil;
    [super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
}

#pragma mark movable sprite
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    Player * newPlayer = nil;
    for (CCSprite *sprite in movableSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            //            newSprite = sprite;
            newPlayer = [[[Player alloc ] initWithFile:@"player2.png" andLayer:self] autorelease];
            newPlayer.position = sprite.position;
            tmpS.position = sprite.position;
            [self changeCircle:TRUE];
            tmpS.visible = TRUE;
            [self addChild:newPlayer];
            
            break;
        }
    }
    
    for (Player *pl in playerArrs) {
        if(CGRectContainsPoint(pl.boundingBox, touchLocation)){
            selPlayer = pl;
            NSLog(@"isrotating: %d", selPlayer.isRotating);
            [ModalAlert Ask: @"Do you want to cancel the game?"
                    onLayer:self // this is usually the current scene layer
                   yesBlock: ^{
                       // code that should be executed on "yes" goes here
                       
                   }
                    noBlock: ^{
                        // code that should be executed on "no" goes here
                        
                    }];
            break;
        }
    }
    if (newPlayer != selSprite) {
        selSprite = newPlayer;
    }
}

- (void)panForTranslation:(CGPoint)translation {
    if (selSprite) {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
        tmpS.position = newPos;
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
}


- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint toTileCoord = [self tileCoordForPosition:touchLocation];
    if(!([self isWallAtTileCoord:toTileCoord] && [self canPutPlayerAtTileCoord:toTileCoord])){
        [self changeCircle:FALSE];
    }else{
        [self changeCircle:TRUE];
    }
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [_tileMap convertTouchToNodeSpace:touch];
    CGPoint toTileCoord = [self tileCoordForPosition:position];
    
    CGPoint positionC = [self positionForTileCoord:toTileCoord];
    if([self isWallAtTileCoord:toTileCoord] && [self canPutPlayerAtTileCoord:toTileCoord]){
        if(nil != selSprite) {
            canPuts[(int)toTileCoord.x][(int)toTileCoord.y] = false;
            selSprite.position = positionC;
            tmpS.visible = FALSE;
            [playerArrs addObject:selSprite];
        }
    }else{
        if(nil != selSprite) selSprite.visible = NO;
        tmpS.visible = FALSE;
    }
    
}
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        [self selectSpriteForTouch:touchLocation];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = ccp(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        
    }
}
#pragma mark tile map
#pragma mark test tile map
- (BOOL)isValidTileCoord:(CGPoint)tileCoord {
    if (tileCoord.x < 0 || tileCoord.y < 0 ||
        tileCoord.x >= _tileMap.mapSize.width ||
        tileCoord.y >= _tileMap.mapSize.height) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - position.y) / _tileMap.tileSize.height;
    return ccp(x, y);
}

- (CGPoint)positionForTileCoord:(CGPoint)tileCoord {
    int x = (tileCoord.x * _tileMap.tileSize.width) + _tileMap.tileSize.width/2;
    int y = (_tileMap.mapSize.height * _tileMap.tileSize.height) - (tileCoord.y * _tileMap.tileSize.height) - _tileMap.tileSize.height/2;
    return ccp(x, y);
}

-(BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayer:(CCTMXLayer *)layer {
    if (![self isValidTileCoord:tileCoord]) return NO;
    int gid = [layer tileGIDAt:tileCoord];
    NSDictionary * properties = [_tileMap propertiesForGID:gid];
    if (properties == nil) return NO;
    return [properties objectForKey:prop] != nil;
}
-(BOOL)isWallAtTileCoord:(CGPoint)tileCoord {
    return [self isProp:@"Wall" atTileCoord:tileCoord forLayer:_bgLayer];
}
-(BOOL)canPutPlayerAtTileCoord:(CGPoint)tileCoord {
    if(canPuts[(int)tileCoord.x][(int)tileCoord.y])
        return YES;
    return NO;
}
-(BOOL)isGoAtTileCoord:(CGPoint)tileCoord {
    return [self isProp:@"Go" atTileCoord:tileCoord forLayer:_bgLayer] ;
}
-(BOOL)isEndAtTileCoord:(CGPoint)tileCoord {
    return [self isProp:@"End" atTileCoord:tileCoord forLayer:_bgLayer];
}
-(void)removeObjectAtTileCoord:(CGPoint)tileCoord {
    //    [_objectLayer removeTileAt:tileCoord];
}
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:8];
    
    BOOL t = NO;
    BOOL l = NO;
    BOOL b = NO;
    BOOL r = NO;
	
	// Top
	CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        t = YES;
	}
	
	// Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        l = YES;
	}
	
	// Bottom
	p = CGPointMake(tileCoord.x, tileCoord.y + 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        b = YES;
	}
	
	// Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        r = YES;
	}
    
    
	// Top Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y - 1);
	if (t && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y + 1);
	if (b && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Top Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y - 1);
	if (t && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y + 1);
	if (b && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
    
	return [NSArray arrayWithArray:tmp];
}

- (float) getAngle:(Player *)ms toFaceTargetSprite:(Monster *)pl {
    
    float theta = atan((ms.position.y-pl.position.y)/(ms.position.x-pl.position.x)) * 180 * 7 /22;
    
    float calculatedAngle;
    
    if(ms.position.y - pl.position.y > 0)
    {
        if(ms.position.x - pl.position.x < 0)
        {
            calculatedAngle = (-90-theta);
        }
        else if(ms.position.x - pl.position.x > 0)
        {
            calculatedAngle = (90-theta);
        }
    }
    else if(ms.position.y - pl.position.y < 0)
    {
        if(ms.position.x - pl.position.x < 0)
        {
            calculatedAngle = (270-theta);
        }
        else if(ms.position.x - pl.position.x > 0)
        {
            calculatedAngle = (90-theta);
        }
    }
    return calculatedAngle;
}
@end
