//
//  EndOfLevelScene.m
//  seeker1
//
//  Created by Troy Stribling on 1/25/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "EndOfLevelScene.h"
#import "EndOfSiteScene.h"
#import "MapScene.h"
#import "UserModel.h"
#import "LevelModel.h"
#import "StatusDisplay.h"
#import "ProgramNgin.h"
#import "ViewControllerManager.h"
#import "AudioManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kEND_OF_LEVEL_TICK_1    40
#define kEND_OF_LEVEL_TICK_2    90
#define kEND_OF_LEVEL_TICK_3    140
#define kEND_OF_LEVEL_TICK_4    190
#define kEND_OF_LEVEL_TICK_5    240

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
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"Mission Failure" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    titleLabel.position = CGPointMake(screenSize.width/2.0, 380.0f);
    titleLabel.color = kCCLABEL_FONT_RED_COLOR; 
    [self addChild:titleLabel];
    CCLabelTTF* errorMsgLabel = [CCLabelTTF labelWithString:self.level.errorMsg fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    errorMsgLabel.position = CGPointMake(screenSize.width/2.0, 347.0f);
    errorMsgLabel.color = kCCLABEL_FONT_GOLD_COLOR;    
    [self addChild:errorMsgLabel];
    CCLabelTTF* errorCodeLabel = [CCLabelTTF labelWithString:@"Error Code" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    errorCodeLabel.position = CGPointMake(screenSize.width/2.0, 312.0f);
    errorCodeLabel.color = kCCLABEL_FONT_RED_COLOR;    
    [self addChild:errorCodeLabel];
    CCLabelTTF* errorCodeID = [CCLabelTTF labelWithString:self.level.errorCode fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    errorCodeID.position = CGPointMake(screenSize.width/2.0, 287.0f);
    errorCodeID.color = kCCLABEL_FONT_RED_COLOR;    
    [self addChild:errorCodeID];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCompletedTitleLabel {
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"Mission Completed" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    titleLabel.position = CGPointMake(20.0, 360.0f);
    titleLabel.color = kCCLABEL_FONT_GOLD_COLOR;    
    titleLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self addChild:titleLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSamplesReturnedLabel:(CGPoint)_position {
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    NSInteger samplesReturnedScore = self.level.samplesReturned * kPOINTS_PER_OBJECT;
    NSString* samplesReturnedString = [NSString stringWithFormat:@"Samples Returned     %d*%d = %d", 
                                       self.level.samplesReturned, kPOINTS_PER_OBJECT, samplesReturnedScore];
    CCLabelTTF* samplesReturnedLabel = [CCLabelTTF labelWithString:samplesReturnedString dimensions:CGSizeMake(250, 60) 
                                                         alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    samplesReturnedLabel.position = _position;
    samplesReturnedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    samplesReturnedLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:samplesReturnedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertSensorsPlacedLabel:(CGPoint)_position {
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    NSInteger sensorsPlacedScore = self.level.sensorsPlaced * kPOINTS_PER_OBJECT;
    NSString* sensorsPlacedString = [NSString stringWithFormat:@"Sensors Placed       %d*%d = %d", 
                                       self.level.sensorsPlaced, kPOINTS_PER_OBJECT, sensorsPlacedScore];
    CCLabelTTF* sensorsPlacedLabel = [CCLabelTTF labelWithString:sensorsPlacedString dimensions:CGSizeMake(250, 60) 
                                               alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    sensorsPlacedLabel.position = _position;
    sensorsPlacedLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    sensorsPlacedLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:sensorsPlacedLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCodeScoreLabel {
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    NSInteger deltaCodeScore = self.level.codeScore - self.level.expectedCodeScore;
    NSInteger expScore = self.level.expectedCodeScore;
    if (deltaCodeScore < 0) {
        deltaCodeScore = 0;
        expScore = self.level.codeScore;
    } 
    NSInteger codeScore = (int)(100.0*(float)(expScore)/(float)self.level.codeScore);
    NSInteger codeScorePoints = deltaCodeScore * kPOINTS_PER_CODE_LINE;
    CCLabelTTF* codeScoreLabel;
    if (deltaCodeScore == 0) {        
        NSString* codeScoreString = [NSString stringWithFormat:@"Code Score: %d%%", codeScore];
        codeScoreLabel = [CCLabelTTF labelWithString:codeScoreString fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
        codeScoreLabel.position = CGPointMake(20.0f, 208.0f);
        codeScoreLabel.color = kCCLABEL_FONT_COLOR;
    } else {
        NSString* codeScoreString = [NSString stringWithFormat:@"Code Score: %d%%     Penalty          %d*%d = %d", 
                                      codeScore, deltaCodeScore, kPOINTS_PER_CODE_LINE, codeScorePoints];
        codeScoreLabel = [CCLabelTTF labelWithString:codeScoreString dimensions:CGSizeMake(250, 90) 
                                         alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
        codeScoreLabel.position = CGPointMake(20.0f, 143.0f);
        codeScoreLabel.color = kCCLABEL_FONT_RED_COLOR;
    }
    codeScoreLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self addChild:codeScoreLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertCompletedTotalScoreLabel {
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    NSInteger deltaCodeScore = self.level.codeScore - self.level.expectedCodeScore;
    NSString* totalScoreString = [NSString stringWithFormat:@"Total Score: %d", self.level.score];
    CCLabelTTF* totalScoreLabel = [CCLabelTTF labelWithString:totalScoreString dimensions:CGSizeMake(300, 60) 
                                              alignment:UITextAlignmentLeft fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    totalScoreLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    totalScoreLabel.color = kCCLABEL_FONT_GOLD_COLOR;
    if (deltaCodeScore <= 0) {
        totalScoreLabel.position = CGPointMake(20.0f, 138.0f);
    } else {
        totalScoreLabel.position = CGPointMake(20.0f, 82.0f);
    }
    [self addChild:totalScoreLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertMissionFailedMenu {
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    CCLabelTTF* redoLabel = [CCLabelTTF labelWithString:@"<redo" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    redoLabel.color = kCCLABEL_FONT_RED_COLOR;
    CCMenuItemLabel* redoItem = [CCMenuItemLabel itemWithLabel:redoLabel
                                                        target:self
                                                        selector:@selector(redoMission)];
    CCLabelTTF* skipLabel = [CCLabelTTF labelWithString:@"skip>" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    skipLabel.color = kCCLABEL_FONT_RED_COLOR;
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
    [[AudioManager instance] playEffect:ItemDisplayedAudioEffectID];
    CCLabelTTF* againLabel = [CCLabelTTF labelWithString:@"<again" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    againLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* againItem = [CCMenuItemLabel itemWithLabel:againLabel
                                                         target:self
                                                         selector:@selector(againMission)];
    CCLabelTTF* nextLabel = [CCLabelTTF labelWithString:@"next>" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_LARGE];
    nextLabel.color = kCCLABEL_FONT_COLOR;
    CCMenuItemLabel* nextItem = [CCMenuItemLabel itemWithLabel:nextLabel
                                                        target:self
                                                      selector:@selector(nextMission)];
    CCMenu* menu = [CCMenu menuWithItems:againItem, nextItem, nil];
    [menu alignItemsHorizontallyWithPadding:90.0];
    menu.position = CGPointMake(155.0f, 35.0f);
    [self addChild:menu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)redoMission {
    [ProgramNgin instance].programHalted = NO;
    [ProgramNgin instance].programRunning = NO;
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)skipMission {
    [self nextMission];
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)againMission {
    [ProgramNgin instance].programHalted = NO;
    [ProgramNgin instance].programRunning = NO;
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)nextMission {
    [ProgramNgin instance].programHalted = NO;
    [ProgramNgin instance].programRunning = NO;
    [UserModel nextLevel];
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    if ([UserModel isLastLevel]) {
        [[CCDirector sharedDirector] replaceScene: [EndOfSiteScene scene]];
    } else  {
        [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
        [TutorialSectionViewController nextLevel];
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
        if (self.level.level != kMISSIONS_PER_QUAD*kQUADS_TOTAL) {
            [[AudioManager instance] stopBackgroundMusic];
        }
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
        } else {
            [self insertMissionFailedMenu];
        }
        [self.statusDisplay clear];
    } else if (self.counter == kEND_OF_LEVEL_TICK_3) {
        if (self.level.completed) {
            [self insertCodeScoreLabel];
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
}    

@end
