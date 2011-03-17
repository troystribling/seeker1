//
//  IntroInstruction4Scene.m
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroInstruction4Scene.h"
#import "StatusDisplay.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kINTRO_1_TICK_1    40
#define kINTRO_1_TICK_2    40

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroInstruction4Scene (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroInstruction4Scene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize counter;
@synthesize acceptTouches;

//===================================================================================================================================
#pragma mark IntroInstruction4Scene PrivateAPI

//===================================================================================================================================
#pragma mark IntroInstruction4Scene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	IntroInstruction4Scene *layer = [IntroInstruction4Scene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"instructions.png"];
        backgroundGrid.anchorPoint = CGPointMake(0.0, 0.0);
        backgroundGrid.position = CGPointMake(0.0, 0.0);
        [self addChild:backgroundGrid z:-10];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter == kINTRO_1_TICK_1) {
    } else if (self.counter == kINTRO_1_TICK_2) {
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.acceptTouches) {
    }
}    

@end
