//
//  StatusDisplay.m
//  seeker1
//
//  Created by Troy Stribling on 11/24/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "StatusDisplay.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kDISPLAY_XPOS_OFFSET    23.0f
#define kENERGY_XPOS            11.0f
#define kSPEED_XPOS             70.0f
#define kSENSOR_XPOS            129.0f
#define kSAMPLE_XPOS            187.0f
#define kDISPLAY_YPOS           422.0f

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StatusDisplay (PrivateAPI)

- (NSInteger)firstDigitPosition:(DisplayType)_displayType;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StatusDisplay

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize testDisplay;
@synthesize digits;
@synthesize energyPosition;
@synthesize speedPosition;
@synthesize samplePosition;
@synthesize sensorPosition;

//===================================================================================================================================
#pragma mark StatusDisplay PrivateAPI

//===================================================================================================================================
#pragma mark StatusDisplay

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    return [self createWithFile:@"empty-display.png"];
}
//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)createWithFile:(NSString*)_display {
    return [[[self alloc] initWithFile:_display] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert:(CCLayer*)_layer {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect rect = self.textureRect;
    self.position = CGPointMake(0.0f, screenSize.height-rect.size.height);
    [_layer addChild:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setTest:(DisplayType)_displayType {
}
                                        
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setDigits:(NSInteger)_digit forDisplay:(DisplayType)_displayType {
}

//===================================================================================================================================
#pragma mark CCSprite

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFile:(NSString *)_filename {
	if((self=[super initWithFile:_filename])) {
        self.anchorPoint = CGPointMake(0.0f, 0.0f);
        self.energyPosition = CGPointMake(kENERGY_XPOS, kDISPLAY_YPOS);
        self.speedPosition = CGPointMake(kSPEED_XPOS, kDISPLAY_YPOS);
        self.sensorPosition = CGPointMake(kSENSOR_XPOS, kDISPLAY_YPOS);
        self.samplePosition = CGPointMake(kSAMPLE_XPOS, kDISPLAY_YPOS);
        self.testDisplay = [CCSprite spriteWithFile:@"LCD-test.png"];
        for (int i = 0; i < 10; i++) {
            NSString* file = [NSString stringWithFormat:@"LCD-%d.png", i];
            CCSprite* digit = [CCSprite spriteWithFile:file];
            [self.digits addObject:digit];
        }
	}
	return self;
}

@end
