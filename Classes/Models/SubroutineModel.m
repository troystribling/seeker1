//
//  SubroutineModel.m
//  seeker1
//
//  Created by Troy Stribling on 12/19/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SubroutineModel.h"
#import "SeekerDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SubroutineModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SubroutineModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize codeListing;
@synthesize subroutineName;

//===================================================================================================================================
#pragma mark SubroutineModel PrivateAPI

//===================================================================================================================================
#pragma mark SubroutineModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertSubroutine:(NSMutableArray*)_function withName:(NSString*)_name {
    SubroutineModel* function = [self findByName:_name];
    if (function) {
        function.codeListing = [_function componentsJoinedByString:@";"];
        function.subroutineName = _name;
        [function update];
    } else {
       function = [[[SubroutineModel alloc] init] autorelease];
        function.codeListing = [_function componentsJoinedByString:@";"];
        function.subroutineName = _name;
        [function insert];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[SeekerDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM subroutines"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[SeekerDbi instance]  updateWithStatement:@"DROP TABLE subroutines"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[SeekerDbi instance]  updateWithStatement:@"CREATE TABLE subroutines (pk integer primary key, codeListing text, subroutineName text)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[SeekerDbi instance]  updateWithStatement:@"DELETE FROM subroutines"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (SubroutineModel*)findByName:(NSString*)_name {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM subroutines WHERE subroutineName = '%@'", _name];
	SubroutineModel* model = [[[SubroutineModel alloc] init] autorelease];
	[[SeekerDbi instance] selectForModel:[SubroutineModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[SeekerDbi instance] selectAllForModel:[SubroutineModel class] withStatement:@"SELECT * FROM subroutines" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)modelsToInstructions:(NSMutableArray*)_models {
	NSMutableArray* instructions = [NSMutableArray arrayWithCapacity:10];
	for (NSMutableArray* model in _models) {
    }
    return instructions;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    insertStatement = [NSString stringWithFormat:@"INSERT INTO subroutines (codeListing, subroutineName) values ('%@', '%@')", self.codeListing, self.subroutineName];	
    [[SeekerDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM subroutines WHERE pk = %d", self.pk];	
	[[SeekerDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM subroutines WHERE subroutineName = '%@'", self.subroutineName];
	[[SeekerDbi instance] selectForModel:[SubroutineModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE subroutines SET codeListing = '%@', subroutineName = '%@' WHERE pk = %d", self.codeListing, 
                                 self.subroutineName, self.pk];
	[[SeekerDbi instance] updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)codeListingToArray {
    return [NSMutableArray arrayWithArray:[self.codeListing componentsSeparatedByString:@";"]];
}


//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* codeListingVal = (char*)sqlite3_column_text(statement, 1);
	if (codeListingVal != nil) {		
		self.codeListing = [[NSString alloc] initWithUTF8String:codeListingVal];
	}
	char* subroutineNameVal = (char*)sqlite3_column_text(statement, 2);
	if (subroutineNameVal != nil) {		
		self.subroutineName = [[NSString alloc] initWithUTF8String:subroutineNameVal];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	SubroutineModel* model = [[SubroutineModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
    [model release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

@end
