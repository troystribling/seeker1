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
#import "AudioManager.h"
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
    CCLabelTTF* missionLabel = [CCLabelTTF labelWithString:@"1. play" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    missionLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* missionItem = [CCMenuItemLabel itemWithLabel:missionLabel
                                                        target:self
                                                        selector:@selector(mission)];
    missionItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabelTTF* settingsLabel = [CCLabelTTF labelWithString:@"2. settings" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    settingsLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* settingsItem = [CCMenuItemLabel itemWithLabel:settingsLabel
                                                        target:self
                                                        selector:@selector(settings)];
    settingsItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabelTTF* statsLabel = [CCLabelTTF labelWithString:@"3. stats" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    statsLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* statsItem = [CCMenuItemLabel itemWithLabel:statsLabel
                                                            target:self
                                                            selector:@selector(stats)];
    statsItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabelTTF* repositoryLabel = [CCLabelTTF labelWithString:@"4. repository" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    repositoryLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* repositoryItem = [CCMenuItemLabel itemWithLabel:repositoryLabel
                                                       target:self
                                                       selector:@selector(repository)];
    repositoryItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabelTTF* tutorialLabel = [CCLabelTTF labelWithString:@"5. tutorial" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
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
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    [[CCDirector sharedDirector] replaceScene:[QuadsScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)settings {
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    [[ViewControllerManager instance] showSettingsView:[[CCDirector sharedDirector] openGLView]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stats {
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    [[ViewControllerManager instance] showStatsView:[[CCDirector sharedDirector] openGLView]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tutorial {
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    [[ViewControllerManager instance] showTutorialIndexView:[[CCDirector sharedDirector] openGLView]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)repository {
    [[AudioManager instance] playEffect:SelectAudioEffectID];
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
        [[AudioManager instance] playBackgroundMusic:BootAudioBackgroundID];
    }
	return self;
}

@end
