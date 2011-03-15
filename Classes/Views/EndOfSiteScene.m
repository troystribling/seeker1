//
//  EndOfSiteScene.m
//  seeker1
//
//  Created by Troy Stribling on 3/14/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "EndOfSiteScene.h"
#import "QuadsScene.h"
#import "UserModel.h"
#import "LevelModel.h"
#import "StatusDisplay.h"
#import "ViewControllerManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfSiteScene (PrivateAPI)

- (void)nextMission;
- (void)insertNextMissionMenu;
- (void)firstQuadDisplay;
- (void)secondQuadDisplay;
- (void)thirdQuadDisplay;
- (void)endOfGame;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EndOfSiteScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize counter;

//===================================================================================================================================
#pragma mark EndOfSiteScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertDisplay {
    NSInteger lastQuad = [UserModel quadrangle] - 1;
    switch (lastQuad) {
        case TharsisQuadType:
            [self firstQuadDisplay];
            break;
        case MemnoniaQuadType:
            [self secondQuadDisplay];
            break;
        case ElysiumQuadType:
            [self thirdQuadDisplay];
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)firstQuadDisplay {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)secondQuadDisplay {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)thirdQuadDisplay {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)endOfGame {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertNextMissionMenu {
    CCLabel* nextLabel = [CCLabel labelWithString:@"Next>" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    nextLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* nextItem = [CCMenuItemLabel itemWithLabel:nextLabel
                                                        target:self
                                                        selector:@selector(nextMission)];
    CCMenu* menu = [CCMenu menuWithItems:nextItem, nil];
    [menu alignItemsHorizontallyWithPadding:90.0];
    menu.position = CGPointMake(155.0f, 35.0f);
    [self addChild:menu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)nextMission {
    [[CCDirector sharedDirector] replaceScene: [QuadsScene scene]];
}

//===================================================================================================================================
#pragma mark EndOfSiteScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	EndOfSiteScene *layer = [EndOfSiteScene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
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
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
}    


@end
