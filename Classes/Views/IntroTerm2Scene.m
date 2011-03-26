//
//  IntroTerm2Scene.m
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroTerm2Scene.h"
#import "IntroInstruction2Scene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAX_TAPS               1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroTerm2Scene (PrivateAPI)

- (void)touchPrompt; 

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroTerm2Scene

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark IntroTerm2Scene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMessage {
    switch (self.tapCounter) {
        case 1:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"term2-text-1.png"];
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
    menu.position = CGPointMake(155.0, 298.0);
    menu.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:menu z:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchPrompt {
    [[CCDirector sharedDirector] replaceScene: [IntroInstruction2Scene scene]];
}

//===================================================================================================================================
#pragma mark IntroTerm2Scene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	IntroTerm2Scene *layer = [IntroTerm2Scene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.maxTaps = kMAX_TAPS;
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"term-1.png"];
        backgroundGrid.anchorPoint = CGPointMake(0.0, 0.0);
        backgroundGrid.position = CGPointMake(0.0, 0.0);
        [self addChild:backgroundGrid z:-10];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

@end
