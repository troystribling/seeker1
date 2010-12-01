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

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeekerSprite

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize isUninitiailized;

//===================================================================================================================================
#pragma mark SeekerSprite PrivateAPI

- (void)setStartOrientation:(NSString*)_orientation {
    CGFloat rotationAngle = 0.0;
    if ([_orientation isEqualToString:@"east"]) {
        rotationAngle = 90.0;
    } else if ([_orientation isEqualToString:@"west"]) {
        rotationAngle = 270.0;
    } else if ([_orientation isEqualToString:@"south"]) {
        rotationAngle = 180.0;
    }
    [self runAction:[CCRotateBy actionWithDuration:1.0f angle:rotationAngle]];
}

//===================================================================================================================================
#pragma mark SeekerSprite

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    return [[[self alloc] initWithFile:@"seeker-1.png"] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setToStartPoint:(CGPoint)_point withOrientation:(NSString*)_orientation {
    self.isUninitiailized = NO;
    self.position = _point;
    [self setStartOrientation:_orientation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)moveToPoint:(CGPoint)_point {
    [self moveToPoint:_point];
}

//===================================================================================================================================
#pragma mark CCSprite

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFile:(NSString *)_filename {
	if((self=[super initWithFile:_filename])) {
        self.isUninitiailized = YES;
        self.anchorPoint = CGPointMake(0.5f, 0.5f);
	}
	return self;
}

@end
