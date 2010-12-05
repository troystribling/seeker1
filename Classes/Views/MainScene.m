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

- (void)startMission;
- (void)configure;
- (void)gameCenter;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MainScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize startMenu;
@synthesize statusDisplay;

//===================================================================================================================================
#pragma mark MainScene PrivateAPI

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
        CCMenuItemImage* startMissionItem = [CCMenuItemImage itemFromNormalImage:@"start-mission.png"
                                                             selectedImage: @"start-mission.png"
                                                             target:self
                                                             selector:@selector(startMission)];
        startMissionItem.anchorPoint = CGPointMake(0.0f, 0.0f);
        CCMenuItemImage* configureItem = [CCMenuItemImage itemFromNormalImage:@"configure.png"
                                                          selectedImage: @"configure.png"
                                                          target:self
                                                          selector:@selector(configure)];
        configureItem.anchorPoint = CGPointMake(0.0f, 0.0f);
        CCMenuItemImage* gameCenterItem = [CCMenuItemImage itemFromNormalImage:@"game-center.png"
                                                           selectedImage: @"game-center.png"
                                                           target:self
                                                           selector:@selector(gameCenter)];
        gameCenterItem.anchorPoint = CGPointMake(0.0f, 0.0f);
        self.startMenu = [CCMenu menuWithItems:startMissionItem, configureItem, gameCenterItem, nil];
        [self.startMenu alignItemsVertically];
        self.startMenu.position = CGPointMake(30.0f, 330.0f);
        [self addChild:self.startMenu];
        self.statusDisplay = [StatusDisplay create];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ boot"];
        [self.statusDisplay addTerminalText:@"$ main"];
        [self.statusDisplay test];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)startMission {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)configure {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)gameCenter {
}

@end
