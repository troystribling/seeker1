//
//  StatusDisplay.h
//  seeker1
//
//  Created by Troy Stribling on 11/24/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagDisplayType {
    EnergyDisplayType,
    SpeedDisplayType,
    SensorDisplayType,
    SampleDisplayType,
} DisplayType;

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StatusDisplay : CCSprite {
    UIImage* testDigitImage;
    NSMutableArray* digitImages;
    NSMutableArray* energyDigits;
    NSMutableArray* speedDigits;
    NSMutableArray* sampleDigits;
    NSMutableArray* sensorDigits;
    CGPoint energyPosition;
    CGPoint speedPosition;
    CGPoint samplePosition;
    CGPoint sensorPosition;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIImage* testDigitImage;
@property (nonatomic, retain) NSMutableArray* digitImages;
@property (nonatomic, retain) NSMutableArray* energyDigits;
@property (nonatomic, retain) NSMutableArray* speedDigits;
@property (nonatomic, retain) NSMutableArray* sampleDigits;
@property (nonatomic, retain) NSMutableArray* sensorDigits;
@property (nonatomic, assign) CGPoint energyPosition;
@property (nonatomic, assign) CGPoint speedPosition;
@property (nonatomic, assign) CGPoint samplePosition;
@property (nonatomic, assign) CGPoint sensorPosition;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)createWithFile:(NSString*)_display;
+ (id)create;
- (void)insert:(CCLayer*)_layer;
- (void)clearDisplay:(DisplayType)_displayType;
- (void)clear;
- (void)test;
- (void)setTest:(DisplayType)_displayType;
- (void)setDigits:(NSInteger)_digit forDisplay:(DisplayType)_displayType;

@end
