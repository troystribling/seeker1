//
//  StartScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "StartScene.h"
#import "StatusDisplay.h"
#import "MenuScene.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StartScene (PrivateAPI)

- (void)updateBootingLabel:(NSString*)_booting;
- (void)insertBootingLabel;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StartScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize bootingLabel;
@synthesize counter;

//===================================================================================================================================
#pragma mark StartScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateBootingLabel:(NSString*)_booting; {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertBootingLabel {
    self.bootingLabel = [CCLabel labelWithString:@"BOOTING." fontName:@"Apple ][" fontSize:18];
    self.bootingLabel.position = CGPointMake(10.0f, 380.0f);
    self.bootingLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self addChild:self.bootingLabel];
}

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
	if((self=[super init])) {
        self.counter = 0;
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self insertBootingLabel];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter > kSTARTUP_TICKS) {
        [[CCDirector sharedDirector] replaceScene: [MenuScene scene]];
    }
}

@end
