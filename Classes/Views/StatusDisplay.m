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
#define kDISPLAY_SECOND_DIGIT   23.0f
#define kENERGY_XPOS            10.0f
#define kSPEED_XPOS             68.0f
#define kSENSOR_XPOS            127.0f
#define kSAMPLE_XPOS            185.0f
#define kDIGIT_YPOS             5.0f

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StatusDisplay (PrivateAPI)

- (void)removeDigits:(NSMutableArray*)_digits;
- (CCSprite*)insertImage:(UIImage*)_image atPostion:(float)_position withKey:(NSString*)_key;
- (void)writeDisplay;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StatusDisplay

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize testDigitImage;
@synthesize digitImages;
@synthesize energyDigits;
@synthesize speedDigits;
@synthesize sensorDigits;
@synthesize sampleDigits;
@synthesize energyPosition;
@synthesize speedPosition;
@synthesize samplePosition;
@synthesize sensorPosition;
@synthesize terminalText;

//===================================================================================================================================
#pragma mark StatusDisplay PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeDigits:(NSMutableArray*)_digits {
    for (CCSprite* digit in _digits) {
        [digit removeFromParentAndCleanup:YES];
    }
    [_digits removeAllObjects];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CCSprite*)insertImage:(UIImage*)_image atPostion:(CGFloat)_position withKey:(NSString*)_key {
    CCSprite* digitSprite = [CCSprite spriteWithCGImage:_image.CGImage key:_key];
    digitSprite.position = CGPointMake(_position, kDIGIT_YPOS);
    digitSprite.anchorPoint = CGPointMake(0.0f, 0.0f);
    [self addChild:digitSprite];
    return digitSprite;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)writeDisplay {
    CGPoint basePoint = CGPointMake(248.0f, 11.0f);
    CGFloat yOffset = 13.0;
    for (int i = 0; i < [self.terminalText count]; i++) {
        CCLabel* _text = [self.terminalText objectAtIndex:i];
        _text.position = CGPointMake(basePoint.x, basePoint.y+i*yOffset);
        [self addChild:_text];
    }
}

//===================================================================================================================================
#pragma mark StatusDisplay

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)clearTerminal {
    for (CCLabel* _text in self.terminalText) {
        [_text removeFromParentAndCleanup:YES];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addTerminalText:(NSString*)_text {
    if ([self.terminalText count] > 3) {
        [self.terminalText removeLastObject];
    }
    CCLabel* _textLabel = [CCLabel labelWithString:_text fontName:@"Retroville NC" fontSize:12];
    _textLabel.color = ccc3(103,243,27);
    _textLabel.anchorPoint = CGPointMake(0.0, 0.0);
    [self.terminalText insertObject:_textLabel atIndex:0];
    [self clearTerminal];
    [self writeDisplay];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    return [self createWithFile:@"empty-display.png"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)createWithFile:(NSString*)_display {
    return [[[self alloc] initWithFile:_display] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)clear {
    [self removeDigits:self.energyDigits];
    [self removeDigits:self.speedDigits];
    [self removeDigits:self.sensorDigits];
    [self removeDigits:self.sampleDigits];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)test {
    [self setTest:EnergyDisplayType];
    [self setTest:SpeedDisplayType];
    [self setTest:SensorDisplayType];
    [self setTest:SampleDisplayType];
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
    [self clearDisplay:_displayType];
    switch(_displayType) {
        case EnergyDisplayType:
            [self.energyDigits addObject:[self insertImage:self.testDigitImage atPostion:kENERGY_XPOS withKey:@"test"]];
            [self.energyDigits addObject:[self insertImage:self.testDigitImage atPostion:(kENERGY_XPOS+kDISPLAY_SECOND_DIGIT) withKey:@"test"]];
            break;
        case SpeedDisplayType:
            [self.speedDigits addObject:[self insertImage:self.testDigitImage atPostion:kSPEED_XPOS withKey:@"test"]];
            [self.speedDigits addObject:[self insertImage:self.testDigitImage atPostion:(kSPEED_XPOS+kDISPLAY_SECOND_DIGIT) withKey:@"test"]];
            break;
        case SensorDisplayType:
            [self.sensorDigits addObject:[self insertImage:self.testDigitImage atPostion:kSENSOR_XPOS withKey:@"test"]];
            [self.sensorDigits addObject:[self insertImage:self.testDigitImage atPostion:(kSENSOR_XPOS+kDISPLAY_SECOND_DIGIT) withKey:@"test"]];
            break;
        case SampleDisplayType:
            [self.sampleDigits addObject:[self insertImage:self.testDigitImage atPostion:kSAMPLE_XPOS withKey:@"test"]];
            [self.sampleDigits addObject:[self insertImage:self.testDigitImage atPostion:(kSAMPLE_XPOS+kDISPLAY_SECOND_DIGIT) withKey:@"test"]];
            break;
    }
}
                                        
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setDigits:(NSInteger)_digits forDisplay:(DisplayType)_displayType {
    [self clearDisplay:_displayType];
    NSInteger tensDigit = floor((CGFloat)_digits/10.0f);
    NSInteger onesDigit = _digits - 10*tensDigit;
    NSString* tensDigitKey = [NSString stringWithFormat:@"%d", tensDigit];
    NSString* onesDigitKey = [NSString stringWithFormat:@"%d", onesDigit];
    switch(_displayType) {
        case EnergyDisplayType:
            [self.energyDigits addObject:[self insertImage:[self.digitImages objectAtIndex:tensDigit] atPostion:kENERGY_XPOS withKey:tensDigitKey]];
            [self.energyDigits addObject:[self insertImage:[self.digitImages objectAtIndex:onesDigit] atPostion:(kENERGY_XPOS+kDISPLAY_SECOND_DIGIT) withKey:onesDigitKey]];
            break;
        case SpeedDisplayType:
            [self.speedDigits addObject:[self insertImage:[self.digitImages objectAtIndex:tensDigit] atPostion:kSPEED_XPOS withKey:tensDigitKey]];
            [self.speedDigits addObject:[self insertImage:[self.digitImages objectAtIndex:onesDigit] atPostion:(kSPEED_XPOS+kDISPLAY_SECOND_DIGIT) withKey:onesDigitKey]];
            break;
        case SensorDisplayType:
            [self.sensorDigits addObject:[self insertImage:[self.digitImages objectAtIndex:tensDigit] atPostion:kSENSOR_XPOS withKey:tensDigitKey]];
            [self.sensorDigits addObject:[self insertImage:[self.digitImages objectAtIndex:onesDigit] atPostion:(kSENSOR_XPOS+kDISPLAY_SECOND_DIGIT) withKey:onesDigitKey]];
            break;
        case SampleDisplayType:
            [self.sampleDigits addObject:[self insertImage:[self.digitImages objectAtIndex:tensDigit] atPostion:kSAMPLE_XPOS withKey:tensDigitKey]];
            [self.sampleDigits addObject:[self insertImage:[self.digitImages objectAtIndex:onesDigit] atPostion:(kSAMPLE_XPOS+kDISPLAY_SECOND_DIGIT) withKey:onesDigitKey]];
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)clearDisplay:(DisplayType)_displayType {
    switch(_displayType) {
        case EnergyDisplayType:
            [self removeDigits:self.energyDigits];
            break;
        case SpeedDisplayType:
            [self removeDigits:self.speedDigits];
            break;
        case SensorDisplayType:
            [self removeDigits:self.sensorDigits];
            break;
        case SampleDisplayType:
            [self removeDigits:self.sampleDigits];
            break;
    }
}

//===================================================================================================================================
#pragma mark CCSprite

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFile:(NSString *)_filename {
	if((self=[super initWithFile:_filename])) {
        self.anchorPoint = CGPointMake(0.0f, 0.0f);
        self.energyPosition = CGPointMake(kENERGY_XPOS, kDIGIT_YPOS);
        self.speedPosition = CGPointMake(kSPEED_XPOS, kDIGIT_YPOS);
        self.sensorPosition = CGPointMake(kSENSOR_XPOS, kDIGIT_YPOS);
        self.samplePosition = CGPointMake(kSAMPLE_XPOS, kDIGIT_YPOS);
        self.testDigitImage = [UIImage imageNamed:@"LCD-test.png"];
        self.digitImages = [NSMutableArray arrayWithCapacity:10];
        self.energyDigits = [NSMutableArray arrayWithCapacity:2];
        self.speedDigits = [NSMutableArray arrayWithCapacity:2];
        self.sensorDigits = [NSMutableArray arrayWithCapacity:2];
        self.sampleDigits = [NSMutableArray arrayWithCapacity:2];
        self.terminalText = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 10; i++) {
            NSString* imageFile = [NSString stringWithFormat:@"LCD-%d.png", i];
            UIImage* digitImage = [UIImage imageNamed:imageFile];
            [self.digitImages addObject:digitImage];
        }
	}
	return self;
}

@end
