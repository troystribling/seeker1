//
//  BootScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "BootScene.h"
#import "StatusDisplay.h"
#import "MainScene.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BootScene (PrivateAPI)

- (void)insertBootingLabel;
- (void)insertProductLabel;
- (void)loadPOSTRunning;
- (void)loadPOSTOK;
- (void)loadConsoleStarting;
- (void)loadConsoleStarted;
- (void)loadConnecting;
- (void)loadConnected;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BootScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize bootingLabel;
@synthesize productLabel;
@synthesize postRunning;
@synthesize postOK;
@synthesize consoleStarting;
@synthesize consoleStarted;
@synthesize connecting;
@synthesize connected;
@synthesize counter;

//===================================================================================================================================
#pragma mark BootScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertBootingLabel {
    self.bootingLabel = [CCLabel labelWithString:@"Booting" fontName:@"Retroville NC" fontSize:20];
    self.bootingLabel.position = CGPointMake(20.0f, 376.0f);
    self.bootingLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.bootingLabel.color = ccc3(103,243,27);
    [self addChild:self.bootingLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertProductLabel {
    self.productLabel = [CCLabel labelWithString:@"an imaginary product" fontName:@"Retroville NC" fontSize:20];
    self.productLabel.position = CGPointMake(20.0f, 20.0f);
    self.productLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.productLabel.color = ccc3(103,243,27);
    [self addChild:self.productLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadPOSTRunning {
    self.postRunning = [CCSprite spriteWithFile:@"POST-running.png"];
    self.postRunning.position = CGPointMake(0.0f, 370.0f);
    self.postRunning.anchorPoint = CGPointMake(0.0f, 0.0f);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadPOSTOK {
    self.postOK = [CCSprite spriteWithFile:@"POST-ok.png"];
    self.postOK.position = CGPointMake(0.0f, 370.0f);
    self.postOK.anchorPoint = CGPointMake(0.0f, 0.0f);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadConsoleStarting {
    self.consoleStarting = [CCSprite spriteWithFile:@"Console-starting.png"];
    self.consoleStarting.position = CGPointMake(0.0f, 340.0f);
    self.consoleStarting.anchorPoint = CGPointMake(0.0f, 0.0f);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadConsoleStarted {
    self.consoleStarted = [CCSprite spriteWithFile:@"Console-started.png"];
    self.consoleStarted.position = CGPointMake(0.0f, 340.0f);
    self.consoleStarted.anchorPoint = CGPointMake(0.0f, 0.0f);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadConnecting {
    self.connecting = [CCSprite spriteWithFile:@"Connecting.png"];
    self.connecting.position = CGPointMake(0.0f, 310.0f);
    self.connecting.anchorPoint = CGPointMake(0.0f, 0.0f);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadConnected {
    self.connected = [CCSprite spriteWithFile:@"Connected.png"];
    self.connected.position = CGPointMake(0.0f, 310.0f);
    self.connected.anchorPoint = CGPointMake(0.0f, 0.0f);
}

//===================================================================================================================================
#pragma mark BootScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	BootScene *layer = [BootScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ boot"];
        [self insertBootingLabel];
        [self loadPOSTRunning];
        [self loadPOSTOK];
        [self loadConsoleStarting];
        [self loadConsoleStarted];
        [self loadConnecting];
        [self loadConnected];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter > kSTARTUP_TICKS) {
        [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
    } else if (self.counter == kBOOT_TICK_1) {
        [self.bootingLabel setString:@"Booting."];
    } else if (self.counter == kBOOT_TICK_2) {
        [self.bootingLabel setString:@"Booting.."];
    } else if (self.counter == kBOOT_TICK_3) {
        [self.bootingLabel setString:@"Booting..."];
    } else if (self.counter == kBOOT_TICK_4) {
        [self.bootingLabel setString:@"Booting...."];
    } else if (self.counter == kBOOT_TICK_5) {
        [self.bootingLabel setString:@"Booting....."];
    } else if (self.counter == kBOOT_TICK_6) {
        [self.bootingLabel removeFromParentAndCleanup:YES];
        [self.statusDisplay setTest:EnergyDisplayType];
        [self addChild:self.postRunning];
    } else if (self.counter == kBOOT_TICK_7) {
        [self.statusDisplay setTest:SpeedDisplayType];
    } else if (self.counter == kBOOT_TICK_8) {
        [self.statusDisplay setTest:SensorDisplayType];
    } else if (self.counter == kBOOT_TICK_9) {
        [self.statusDisplay setTest:SampleDisplayType];
    } else if (self.counter == kBOOT_TICK_10) {
        [self.statusDisplay clear];
    } else if (self.counter == kBOOT_TICK_11) {
        [self.statusDisplay test];
        [self.postRunning removeFromParentAndCleanup:YES];
        [self addChild:self.postOK];
        [self addChild:self.consoleStarting];
    } else if (self.counter == kBOOT_TICK_12) {
        [self.statusDisplay clear];
        [self.consoleStarting removeFromParentAndCleanup:YES];
        [self addChild:self.consoleStarted];
        [self addChild:self.connecting];
    } else if (self.counter == kBOOT_TICK_13) {
        [self.statusDisplay test];
        [self.connecting removeFromParentAndCleanup:YES];
        [self addChild:self.connected];
        [self insertProductLabel];
    }    
}

@end
