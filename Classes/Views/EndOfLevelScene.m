//
//  EndOfLevelScene.m
//  seeker1
//
//  Created by Troy Stribling on 1/25/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "EndOfLevelScene.h"
#import "MapScene.h"
#import "UserModel.h"
#import "LevelModel.h"
#import "StatusDisplay.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfLevelScene (PrivateAPI)

- (void)insertTitleLabel;
- (void)insertSamplesReturnedLabel;
- (void)insertSamplesCollectedLabel;
- (void)insertSensorsPlacedLabel;
- (void)insertEnergyBonusLabel;
- (void)insertTotalScoreLabel;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EndOfLevelScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize titleLabel;
@synthesize samplesReturnedLabel;
@synthesize samplesCollectedLabel;
@synthesize sensorsPlacedLabel;
@synthesize energyBonusLabel;
@synthesize levelCompletedBonusLabel;
@synthesize totalScoreLabel;
@synthesize counter;
@synthesize levelCompleted;

//===================================================================================================================================
#pragma mark EndOfLevelScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertTitleLabel {
    NSString* titleString = @"Mission Failure";
    if (self.levelCompleted) {
        titleString = @"Mission Completed";
    }
    self.titleLabel = [CCLabel labelWithString:titleString fontName:@"Courier" fontSize:26];
    self.titleLabel.position = CGPointMake(20.0f, 361.0f);
    self.titleLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    if (self.levelCompleted) {
        self.titleLabel.color = ccc3(103,243,27);    
    } else {
        self.titleLabel.color = ccc3(204,51,0);    
    }
    [self addChild:self.titleLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSamplesReturned {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSamplesCollected {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSensorsPlaced {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertEnergyBonus {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertTotalScore {
}

//===================================================================================================================================
#pragma mark EndOfLevelScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	EndOfLevelScene *layer = [EndOfLevelScene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.isTouchEnabled = YES;
        self.levelCompleted = [LevelModel levelCompleted:[UserModel level]];
        if (self.levelCompleted) {
            [UserModel nextLevel];
        }
        [self insertTitleLabel];
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"~>"];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter > kSTARTUP_TICKS) {
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}    

@end
