//
//  LevelModel.h
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


//-----------------------------------------------------------------------------------------------------------------------------------
@class SeekerSprite;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LevelModel : NSObject {
    NSInteger pk;
    NSInteger level;
    NSInteger quadrangle;
    BOOL completed;
    NSInteger score;
    NSInteger samplesReturned;
    NSInteger sensorsPlaced;
    NSInteger expectedCodeScore;
    NSInteger codeScore;
    NSInteger sampleSites;
    NSInteger sensorSites;
    NSString* errorCode;
    NSString* errorMsg;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger quadrangle;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger samplesReturned;
@property (nonatomic, assign) NSInteger sensorsPlaced;
@property (nonatomic, assign) NSInteger expectedCodeScore;
@property (nonatomic, assign) NSInteger codeScore;
@property (nonatomic, assign) NSInteger sampleSites;
@property (nonatomic, assign) NSInteger sensorSites;
@property (nonatomic, assign) NSString* errorCode;
@property (nonatomic, assign) NSString* errorMsg;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (NSInteger)totalScore;
+ (NSInteger)maxScore;
+ (NSInteger)completedLevels;
+ (NSInteger)avgCodeScore;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (LevelModel*)findByLevel:(NSInteger)_level;
+ (NSMutableArray*)findAllByQudrangle:(NSInteger)_quad;
+ (NSMutableArray*)findAll;
+ (NSInteger)maxLevel;
+ (void)insertForLevel:(NSInteger)_level;
+ (void)completeLevel:(NSInteger)_level forSeeker:(SeekerSprite*)_seeker;
+ (void)incompleteLevel:(NSInteger)_level forSeeker:(SeekerSprite*)_seeker;
+ (BOOL)levelCompleted:(NSInteger)_level;
+ (void)setLevel:(NSInteger)_level errorCode:(NSString*)_errCode andMessage:(NSString*)_errMsg;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (NSInteger)completedAsInteger;
- (void)setCompletedAsInteger:(NSInteger)_value;

@end
