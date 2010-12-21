//
//  FunctionModel.m
//  seeker1
//
//  Created by Troy Stribling on 12/19/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "FunctionModel.h"
#import "SeekerDbi.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface FunctionModel (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FunctionModel

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize pk;
@synthesize codeListing;
@synthesize functionName;

//===================================================================================================================================
#pragma mark FunctionModel

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertFunction:(NSMutableArray*)_function withName:(NSString*)_name {
    FunctionModel* function = [self findByName:_name];
    if (function) {
        function.codeListing = [_function componentsJoinedByString:@";"];
        function.functionName = _name;
        [function update];
    } else {
       function = [[[FunctionModel alloc] init] autorelease];
        function.codeListing = [_function componentsJoinedByString:@";"];
        function.functionName = _name;
        [function insert];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSInteger)count {
	return [[SeekerDbi instance]  selectIntExpression:@"SELECT COUNT(pk) FROM funtions"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)drop {
	[[SeekerDbi instance]  updateWithStatement:@"DROP TABLE funtions"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)create {
	[[SeekerDbi instance]  updateWithStatement:@"CREATE TABLE funtions (pk integer primary key, codeListing text, functionName text)"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (FunctionModel*)findByName:(NSString*)_name {
	NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM functions WHERE functionName = '%@'", _name];
	FunctionModel* model = [[[FunctionModel alloc] init] autorelease];
	[[SeekerDbi instance] selectForModel:[FunctionModel class] withStatement:selectStatement andOutputTo:model];
    if (model.pk == 0) {
        model = nil;
    }
	return model;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
	[[SeekerDbi instance] selectAllForModel:[FunctionModel class] withStatement:@"SELECT * FROM functions" andOutputTo:output];
	return output;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)destroyAll {
	[[SeekerDbi instance]  updateWithStatement:@"DELETE FROM funtions"];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    insertStatement = [NSString stringWithFormat:@"INSERT INTO funtions (codeListing, functionName) values ('%@', '%@')", self.codeListing, self.functionName];	
    [[SeekerDbi instance]  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* destroyStatement = [NSString stringWithFormat:@"DELETE FROM funtions WHERE pk = %d", self.pk];	
	[[SeekerDbi instance]  updateWithStatement:destroyStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)load {
    NSString* selectStatement = [NSString stringWithFormat:@"SELECT * FROM funtions WHERE functionName = '%@'", self.functionName];
	[[SeekerDbi instance] selectForModel:[FunctionModel class] withStatement:selectStatement andOutputTo:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE funtions SET codeListing = '%@', functionName = '%@' WHERE pk = %d", self.codeListing, 
                                 self.functionName, self.pk];
	[[SeekerDbi instance] updateWithStatement:updateStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSArray*)codeListingToArray {
    return [self.codeListing componentsSeparatedByString:@";"];
}

//===================================================================================================================================
#pragma mark FunctionModel PrivateAPI

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	char* codeListingVal = (char*)sqlite3_column_text(statement, 1);
	if (codeListingVal != nil) {		
		self.codeListing = [[NSString alloc] initWithUTF8String:codeListingVal];
	}
	char* functionNameVal = (char*)sqlite3_column_text(statement, 2);
	if (functionNameVal != nil) {		
		self.functionName = [[NSString alloc] initWithUTF8String:functionNameVal];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	FunctionModel* model = [[FunctionModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
    [model release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

@end
