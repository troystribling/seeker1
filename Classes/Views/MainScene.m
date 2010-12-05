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
    CCLabel* missionLabel = [CCLabel labelWithString:@"mission" fontName:@"Retroville NC" fontSize:24];
    missionLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* missionItem = [CCMenuItemLabel itemWithLabel:missionLabel
                                                           target:self
                                                         selector:@selector(mission)];
    missionItem.anchorPoint = CGPointMake(0.0f, 0.0f);
    CCLabel* settingsLabel = [CCLabel labelWithString:@"settings" fontName:@"Retroville NC" fontSize:24];
    settingsLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* settingsItem = [CCMenuItemLabel itemWithLabel:settingsLabel
                                                            target:self
                                                          selector:@selector(configure)];
    settingsItem.anchorPoint = CGPointMake(0.0f, 0.0f);
    CCLabel* gameCenterLabel = [CCLabel labelWithString:@"game center" fontName:@"Retroville NC" fontSize:24];
    gameCenterLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* gameCenterItem = [CCMenuItemLabel itemWithLabel:gameCenterLabel
                                                              target:self
                                                            selector:@selector(gameCenter)];
    gameCenterItem.anchorPoint = CGPointMake(0.0f, 0.0f);
    CCLabel* tutorialLabel = [CCLabel labelWithString:@"tutorial" fontName:@"Retroville NC" fontSize:24];
    tutorialLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* tutorialItem = [CCMenuItemLabel itemWithLabel:tutorialLabel
                                                      target:self
                                                      selector:@selector(tutorial)];
    tutorialItem.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.startMenu = [CCMenu menuWithItems:missionItem, settingsItem, gameCenterItem, tutorialItem, nil];
    [self.startMenu alignItemsVertically];
    self.startMenu.position = CGPointMake(30.0f, 300.0f);
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
