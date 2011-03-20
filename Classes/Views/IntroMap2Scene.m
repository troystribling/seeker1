//
//  IntroMap2Scene.m
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "IntroMap2Scene.h"
#import "StatusDisplay.h"
#import "SeekerSprite.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAX_TAPS           1
#define kINTRO_2_TICK_1     30
#define kITEM_COUNTER_DELTA 60
#define kTAP_COUNTER_DELTA  180

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroMap2Scene (PrivateAPI)

- (void)initObjects;
- (void)updateEnergy;
- (void)updateSensorCount;
- (void)initStatusDisplay;
-(void)showTapToContinue;
-(void)showMessage;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation IntroMap2Scene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize displayedMessageSprite;
@synthesize tapCounterMessageSprite;
@synthesize sensorSiteSprite;
@synthesize sensorSprite;
@synthesize seeker;
@synthesize messageDisplayedCount;
@synthesize tapCounter;
@synthesize counter;
@synthesize energy;
@synthesize acceptTouches;

//===================================================================================================================================
#pragma mark IntroMap2Scene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initObjects {
    self.seeker = [SeekerSprite create];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    [self.seeker setToStartPoint:CGPointMake(screenSize.width/2.0 - 10.0, 240.0) withBearing:@"south"];
    CCSprite* homeBase = [CCSprite spriteWithFile:@"map2-home-base.png"];
    homeBase.position = CGPointMake(screenSize.width/2.0 - 40.0, 210.0);
    self.sensorSiteSprite = [CCSprite spriteWithFile:@"map2-sensor-site.png"];
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
-(void)showTapToContinue {
    self.acceptTouches = YES;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.tapCounterMessageSprite = [CCSprite spriteWithFile:@"tap-to-continue.png"];
    self.tapCounterMessageSprite.position = CGPointMake(screenSize.width/2.0, 15.0);
    [self addChild:self.tapCounterMessageSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void)showMessage {
    self.acceptTouches = NO;
    self.messageDisplayedCount = self.counter;
    self.tapCounter++;
    if (self.tapCounterMessageSprite) {
        [self.tapCounterMessageSprite removeFromParentAndCleanup:YES];
        self.tapCounterMessageSprite = nil;
    }
    if (self.tapCounter > 1) {
        [self.displayedMessageSprite removeFromParentAndCleanup:YES];
    }
    switch (self.tapCounter) {
        case 1:
            self.displayedMessageSprite = [CCSprite spriteWithFile:@"map2-text-1.png"];
            break;
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.displayedMessageSprite.position = CGPointMake(screenSize.width/2, 285.0);
    self.displayedMessageSprite.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:self.displayedMessageSprite];
}

//===================================================================================================================================
#pragma mark IntroMap2Scene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	IntroMap2Scene *layer = [IntroMap2Scene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.energy = 6;
        self.tapCounter = 0;
        self.messageDisplayedCount = kINTRO_2_TICK_1;
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"empty-map.png"];
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
    if (self.counter == kINTRO_2_TICK_1) {
        [self showMessage];
    } else if ((self.counter - self.messageDisplayedCount) > kTAP_COUNTER_DELTA && self.tapCounterMessageSprite == nil) {
        [self showTapToContinue];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.acceptTouches) {
        if (self.tapCounter < kMAX_TAPS) {
            [self showMessage];
        } else {
        }
    }
}    

@end
