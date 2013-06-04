//
//  HealthBar.m
//  MathCar
//
//  Created by Mohammad Azam on 5/24/11.
//  Copyright 2011 HighOnCoding. All rights reserved.
//

#import "HealthBar.h"


@implementation HealthBar

@synthesize sprite,progressTimer; 

-(id) initWithProgressTimerSprite:(NSString *)img
{
    self = [super init]; 

//    self.progressTimer = [CCProgressTimer progressWithFile:img];
//    self.progressTimer.type = kCCProgressTimerTypeHorizontalBarLR;
//    self.progressTimer.percentage = 100;
    
//    progressBorder = [CCSprite spriteWithFile: img];
//    [progressBorder setPosition:ccp(winSize.width/2.0f, winSize.height*0.10f)];
//    [self addChild: progressBorder z:2];
    self.progressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:img]];
    self.progressTimer.type = kCCProgressTimerTypeBar;
    
    self.progressTimer.barChangeRate=ccp(1,0);
    self.progressTimer.midpoint=ccp(0.0,0.0f);
    
//    [self.progressTimer addChild:progressBar z:3];
    [self.progressTimer setAnchorPoint: ccp(0,0)];
    CCProgressTo *progressTo = [CCProgressTo actionWithDuration:.1f percent:100.0f];
    [self.progressTimer runAction:progressTo];
    
    return self;
}

-(void) update:(float) percentage
{
    CCProgressTo *progressComplete = [CCProgressTo actionWithDuration:0.1f percent:percentage];
    [self.progressTimer runAction:progressComplete];
}

@end
