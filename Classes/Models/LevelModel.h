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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LevelModel : NSObject {
    NSInteger pk;
    NSInteger level;
    NSInteger quadrangle;
    BOOL completed;
    NSInteger score;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger quadrangle;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) NSInteger score;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (LevelModel*)findByLevel:(NSInteger)_level;
+ (NSMutableArray*)findAllByQudrangle:(NSInteger)_quad;
+ (NSMutableArray*)findAll;
+ (void)insertForLevel:(NSInteger)_level;
+ (void)completeLevel:(NSInteger)_level withScore:(NSInteger)_score;
+ (void)setScore:(NSInteger)_score forLevel:(NSInteger)_level;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (NSInteger)completedAsInteger;
- (void)setCompletedAsInteger:(NSInteger)_value;

@end
