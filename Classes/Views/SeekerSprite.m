//
//  SeekerSprite.m
//  seeker1
//
//  Created by Troy Stribling on 11/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SeekerSprite.h"
#import "UserModel.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
// seeker capacities
//-----------------------------------------------------------------------------------------------------------------------------------
#define kSEEKER_SENSOR_BIN_SIZE             5
#define kSEEKER_SAMPLE_BIN_SIZE             5

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeekerSprite (PrivateAPI)

- (SeekerBearing)leftFromBearing;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeekerSprite

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize bearing;
@synthesize expectedCodeScore;
@synthesize codeScore;
@synthesize energyTotal;
@synthesize energy;
@synthesize sampleSites;
@synthesize sampleBin;
@synthesize samplesCollected;
@synthesize samplesReturned;
@synthesize samplesRemaining;
@synthesize sensorSites;
@synthesize sensorBin;
@synthesize sensorsPlaced;
@synthesize sensorsRemaining;
@synthesize speed;
@synthesize idle;

//===================================================================================================================================
#pragma mark SeekerSprite PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (SeekerBearing)leftFromBearing {
    SeekerBearing left = 0;
    switch(self.bearing) {
        case NorthSeekerBearing:
            left = WestSeekerBearing;
            break;
        case SouthSeekerBearing:
            left = EastSeekerBearing;
            break;
        case EastSeekerBearing:
            left = NorthSeekerBearing;
            break;
        case WestSeekerBearing:
            left = SouthSeekerBearing;
            break;
    }
    return left;
}

//===================================================================================================================================
#pragma mark SeekerSprite
//-----------------------------------------------------------------------------------------------------------------------------------
// initialize/reset
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark initialize/reset

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    return [[[self alloc] initWithFile:@"seeker-1.png"] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setToStartPoint:(CGPoint)_point withBearing:(NSString*)_bearing {
    self.position = _point;
    self.bearing = [self stringToBearing:_bearing];
    CGFloat startRotation = [self rotationFromNorthToBearing:self.bearing];
    [self rotate:startRotation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetToStartPoint:(CGPoint)_point withBearing:(NSString*)_bearing {
    self.position = _point;
    CGFloat northRotation = [self rotationToNorthFromBearing];
    self.bearing = [self stringToBearing:_bearing];
    CGFloat startRotation = [self rotationFromNorthToBearing:self.bearing];
    [self rotate:(northRotation + startRotation)];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initParams:(NSDictionary*)_site {
    self.energyTotal = [[_site valueForKey:@"energy"] intValue];
    self.energy = self.energyTotal;
    self.expectedCodeScore = [[_site valueForKey:@"expectedCodeScore"] intValue];
    self.sensorSites = [[_site valueForKey:@"sensorSites"] intValue];
    self.sampleSites = [[_site valueForKey:@"sampleSites"] intValue];
    self.samplesCollected = 0;
    self.samplesReturned = 0;
    self.sampleBin = 0;
    self.sensorsPlaced = 0;
    self.speed = 0;
    self.samplesRemaining = self.sampleSites;
    self.sensorsRemaining = self.sensorSites;
    self.scale = 1.0;
    self.idle = YES;
    [self emptySampleBin];
    [self loadSensorBin];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// instructions
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark instructions

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)nextPositionForDelta:(CGSize)_delta {
    CGPoint deltaBearing = [self positionDeltaAlongBearing:_delta];
    return ccpAdd(self.position, deltaBearing);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)positionDeltaAlongBearing:(CGSize)_delta {
    CGPoint bearingDelta = CGPointMake(0.0, 0.0);
    switch(self.bearing) {
        case NorthSeekerBearing:
            bearingDelta = CGPointMake(0.0, _delta.height);
            break;
        case SouthSeekerBearing:
            bearingDelta = CGPointMake(0.0, -_delta.height);
            break;
        case EastSeekerBearing:
            bearingDelta = CGPointMake(_delta.width, 0.0);
            break;
        case WestSeekerBearing:
            bearingDelta = CGPointMake(-_delta.width, 0.0);
            break;
    }
    return bearingDelta;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)moveBy:(CGPoint)_delta {
    CGFloat speedScale = [UserModel speedScaleFactor];
    [self runAction:[CCMoveBy actionWithDuration:kSEEKER_GRID_DISTANCE/(speedScale*self.speed) position:_delta]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)useEnergy:(CGFloat)_deltaEnergy {
    BOOL hasEnergy = NO;
    if (self.energy > 0) {hasEnergy = YES;}
    self.energy -= _deltaEnergy;
    return hasEnergy;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)changeSpeed:(CGFloat)_deltaSpeed {
    BOOL validSpeed = YES;
    if (self.idle) {
        self.speed  = kSEEKER_ZERO_GRADIENT_SPEED;
        self.idle = NO;
    }
    if (_deltaSpeed == 0) {
        self.speed  = kSEEKER_ZERO_GRADIENT_SPEED;
    } else {
        self.speed += _deltaSpeed;
    }
    if (self.speed == kSEEKER_MAX_SPEED) {
        validSpeed = NO;
    } else if (self.speed == kSEEKER_MIN_SPEED) {
        validSpeed = NO;
    }
    return validSpeed;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)turnLeft {
    self.bearing = [self leftFromBearing];
    CGFloat speedScale = [UserModel speedScaleFactor];
    CGFloat duration = kSEEKER_ROTATION_DURATION_PER_QUAD / speedScale;
    [self runAction:[CCRotateBy actionWithDuration:duration angle:-90.0]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)getSample {
    BOOL status = YES;
    self.samplesCollected++;
    self.sampleBin++;
    self.samplesRemaining--;
    if (self.sampleBin > kSEEKER_SAMPLE_BIN_SIZE) {
        status = NO;
    }
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)emptySampleBin {
    self.samplesReturned += self.sampleBin;
    self.sampleBin = 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)putSensor {
    BOOL status = YES;
    self.sensorsPlaced++;
    self.sensorBin--;
    self.sensorsRemaining--;
    if (self.sensorBin < 0) {
        status = NO;
    }
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// utils
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark utils

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadSensorBin {
    if (self.sensorsRemaining > kSEEKER_SENSOR_BIN_SIZE) {
        self.sensorBin = kSEEKER_SENSOR_BIN_SIZE;
    } else {
        self.sensorBin = self.sensorsRemaining;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isLevelCompleted {
    BOOL gameIsOver = NO;
    if (self.sensorsPlaced == self.sensorSites &&
        self.samplesCollected == self.sampleSites &&
        self.sampleBin  == 0) {
        gameIsOver = YES;
    }
    return gameIsOver;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)score {
    NSInteger totalScore = kPOINTS_PER_OBJECT * (self.samplesReturned + self.sensorsPlaced);
    if ([self isLevelCompleted]) {
        self.codeScore = [ProgramNgin instance].codeScore;
        NSInteger deltaCodeLines = self.codeScore - self.expectedCodeScore;
        if (deltaCodeLines < 0) {
            deltaCodeLines = 0;
        }
        totalScore -= kPOINTS_PER_CODE_LINE * deltaCodeLines;
    }
    return totalScore;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isSensorBinEmpty {
    return (self.sensorBin == 0);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isSampleBinFull {
    return (self.sampleBin == kSEEKER_SAMPLE_BIN_SIZE);
}

//-----------------------------------------------------------------------------------------------------------------------------------
// rotate
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark rotate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rotate:(CGFloat)_angle {
    CGFloat speedScale = [UserModel speedScaleFactor];
    CGFloat duration = fabs(kSEEKER_ROTATION_DURATION_PER_QUAD * _angle / (speedScale*90.0f));
    [self runAction:[CCRotateBy actionWithDuration:duration angle:_angle]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)rotationToNorthFromBearing {
    CGFloat rotationAngle = 0.0;
    switch(self.bearing) {
        case NorthSeekerBearing:
            break;
        case SouthSeekerBearing:
            rotationAngle = 180.0;
            break;
        case EastSeekerBearing:
            rotationAngle = 270.0;
            break;
        case WestSeekerBearing:
            rotationAngle = 90.0;
            break;
    }
    return rotationAngle;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)rotationFromNorthToBearing:(SeekerBearing)_bearing {
    CGFloat rotationAngle = 0.0;
    switch(_bearing) {
        case NorthSeekerBearing:
            break;
        case SouthSeekerBearing:
            rotationAngle = -180.0;
            break;
        case EastSeekerBearing:
            rotationAngle = -270.0;
            break;
        case WestSeekerBearing:
            rotationAngle = -90.0;
            break;
    }
    return rotationAngle;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// bearing
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark bearing

//-----------------------------------------------------------------------------------------------------------------------------------
- (SeekerBearing)stringToBearing:(NSString*)_bearingString {
    SeekerBearing transBearing = NorthSeekerBearing;
    if ([_bearingString isEqualToString:@"east"]) {
        transBearing = EastSeekerBearing;
    } else if ([_bearingString isEqualToString:@"west"]) {
        transBearing = WestSeekerBearing;
    } else if ([_bearingString isEqualToString:@"south"]) {
        transBearing = SouthSeekerBearing;
    }
    return transBearing;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)bearingToString {
    NSString* bearingString = @"north";
    switch(self.bearing) {
        case NorthSeekerBearing:
            bearingString = @"north";
            break;
        case SouthSeekerBearing:
            bearingString = @"south";
            break;
        case EastSeekerBearing:
            bearingString = @"east";
            break;
        case WestSeekerBearing:
            bearingString = @"west";
            break;
    }
    return bearingString;
}

//===================================================================================================================================
#pragma mark CCSprite

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFile:(NSString *)_filename {
	if((self=[super initWithFile:_filename])) {
        self.anchorPoint = CGPointMake(0.5f, 0.5f);
	}
	return self;
}

@end
