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
        CCMenuItemImage* playMenuItem = [CCMenuItemImage itemFromNormalImage:@"play-button.png"
                                                               selectedImage: @"play-button.png"
                                                                      target:self
                                                                    selector:@selector(startPlaying)];
        [self.startMenu alignItemsVertically];
        self.startMenu = [CCMenu menuWithItems:playMenuItem, nil];
        [self addChild:self.startMenu];
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)startPlaying {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

@end
