//
//  MainScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/28/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MainScene.h"
#import "QuadsScene.h"
#import "StatusDisplay.h"
#import "ViewControllerManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MainScene (PrivateAPI)

- (void)buildMenu;
- (void)mission;
- (void)settings;
- (void)stats;
- (void)tutorial;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MainScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize startMenu;
@synthesize statusDisplay;

//===================================================================================================================================
#pragma mark MainScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)buildMenu {
    CCLabel* missionLabel = [CCLabel labelWithString:@"1. play" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    missionLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* missionItem = [CCMenuItemLabel itemWithLabel:missionLabel
                                                        target:self
                                                        selector:@selector(mission)];
    missionItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* settingsLabel = [CCLabel labelWithString:@"2. settings" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    settingsLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* settingsItem = [CCMenuItemLabel itemWithLabel:settingsLabel
                                                        target:self
                                                        selector:@selector(settings)];
    settingsItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* statsLabel = [CCLabel labelWithString:@"3. stats" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    statsLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* statsItem = [CCMenuItemLabel itemWithLabel:statsLabel
                                                            target:self
                                                            selector:@selector(stats)];
    statsItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* repositoryLabel = [CCLabel labelWithString:@"4. repository" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    repositoryLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* repositoryItem = [CCMenuItemLabel itemWithLabel:repositoryLabel
                                                       target:self
                                                       selector:@selector(repository)];
    repositoryItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* tutorialLabel = [CCLabel labelWithString:@"5. tutorial" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    tutorialLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* tutorialItem = [CCMenuItemLabel itemWithLabel:tutorialLabel
                                                      target:self
                                                      selector:@selector(tutorial)];
    tutorialItem.anchorPoint = CGPointMake(0.0, 0.0);
    self.startMenu = [CCMenu menuWithItems:missionItem, settingsItem, statsItem, repositoryItem, tutorialItem, nil];
    [self.startMenu alignItemsVerticallyWithPadding:20.0];
    self.startMenu.position = CGPointMake(20.0f, 275.0f);
    [self addChild:self.startMenu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mission {
    [[CCDirector sharedDirector] replaceScene:[QuadsScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)settings {
    [[ViewControllerManager instance] showSettingsView:[[CCDirector sharedDirector] openGLView]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stats {
    [[ViewControllerManager instance] showStatsView:[[CCDirector sharedDirector] openGLView]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tutorial {
    [[ViewControllerManager instance] showTutorialIndexView:[[CCDirector sharedDirector] openGLView]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)repository {
    [[ViewControllerManager instance] showRepositoryView:[[CCDirector sharedDirector] openGLView]];
}

//===================================================================================================================================
#pragma mark MainScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	MainScene *layer = [MainScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if( (self=[super init] )) {
        [self buildMenu];
        self.statusDisplay = [StatusDisplay create];
        [self.statusDisplay insert:self];
        [self.statusDisplay test];
    }
	return self;
}

@end
