//
//  MapScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MapScene.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapScene

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark MapScene PrivateAPI

//===================================================================================================================================
#pragma mark MapScene

//-----------------------------------------------------------------------------------------------------------------------------------
+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MapScene *layer = [MapScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(id) init {
	if( (self=[super init] )) {
		
		// create and initialize a Label
		CCLabel* label = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) dealloc {
	[super dealloc];
}

@end
