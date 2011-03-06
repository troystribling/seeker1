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
@synthesize getStartedShown;
@synthesize subroutinesShown;
@synthesize timesLoopShown;
@synthesize untilLoopShown;
@synthesize roverBinsShown;
@synthesize speedScaleFactor;
@synthesize audioEnabled;

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
	[[SeekerDbi instance]  updateWithStatement:@"CREATE TABLE users (pk integer primary key, level integer, quadrangle integer, getStartedShown integer, subroutinesShown integer, timesLoopShown integer, untilLoopShown integer, roverBinsShown integer, speedScaleFactor float, audioEnabled integer)"];
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
+ (void)setQuadrangle:(NSInteger)_quad {
    UserModel* user = [self findFirst];
    user.quadrangle = _quad;
    [user update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)quadrangle {
    UserModel* user = [self findFirst];
    return user.quadrangle;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)resetTutorials {
    UserModel* user = [self findFirst];
    user.getStartedShown = NO;
    user.subroutinesShown = NO;
    user.timesLoopShown = NO;
    user.untilLoopShown = NO;
    user.roverBinsShown = NO;
    [user update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)tutorialWasShown:(TutorialSectionID)_sectionID {
    UserModel* user = [self findFirst];
    switch (_sectionID) {
        case GettingStartedTutorialSectionID:
            user.getStartedShown = YES;
            break;
        case SubroutinesTutorialSectionID:
            user.subroutinesShown = YES;
            break;
        case TimesLoopTutorialSectionID:
            user.timesLoopShown = YES;
            break;
        case UntilLoopTutorialSectionID:
            user.untilLoopShown = YES;
            break;
        case RoverBinsTutorialSectionID:
            user.roverBinsShown = YES;
            break;
        default:
            break;
    }
    [user update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)wasTutorialShown:(TutorialSectionID)_sectionID {
    UserModel* user = [self findFirst];
    BOOL wasShown = NO;
    switch (_sectionID) {
        case GettingStartedTutorialSectionID:
            wasShown = user.getStartedShown;
            break;
        case SubroutinesTutorialSectionID:
            wasShown = user.subroutinesShown;
            break;
        case TimesLoopTutorialSectionID:
            wasShown = user.timesLoopShown;
            break;
        case UntilLoopTutorialSectionID:
            wasShown = user.untilLoopShown;
            break;
        case RoverBinsTutorialSectionID:
            wasShown = user.roverBinsShown;
            break;
        default:
            break;
    }
    return wasShown;;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)setSpeedScaleFactor:(double)_fact {
    UserModel* user = [self findFirst];
    user.speedScaleFactor = _fact;
    [user update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (double)speedScaleFactor {
    UserModel* user = [self findFirst];
    return user.speedScaleFactor;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)setAudioEnabled:(BOOL)_enabled {
    UserModel* user = [self findFirst];
    user.audioEnabled = _enabled;
    [user update];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)audioEnabled {
    UserModel* user = [self findFirst];
    return user.audioEnabled;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insert {
    UserModel* user = [[[UserModel alloc] init] autorelease];
    user.level = 1;
    user.quadrangle = 0;
    user.getStartedShown = NO;
    user.subroutinesShown = NO;
    user.timesLoopShown = NO;
    user.untilLoopShown = NO;
    user.roverBinsShown = NO;
    user.speedScaleFactor = 1.0;
    user.audioEnabled = YES;
    [user insert];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    insertStatement = [NSString stringWithFormat:@"INSERT INTO users (level, quadrangle, getStartedShown, subroutinesShown, timesLoopShown, untilLoopShown, roverBinsShown, speedScaleFactor, audioEnabled) values (%d, %d, %d, %d, %d, %d, %d, %g, %d)", 
                       self.level, self.quadrangle, [self getStartedShownAsInteger], [self subroutinesShownAsInteger], [self timesLoopShownAsInteger], [self untilLoopShownAsInteger], [self roverBinsShownAsInteger], self.speedScaleFactor, [self audioEnabledAsInteger]];	
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
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE users SET level = %d, quadrangle = %d, getStartedShown = %d, subroutinesShown = %d, timesLoopShown = %d, untilLoopShown = %d, roverBinsShown = %d, speedScaleFactor = %g, audioEnabled = %d WHERE pk = %d", 
                                 self.level, self.quadrangle, [self getStartedShownAsInteger], [self subroutinesShownAsInteger], [self timesLoopShownAsInteger], [self untilLoopShownAsInteger], [self roverBinsShownAsInteger], self.speedScaleFactor, [self audioEnabledAsInteger], self.pk];
	[[SeekerDbi instance]  updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)getStartedShownAsInteger {
	return self.getStartedShown == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setGetStartedShownAsInteger:(NSInteger)_value {
	if (_value == 1) {
		self.getStartedShown = YES; 
	} else {
		self.getStartedShown = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)subroutinesShownAsInteger {
	return self.subroutinesShown == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSubroutinesShownAsInteger:(NSInteger)_value {
	if (_value == 1) {
		self.subroutinesShown = YES; 
	} else {
		self.subroutinesShown = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)timesLoopShownAsInteger {
	return self.timesLoopShown == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setTimesLoopShownAsInteger:(NSInteger)_value {
	if (_value == 1) {
		self.timesLoopShown = YES; 
	} else {
		self.timesLoopShown = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)untilLoopShownAsInteger {
	return self.untilLoopShown == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUntilLoopShownAsInteger:(NSInteger)_value {
	if (_value == 1) {
		self.untilLoopShown = YES; 
	} else {
		self.untilLoopShown = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)roverBinsShownAsInteger {
	return self.roverBinsShown == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setRoverBinsShownAsInteger:(NSInteger)_value {
	if (_value == 1) {
		self.roverBinsShown = YES; 
	} else {
		self.roverBinsShown = NO;
	};
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)audioEnabledAsInteger {
	return self.audioEnabled == YES ? 1 : 0;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAudioEnabledAsInteger:(NSInteger)_value {
	if (_value == 1) {
		self.audioEnabled = YES; 
	} else {
		self.audioEnabled = NO;
	};
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
	[self setGetStartedShown:(int)sqlite3_column_int(statement, 3)];
	[self setSubroutinesShownAsInteger:(int)sqlite3_column_int(statement, 4)];
	[self setTimesLoopShownAsInteger:(int)sqlite3_column_int(statement, 5)];
	[self setUntilLoopShownAsInteger:(int)sqlite3_column_int(statement, 6)];
	[self setRoverBinsShownAsInteger:(int)sqlite3_column_int(statement, 7)];
    self.speedScaleFactor = (double)sqlite3_column_double(statement, 8);
    [self setAudioEnabledAsInteger:(int)sqlite3_column_int(statement, 9)];
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
