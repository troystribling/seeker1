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
#import "ProgramNgin.h"

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
+ (void)insertSubroutine:(NSMutableArray*)_subroutine withName:(NSString*)_name {
    SubroutineModel* subroutineModel = [self findByName:_name];
    if (subroutineModel) {
        subroutineModel.codeListing = [self instructionsToCodeListing:_subroutine];
        subroutineModel.subroutineName = _name;
        [subroutineModel update];
    } else {
        subroutineModel = [[[SubroutineModel alloc] init] autorelease];
        subroutineModel.codeListing = [self instructionsToCodeListing:_subroutine];
        subroutineModel.subroutineName = _name;
        [subroutineModel insert];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (SubroutineModel*)createSubroutineWithName:(NSString*)_name {
    SubroutineModel* subroutineModel = [[[SubroutineModel alloc] init] autorelease];
    subroutineModel.codeListing = nil;
    subroutineModel.subroutineName = _name;
    [subroutineModel insert];
    return subroutineModel;
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
	NSMutableArray* instructionSets = [NSMutableArray arrayWithCapacity:10];
	for (SubroutineModel* model in _models) {
        [instructionSets addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:SubroutineProgramInstruction], model.subroutineName, nil]];
    }
    return instructionSets;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)instructionsToCodeListing:(NSMutableArray*)_instructionSets {
    NSMutableArray* instructionStrings = [NSMutableArray arrayWithCapacity:10];
    for (NSMutableArray* instructionSet in _instructionSets) {
        ProgramInstruction instruction = [[instructionSet objectAtIndex:0] intValue];
        NSString* instructionString = nil;
        switch (instruction) {
            case MoveProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d", instruction];
                break;
            case TurnLeftProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d", instruction];
                break;
            case PutSensorProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d", instruction];
                break;
            case GetSampleProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d", instruction];
                break;
            case DoTimesProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d*%d*%d", instruction, 
                                     [[instructionSet objectAtIndex:1] intValue], 
                                     [[instructionSet objectAtIndex:2] intValue]];
                break;
            case DoUntilProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d*%d*%d", instruction, 
                                     [[instructionSet objectAtIndex:1] intValue], 
                                     [[instructionSet objectAtIndex:2] intValue]];
                break;
            case SubroutineProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d*%@", instruction, 
                                     [[instructionSet objectAtIndex:1] stringValue]];
                break;
            default:
                break;
        }
        [instructionStrings addObject:instructionString];
    }
    return [instructionStrings componentsJoinedByString:@"~"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)codeListingToInstructions:(NSString*)_listing {
    NSMutableArray* instructions = [NSMutableArray arrayWithCapacity:10];
    if (_listing) {
        NSArray* subroutineStrings = [_listing componentsSeparatedByString:@"~"];
        for (NSString* subroutineString in subroutineStrings) {
            NSArray* instructionSetStrings = [subroutineString componentsSeparatedByString:@"*"];
            ProgramInstruction instruction = [[instructionSetStrings objectAtIndex:0] intValue];
            NSMutableArray* instructionSet = nil;
            switch (instruction) {
                case MoveProgramInstruction:
                    instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:instruction], nil];
                    break;
                case TurnLeftProgramInstruction:
                    instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:instruction], nil];
                    break;
                case PutSensorProgramInstruction:
                    instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:instruction], nil];
                    break;
                case GetSampleProgramInstruction:
                    instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:instruction], nil];
                    break;
                case DoTimesProgramInstruction:
                    instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:instruction], 
                                     [NSNumber numberWithInt:[[instructionSetStrings objectAtIndex:1] intValue]],
                                     [NSNumber numberWithInt:[[instructionSetStrings objectAtIndex:2] intValue]], nil];
                    break;
                case DoUntilProgramInstruction:
                    instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:instruction], 
                                     [NSNumber numberWithInt:[[instructionSetStrings objectAtIndex:1] intValue]],
                                     [NSNumber numberWithInt:[[instructionSetStrings objectAtIndex:2] intValue]], nil];
                    break;
                case SubroutineProgramInstruction:
                    instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:instruction], 
                                     [instructionSetStrings objectAtIndex:1], nil];
                    break;
                default:
                    break;
            }
            [instructions addObject:instructionSet];
        }
    }
    return instructions;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert {
    NSString* insertStatement;
    if (self.codeListing) {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO subroutines (codeListing, subroutineName) values ('%@', '%@')", self.codeListing, self.subroutineName];	
    } else {
        insertStatement = [NSString stringWithFormat:@"INSERT INTO subroutines (subroutineName) values ('%@')", self.subroutineName];	
    }
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
- (NSMutableArray*)codeListingToInstrictions {
    return [SubroutineModel codeListingToInstructions:self.codeListing];
}

//===================================================================================================================================
#pragma mark WebgnosusDbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
	self.pk = (int)sqlite3_column_int(statement, 0);
	const char* codeListingVal = (const char* )sqlite3_column_text(statement, 1);
	if (codeListingVal != NULL) {		
		self.codeListing = [NSString stringWithUTF8String:codeListingVal];
	}
	const char* subroutineNameVal = (const char* )sqlite3_column_text(statement, 2);
	if (subroutineNameVal != NULL) {		
		self.subroutineName = [NSString stringWithUTF8String:subroutineNameVal];
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
