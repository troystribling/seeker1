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

//===================================================================================================================================
#pragma mark SeekerSprite PrivateAPI

- (void)setStartOrientation:(NSString*)_orientation {
    if ([_orientation isEqualToString:@"east"]) {
    } else if ([_orientation isEqualToString:@"west"]) {
    } else if ([_orientation isEqualToString:@"north"]) {
    } else if ([_orientation isEqualToString:@"south"]) {
    }
}

//===================================================================================================================================
#pragma mark SeekerSprite

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    return [[[self alloc] initWithFile:@"seeker-1.png"] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setToStartPoint:(CGPoint)_point withOrientation:(NSString*)_orientation {
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
	if( (self=[super initWithFile:_filename] )) {
        self.anchorPoint = CGPointMake(0.0f, 0.0f);
	}
	return self;
}

@end
