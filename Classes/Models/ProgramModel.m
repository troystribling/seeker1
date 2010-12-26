//
//  ProgramModel.m
//  seeker1
//
//  Created by Troy Stribling on 12/19/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ProgramModel.h"
#import "SeekerDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ProgramModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize level;
@synthesize codeListing;

//===================================================================================================================================
#pragma mark ProgramModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertProgram:(NSMutableArray*)_program forLevel:(NSInteger)_level {
    ProgramModel* program = [self findByLevel:_level];
    if (program) {
        program.codeListing = [_program componentsJoinedByString:@";"];
        program.level = _level;
        [program update];
    } else {
        program = [[[ProgramModel alloc] init] autorelease];
        program.codeListing = [_program componentsJoinedByString:@";"];
        program.level = _level;
        [program insert];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[SeekerDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM programs"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[SeekerDbi instance]  updateWithStatement:@"DROP TABLE programs"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[SeekerDbi instance]  updateWithStatement:@"CREATE TABLE programs (pk integer primary key, codeListing text, level integer)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ProgramModel*)findByLevel:(NSInteger)_level {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM programs WHERE level = %d", _level];
	ProgramModel* model = [[[ProgramModel alloc] init] autorelease];
	[[SeekerDbi instance] selectForModel:[ProgramModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[SeekerDbi instance] selectAllForModel:[ProgramModel class] withStatement:@"SELECT * FROM programs" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[SeekerDbi instance]  updateWithStatement:@"DELETE FROM programs"];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    insertStatement = [NSString stringWithFormat:@"INSERT INTO programs (codeListing, level) values ('%@', %d)", self.codeListing, self.level];	
    [[SeekerDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM programs WHERE pk = %d", self.pk];	
	[[SeekerDbi instance] updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM programs WHERE level = %d", self.level];
	[[SeekerDbi instance] selectForModel:[ProgramModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE funtions SET codeListing = '%@', level = %d WHERE pk = %d", self.codeListing, 
                                 self.level, self.pk];
	[[SeekerDbi instance] updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)codeListingToArray {
    return [self.codeListing componentsSeparatedByString:@";"];
}

//===================================================================================================================================
#pragma mark ProgramModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* codeListingVal = (char*)sqlite3_column_text(statement, 1);
	if (codeListingVal != nil) {		
		self.codeListing = [[NSString alloc] initWithUTF8String:codeListingVal];
	}
	self.level = (int)sqlite3_column_int(statement, 2);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	ProgramModel* model = [[ProgramModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
    [model release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

@end
