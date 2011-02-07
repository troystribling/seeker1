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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfLevelScene (PrivateAPI)

- (void)insertFailedTitleLabel;
- (void)insertCompletedTitleLabel;
- (void)insertSamplesReturnedLabel;
- (void)insertSensorsPlacedLabel;
- (void)insertCodeReviewLabel;
- (void)insertFailedTotalScoreLabel;
- (void)insertCompletedTotalScoreLabel;
- (void)insertMissionFailedMenu;
- (void)redoMission;
- (void)skipMission;
- (void)againMission;
- (void)nextMission;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EndOfLevelScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize counter;
@synthesize level;

//===================================================================================================================================
#pragma mark EndOfLevelScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertFailedTitleLabel {
    CCLabel* titleLabel = [CCLabel labelWithString:@"Mission Failure" fontName:@"Courier" fontSize:26];
    titleLabel.position = CGPointMake(20.0f, 361.0f);
    titleLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    titleLabel.color = ccc3(204,51,0);    
    [self addChild:titleLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCompletedTitleLabel {
    CCLabel* titleLabel = [CCLabel labelWithString:@"Mission Completed" fontName:@"Courier" fontSize:26];
    titleLabel.position = CGPointMake(20.0f, 361.0f);
    titleLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    titleLabel.color = ccc3(255,255,0);    
    [self addChild:titleLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSamplesReturnedLabel {
    NSInteger samplesReturnedScore = self.level.samplesReturned * kPOINTS_PER_OBJECT;
    NSString* samplesReturnedString = [NSString stringWithFormat:@"Samples Returned     %d*%d = %d", 
                                       self.level.samplesReturned, kPOINTS_PER_OBJECT, samplesReturnedScore];
    CCLabel* samplesReturnedLabel = [CCLabel labelWithString:samplesReturnedString dimensions:CGSizeMake(250, 60) 
                                                   alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    samplesReturnedLabel.position = CGPointMake(20.0f, 290.0f);
    samplesReturnedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    samplesReturnedLabel.color = ccc3(103,243,27);
    [self addChild:samplesReturnedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSensorsPlacedLabel {
    NSInteger sensorsPlacedScore = self.level.sensorsPlaced * kPOINTS_PER_OBJECT;
    NSString* sensorsPlacedString = [NSString stringWithFormat:@"Sensors Placed       %d*%d = %d", 
                                       self.level.sensorsPlaced, kPOINTS_PER_OBJECT, sensorsPlacedScore];
    CCLabel* sensorsPlacedLabel = [CCLabel labelWithString:sensorsPlacedString dimensions:CGSizeMake(250, 60) 
                                               alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    sensorsPlacedLabel.position = CGPointMake(20.0f, 230.0f);
    sensorsPlacedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    sensorsPlacedLabel.color = ccc3(103,243,27);
    [self addChild:sensorsPlacedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCodeReviewLabel {
    NSInteger deltaCodeLines = self.level.codeLines - self.level.expectedCodeLines;
    if (deltaCodeLines < 0) {
        deltaCodeLines = 0;
    }    
    NSInteger codeReviewScore = deltaCodeLines * kPOINTS_PER_CODE_LINE;
    NSString* codeReviewString = [NSString stringWithFormat:@"Code Review Penalty     %d*%d = %d", 
                                    deltaCodeLines, kPOINTS_PER_CODE_LINE, codeReviewScore];
    CCLabel* codeReviewLabel = [CCLabel labelWithString:codeReviewString dimensions:CGSizeMake(250, 60) 
                                              alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    codeReviewLabel.position = CGPointMake(20.0f, 170.0f);
    codeReviewLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    codeReviewLabel.color = ccc3(204,51,0);
    [self addChild:codeReviewLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertFailedTotalScoreLabel {
    NSString* totalScoreString = [NSString stringWithFormat:@"Total Score: %d", self.level.score];
    CCLabel* totalScoreLabel = [CCLabel labelWithString:totalScoreString fontName:@"Courier" fontSize:20];
    totalScoreLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    totalScoreLabel.color = ccc3(255,255,0);
    totalScoreLabel.position = CGPointMake(20.0f, 140.0f);
    [self addChild:totalScoreLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCompletedTotalScoreLabel {
    NSString* totalScoreString = [NSString stringWithFormat:@"Total Score and Bonus     2*%d = %d", self.level.score/2, self.level.score];
    CCLabel* totalScoreLabel = [CCLabel labelWithString:totalScoreString dimensions:CGSizeMake(300, 60) 
                                              alignment:UITextAlignmentLeft fontName:@"Courier" fontSize:20];
    totalScoreLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    totalScoreLabel.color = ccc3(255,255,0);
    totalScoreLabel.position = CGPointMake(20.0f, 110.0f);
    [self addChild:totalScoreLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertMissionFailedMenu {
    CCLabel* redoLabel = [CCLabel labelWithString:@"<Redo" fontName:@"Courier" fontSize:26];
    redoLabel.color = ccc3(204,51,0);
    CCMenuItemLabel* redoItem = [CCMenuItemLabel itemWithLabel:redoLabel
                                                        target:self
                                                        selector:@selector(redoMission)];
    CCLabel* skipLabel = [CCLabel labelWithString:@"Skip>" fontName:@"Courier" fontSize:26];
    skipLabel.color = ccc3(204,51,0);
    CCMenuItemLabel* skipItem = [CCMenuItemLabel itemWithLabel:skipLabel
                                                        target:self
                                                        selector:@selector(skipMission)];
    CCMenu* menu = [CCMenu menuWithItems:redoItem, skipItem, nil];
    [menu alignItemsHorizontallyWithPadding:115.0];
    menu.position = CGPointMake(157.0f, 55.0f);
    [self addChild:menu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertMissionCompletedMenu {
    CCLabel* againLabel = [CCLabel labelWithString:@"<Again" fontName:@"Courier" fontSize:26];
    againLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* againItem = [CCMenuItemLabel itemWithLabel:againLabel
                                                         target:self
                                                         selector:@selector(againMission)];
    CCLabel* skipLabel = [CCLabel labelWithString:@"Next>" fontName:@"Courier" fontSize:26];
    skipLabel.color = ccc3(103,243,27);
    CCMenuItemLabel* skipItem = [CCMenuItemLabel itemWithLabel:skipLabel
                                                        target:self
                                                      selector:@selector(nextMission)];
    CCMenu* menu = [CCMenu menuWithItems:againItem, skipItem, nil];
    [menu alignItemsHorizontallyWithPadding:90.0];
    menu.position = CGPointMake(155.0f, 35.0f);
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


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)againMission {
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)nextMission {
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
        self.level = [LevelModel findByLevel:[UserModel level]];
        if (self.level.completed) {
            [self insertCompletedTitleLabel];
        } else {
            [self insertFailedTitleLabel];
        }
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"~> sam"];
        [self.statusDisplay test];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter == kEND_OF_LEVEL_TICK_1) {
        [self insertSamplesReturnedLabel];
        [self.statusDisplay addTerminalText:@"~> sen"];
        [self.statusDisplay test];
    } else if (self.counter == kEND_OF_LEVEL_TICK_2) {
        [self insertSensorsPlacedLabel];
        [self.statusDisplay addTerminalText:@"~> code"];
        [self.statusDisplay clear];
    } else if (self.counter == kEND_OF_LEVEL_TICK_3) {
        [self insertCodeReviewLabel];
        [self.statusDisplay addTerminalText:@"~> tot"];
        [self.statusDisplay test];
    } else if (self.counter == kEND_OF_LEVEL_TICK_4) {
        if (self.level.completed) {
            [self insertCompletedTotalScoreLabel];
        } else {
            [self insertFailedTotalScoreLabel];
        }
        [self.statusDisplay addTerminalText:@"~> menu"];
        [self.statusDisplay clear];
    } else if (self.counter == kEND_OF_LEVEL_TICK_5) {
        if (self.level.completed) {
            [self insertMissionCompletedMenu];
        } else {
            [self insertMissionFailedMenu];
        }
        [self.statusDisplay test];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.level.completed) {
        [UserModel nextLevel];
    }
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}    

@end
