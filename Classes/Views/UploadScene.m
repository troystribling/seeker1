//
//  UploadScene.m
//  seeker1
//
//  Created by Troy Stribling on 1/27/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "UploadScene.h"
#import "MapScene.h"
#import "StatusDisplay.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kUPLOAD_TICK_1      20
#define kUPLOAD_TICK_2      35
#define kUPLOAD_TICK_3      55
#define kUPLOAD_TICK_4      75
#define kUPLOAD_TICK_5      95
#define kUPLOAD_TICK_6      115
#define kUPLOAD_TICK_7      135
#define kUPLOAD_TICK_8      155
#define kUPLOAD_TICK_9      175
#define kUPLOAD_TICK_10     225

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UploadScene (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UploadScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize percentUploadLabel;
@synthesize uploadProgressLabel;
@synthesize counter;

//===================================================================================================================================
#pragma mark UploadScene PrivateAPI

//===================================================================================================================================
#pragma mark UploadScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	UploadScene *layer = [UploadScene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.isTouchEnabled = YES;
        
        self.percentUploadLabel = [CCLabel labelWithString:@"upload  0%  (2Kb/s)" fontName:@"Courier" fontSize:20];
        self.percentUploadLabel.position = CGPointMake(20.0f, 375.0f);
        self.percentUploadLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
        self.percentUploadLabel.color = ccc3(103,243,27);
        [self addChild:self.percentUploadLabel];

        self.uploadProgressLabel = [CCLabel labelWithString:@"=>" fontName:@"Courier" fontSize:20];
        self.uploadProgressLabel.position = CGPointMake(20.0f, 350.0f);
        self.uploadProgressLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
        self.uploadProgressLabel.color = ccc3(103,243,27);
        [self addChild:self.uploadProgressLabel];

        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"~> up"];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter == kUPLOAD_TICK_1) {
        [self.percentUploadLabel setString:@"upload 10%  (1.0Kb/s)"];
        [self.uploadProgressLabel setString:@"===>"];
        [self.statusDisplay setTest:EnergyDisplayType];
    } else if (self.counter == kUPLOAD_TICK_2) {
        [self.percentUploadLabel setString:@"upload 20%  (0.8Kb/s)"];
        [self.uploadProgressLabel setString:@"====>"];
        [self.statusDisplay setTest:SpeedDisplayType];
    } else if (self.counter == kUPLOAD_TICK_3) {
        [self.percentUploadLabel setString:@"upload 30%  (1.2Kb/s)"];
        [self.uploadProgressLabel setString:@"======>"];
        [self.statusDisplay setTest:SensorDisplayType];
    } else if (self.counter == kUPLOAD_TICK_4) {
        [self.percentUploadLabel setString:@"upload 40%  (1.5Kb/s)"];
        [self.uploadProgressLabel setString:@"=========>"];
        [self.statusDisplay setTest:SampleDisplayType];
    } else if (self.counter == kUPLOAD_TICK_5) {
        [self.percentUploadLabel setString:@"upload 60%  (1.2Kb/s)"];
        [self.uploadProgressLabel setString:@"===========>"];
        [self.statusDisplay clear];
    } else if (self.counter == kUPLOAD_TICK_6) {
        [self.percentUploadLabel setString:@"upload 70%  (1.8Kb/s)"];
        [self.uploadProgressLabel setString:@"=============>"];
        [self.statusDisplay setTest:EnergyDisplayType];
    } else if (self.counter == kUPLOAD_TICK_7) {
        [self.percentUploadLabel setString:@"upload 80%  (2.0Kb/s)"];
        [self.uploadProgressLabel setString:@"================>"];
        [self.statusDisplay setTest:SpeedDisplayType];
    } else if (self.counter == kUPLOAD_TICK_8) {
        [self.percentUploadLabel setString:@"upload 90%  (2.1Kb/s)"];
        [self.uploadProgressLabel setString:@"====================>"];
        [self.statusDisplay setTest:SensorDisplayType];
    } else if (self.counter == kUPLOAD_TICK_9) {
        [self.percentUploadLabel setString:@"upload 100% (0.5b/s)"];
        [self.uploadProgressLabel setString:@"======================>"];
        [self.statusDisplay setTest:SampleDisplayType];
        [self.statusDisplay addTerminalText:@"~> run"];
    } else if (self.counter == kUPLOAD_TICK_10) {
        [[ProgramNgin instance] runProgram];
        [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [[ProgramNgin instance] runProgram];
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}    

@end
