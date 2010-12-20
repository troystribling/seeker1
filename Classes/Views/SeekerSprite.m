//
//  SeekerSprite.m
//  seeker1
//
//  Created by Troy Stribling on 11/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SeekerSprite.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeekerSprite (PrivateAPI)

- (SeekerBearing)leftFromBearing;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeekerSprite

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize bearing;
@synthesize energyTotal;
@synthesize energy;
@synthesize sampleSites;
@synthesize sampleBin;
@synthesize samplesCollected;
@synthesize samplesRemaining;
@synthesize sensorSites;
@synthesize sensorBin;
@synthesize sensorsPlaced;
@synthesize sensorsRemaining;
@synthesize speed;

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
    self.sensorSites = [[_site valueForKey:@"sensorSites"] intValue];
    self.sampleSites = [[_site valueForKey:@"sampleSites"] intValue];
    self.samplesCollected = 0;
    self.sensorsPlaced = 0;
    self.samplesRemaining = self.sampleSites;
    self.sensorsRemaining = self.sensorSites;
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
    CGPoint bearingDelta;
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
- (void)moveBy:(CGSize)_delta {
    CGPoint deltaBearing = [self positionDeltaAlongBearing:_delta];
    [self runAction:[CCMoveBy actionWithDuration:kSEEKER_BASE_SPEED/self.speed position:deltaBearing]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)useEnergy:(CGFloat)_deltaEnergy {
    BOOL hasEnergy = NO;
    self.energy -= _deltaEnergy;
    if (self.energy >= 0) {hasEnergy = YES;}
    return hasEnergy;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)turnLeft {
    self.bearing = [self leftFromBearing];
    [self runAction:[CCRotateBy actionWithDuration:kSEEKER_BASE_SPEED/self.speed angle:-90.0]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)getSample {
    BOOL status = YES;
    self.samplesCollected++;
    self.sampleBin++;
    self.samplesRemaining--;
    if (self.sampleBin == kSEEKER_SAMPLE_BIN_SIZE) {
        status = NO;
    }
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)emptySampleBin {
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
- (void)loadSensorBin {
    if (self.sensorsRemaining > kSEEKER_SENSOR_BIN_SIZE) {
        self.sensorBin = kSEEKER_SENSOR_BIN_SIZE;
    } else {
        self.sensorBin = self.sensorsRemaining;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isGameOver {
    BOOL gameIsOver = YES;
    if (self.sensorsPlaced == self.sensorSites &&
        self.samplesCollected == self.sampleSites &&
        self.sampleBin  == 0) {
        gameIsOver = YES;
    }
    return gameIsOver;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// rotate
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark rotate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rotate:(CGFloat)_angle {
    [self runAction:[CCRotateBy actionWithDuration:kSEEKER_BASE_SPEED/self.speed angle:_angle]];
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
        self.speed = 10;
        self.anchorPoint = CGPointMake(0.5f, 0.5f);
	}
	return self;
}

@end
