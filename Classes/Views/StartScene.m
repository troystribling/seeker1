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

- (void)insertBootingLabel;
- (void)insertConsoleLabel;
- (void)insertProtocolsLabel;
- (void)insertConnectingLabel;
- (void)insertProductLabel;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StartScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize bootingLabel;
@synthesize consoleLabel;
@synthesize protocolsLabel;
@synthesize connectingLabel;
@synthesize productLabel;
@synthesize counter;

//===================================================================================================================================
#pragma mark StartScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertBootingLabel {
    self.bootingLabel = [CCLabel labelWithString:@"Booting." fontName:@"Retroville NC" fontSize:20];
    self.bootingLabel.position = CGPointMake(20.0f, 376.0f);
    self.bootingLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.bootingLabel.color = ccc3(103,243,27);
    [self addChild:self.bootingLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertConsoleLabel {
    self.consoleLabel = [CCLabel labelWithString:@"Console       [starting]" fontName:@"Retroville NC" fontSize:20];
    self.consoleLabel.position = CGPointMake(20.0f, 376.0f);
    self.consoleLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.consoleLabel.color = ccc3(103,243,27);
    [self addChild:self.consoleLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertProtocolsLabel {
    self.protocolsLabel = [CCLabel labelWithString:@"Protocols  [starting]" fontName:@"Retroville NC" fontSize:20];
    self.protocolsLabel.position = CGPointMake(20.0f, 356.0f);
    self.protocolsLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.protocolsLabel.color = ccc3(103,243,27);
    [self addChild:self.protocolsLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertConnectingLabel {
    self.connectingLabel = [CCLabel labelWithString:@"Connecting" fontName:@"Retroville NC" fontSize:20];
    self.connectingLabel.position = CGPointMake(20.0f, 336.0f);
    self.connectingLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.connectingLabel.color = ccc3(103,243,27);
    [self addChild:self.connectingLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertProductLabel {
    self.productLabel = [CCLabel labelWithString:@"an imaginary product" fontName:@"Retroville NC" fontSize:20];
    self.productLabel.position = CGPointMake(20.0f, 20.0f);
    self.productLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.productLabel.color = ccc3(103,243,27);
    [self addChild:self.productLabel];
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
    } else if (self.counter == kBOOT_TICK_1) {
        [self.bootingLabel setString:@"Booting.."];
    } else if (self.counter == kBOOT_TICK_2) {
        [self.bootingLabel setString:@"Booting..."];
    } else if (self.counter == kBOOT_TICK_3) {
        [self.bootingLabel setString:@"Booting...."];
    } else if (self.counter == kBOOT_TICK_4) {
        [self.bootingLabel setString:@"Booting....."];
    } else if (self.counter == kBOOT_TICK_5) {
        [self.bootingLabel setString:@"Booting......"];
    } else if (self.counter == kBOOT_TICK_6) {
        [self.bootingLabel removeFromParentAndCleanup:YES];
        [self insertConsoleLabel];
    } else if (self.counter == kBOOT_TICK_7) {
        [self.consoleLabel setString:@"Console       [started]"];
        [self insertProtocolsLabel];
    } else if (self.counter == kBOOT_TICK_8) {
        [self.protocolsLabel setString:@"Protocols  [started]"];
        [self insertConnectingLabel];
    } else if (self.counter == kBOOT_TICK_9) {
        [self.connectingLabel setString:@"Connected"];
        [self insertProductLabel];
    }    
}

@end
