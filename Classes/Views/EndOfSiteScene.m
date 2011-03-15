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
#define kEND_OF_LEVEL_TICK_1    40
#define kEND_OF_LEVEL_TICK_2    80
#define kEND_OF_LEVEL_TICK_3    120


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfSiteScene (PrivateAPI)

- (void)insertCompletedDisplay;
- (void)insertNextDisplay;
- (void)insertNextMissionMenu;
- (void)nextMission;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EndOfSiteScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize counter;

//===================================================================================================================================
#pragma mark EndOfSiteScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCompletedDisplay {
    CCLabel* completedLabel = [CCLabel labelWithString:@"completed site" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    CCLabel* siteLabel;
    NSInteger lastQuad = [UserModel quadrangle] - 1;
    switch (lastQuad) {
        case TharsisQuadType:
            siteLabel = [CCLabel labelWithString:@"tharsis" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_REALLY_LARGE];
            break;
        case MemnoniaQuadType:
            siteLabel = [CCLabel labelWithString:@"memnonia" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_REALLY_LARGE];
            break;
        case ElysiumQuadType:
            siteLabel = [CCLabel labelWithString:@"elysium" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_REALLY_LARGE];
            break;
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    completedLabel.position = CGPointMake(screenSize.width/2.0, 380.0f);
    completedLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:completedLabel];
    siteLabel.position = CGPointMake(screenSize.width/2.0, 345.0f);
    siteLabel.color = kCCLABEL_FONT_GOLD_COLOR;
    [self addChild:siteLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertNextDisplay {
    NSInteger nextQuad = [UserModel quadrangle];
    CCLabel* nextLabel;
    CCLabel* siteLabel;
    switch (nextQuad) {
        case MemnoniaQuadType:
            nextLabel = [CCLabel labelWithString:@"next site" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
            siteLabel = [CCLabel labelWithString:@"memnonia" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_REALLY_LARGE];
            break;
        case ElysiumQuadType:
            nextLabel = [CCLabel labelWithString:@"next site" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
            siteLabel = [CCLabel labelWithString:@"elysium" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_REALLY_LARGE];
            break;
        default:
            siteLabel = [CCLabel labelWithString:@"game over" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_REALLY_LARGE];
            break;
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    nextLabel.position = CGPointMake(screenSize.width/2.0, 275.0f);
    nextLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:nextLabel];
    siteLabel.position = CGPointMake(screenSize.width/2.0, 240.0f);
    siteLabel.color = kCCLABEL_FONT_GOLD_COLOR;
    [self addChild:siteLabel];
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
    menu.position = CGPointMake(245.0f, 35.0f);
    [self addChild:menu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)nextMission {
    [TutorialSectionViewController nextLevel];
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
    if (self.counter == kEND_OF_LEVEL_TICK_1) {
        [self insertCompletedDisplay];
        [self.statusDisplay test];
    } else if (self.counter == kEND_OF_LEVEL_TICK_2) {
        [self insertNextDisplay];
        [self.statusDisplay clear];
    } else if (self.counter == kEND_OF_LEVEL_TICK_3) {
        [self insertNextMissionMenu];
        [self.statusDisplay test];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
}    


@end
