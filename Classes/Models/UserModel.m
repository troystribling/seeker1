//
//  UserModel.m
//  seeker1
//
//  Created by Troy Stribling on 12/19/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "UserModel.h"
#import "SeekerDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UserModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UserModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize level;
@synthesize quadrangle;

//===================================================================================================================================
#pragma mark UserModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[SeekerDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM users"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[SeekerDbi instance]  updateWithStatement:@"DROP TABLE users"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[SeekerDbi instance]  updateWithStatement:@"CREATE TABLE users (pk integer primary key, level integer, quadrangle integer)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[SeekerDbi instance]  updateWithStatement:@"DELETE FROM users"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UserModel*)findFirst {
	UserModel* model = [[[UserModel alloc] init] autorelease];
	[[SeekerDbi instance] selectForModel:[UserModel class] withStatement:@"SELECT * FROM users LIMIT 1" andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)nextLevel {
    UserModel* user = [self findFirst];
    user.level++;
    NSInteger quad = user.level / kMISSIONS_PER_QUAD;
    if (quad > user.quadrangle) {
        user.quadrangle++;
    }
    [user update];
    return user.level;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)setLevel:(NSInteger)_level {
    UserModel* user = [self findFirst];
    user.level = _level;
    user.quadrangle = user.level / kMISSIONS_PER_QUAD;
    [user update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)level {
    UserModel* user = [self findFirst];
    return user.level;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)nextQuadrangle {
    UserModel* user = [self findFirst];
    user.quadrangle++;
    [user update];
    return user.quadrangle;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)quadrangle {
    UserModel* user = [self findFirst];
    return user.quadrangle;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert {
    UserModel* user = [[[UserModel alloc] init] autorelease];
    user.level = 1;
    user.quadrangle = 0;
    [user insert];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    insertStatement = [NSString stringWithFormat:@"INSERT INTO users (level, quadrangle) values (%d, %d)", 
                       self.level, self.quadrangle];	
    [[SeekerDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM users WHERE pk = %d", self.pk];	
	[[SeekerDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
	[[SeekerDbi instance] selectForModel:[UserModel class] withStatement:@"SELECT * FROM users LIMIT 1" andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE users SET level = %d, quadrangle = %d WHERE pk = %d", 
                                 self.level, self.quadrangle, self.pk];
	[[SeekerDbi instance]  updateWithStatement:updateStatement];
}

//===================================================================================================================================
#pragma mark ServiceModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	self.level = (int)sqlite3_column_int(statement, 1);
    self.quadrangle = (int)sqlite3_column_int(statement, 2);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	UserModel* model = [[UserModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
    [model release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

@end
