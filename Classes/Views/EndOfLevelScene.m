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
#import "ProgramNgin.h"
#import "ViewControllerManager.h"

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
- (void)insertSamplesReturnedLabel:(CGPoint)_position;
- (void)insertSensorsPlacedLabel:(CGPoint)_position;
- (void)insertCodeScoreLabel;
- (void)insertFailedTotalScoreLabel;
- (void)insertCompletedTotalScoreLabel;
- (void)insertMissionFailedMenu;
- (void)redoMission;
- (void)skipMission;
- (void)againMission;
- (void)nextMission;
- (void)nextLevel;

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
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCLabel* titleLabel = [CCLabel labelWithString:@"Mission Failure" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    titleLabel.position = CGPointMake(screenSize.width/2.0, 380.0f);
    titleLabel.color = ccc3(204,51,0); 
    [self addChild:titleLabel];
    CCLabel* errorMsgLabel = [CCLabel labelWithString:self.level.errorMsg fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    errorMsgLabel.position = CGPointMake(screenSize.width/2.0, 347.0f);
    errorMsgLabel.color = ccc3(204,51,0);    
    [self addChild:errorMsgLabel];
    NSString* errorCodeString = [NSString stringWithFormat:@"Error Code: %@", self.level.errorCode];
    CCLabel* errorCodeLabel = [CCLabel labelWithString:errorCodeString fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    errorCodeLabel.position = CGPointMake(screenSize.width/2.0, 322.0f);
    errorCodeLabel.color = ccc3(204,51,0);    
    [self addChild:errorCodeLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCompletedTitleLabel {
    CCLabel* titleLabel = [CCLabel labelWithString:@"Mission Completed" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    titleLabel.position = CGPointMake(20.0, 360.0f);
    titleLabel.color = ccc3(255,255,0);    
    titleLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self addChild:titleLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSamplesReturnedLabel:(CGPoint)_position {
    NSInteger samplesReturnedScore = self.level.samplesReturned * kPOINTS_PER_OBJECT;
    NSString* samplesReturnedString = [NSString stringWithFormat:@"Samples Returned     %d*%d = %d", 
                                       self.level.samplesReturned, kPOINTS_PER_OBJECT, samplesReturnedScore];
    CCLabel* samplesReturnedLabel = [CCLabel labelWithString:samplesReturnedString dimensions:CGSizeMake(250, 60) 
                                                   alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    samplesReturnedLabel.position = _position;
    samplesReturnedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    samplesReturnedLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:samplesReturnedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSensorsPlacedLabel:(CGPoint)_position {
    NSInteger sensorsPlacedScore = self.level.sensorsPlaced * kPOINTS_PER_OBJECT;
    NSString* sensorsPlacedString = [NSString stringWithFormat:@"Sensors Placed       %d*%d = %d", 
                                       self.level.sensorsPlaced, kPOINTS_PER_OBJECT, sensorsPlacedScore];
    CCLabel* sensorsPlacedLabel = [CCLabel labelWithString:sensorsPlacedString dimensions:CGSizeMake(250, 60) 
                                               alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    sensorsPlacedLabel.position = _position;
    sensorsPlacedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    sensorsPlacedLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:sensorsPlacedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCodeScoreLabel {
    NSInteger deltaCodeScore = self.level.codeScore - self.level.expectedCodeScore;
    NSInteger expScore = self.level.expectedCodeScore;
    if (deltaCodeScore < 0) {
        deltaCodeScore = 0;
        expScore = self.level.codeScore;
    } 
    NSInteger codeScore = (int)(100.0*(float)(expScore)/(float)self.level.codeScore);
    NSInteger codeScorePoints = deltaCodeScore * kPOINTS_PER_CODE_LINE;
    CCLabel* codeScoreLabel;
    if (deltaCodeScore == 0) {        
        NSString* codeScoreString = [NSString stringWithFormat:@"Code Score: %d%%", codeScore];
        codeScoreLabel = [CCLabel labelWithString:codeScoreString fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
        codeScoreLabel.position = CGPointMake(20.0f, 208.0f);
        codeScoreLabel.color = kCCLABEL_FONT_COLOR;
    } else {
        NSString* codeScoreString = [NSString stringWithFormat:@"Code Score: %d%%     Penalty          %d*%d = %d", 
                                      codeScore, deltaCodeScore, kPOINTS_PER_CODE_LINE, codeScorePoints];
        codeScoreLabel = [CCLabel labelWithString:codeScoreString dimensions:CGSizeMake(250, 90) 
                                         alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
        codeScoreLabel.position = CGPointMake(20.0f, 143.0f);
        codeScoreLabel.color = ccc3(204,51,0);
    }
    codeScoreLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self addChild:codeScoreLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCompletedTotalScoreLabel {
    NSInteger deltaCodeScore = self.level.codeScore - self.level.expectedCodeScore;
    NSString* totalScoreString = [NSString stringWithFormat:@"Total Score: %d", self.level.score];
    CCLabel* totalScoreLabel = [CCLabel labelWithString:totalScoreString dimensions:CGSizeMake(300, 60) 
                                              alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    totalScoreLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    totalScoreLabel.color = ccc3(255,255,0);
    if (deltaCodeScore == 0) {
        totalScoreLabel.position = CGPointMake(20.0f, 138.0f);
    } else {
        totalScoreLabel.position = CGPointMake(20.0f, 82.0f);
    }
    [self addChild:totalScoreLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertMissionFailedMenu {
    CCLabel* redoLabel = [CCLabel labelWithString:@"<Redo" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    redoLabel.color = ccc3(204,51,0);
    CCMenuItemLabel* redoItem = [CCMenuItemLabel itemWithLabel:redoLabel
                                                        target:self
                                                        selector:@selector(redoMission)];
    CCLabel* skipLabel = [CCLabel labelWithString:@"Skip>" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
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
    CCLabel* againLabel = [CCLabel labelWithString:@"<Again" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    againLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* againItem = [CCMenuItemLabel itemWithLabel:againLabel
                                                         target:self
                                                         selector:@selector(againMission)];
    CCLabel* skipLabel = [CCLabel labelWithString:@"Next>" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    skipLabel.color = kCCLABEL_FONT_COLOR;
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
    [ProgramNgin instance].programHalted = NO;
    [ProgramNgin instance].programRunning = NO;
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)skipMission {
    [ProgramNgin instance].programHalted = NO;
    [ProgramNgin instance].programRunning = NO;
    [self nextLevel];
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)againMission {
    [ProgramNgin instance].programHalted = NO;
    [ProgramNgin instance].programRunning = NO;
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)nextMission {
    [ProgramNgin instance].programHalted = NO;
    [ProgramNgin instance].programRunning = NO;
    [self nextLevel];
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)nextLevel {   
    TutorialSectionID sectionID = GettingStartedTutorialSectionID;
    switch ([UserModel nextLevel]) {
        case kLEVEL_FOR_SUBROUTINES:
            sectionID = SubroutinesTutorialSectionID;
            break;
        case kLEVEL_FOR_TIMES:
            sectionID = TimesLoopTutorialSectionID;
            break;
        case kLEVEL_FOR_UNTIL:
            sectionID = UntilLoopTutorialSectionID;
            break;
        case kLEVEL_FOR_BINS:
            sectionID = RoverBinsTutorialSectionID;
            break;
        default:
            break;
    }
    if (sectionID != GettingStartedTutorialSectionID) {
        [[ViewControllerManager instance] showTutorialIntroductionView:[[CCDirector sharedDirector] openGLView] withSectionID:sectionID];
        [UserModel tutorialWasShown:sectionID];
    }
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
        [self.statusDisplay test];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter == kEND_OF_LEVEL_TICK_1) {
        if (self.level.completed) {
            [self insertSamplesReturnedLabel:CGPointMake(20.0f, 295.0f)];
        }
        [self.statusDisplay test];
    } else if (self.counter == kEND_OF_LEVEL_TICK_2) {
        if (self.level.completed) {
            [self insertSensorsPlacedLabel:CGPointMake(20.0f, 235.0f)];
        }
        [self.statusDisplay clear];
    } else if (self.counter == kEND_OF_LEVEL_TICK_3) {
        if (self.level.completed) {
            [self insertCodeScoreLabel];
        } else {
            [self insertMissionFailedMenu];
        }
        [self.statusDisplay test];
    } else if (self.counter == kEND_OF_LEVEL_TICK_4) {
        if (self.level.completed) {
            [self insertCompletedTotalScoreLabel];
        }
        [self.statusDisplay clear];
    } else if (self.counter == kEND_OF_LEVEL_TICK_5) {
        if (self.level.completed) {
            [self insertMissionCompletedMenu];
            [self.statusDisplay test];
        } 
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.level.completed) {
        [self nextLevel];
    } else {
        [ProgramNgin instance].programHalted = NO;
        [ProgramNgin instance].programRunning = NO;
    }
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}    

@end
