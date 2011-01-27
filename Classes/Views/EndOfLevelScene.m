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

//-----------------------------------------------------------------------------------------------------------------------------------
#define kEND_OF_LEVEL_TICK_1    40
#define kEND_OF_LEVEL_TICK_2    80
#define kEND_OF_LEVEL_TICK_3    120
#define kEND_OF_LEVEL_TICK_4    160
#define kEND_OF_LEVEL_TICK_5    200
#define kEND_OF_LEVEL_TICK_6    240

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfLevelScene (PrivateAPI)

- (void)insertTitleLabel;
- (void)insertSamplesReturnedLabel;
- (void)insertSamplesCollectedLabel;
- (void)insertSensorsPlacedLabel;
- (void)insertEnergyBonusLabel;
- (void)insertLevelCompletedBonus;
- (void)insertTotalScoreLabel;
- (void)insertMissionFailedMenu;
- (void)redoMission;
- (void)skipMission;

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
@synthesize level;

//===================================================================================================================================
#pragma mark EndOfLevelScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertTitleLabel {
    NSString* titleString = @"Mission Failure";
    if (self.level.completed) {
        titleString = @"Mission Completed";
    }
    self.titleLabel = [CCLabel labelWithString:titleString fontName:@"Courier" fontSize:26];
    self.titleLabel.position = CGPointMake(20.0f, 361.0f);
    self.titleLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    if (self.level.completed) {
        self.titleLabel.color = ccc3(103,243,27);    
    } else {
        self.titleLabel.color = ccc3(204,51,0);    
    }
    [self addChild:self.titleLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSamplesCollected {
    NSInteger samplesCollectedScore = self.level.samplesCollected * kPOINTS_PER_OBJECT;
    NSString* samplesCollectedString = [NSString stringWithFormat:@"Samples Collected   %d*%d = %d", 
                                       self.level.samplesCollected, kPOINTS_PER_OBJECT, samplesCollectedScore];
    self.samplesReturnedLabel = [CCLabel labelWithString:samplesCollectedString dimensions:CGSizeMake(250, 60) 
                                               alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    self.samplesReturnedLabel.position = CGPointMake(20.0f, 290.0f);
    self.samplesReturnedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.samplesReturnedLabel.color = ccc3(103,243,27);
    [self addChild:self.samplesReturnedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSamplesReturned {
    NSInteger samplesReturnedScore = self.level.samplesReturned * kPOINTS_PER_OBJECT;
    NSString* samplesReturnedString = [NSString stringWithFormat:@"Samples Returned     %d*%d = %d", 
                                       self.level.samplesReturned, kPOINTS_PER_OBJECT, samplesReturnedScore];
    self.samplesReturnedLabel = [CCLabel labelWithString:samplesReturnedString dimensions:CGSizeMake(250, 60) 
                                               alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    self.samplesReturnedLabel.position = CGPointMake(20.0f, 230.0f);
    self.samplesReturnedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.samplesReturnedLabel.color = ccc3(103,243,27);
    [self addChild:self.samplesReturnedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSensorsPlaced {
    NSInteger sensorsPlacedScore = self.level.sensorsPlaced * kPOINTS_PER_OBJECT;
    NSString* sensorsPlacedString = [NSString stringWithFormat:@"Sensors Placed       %d*%d = %d", 
                                       self.level.sensorsPlaced, kPOINTS_PER_OBJECT, sensorsPlacedScore];
    self.sensorsPlacedLabel = [CCLabel labelWithString:sensorsPlacedString dimensions:CGSizeMake(250, 60) 
                                               alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    self.sensorsPlacedLabel.position = CGPointMake(20.0f, 170.0f);
    self.sensorsPlacedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.sensorsPlacedLabel.color = ccc3(103,243,27);
    [self addChild:self.sensorsPlacedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertEnergyBonus {
    NSInteger energyBounusScore = self.level.energyBonus * kPOINTS_PER_ENERGY_UNIT;
    NSString* sensorsPlacedString = [NSString stringWithFormat:@"Energy Bonus      %d*%d = %d", 
                                     self.level.energyBonus, kPOINTS_PER_ENERGY_UNIT, energyBounusScore];
    self.energyBonusLabel = [CCLabel labelWithString:sensorsPlacedString dimensions:CGSizeMake(250, 60) 
                                             alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    self.energyBonusLabel.position = CGPointMake(20.0f, 110.0f);
    self.energyBonusLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.energyBonusLabel.color = ccc3(103,243,27);
    [self addChild:self.energyBonusLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertLevelCompletedBonus {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertTotalScore {
    NSString* totalScoreString = [NSString stringWithFormat:@"Total Score: %d", self.level.score];
    self.totalScoreLabel = [CCLabel labelWithString:totalScoreString fontName:@"Courier" fontSize:20];
    self.totalScoreLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.totalScoreLabel.color = ccc3(205,149,12);
    if (self.level.completed) {
    } else {
        self.totalScoreLabel.position = CGPointMake(20.0f, 85.0f);
    }
    [self addChild:self.totalScoreLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertMissionFailedMenu {
    CCLabel* redoLabel = [CCLabel labelWithString:@"<Redo" fontName:@"Courier" fontSize:26];
    redoLabel.color =  ccc3(204,51,0);
    CCMenuItemLabel* redoItem = [CCMenuItemLabel itemWithLabel:redoLabel
                                                        target:self
                                                        selector:@selector(redoMission)];
    CCLabel* skipLabel = [CCLabel labelWithString:@"Skip>" fontName:@"Courier" fontSize:26];
    skipLabel.color =  ccc3(204,51,0);
    CCMenuItemLabel* skipItem = [CCMenuItemLabel itemWithLabel:skipLabel
                                                        target:self
                                                        selector:@selector(skipMission)];
    CCMenu* menu = [CCMenu menuWithItems:redoItem, skipItem, nil];
    [menu alignItemsHorizontallyWithPadding:115.0];
    menu.position = CGPointMake(157.0f, 55.0f);
    [self addChild:menu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)redoMission {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)skipMission {
    [UserModel nextLevel];
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
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
        self.level.completed = [LevelModel levelCompleted:[UserModel level]];
        if (self.level.completed) {
            [UserModel nextLevel];
        }
        self.level = [LevelModel findByLevel:[UserModel level]];
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
    if (self.counter == kEND_OF_LEVEL_TICK_1) {
        [self insertSamplesCollected];
    } else if (self.counter == kEND_OF_LEVEL_TICK_2) {
        [self insertSamplesReturned];
    } else if (self.counter == kEND_OF_LEVEL_TICK_3) {
        [self insertSensorsPlaced];
    } else if (self.counter == kEND_OF_LEVEL_TICK_4) {
        [self insertEnergyBonus];
    } else if (self.counter == kEND_OF_LEVEL_TICK_5) {
        if (self.level.completed) {
            [self insertLevelCompletedBonus];
        } else {
            [self insertTotalScore];
        }
    } else if (self.counter == kEND_OF_LEVEL_TICK_6) {
        if (self.level.completed) {
            [self insertTotalScore];
        } else {
            [self insertMissionFailedMenu];
        }
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}    

@end
