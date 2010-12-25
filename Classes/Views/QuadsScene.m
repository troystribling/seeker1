//
//  QuadsScene.m
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "QuadsScene.h"
#import "StatusDisplay.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMISSION_SET_IMAGE_YDELTA       50.0f

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QuadsScene (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation QuadsScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize tharsisSprite;
@synthesize tharsisPosition;
@synthesize memnoniaSprite;
@synthesize memnoniaPosition;
@synthesize elysiumSprite;
@synthesize elysiumPosition;
@synthesize displayedSprite;

//===================================================================================================================================
#pragma mark QuadsScene PrivateAPI

//===================================================================================================================================
#pragma mark QuadsScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	QuadsScene *layer = [QuadsScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if( (self=[super init] )) {
        self.elysiumSprite = [[[CCSprite alloc] initWithFile:@"elysium.png"] autorelease];
        self.memnoniaSprite = [[[CCSprite alloc] initWithFile:@"memnonia.png"] autorelease];
        self.tharsisSprite = [[[CCSprite alloc] initWithFile:@"tharsis.png"] autorelease];
        self.displayedSprite = self.tharsisSprite;
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ miss"];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
}    

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
}    

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {    
}

@end
