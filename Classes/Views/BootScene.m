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
- (void)insertPOST:(NSString*)_post;
- (void)insertConsole:(NSString*)_console;
- (void)insertConnection:(NSString*)_connection;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BootScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize bootingLabel;
@synthesize productLabel;
@synthesize post;
@synthesize console;
@synthesize connection;
@synthesize counter;

//===================================================================================================================================
#pragma mark BootScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertBootingLabel {
    self.bootingLabel = [CCLabel labelWithString:@"Booting" fontName:@"Courier" fontSize:24];
    self.bootingLabel.position = CGPointMake(20.0f, 361.0f);
    self.bootingLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.bootingLabel.color = ccc3(103,243,27);
    [self addChild:self.bootingLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertProductLabel {
    self.productLabel = [CCLabel labelWithString:@"imaginaryProducts.com" fontName:@"Courier" fontSize:22];
    self.productLabel.position = CGPointMake(20.0f, 20.0f);
    self.productLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.productLabel.color = ccc3(103,243,27);
    [self addChild:self.productLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertPOST:(NSString*)_post {
    self.post = [CCLabel labelWithString:_post fontName:@"Courier" fontSize:24];
    self.post.position = CGPointMake(20.0f, 361.0f);
    self.post.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.post.color = ccc3(103,243,27);
    [self addChild:self.post];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertConsole:(NSString*)_console {
    self.console = [CCLabel labelWithString:_console fontName:@"Courier" fontSize:24];
    self.console.position = CGPointMake(20.0f, 321.0f);
    self.console.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.console.color = ccc3(103,243,27);
    [self addChild:self.console];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertConnection:(NSString*)_connection {
    self.connection = [CCLabel labelWithString:_connection fontName:@"Courier" fontSize:24];
    self.connection.position = CGPointMake(20.0f, 281.0f);
    self.connection.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.connection.color = ccc3(103,243,27);
    [self addChild:self.connection];
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
        [self.statusDisplay addTerminalText:@"$"];
        [self insertBootingLabel];
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
        [self insertProductLabel];
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
        [self.statusDisplay clearTerminal];
        [self.statusDisplay addTerminalText:@"$ boot"];
        [self.statusDisplay addTerminalText:@"$ post"];
        [self.statusDisplay addTerminalText:@"$"];
        [self.statusDisplay setTest:EnergyDisplayType];
        [self insertPOST:@"POST    [start]"];
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
        [self.post removeFromParentAndCleanup:YES];
        [self insertPOST:@"POST    [OK]"];
        [self.statusDisplay clearTerminal];
        [self.statusDisplay addTerminalText:@"$ boot"];
        [self.statusDisplay addTerminalText:@"$ post"];
        [self.statusDisplay addTerminalText:@"$ con"];
        [self insertConsole:@"console [start]"];
    } else if (self.counter == kBOOT_TICK_12) {
        [self.statusDisplay clear];
        [self.console removeFromParentAndCleanup:YES];
        [self insertConsole:@"console [started]"];
        [self insertConnection:@"connecting"];
    } else if (self.counter == kBOOT_TICK_13) {
        [self.statusDisplay test];
        [self.connection removeFromParentAndCleanup:YES];
        [self insertConnection:@"connected"];
    }    
}

@end
