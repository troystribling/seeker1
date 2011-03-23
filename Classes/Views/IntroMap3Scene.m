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
@synthesize statusDisplay;
@synthesize displayedMessageSprite;
@synthesize tapCounterMessageSprite;
@synthesize sensorSiteSprite;
@synthesize sensorSprite;
@synthesize seeker;
@synthesize seekerMoveCount;
@synthesize counter;
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
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    [self.seeker setToStartPoint:CGPointMake(screenSize.width/2.0 - 10.0, 240.0) withBearing:@"south"];
    CCSprite* homeBase = [CCSprite spriteWithFile:@"map-home-base.png"];
    homeBase.position = CGPointMake(screenSize.width/2.0 - 40.0, 210.0);
    self.sensorSiteSprite = [CCSprite spriteWithFile:@"map-sensor-site.png"];
    self.sensorSiteSprite.position = CGPointMake(screenSize.width/2.0 - 10.0, 60.0);
    [self addChild:homeBase z:-1];
    [self addChild:self.seeker z:0];
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
    [self.seeker moveBy:CGPointMake(0.0, kSEEKER_STEP_SIZE)];    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showPutPod {
    [self.sensorSprite removeFromParentAndCleanup:YES];
    self.sensorSiteSprite = [CCSprite spriteWithFile:@"map-sensor.png"];
    [self addChild:self.sensorSiteSprite z:0];
    self.putPod = NO;
    self.missionComplete = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMissionComplete {    
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
        self.isTouchEnabled = YES;
        self.moveSeeker = NO;
        self.putPod = NO;
        self.missionComplete = NO;
        self.tapContinue = NO;
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
        if (self.counter == kSTART_PROGRAM) {
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
    }
}    

@end
