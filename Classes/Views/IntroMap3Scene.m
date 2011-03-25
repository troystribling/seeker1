//
//  IntroMap3Scene.m
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroMap3Scene.h"
#import "IntroMap4Scene.h"
#import "StatusDisplay.h"
#import "SeekerSprite.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kSTART_PROGRAM      30
#define kSEEKER_STEP_SIZE   60
#define kSEEKER_MOVE_COUNT  3
#define kSEEKER_SPEED       15

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroMap3Scene (PrivateAPI)

- (void)initObjects;
- (void)updateEnergy;
- (void)updateSensorCount;
- (void)initStatusDisplay;
- (void)showTapToContinue;
- (void)showMoveSeeker;
- (void)showPutPod;
- (void)showMissionComplete;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroMap3Scene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize startMission;
@synthesize statusDisplay;
@synthesize displayedMessageSprite;
@synthesize tapCounterMessageSprite;
@synthesize sensorSiteSprite;
@synthesize sensorSprite;
@synthesize instructionSprite;
@synthesize seeker;
@synthesize seekerMoveCount;
@synthesize counter;
@synthesize startCount;
@synthesize energy;
@synthesize acceptTouches;
@synthesize moveSeeker;
@synthesize putPod;
@synthesize missionComplete;
@synthesize tapContinue;

//===================================================================================================================================
#pragma mark IntroMap3Scene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initObjects {
    self.seeker = [SeekerSprite create];
    self.seeker.speed = kSEEKER_SPEED;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    [self.seeker setToStartPoint:CGPointMake(screenSize.width/2.0 - 10.0, 240.0) withBearing:@"south"];
    CCSprite* homeBase = [CCSprite spriteWithFile:@"map-home-base.png"];
    homeBase.position = CGPointMake(screenSize.width/2.0 - 40.0, 210.0);
    self.sensorSiteSprite = [CCSprite spriteWithFile:@"map-sensor-site.png"];
    self.sensorSiteSprite.position = CGPointMake(screenSize.width/2.0 - 10.0, 60.0);
    [self addChild:homeBase z:-1];
    [self addChild:self.seeker z:10];
    [self addChild:self.sensorSiteSprite z:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateEnergy {
    self.energy -= 2;
    [self.statusDisplay setDigits:self.energy forDisplay:EnergyDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSensorCount {
    [self.statusDisplay setDigits:0 forDisplay:SensorDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initStatusDisplay {
    [self.statusDisplay setDigits:1 forDisplay:LevelDisplayType]; 
    [self.statusDisplay setDigits:0 forDisplay:SampleDisplayType]; 
    [self.statusDisplay setDigits:15 forDisplay:SpeedDisplayType]; 
    [self.statusDisplay setDigits:1 forDisplay:SensorDisplayType]; 
    [self.statusDisplay setDigits:self.energy forDisplay:EnergyDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showTapToContinue {
    self.acceptTouches = YES;
    self.tapContinue = NO;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.tapCounterMessageSprite = [CCSprite spriteWithFile:@"tap-to-continue.png"];
    self.tapCounterMessageSprite.position = CGPointMake(screenSize.width/2.0, 15.0);
    [self addChild:self.tapCounterMessageSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMoveSeeker {
    [self updateEnergy];
    self.seekerMoveCount++;
    if (self.seekerMoveCount == kSEEKER_MOVE_COUNT) {
        self.moveSeeker = NO;
        self.putPod = YES;
    }
    if (self.instructionSprite) {
        [self.instructionSprite removeFromParentAndCleanup:YES];
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.instructionSprite = [CCSprite spriteWithFile:@"map-move.png"];
    self.instructionSprite.position = CGPointMake(screenSize.width/2.0 + 1.5*kSEEKER_STEP_SIZE, 210.0 - (self.seekerMoveCount - 1.5) * kSEEKER_STEP_SIZE);
    [self addChild:self.instructionSprite z:10];
    [self.seeker moveBy:CGPointMake(0.0, -kSEEKER_STEP_SIZE)];    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showPutPod {
    [self.sensorSprite removeFromParentAndCleanup:YES];
    self.sensorSiteSprite = [CCSprite spriteWithFile:@"map-sensor.png"];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.sensorSiteSprite.position = CGPointMake(screenSize.width/2.0 - 10.0, 60.0);
    [self addChild:self.sensorSiteSprite z:0];
    self.putPod = NO;
    self.missionComplete = YES;
    [self.instructionSprite removeFromParentAndCleanup:YES];
    self.instructionSprite = [CCSprite spriteWithFile:@"map-put-pod.png"];
    [self addChild:self.instructionSprite z:10];
    self.instructionSprite.position = CGPointMake(screenSize.width/2.0 + 1.5*kSEEKER_STEP_SIZE, 60.0);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMissionComplete {    
    self.missionComplete = NO;
    self.tapContinue = YES;
    self.displayedMessageSprite = [CCSprite spriteWithFile:@"map-mission-completed.png"];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.displayedMessageSprite.position = CGPointMake(screenSize.width/2, 275.0);
    self.displayedMessageSprite.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:self.displayedMessageSprite];
    [self.seeker rotate:360.0];
}

//===================================================================================================================================
#pragma mark IntroMap3Scene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	IntroMap3Scene *layer = [IntroMap3Scene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.energy = 6;
        self.seekerMoveCount = 0;
        self.startCount = 0;
        self.isTouchEnabled = YES;
        self.startMission = YES;
        self.moveSeeker = NO;
        self.putPod = NO;
        self.missionComplete = NO;
        self.tapContinue = NO;
        self.instructionSprite = nil;
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"empty-map-stop.png"];
        backgroundGrid.anchorPoint = CGPointMake(0.0, 0.0);
        backgroundGrid.position = CGPointMake(0.0, 0.0);
        [self addChild:backgroundGrid z:-10];
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self initObjects];
        [self initStatusDisplay];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    NSInteger seekerActions = [self.seeker numberOfRunningActions];
    if (seekerActions == 0) {
        if (self.startMission) {
            self.startMission = NO;
            self.startCount = self.counter;
        } else if (self.counter - self.startCount == kSTART_PROGRAM) {
            self.moveSeeker = YES;
        } else if (self.moveSeeker) {
            [self showMoveSeeker];
        } else if (self.putPod) {
            [self showPutPod];
        } else if (self.missionComplete) {
            [self showMissionComplete];
        } else if (self.tapContinue) {
            [self showTapToContinue];
        }    
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.acceptTouches) {
        [[CCDirector sharedDirector] replaceScene: [IntroMap4Scene scene]];
    }
}    

@end
