//
//  StartScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "StartScene.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StartScene (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StartScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize startMenu

//===================================================================================================================================
#pragma mark StartScene PrivateAPI

//===================================================================================================================================
#pragma mark StartScene

//-----------------------------------------------------------------------------------------------------------------------------------
+(id) scene {
	CCScene *scene = [CCScene node];
	StartScene *layer = [StartScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(id) init {
	if( (self=[super init] )) {
        self.startMenu = [CCMenu menuWithItems:nil];
        CCMenuItemImage *playMenuItem = [CCMenuItemImage itemFromNormalImage:@"myFirstButton.png"
                                                         selectedImage: @"myFirstButton_selected.png"
                                                         target:self
                                                         selector:@selector(startPlaying)];
        [self.startMenu alignItemsVertically];
        [self.startMenu addChild:playMenuItem];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)startPlaying {
}
    
@end
