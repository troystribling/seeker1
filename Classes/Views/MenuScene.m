//
//  MenuScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/28/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MenuScene.h"
#import "MapScene.h"
#import "StatusDisplay.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MenuScene (PrivateAPI)

- (void)startMission;
- (void)configure;
- (void)gameCenter;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MenuScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize startMenu;
@synthesize statusDisplay;

//===================================================================================================================================
#pragma mark MenuScene PrivateAPI

//===================================================================================================================================
#pragma mark MenuScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	MenuScene *layer = [MenuScene node];
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
