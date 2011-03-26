//
//  IntroTerm3Scene.m
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroTerm3Scene.h"
#import "IntroInstruction3Scene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAX_TAPS               1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroTerm3Scene (PrivateAPI)

- (void)touchPrompt; 

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroTerm3Scene

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark IntroTerm3Scene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMessage {
    switch (self.tapCounter) {
        case 1:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"term3-text-1.png"];
            self.readyForPrompt = YES;
            break;
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.displayedMessageSprite.position = CGPointMake(screenSize.width/2, 110.0);
    self.displayedMessageSprite.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:self.displayedMessageSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showPrompt {
    self.readyForPrompt = NO;
    CCSprite* progSprite = [CCSprite spriteWithFile:@"term-prompt.png"];
    CCSprite* progSpriteSelected = [CCSprite spriteWithFile:@"term-prompt.png"];
    CCMenuItemLabel* nextItem = [CCMenuItemSprite itemFromNormalSprite:progSprite selectedSprite:progSpriteSelected target:self selector:@selector(touchPrompt)];
    CCMenu* menu = [CCMenu menuWithItems:nextItem, nil];
    [menu alignItemsHorizontallyWithPadding:0.0];
    menu.position = CGPointMake(155.0, 248.0);
    menu.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:menu z:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchPrompt {
    [[CCDirector sharedDirector] replaceScene: [IntroInstruction3Scene scene]];
}

//===================================================================================================================================
#pragma mark IntroTerm3Scene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	IntroTerm3Scene *layer = [IntroTerm3Scene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.maxTaps = kMAX_TAPS;
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"term-2.png"];
        backgroundGrid.anchorPoint = CGPointMake(0.0, 0.0);
        backgroundGrid.position = CGPointMake(0.0, 0.0);
        [self addChild:backgroundGrid z:-10];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

@end
