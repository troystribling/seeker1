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

- (void)setStartOrientation:(NSString*)_orientation;
- (SeekerBearing)leftFromBearing;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeekerSprite

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize isUninitiailized;
@synthesize bearing;
@synthesize sampleCount;
@synthesize sensorCount;
@synthesize speed;

//===================================================================================================================================
#pragma mark SeekerSprite PrivateAPI

- (void)setStartBearing:(NSString*)_bearing {
    CGFloat rotationAngle = 0.0;
    if ([_bearing isEqualToString:@"east"]) {
        self.bearing = EastSeekerBearing;
        rotationAngle = -270.0;
    } else if ([_bearing isEqualToString:@"west"]) {
        self.bearing = WestSeekerBearing;
        rotationAngle = -90.0;
    } else if ([_bearing isEqualToString:@"south"]) {
        self.bearing = SouthSeekerBearing;
        rotationAngle = -180.0;
    } else {
        self.bearing = NorthSeekerBearing;
    }
    [self runAction:[CCRotateBy actionWithDuration:kSEEKER_BASE_SPEED/self.speed angle:rotationAngle]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (SeekerBearing)leftFromBearing {
    SeekerBearing left;
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
+ (id)create {
    return [[[self alloc] initWithFile:@"seeker-1.png"] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setToStartPoint:(CGPoint)_point withBearing:(NSString*)_bearing {
    self.isUninitiailized = NO;
    self.position = _point;
    [self setStartBearing:_bearing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)moveToPoint:(CGPoint)_point {
    [self runAction:[CCMoveBy actionWithDuration:kSEEKER_BASE_SPEED/self.speed position:_point]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rotateLeft {
    self.bearing = [self leftFromBearing];
    [self runAction:[CCRotateBy actionWithDuration:kSEEKER_BASE_SPEED/self.speed angle:-90.0]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)getSample {
    BOOL status = YES;
    self.sampleCount++;
    if (self.sampleCount == kSEEKER_MAX_SAMMPLES) {
        status = NO;
    }
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)putSensor {
    self.sensorCount--;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)loadSensors:(NSInteger)_sensors {
    NSInteger extra = 0;
    if (_sensors >= kSEEKER_MAX_SENSORS) {
        extra = _sensors - kSEEKER_MAX_SENSORS;
    }
    return extra;
}

//===================================================================================================================================
#pragma mark CCSprite

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFile:(NSString *)_filename {
	if((self=[super initWithFile:_filename])) {
        self.isUninitiailized = YES;
        self.speed = 1.0;
        self.anchorPoint = CGPointMake(0.5f, 0.5f);
	}
	return self;
}

@end
