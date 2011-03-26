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

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAX_TAPS               3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroInstruction1Scene (PrivateAPI)

- (void)touchPrompt;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroInstruction1Scene

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark IntroInstruction1Scene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMessage {
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
    self.displayedMessageSprite.position = CGPointMake(screenSize.width/2, 90.0);
    self.displayedMessageSprite.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:self.displayedMessageSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showPrompt {
    self.readyForPrompt = NO;
    CCSprite* progSprite = [CCSprite spriteWithFile:@"inst-move.png"];
    CCSprite* progSpriteSelected = [CCSprite spriteWithFile:@"inst-move.png"];
    CCMenuItemLabel* nextItem = [CCMenuItemSprite itemFromNormalSprite:progSprite selectedSprite:progSpriteSelected target:self selector:@selector(touchPrompt)];
    CCMenu* menu = [CCMenu menuWithItems:nextItem, nil];
    [menu alignItemsHorizontallyWithPadding:0.0];
    menu.position = CGPointMake(160.0, 389.0);
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
        self.maxTaps = kMAX_TAPS;
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"instructions.png"];
        backgroundGrid.anchorPoint = CGPointMake(0.0, 0.0);
        backgroundGrid.position = CGPointMake(0.0, 0.0);
        [self addChild:backgroundGrid z:-10];
    }
	return self;
}

@end
