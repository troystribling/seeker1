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
#import "MapScene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ProgramNgin* thisProgramNgin = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramNgin (PrivateAPI)

- (void)compile;
- (void)compileSubrotine:(NSMutableArray*)_instructionSet to:(NSMutableArray*)_program;
- (void)compileInstructionSet:(NSMutableArray*)_instrctionSet to:(NSMutableArray*)_program;
- (NSMutableArray*)doUntilNextInstruction:(MapScene*)_mapScene forPosition:(CGPoint)_position;
- (BOOL)pathBlocked:(MapScene*)_mapScene forPosition:(CGPoint)_position;
- (BOOL)sensorBinEmpty:(MapScene*)_mapScene forPosition:(CGPoint)_position;
- (BOOL)sampleBinFull:(MapScene*)_mapScene forPosition:(CGPoint)_position;
- (BOOL)atStation:(MapScene*)_mapScene forPosition:(CGPoint)_position;
- (NSMutableArray*)nextInstruction;

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
    [self.doUntilStack removeAllObjects];
    [self.doUntilStackLine removeAllObjects];
    for (NSMutableArray* instructionSet in self.program) {
        [self compileInstructionSet:instructionSet to:self.compiledProgram];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileSubrotine:(NSMutableArray*)_instructionSet to:(NSMutableArray*)_program {
    NSString* subroutineName = [_instructionSet objectAtIndex:1];
    SubroutineModel* model = [SubroutineModel findByName:subroutineName];
    NSMutableArray* subroutineInstructionSets = [model codeListingToInstrictions];
    for (NSMutableArray* subroutineInstructionSet in subroutineInstructionSets) {
        [self compileInstructionSet:subroutineInstructionSet to:_program];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileInstructionSet:(NSMutableArray*)_instrctionSet to:(NSMutableArray*)_program {
    ProgramInstruction instruction = [[_instrctionSet objectAtIndex:0] intValue];
    NSMutableArray* doTimesInstructionSet;
    switch (instruction) {
        case MoveProgramInstruction:
            [_program addObject:_instrctionSet];
            break;
        case TurnLeftProgramInstruction:
            [_program addObject:_instrctionSet];
            break;
        case PutSensorProgramInstruction:
            [_program addObject:_instrctionSet];
            break;
        case GetSampleProgramInstruction:
            [_program addObject:_instrctionSet];
            break;
        case DoTimesProgramInstruction:
            doTimesInstructionSet = [_instrctionSet objectAtIndex:1];
            ProgramInstruction doTimesInstruction = [[doTimesInstructionSet objectAtIndex:0] intValue];
            NSInteger doTimesNumber = [[_instrctionSet objectAtIndex:2] intValue];
            if (doTimesInstruction == SubroutineProgramInstruction) {
                for (int i = 0; i < doTimesNumber; i++) {
                    [self compileSubrotine:doTimesInstructionSet to:_program];
                }
            } else {
                for (int i = 0; i < doTimesNumber; i++) {
                    [_program addObject:doTimesInstructionSet];
                }
            }
            break;
        case DoUntilProgramInstruction:
            [self.doUntilStack insertObject:_instrctionSet atIndex:0];
            [self.doUntilStackLine insertObject:[NSNumber numberWithInt:0] atIndex:0];
            break;
        case SubroutineProgramInstruction:
            [self compileSubrotine:_instrctionSet to:_program];
            break;
        default:
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)doUntilNextInstruction:(MapScene*)_mapScene forPosition:(CGPoint)_position {
    NSMutableArray* instructionSet = [self.doUntilStack objectAtIndex:0];
    NSMutableArray* instruction = nil;
    ProgramInstruction predicateInstruction = [[instructionSet objectAtIndex:2] intValue];
    BOOL predicateTrue = YES;
    switch (predicateInstruction) {
        case PathBlockedPredicateProgramInstruction:
            predicateTrue = [self pathBlocked:_mapScene forPosition:_position];
            break;
        case SensorBinEmptyPredicateProgramInstruction:
            predicateTrue = [self sensorBinEmpty:_mapScene forPosition:_position];
            break;
        case SampleBinFullPredicateProgramInstruction:
            predicateTrue = [self sampleBinFull:_mapScene forPosition:_position];
            break;
        case AtStationPredicateProgramInstruction:
            predicateTrue = [self atStation:_mapScene forPosition:_position];
            break;
        default:
            break;
    }
    if (!predicateTrue) {
        NSMutableArray* doInstructionSet = [instructionSet objectAtIndex:1];
        ProgramInstruction doInstruction = [[doInstructionSet objectAtIndex:0] intValue];
        switch (doInstruction) {
            case MoveProgramInstruction:
            case TurnLeftProgramInstruction:
            case PutSensorProgramInstruction:
            case GetSampleProgramInstruction:
                instruction = doInstructionSet;
                break;
            case DoTimesProgramInstruction:
                break;
            case DoUntilProgramInstruction:
                break;
            case SubroutineProgramInstruction:
                break;
            default:
                break;
        }
    }
    return instruction;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)pathBlocked:(MapScene*)_mapScene forPosition:(CGPoint)_position {
    BOOL isBlocked = NO;
    if ([_mapScene positionIsInPlayingArea:_position]) {
        NSDictionary* terrain = [_mapScene getTileProperties:_position forLayer:_mapScene.terrainLayer];
        if (terrain) {
            NSString* mapID = [terrain valueForKey:@"mapID"];
            if ([mapID isEqualToString:@"up-1"]) {
                isBlocked = YES;
            } 
        } 
    } else {
        isBlocked = YES;
    }
    return isBlocked;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)sensorBinEmpty:(MapScene*)_mapScene forPosition:(CGPoint)_position {
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)sampleBinFull:(MapScene*)_mapScene forPosition:(CGPoint)_position {
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)atStation:(MapScene*)_mapScene forPosition:(CGPoint)_position {
    return YES;
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
                                                               [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:MoveProgramInstruction], nil], 
                                                               [NSNumber numberWithInt:1], nil]];
    }
    if (level >= kLEVEL_FOR_UNTIL) {
        [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:DoUntilProgramInstruction],
                                                               [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:MoveProgramInstruction], nil], 
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
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:PathBlockedPredicateProgramInstruction], nil]];
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
        case DoUntilProgramInstruction:
        case SubroutineProgramInstruction:
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
- (NSString*)iteratedInstructionString:(NSMutableArray*)_instructionSet {
    NSString* instructionString = nil;
    ProgramInstruction instruction = [[[_instructionSet objectAtIndex:1] objectAtIndex:0] intValue];
    switch (instruction) {
        case MoveProgramInstruction:
        case TurnLeftProgramInstruction:
        case PutSensorProgramInstruction:
        case GetSampleProgramInstruction:
            instructionString = [self instructionToString:instruction];
            break;
        case SubroutineProgramInstruction:
            instructionString = [[_instructionSet objectAtIndex:1] objectAtIndex:1];
            break;
        default:
            break;
    }
    return instructionString;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadProgram:(NSMutableArray*)_program {
    [self saveProgram:_program];
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
    [self compile];
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
- (NSMutableArray*)nextInstruction:(MapScene*)_mapScene forPosition:(CGPoint)_position {
    NSMutableArray* instruction = nil;
    NSInteger stackDepth = [self.doUntilStack count];
    if (stackDepth == 0) {
        instruction = [self nextInstruction];
    } else if (!(instruction = [self doUntilNextInstruction:_mapScene forPosition:_position])) {
        instruction = [self nextInstruction];
    }
    return instruction;
}

@end
