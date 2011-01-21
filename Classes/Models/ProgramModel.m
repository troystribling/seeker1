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
#import "CodeModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ProgramModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize level;
@synthesize codeListing;
@synthesize updatedAt;

//===================================================================================================================================
#pragma mark ProgramModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertProgram:(NSMutableArray*)_program forLevel:(NSInteger)_level {
    ProgramModel* program = [self findByLevel:_level];
    if (program) {
        program.codeListing = [CodeModel instructionsToCodeListing:_program];
        program.level = _level;
        program.updatedAt = [NSDate date];
        [program update];
    } else {
        program = [[[ProgramModel alloc] init] autorelease];
        program.codeListing = [CodeModel instructionsToCodeListing:_program];
        program.level = _level;
        program.updatedAt = [NSDate date];
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
	[[SeekerDbi instance]  updateWithStatement:@"CREATE TABLE programs (pk integer primary key, codeListing text, level integer, updatedAt text)"];
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
    insertStatement = [NSString stringWithFormat:@"INSERT INTO programs (codeListing, level, updatedAt) values ('%@', %d, '%@')", 
                       self.codeListing, self.level, [self updatedAtAsString]];	
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
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE programs SET codeListing = '%@', level = %d, updatedAt = '%@' WHERE pk = %d", 
                                 self.codeListing, self.level, [self updatedAtAsString], self.pk];
	[[SeekerDbi instance] updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)codeListingToInstrictions {
    return [CodeModel codeListingToInstructions:self.codeListing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)updatedAtAsString {
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss zzz"];
    NSString* dateString = [df stringFromDate:self.updatedAt];
    return dateString;
}

//===================================================================================================================================
#pragma mark ProgramModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	const char* codeListingVal = (const char*)sqlite3_column_text(statement, 1);
	if (codeListingVal != NULL) {		
		self.codeListing = [NSString stringWithUTF8String:codeListingVal];
	}
	self.level = (int)sqlite3_column_int(statement, 2);
    char* updatedAtVal = (char*)sqlite3_column_text(statement, 3);
    if (updatedAtVal != nil) {		
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss zzz"];
        self.updatedAt = [df dateFromString:[NSString stringWithCString:updatedAtVal encoding:NSUTF8StringEncoding]];
    }
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
