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
#define kLEVEL_FOR_WHILE_UNTIL      1
#define kLEVEL_FOR_IF_THEN          1
#define kLEVEL_FOR_IF_THEN_ELSE     1

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
                break;
            case DoWhileProgramInstruction:
                break;
            case DoUntilProgramInstruction:
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
- (NSMutableArray*)getPrimativeInstructions {
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
//    if (level >= kLEVEL_FOR_WHILE_UNTIL) {
//        [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:DoWhileProgramInstruction], nil]];
//        [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:DoUntilProgramInstruction], nil]];
//    }
    return primatives;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getDoTimesInstructions {
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
    return primatives;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getDoWhilePredicates {
    NSMutableArray* primatives = [NSMutableArray arrayWithCapacity:10];
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
        case DoWhileProgramInstruction:
            break;
        case DoUntilProgramInstruction:
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
    NSInteger codeLines = [self.program count];
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
