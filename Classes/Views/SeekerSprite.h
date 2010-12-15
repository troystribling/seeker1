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
    SeekerBearing bearing;
    NSInteger energyTotal;
    NSInteger energy;
    NSInteger sampleSites;
    NSInteger samplesBin;
    NSInteger samples;
    NSInteger sensorSites;
    NSInteger sensorBin;
    NSInteger sensors;
    NSInteger speed;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) SeekerBearing bearing;
@property (nonatomic, assign) NSInteger energyTotal;
@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) NSInteger sampleSites;
@property (nonatomic, assign) NSInteger samplesBin;
@property (nonatomic, assign) NSInteger samples;
@property (nonatomic, assign) NSInteger sensorSites;
@property (nonatomic, assign) NSInteger sensorBin;
@property (nonatomic, assign) NSInteger sensors;
@property (nonatomic, assign) NSInteger speed;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;
- (void)setToStartPoint:(CGPoint)_point withBearing:(NSString*)_bearing;
- (void)resetToStartPoint:(CGPoint)_point withBearing:(NSString*)_bearing;
- (CGPoint)positionDeltaAlongBearing:(CGSize)_delta;
- (CGPoint)nextPositionForDelta:(CGSize)_delta;
- (void)moveBy:(CGSize)_delta;
- (void)turnLeft;
- (BOOL)putSample;
- (void)emptySampleBin;
- (BOOL)putSensor;
- (void)emptySensorBin;
- (void)initParams:(NSDictionary*)_site;

@end
