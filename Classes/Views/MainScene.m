//
//  MainScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/28/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MainScene.h"
#import "MapScene.h"
#import "StatusDisplay.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MainScene (PrivateAPI)

- (void)buildMenu;
- (void)mission;
- (void)configure;
- (void)gameCenter;
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
    CCLabel* missionLabel = [CCLabel labelWithString:@"1. mission" fontName:@"Courier" fontSize:24];
    missionLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* missionItem = [CCMenuItemLabel itemWithLabel:missionLabel
                                                           target:self
                                                         selector:@selector(mission)];
    missionItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* settingsLabel = [CCLabel labelWithString:@"2. settings" fontName:@"Courier" fontSize:24];
    settingsLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* settingsItem = [CCMenuItemLabel itemWithLabel:settingsLabel
                                                            target:self
                                                          selector:@selector(configure)];
    settingsItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* gameCenterLabel = [CCLabel labelWithString:@"3. game center" fontName:@"Courier" fontSize:24];
    gameCenterLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* gameCenterItem = [CCMenuItemLabel itemWithLabel:gameCenterLabel
                                                              target:self
                                                            selector:@selector(gameCenter)];
    gameCenterItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* repositoryLabel = [CCLabel labelWithString:@"4. repository" fontName:@"Courier" fontSize:24];
    repositoryLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* repositoryItem = [CCMenuItemLabel itemWithLabel:repositoryLabel
                                                       target:self
                                                       selector:@selector(repository)];
    repositoryItem.anchorPoint = CGPointMake(0.0, 0.0);
    CCLabel* tutorialLabel = [CCLabel labelWithString:@"5. tutorial" fontName:@"Courier" fontSize:24];
    tutorialLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* tutorialItem = [CCMenuItemLabel itemWithLabel:tutorialLabel
                                                      target:self
                                                      selector:@selector(tutorial)];
    tutorialItem.anchorPoint = CGPointMake(0.0, 0.0);
    self.startMenu = [CCMenu menuWithItems:missionItem, settingsItem, gameCenterItem, repositoryItem, tutorialItem, nil];
    [self.startMenu alignItemsVerticallyWithPadding:10.0];
    self.startMenu.position = CGPointMake(20.0f, 282.0f);
    [self addChild:self.startMenu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mission {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)configure {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)gameCenter {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tutorial {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)repository {
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
        [self.statusDisplay addTerminalText:@"$ main"];
        [self.statusDisplay test];
    }
	return self;
}

@end
