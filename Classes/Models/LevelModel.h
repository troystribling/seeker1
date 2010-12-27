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
    NSInteger codeReview;
    BOOL completed;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger codeReview;
@property (nonatomic, assign) BOOL completed;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (LevelModel*)findByLevel:(NSInteger)_level;
+ (NSMutableArray*)findAll;
+ (void)insertForLevel:(NSInteger)_level;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (NSInteger)completedAsInteger;
- (void)setCompletedAsInteger:(NSInteger)_value;

@end
