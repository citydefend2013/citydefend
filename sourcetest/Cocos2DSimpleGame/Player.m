//
//  Player.m
//  Cocos2DSimpleGame
//
//  Created by apple on 5/29/13.
//  Copyright 2013 Razeware LLC. All rights reserved.
//

#import "Player.h"
#import "HelloWorldLayer.h"



@implementation Player
- (id)initWithFile:(NSString *)file andLayer:(HelloWorldLayer *) l{
    if ((self = [super initWithFile:file])) {
        self.isRotating = FALSE;
        self.shootFar = 150;// how far it can shoot
        self.type = 1;      // type of soldier
        self.cost= 200;     //it's cost 200 to buy
        self.attack = 100;  //ability to attack is 100
        self.defend = 100;  //ability to defend is 100
        self.percentcorrect =90; //ability to shoot to destionation exactly is 90%
        self.level = 1;     //current level of soldier is 1;
        _layer = l;
    }
    return self;
}
-(void) addCircleAvailable{
    
}
-(void) addCircleNotAvailable{
    
}
-(void) addCircleinformation{
    
}
-(void) upgrade{
    
}
-(void) sale{
    
}

@end
