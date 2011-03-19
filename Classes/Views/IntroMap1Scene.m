//
//  IntroMap1Scene.m
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroMap1Scene.h"
#import "StatusDisplay.h"
#import "IntroMap2Scene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAX_TAPS           11
#define kINTRO_1_TICK_1     30
#define kTAP_COUNTER_DELTA  180

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroMap1Scene (PrivateAPI)

-(void)showTapToContinue;
-(void)showMessage;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroMap1Scene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize displayedMessageSprite;
@synthesize tapCounterMessageSprite;
@synthesize itemSprite;
@synthesize counter;
@synthesize messageDisplayedCount;
@synthesize tapCounter;
@synthesize acceptTouches;

//===================================================================================================================================
#pragma mark IntroMap1Scene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
-(void)showTapToContinue {
    self.acceptTouches = YES;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.tapCounterMessageSprite = [CCSprite spriteWithFile:@"tap-to-continue.png"];
    self.tapCounterMessageSprite.position = CGPointMake(screenSize.width/2, 15.0);
    [self addChild:self.tapCounterMessageSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void)showMessage {
    self.acceptTouches = NO;
    self.messageDisplayedCount = self.counter;
    if (self.tapCounter > 1) {
        [self.displayedMessageSprite removeFromParentAndCleanup:YES];
    }
    if (self.itemSprite) {
        [self.itemSprite removeFromParentAndCleanup:YES];
    }
    switch (self.tapCounter) {
        case 1:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-1.png"];
            break;
        case 2:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-2.png"];
            break;
        case 3:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-3.png"];
            break;
        case 4:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-4.png"];
            break;
        case 5:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-5.png"];
            break;
        case 6:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-6.png"];
            break;
        case 7:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-7.png"];
            break;
        case 8:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-8.png"];
            break;
        case 9:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-9.png"];
            break;
        case 10:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-10.png"];
            break;
        case 11:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map1-text-11.png"];
            break;
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.displayedMessageSprite.position = CGPointMake(screenSize.width/2, 290.0);
    self.displayedMessageSprite.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:self.displayedMessageSprite];
}

//===================================================================================================================================
#pragma mark IntroMap1Scene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	IntroMap1Scene *layer = [IntroMap1Scene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.tapCounter = 0;
        self.messageDisplayedCount = kINTRO_1_TICK_1;
        self.tapCounterMessageSprite = nil;
        self.isTouchEnabled = YES;
        self.itemSprite = nil;
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"intro-map.png"];
        backgroundGrid.anchorPoint = CGPointMake(0.0, 0.0);
        backgroundGrid.position = CGPointMake(0.0, 0.0);
        [self addChild:backgroundGrid z:-10];
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self.statusDisplay test];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter == kINTRO_1_TICK_1) {
        self.tapCounter++;
        [self showMessage];
    } else if ((self.counter - self.messageDisplayedCount) > kTAP_COUNTER_DELTA && self.tapCounterMessageSprite == nil) {
        [self showTapToContinue];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.acceptTouches) {
        self.tapCounter++;
        if (self.tapCounter <= kMAX_TAPS) {
            if (self.tapCounterMessageSprite) {
                [self.tapCounterMessageSprite removeFromParentAndCleanup:YES];
            }
            self.tapCounterMessageSprite = nil;
            [self showMessage];
        } else {
            [[CCDirector sharedDirector] replaceScene: [IntroMap2Scene scene]];
        }
    }
}    

@end
