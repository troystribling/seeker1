//
//  IntroScene.m
//  seeker1
//
//  Created by Troy Stribling on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroScene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kINTRO_1_TICK_1         30
#define kPROMPT_COUNTER_DELTA   60
#define kTAP_COUNTER_DELTA      120

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroScene (PrivateAPI)

- (void)showTapToContinue;
- (void)displayMessage;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize displayedMessageSprite;
@synthesize tapCounterMessageSprite;
@synthesize counter;
@synthesize messageDisplayedCount;
@synthesize tapCounter;
@synthesize maxTaps;
@synthesize acceptTouches;
@synthesize readyForPrompt;

//===================================================================================================================================
#pragma mark IntroInstruction1Scene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showTapToContinue {
    self.acceptTouches = YES;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.tapCounterMessageSprite = [CCSprite spriteWithFile:@"tap-to-continue.png"];
    self.tapCounterMessageSprite.position = CGPointMake(screenSize.width/2.0, 15.0);
    [self addChild:self.tapCounterMessageSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)displayMessage {
    self.acceptTouches = NO;
    self.messageDisplayedCount = self.counter;
    self.tapCounter++;
    if (self.tapCounterMessageSprite) {
        [self.tapCounterMessageSprite removeFromParentAndCleanup:YES];
        self.tapCounterMessageSprite = nil;
    }
    if (self.tapCounter > 1) {
        [self.displayedMessageSprite removeFromParentAndCleanup:YES];
    }
    [self showMessage];
}

//===================================================================================================================================
#pragma mark IntroInstruction1Scene Interface

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMessage {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showPrompt {
}

//===================================================================================================================================
#pragma mark IntroInstruction1Scene

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.counter = 0;
        self.messageDisplayedCount = 0;
        self.tapCounter = 0;
        self.isTouchEnabled = YES;
        self.readyForPrompt = NO;
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter == kINTRO_1_TICK_1) {
        [self displayMessage];
    } else if ((self.counter - self.messageDisplayedCount) > kTAP_COUNTER_DELTA && self.tapCounterMessageSprite == nil && self.tapCounter != self.maxTaps) {
        [self showTapToContinue];
    } else if ((self.counter - self.messageDisplayedCount) > kPROMPT_COUNTER_DELTA && self.readyForPrompt) {
        [self showPrompt];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.acceptTouches) {
        if (self.tapCounter < self.maxTaps) {
            [self displayMessage];
        }
    }
}    

@end
