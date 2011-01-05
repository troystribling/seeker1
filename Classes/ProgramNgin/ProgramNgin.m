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

//-----------------------------------------------------------------------------------------------------------------------------------
#define kLEVEL_FOR_ITERATIONS       1
#define kLEVEL_FOR_UNTIL            1

//-----------------------------------------------------------------------------------------------------------------------------------
static ProgramNgin* thisProgramNgin = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramNgin (PrivateAPI)

- (void)compile;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ProgramNgin

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize program;
@synthesize compiledProgram;
@synthesize programHalted;
@synthesize programRunning;
@synthesize nextLine;

//===================================================================================================================================
#pragma mark ProgramNgin PrivateApi

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compile {
    [self.compiledProgram removeAllObjects];
    for (NSMutableArray* instructionSet in self.program) {
        ProgramInstruction instruction = [[instructionSet objectAtIndex:0] intValue];
        ProgramInstruction doTimesInstruction;
        switch (instruction) {
            case MoveProgramInstruction:
                [self.compiledProgram addObject:instructionSet];
                break;
            case TurnLeftProgramInstruction:
                [self.compiledProgram addObject:instructionSet];
                break;
            case PutSensorProgramInstruction:
                [self.compiledProgram addObject:instructionSet];
                break;
            case GetSampleProgramInstruction:
                [self.compiledProgram addObject:instructionSet];
                break;
            case DoTimesProgramInstruction:
                doTimesInstruction = [[instructionSet objectAtIndex:1] intValue];
                NSInteger doTimesNumber = [[instructionSet objectAtIndex:2] intValue];
                for (int i = 0; i < doTimesNumber; i++) {
                    [self.compiledProgram addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:doTimesInstruction], nil]];
                }
                break;
            case DoUntilProgramInstruction:
                break;
            default:
                break;
        }
    }
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
                                                               [NSNumber numberWithInt:SensorBinEmptyPredicateProgramInstruction], nil]];
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
- (NSMutableArray*)nextInstruction {
    NSMutableArray* instruction = nil;
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
    return instruction;
}

@end
