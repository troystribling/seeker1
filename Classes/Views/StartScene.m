//
//  StartScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "StartScene.h"
#import "MapScene.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StartScene (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StartScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize startMenu;

//===================================================================================================================================
#pragma mark StartScene PrivateAPI

//===================================================================================================================================
#pragma mark StartScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	StartScene *layer = [StartScene node];
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
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)startPlaying {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}
    
@end
