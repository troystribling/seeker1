//
//  LevelModel.m
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "LevelModel.h"
#import "SeekerDbi.h"
#import "SeekerSprite.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LevelModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LevelModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize level;
@synthesize quadrangle;
@synthesize completed;
@synthesize score;
@synthesize samplesReturned;
@synthesize sensorsPlaced;
@synthesize expectedCodeScore;
@synthesize codeScore;

//===================================================================================================================================
#pragma mark LevelModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[SeekerDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM levels"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[SeekerDbi instance]  updateWithStatement:@"DROP TABLE levels"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[SeekerDbi instance]  updateWithStatement:@"CREATE TABLE levels (pk integer primary key, level integer, completed integer, score integer, quadrangle integer, samplesReturned integer, sensorsPlaced integer, expectedCodeScore integer, codeScore integer)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (LevelModel*)findByLevel:(NSInteger)_level {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM levels WHERE level = %d", _level];
	LevelModel* model = [[[LevelModel alloc] init] autorelease];
	[[SeekerDbi instance] selectForModel:[LevelModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAllByQudrangle:(NSInteger)_quad {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM levels WHERE quadrangle = %d", _quad];
	[[SeekerDbi instance] selectAllForModel:[LevelModel class] withStatement:selectStatement andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[SeekerDbi instance] selectAllForModel:[LevelModel class] withStatement:@"SELECT * FROM levels" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)maxLevel {
	return [[SeekerDbi instance]  selectIntExpression:@"SELECT MAX(level) FROM levels"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[SeekerDbi instance]  updateWithStatement:@"DELETE FROM levels"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertForLevel:(NSInteger)_level {
    LevelModel* model = [self findByLevel:_level];
    if (model == nil) {
        model = [[[LevelModel alloc] init] autorelease];
        model.level = _level;
        model.quadrangle = model.level / kMISSIONS_PER_QUAD;
        model.completed = NO;
        model.score = 0;
        [model insert];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)completeLevel:(NSInteger)_level forSeeker:(SeekerSprite*)_seeker {
    LevelModel* model = [self findByLevel:_level];
    if (model) {
        model.completed = YES;
        model.score = [_seeker score];
        model.samplesReturned = _seeker.samplesReturned;
        model.sensorsPlaced = _seeker.sensorsPlaced;
        model.expectedCodeScore = _seeker.expectedCodeScore;
        model.codeScore = _seeker.codeScore;
        [model update];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)incompleteLevel:(NSInteger)_level forSeeker:(SeekerSprite*)_seeker {
    LevelModel* model = [self findByLevel:_level];
    if (model) {
        model.completed = NO;
        model.score = [_seeker score];
        model.samplesReturned = _seeker.samplesReturned;
        model.sensorsPlaced = _seeker.sensorsPlaced;
        model.expectedCodeScore = _seeker.expectedCodeScore;
        model.codeScore = _seeker.codeScore;
        [model update];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)levelCompleted:(NSInteger)_level {
    LevelModel* model = [self findByLevel:_level];
    return model.completed;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    insertStatement = [NSString stringWithFormat:@"INSERT INTO levels (level, completed, score, quadrangle, samplesReturned, sensorsPlaced, expectedCodeScore, codeScore) values (%d, %d, %d, %d, %d, %d, %d, %d)", 
                        self.level, [self completedAsInteger], self.score, self.quadrangle, self.samplesReturned, self.sensorsPlaced, self.expectedCodeScore, self.codeScore];	
    [[SeekerDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM levels WHERE pk = %d", self.pk];	
	[[SeekerDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	[[SeekerDbi instance] selectForModel:[LevelModel class] withStatement:@"SELECT * FROM levels LIMIT 1" andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE levels SET level = %d, completed = %d, score = %d, quadrangle = %d, samplesReturned = %d, sensorsPlaced = %d, expectedCodeScore = %d, codeScore = %d WHERE pk = %d", self.level, 
                                    [self completedAsInteger], self.score, self.quadrangle, self.samplesReturned, self.sensorsPlaced, self.expectedCodeScore, self.codeScore, self.pk];
	[[SeekerDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)completedAsInteger {
	return self.completed == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setCompletedAsInteger:(NSInteger)_value {
	if (_value == 1) {
		self.completed = YES; 
	} else {
		self.completed = NO;
	};
}

//===================================================================================================================================
#pragma mark LevelModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	self.level = (int)sqlite3_column_int(statement, 1);
	[self setCompletedAsInteger:(int)sqlite3_column_int(statement, 2)];
	self.score = (int)sqlite3_column_int(statement, 3);
	self.quadrangle = (int)sqlite3_column_int(statement, 4);
	self.samplesReturned = (int)sqlite3_column_int(statement, 5);
	self.sensorsPlaced = (int)sqlite3_column_int(statement, 6);
	self.expectedCodeScore = (int)sqlite3_column_int(statement, 7);
	self.codeScore = (int)sqlite3_column_int(statement, 8);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	LevelModel* model = [[LevelModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
    [model release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

@end
