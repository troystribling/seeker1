//
//  IntroInstruction1Scene.m
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroInstruction1Scene.h"
#import "IntroTerm2Scene.h"
#import "StatusDisplay.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAX_TAPS               3
#define kINTRO_1_TICK_1         30
#define kPROMPT_COUNTER_DELTA   60
#define kTAP_COUNTER_DELTA      180

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroInstruction1Scene (PrivateAPI)

- (void)showTapToContinue;
- (void)showMessage;
- (void)showPromptMenu;
- (void)touchPrompt;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroInstruction1Scene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize displayedMessageSprite;
@synthesize tapCounterMessageSprite;
@synthesize counter;
@synthesize messageDisplayedCount;
@synthesize tapCounter;
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
- (void)showMessage {
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
    switch (self.tapCounter) {
        case 1:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"inst1-text-1.png"];
            break;
        case 2:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"inst1-text-2.png"];
            break;
        case 3:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"inst1-text-3.png"];
            self.readyForPrompt = YES;
            break;
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.displayedMessageSprite.position = CGPointMake(screenSize.width/2, 100.0);
    self.displayedMessageSprite.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:self.displayedMessageSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showPromptMenu {
    self.readyForPrompt = NO;
    CCSprite* progSprite = [CCSprite spriteWithFile:@"inst-move.png"];
    CCMenuItemLabel* nextItem = [CCMenuItemSprite itemFromNormalSprite:progSprite selectedSprite:progSprite target:self selector:@selector(touchPrompt)];
    CCMenu* menu = [CCMenu menuWithItems:nextItem, nil];
    [menu alignItemsHorizontallyWithPadding:0.0];
    menu.position = CGPointMake(160.0, 390.0);
    menu.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:menu z:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchPrompt {
    [[CCDirector sharedDirector] replaceScene: [IntroTerm2Scene scene]];
}

//===================================================================================================================================
#pragma mark IntroInstruction1Scene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	IntroInstruction1Scene *layer = [IntroInstruction1Scene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.counter = 0;
        self.messageDisplayedCount = 0;
        self.tapCounter = 0;
        self.isTouchEnabled = YES;
        self.readyForPrompt = NO;
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
        [self showMessage];
    } else if ((self.counter - self.messageDisplayedCount) > kTAP_COUNTER_DELTA && self.tapCounterMessageSprite == nil && self.tapCounter != kMAX_TAPS) {
        [self showTapToContinue];
    } else if ((self.counter - self.messageDisplayedCount) > kPROMPT_COUNTER_DELTA && self.readyForPrompt) {
        [self showPromptMenu];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.acceptTouches) {
        if (self.tapCounter < kMAX_TAPS) {
            [self showMessage];
        }
    }
}    

@end
