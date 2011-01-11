//
//  ProgramNgin.m
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ProgramNgin.h"
#import "UserModel.h"
#import "SubroutineModel.h"
#import "SeekerSprite.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ProgramNgin* thisProgramNgin = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramNgin (PrivateAPI)

- (void)compile;
- (void)compileSubrotine:(NSMutableArray*)_instructionSet;
- (void)compileInstructionSet:(NSMutableArray*)_instrctionSet;
- (NSMutableArray*)doUntilNextInstructionForItem:(NSDictionary*)_item terrain:(NSDictionary*)_terrrain sand:(NSDictionary*)_sand andSeeker:(SeekerSprite*)_seeker;

- (BOOL)pathBlocked:(NSDictionary*)_terrrain;
- (BOOL)sensorBinEmpty:(SeekerSprite*)_seeker;
- (BOOL)sampleBinFull:(SeekerSprite*)_seeker;
- (BOOL)atStation:(NSDictionary*)_terrrain;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ProgramNgin

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize program;
@synthesize compiledProgram;
@synthesize doUntilStack;
@synthesize doUntilStackLine;
@synthesize programHalted;
@synthesize programRunning;
@synthesize nextLine;

//===================================================================================================================================
#pragma mark ProgramNgin PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compile {
    [self.compiledProgram removeAllObjects];
    for (NSMutableArray* instructionSet in self.program) {
        [self compileInstructionSet:instructionSet];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileSubrotine:(NSMutableArray*)_instructionSet {
    NSString* subroutineName = [_instructionSet objectAtIndex:1];
    SubroutineModel* model = [SubroutineModel findByName:subroutineName];
    NSMutableArray* subroutineInstructionSets = [model codeListingToInstrictions];
    for (NSMutableArray* subroutineInstructionSet in subroutineInstructionSets) {
        [self compileInstructionSet:subroutineInstructionSet];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileInstructionSet:(NSMutableArray*)_instrctionSet {
    ProgramInstruction instruction = [[_instrctionSet objectAtIndex:0] intValue];
    ProgramInstruction doTimesInstruction;
    switch (instruction) {
        case MoveProgramInstruction:
            [self.compiledProgram addObject:_instrctionSet];
            break;
        case TurnLeftProgramInstruction:
            [self.compiledProgram addObject:_instrctionSet];
            break;
        case PutSensorProgramInstruction:
            [self.compiledProgram addObject:_instrctionSet];
            break;
        case GetSampleProgramInstruction:
            [self.compiledProgram addObject:_instrctionSet];
            break;
        case DoTimesProgramInstruction:
            doTimesInstruction = [[_instrctionSet objectAtIndex:1] intValue];
            NSInteger doTimesNumber = [[_instrctionSet objectAtIndex:2] intValue];
            for (int i = 0; i < doTimesNumber; i++) {
                [self.compiledProgram addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:doTimesInstruction], nil]];
            }
            break;
        case DoUntilProgramInstruction:
            [self.doUntilStack insertObject:_instrctionSet atIndex:0];
            [self.doUntilStackLine insertObject:[NSNumber numberWithInt:0] atIndex:0];
            break;
        case SubroutineProgramInstruction:
            [self compileSubrotine:_instrctionSet];
            break;
        default:
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)doUntilNextInstructionForItem:(NSDictionary*)_item terrain:(NSDictionary*)_terrrain sand:(NSDictionary*)_sand andSeeker:(SeekerSprite*)_seeker {
    NSMutableArray* instructionSet = [self.doUntilStack objectAtIndex:0];
    NSMutableArray* instruction = [instructionSet objectAtIndex:1];
    ProgramInstruction predicateInstruction = [[instructionSet objectAtIndex:2] intValue];
    BOOL predicateTrue = YES;
    switch (predicateInstruction) {
        case PathBlockedPredicateProgramInstruction:
            predicateTrue = [self pathBlocked:_terrrain];
            break;
        case SensorBinEmptyPredicateProgramInstruction:
            predicateTrue = [self sensorBinEmpty:_seeker];
            break;
        case SampleBinFullPredicateProgramInstruction:
            predicateTrue = [self sampleBinFull:_seeker];
            break;
        case AtStationPredicateProgramInstruction:
            predicateTrue = [self atStation:_item];
            break;
        default:
            break;
    }
    if (predicateTrue) {
    } else {
    }
    return instruction;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)pathBlocked:(NSDictionary*)_terrrain {
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)sensorBinEmpty:(SeekerSprite*)_seeker {
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)sampleBinFull:(SeekerSprite*)_seeker {
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)atStation:(NSDictionary*)_item {
    return YES;
}

//===================================================================================================================================
#pragma mark ProgramNgin

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ProgramNgin*)instance {	
    @synchronized(self) {
        if (thisProgramNgin == nil) {
            thisProgramNgin = [[self alloc] init]; 
        }
    }
    return thisProgramNgin;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.program = [NSMutableArray arrayWithCapacity:10];
        self.compiledProgram = [NSMutableArray arrayWithCapacity:10];
        self.doUntilStack = [NSMutableArray arrayWithCapacity:10];
        self.nextLine = 0;
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getPrimitiveInstructions {
    NSMutableArray* primatives = [NSMutableArray arrayWithCapacity:10];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:MoveProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:TurnLeftProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:PutSensorProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GetSampleProgramInstruction], nil]];
    NSInteger level = [UserModel level];
    if (level >= kLEVEL_FOR_ITERATIONS) {
        [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:DoTimesProgramInstruction], 
                                                               [NSNumber numberWithInt:MoveProgramInstruction], 
                                                               [NSNumber numberWithInt:1], nil]];
    }
    if (level >= kLEVEL_FOR_UNTIL) {
        [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:DoUntilProgramInstruction],
                                                               [NSNumber numberWithInt:MoveProgramInstruction], 
                                                               [NSNumber numberWithInt:PathBlockedPredicateProgramInstruction], nil]];
    }
    return primatives;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getDoInstructions {
    NSMutableArray* primatives = [NSMutableArray arrayWithCapacity:10];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:MoveProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:TurnLeftProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:PutSensorProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GetSampleProgramInstruction], nil]];
    return primatives;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getDoUntilPredicates {
    NSMutableArray* primatives = [NSMutableArray arrayWithCapacity:10];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:SensorBinEmptyPredicateProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:SampleBinFullPredicateProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:AtStationPredicateProgramInstruction], nil]];
    return primatives;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getSubroutines {
    return [NSMutableArray arrayWithCapacity:10];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)instructionToString:(ProgramInstruction)_instruction {
    NSString* instructionString = nil;
    switch (_instruction) {
        case MoveProgramInstruction:
            instructionString = @"move";
            break;
        case TurnLeftProgramInstruction:
            instructionString = @"turn left";
            break;
        case PutSensorProgramInstruction:
            instructionString = @"put sensor";
            break;
        case GetSampleProgramInstruction:
            instructionString = @"get sample";
            break;
        case DoTimesProgramInstruction:
            break;
        case DoUntilProgramInstruction:
            break;
        case SubroutineProgramInstruction:
            break;
        case PathBlockedPredicateProgramInstruction:
            instructionString = @"path blocked";
            break;
        case SensorBinEmptyPredicateProgramInstruction:
            instructionString = @"sensor bin empty";
            break;
        case SampleBinFullPredicateProgramInstruction:
            instructionString = @"sample bin full";
            break;
        case AtStationPredicateProgramInstruction:
            instructionString = @"at station";
            break;
    }
    return instructionString;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadProgram:(NSMutableArray*)_program {
    [self saveProgram:_program];
    [self compile];
    [self runProgram];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)saveProgram:(NSMutableArray*)_program {
    self.program = [NSMutableArray arrayWithArray:_program];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)deleteProgram {
    [self.program removeAllObjects];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)runProgram {
    self.nextLine = 0;
    self.programRunning = YES;
    self.programHalted = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stopProgram {
    self.nextLine = 0;
    self.programRunning = NO;
    self.programHalted = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)haltProgram {
    self.nextLine = 0;
    self.programRunning = NO;
    self.programHalted = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)programIsLoaded {
    if ([self.program count] == 0) {
        return NO;
    } else {
        return YES;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)programIsRunning {
    return self.programRunning;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)programIsHalted {
    return self.programHalted;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)nextInstructionForItem:(NSDictionary*)_item terrain:(NSDictionary*)_terrrain sand:(NSDictionary*)_sand andSeeker:(SeekerSprite*)_seeker {
    NSMutableArray* instruction = nil;
    NSInteger stackDepth = [self.doUntilStack count];
    if (stackDepth == 0) {
        NSInteger codeLines = [self.compiledProgram count];
        if (self.nextLine < codeLines - 1) {
            instruction = [self.compiledProgram objectAtIndex:self.nextLine];
            self.nextLine++;
        } else if (self.nextLine == codeLines - 1) {
            instruction = [self.compiledProgram objectAtIndex:self.nextLine];
            self.nextLine = 0;
        } else {
            [self stopProgram];
        }   
    } else {
        instruction = [self doUntilNextInstructionForItem:_item terrain:_terrrain sand:_sand andSeeker:_seeker];
    }
    return instruction;
}

@end
