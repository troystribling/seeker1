//
//  SeekerSprite.h
//  seeker1
//
//  Created by Troy Stribling on 11/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagSeekerBearing {
    NorthSeekerBearing,
    SouthSeekerBearing,
    EastSeekerBearing,
    WestSeekerBearing,
} SeekerBearing;

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeekerSprite : CCSprite {
    BOOL isUninitiailized;
    SeekerBearing bearing;
    NSInteger sensorCount;
    NSInteger sampleCount;
    CGFloat speed;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) BOOL isUninitiailized;
@property (nonatomic, assign) SeekerBearing bearing;
@property (nonatomic, assign) NSInteger sensorCount;
@property (nonatomic, assign) NSInteger sampleCount;
@property (nonatomic, assign) CGFloat speed;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;
- (void)setToStartPoint:(CGPoint)_point withBearing:(NSString*)_bearing;
- (CGPoint)positionDeltaAlongBearing:(CGSize)_delta;
- (CGPoint)nextPositionForDelta:(CGSize)_delta;
- (void)moveBy:(CGSize)_delta;
- (void)turnLeft;
- (BOOL)getSample;
- (void)putSensor;
- (NSInteger)loadSensors:(NSInteger)_sensors;

@end
