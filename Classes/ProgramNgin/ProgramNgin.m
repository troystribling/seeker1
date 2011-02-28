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
#import "ProgramModel.h"
#import "MapScene.h"
#import "SeekerSprite.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ProgramNgin* thisProgramNgin = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramNgin (PrivateAPI)

// compile
- (void)compile;
- (void)compileInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program;
- (void)compileSubrotineInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program;
- (void)compileDoTimesInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program;
- (void)compileDoUntilInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program;
- (void)resetMaxCallStackDepth:(NSInteger)_depth;
// execution
- (NSMutableArray*)getInstructionSet:(MapScene*)_mapScene;
- (NSMutableArray*)doUntilNextInstruction:(MapScene*)_mapScene forInstructionSet:(NSMutableArray*)_instructionSet;
- (void)incrementLineCounter:(NSMutableArray*)_instructionSet;
// predicates
- (BOOL)hasItem:(MapScene*)_mapScene withValue:(NSString*)_value;
- (BOOL)pathBlocked:(MapScene*)_mapScene;
- (BOOL)sensorBinEmpty:(MapScene*)_mapScene;
- (BOOL)sampleBinFull:(MapScene*)_mapScene;
- (BOOL)atStation:(MapScene*)_mapScene;
- (BOOL)atSample:(MapScene*)_mapScene;
- (BOOL)atSensorSite:(MapScene*)_mapScene;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ProgramNgin

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize program;
@synthesize compiledProgram;
@synthesize programHalted;
@synthesize programRunning;
@synthesize codeLine;
@synthesize codeScore;
@synthesize callStackDepth;
@synthesize maxCallStackDepth;

//===================================================================================================================================
#pragma mark ProgramNgin Compile

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compile {
    self.codeScore = 0;
    [self.compiledProgram removeAllObjects];
    for (NSMutableArray* instructionSet in self.program) {
        [self compileInstructionSet:instructionSet forParentInstructionSet:nil toProgram:self.compiledProgram];
    }
    self.maxCallStackDepth = [self.compiledProgram count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program {
    ProgramInstruction instruction = [[_instructionSet objectAtIndex:0] intValue];
    switch (instruction) {
        case MoveProgramInstruction:
            [_program addObject:_instructionSet];
            self.codeScore++;
            break;
        case TurnLeftProgramInstruction:
            [_program addObject:_instructionSet];
            self.codeScore++;
            break;
        case PutSensorProgramInstruction:
            [_program addObject:_instructionSet];
            self.codeScore++;
            break;
        case GetSampleProgramInstruction:
            [_program addObject:_instructionSet];
            self.codeScore++;
            break;
        case DoTimesProgramInstruction:
            [self compileDoTimesInstructionSet:_instructionSet forParentInstructionSet:_parent toProgram:_program];
            self.codeScore++;
           break;
        case DoUntilProgramInstruction:
            [self compileDoUntilInstructionSet:_instructionSet forParentInstructionSet:_parent toProgram:_program];
            self.codeScore++;
            break;
        case SubroutineProgramInstruction:
            [self compileSubrotineInstructionSet:_instructionSet forParentInstructionSet:_parent toProgram:_program];
            break;
        default:
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileSubrotineInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program {
    NSString* subroutineName = [_instructionSet objectAtIndex:1];
    SubroutineModel* model = [SubroutineModel findByName:subroutineName];
    NSMutableArray* subroutineInstructionSets = [model codeListingToInstrictions];
    for (NSMutableArray* subroutineInstructionSet in subroutineInstructionSets) {
        [self compileInstructionSet:subroutineInstructionSet forParentInstructionSet:_parent toProgram:_program];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
// format: 0. instructionType, 1. doTimes instruction, 2. doTimes number
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileDoTimesInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program {
    NSMutableArray* doTimesInstructionSet = [_instructionSet objectAtIndex:1];
    NSInteger doTimesNumber = [[_instructionSet objectAtIndex:2] intValue];
    ProgramInstruction doTimesInstruction = [[doTimesInstructionSet objectAtIndex:0] intValue];
    if (doTimesInstruction == SubroutineProgramInstruction) {
        for (int i = 0; i < doTimesNumber; i++) {
            [self compileInstructionSet:doTimesInstructionSet forParentInstructionSet:_parent toProgram:_program];
        }
    } else {
        for (int i = 0; i < doTimesNumber; i++) {
            [_program addObject:doTimesInstructionSet];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
// format: 0. instructionType, 1. doUntil instruction, 2. doUntil predicate, 3. doUntil compiled instructions
//         4. do Until compiled instructions line number, 5. parent doUntil instruction, 
//-----------------------------------------------------------------------------------------------------------------------------------
- (void)compileDoUntilInstructionSet:(NSMutableArray*)_instructionSet forParentInstructionSet:(NSMutableArray*)_parent toProgram:(NSMutableArray*)_program {
    NSMutableArray* doUntilInstructionSets = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray* doInstructionSet = [_instructionSet objectAtIndex:1];
    [_instructionSet addObject:doUntilInstructionSets];
    [_instructionSet addObject:[NSNumber numberWithInt:0]];
    if (_parent) {
        [_instructionSet addObject:_parent];
    } else {
        [_instructionSet addObject:[NSNumber numberWithInt:0]];
    }
    [_program addObject:_instructionSet];
    [self compileInstructionSet:doInstructionSet forParentInstructionSet:_parent toProgram:doUntilInstructionSets];
    [self resetMaxCallStackDepth:[doUntilInstructionSets count]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetMaxCallStackDepth:(NSInteger)_depth {
    self.maxCallStackDepth = MAX(_depth, self.maxCallStackDepth);
}

//===================================================================================================================================
#pragma mark ProgramNgin Execution
        
//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getInstructionSet:(MapScene*)_mapScene {
    NSMutableArray* instructionSet = nil;
    NSMutableArray* exeInstructionSet = [self.compiledProgram objectAtIndex:self.codeLine];
    ProgramInstruction exeInstruction = [[exeInstructionSet objectAtIndex:0] intValue];;
    switch (exeInstruction) {
        case MoveProgramInstruction:
        case TurnLeftProgramInstruction:
        case PutSensorProgramInstruction:
        case GetSampleProgramInstruction:
            instructionSet = [self.compiledProgram objectAtIndex:self.codeLine];
            self.codeLine++;
            break;
        case DoUntilProgramInstruction:
            instructionSet = [self doUntilNextInstruction:_mapScene forInstructionSet:exeInstructionSet];
            break;
        default:
            break;
    }
    return instructionSet;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)doUntilNextInstruction:(MapScene*)_mapScene forInstructionSet:(NSMutableArray*)_instructionSet {
    NSMutableArray* exeInstruction = nil;
    ProgramInstruction predicateInstruction = [[_instructionSet objectAtIndex:2] intValue];
    BOOL predicateTrue = YES;
    switch (predicateInstruction) {
        case PathBlockedPredicateProgramInstruction:
            predicateTrue = [self pathBlocked:_mapScene];
            break;
        case SensorBinEmptyPredicateProgramInstruction:
            predicateTrue = [self sensorBinEmpty:_mapScene];
            break;
        case SampleBinFullPredicateProgramInstruction:
            predicateTrue = [self sampleBinFull:_mapScene];
            break;
        case AtStationPredicateProgramInstruction:
            predicateTrue = [self atStation:_mapScene];
            break;
        case AtSampleProgramInstruction:
            predicateTrue = [self atSample:_mapScene];
            break;
        case AtSensorSiteProgramInstruction:
            predicateTrue = [self atSensorSite:_mapScene];
            break;
        default:
            break;
    }
    NSMutableArray* parent = [_instructionSet objectAtIndex:5];
    if (!predicateTrue) {
        NSMutableArray* doInstructionProgram = [_instructionSet objectAtIndex:3];
        NSInteger doInstructionLine = [[_instructionSet objectAtIndex:4] intValue];
        NSMutableArray* doInstructionSet = [doInstructionProgram objectAtIndex:doInstructionLine];
        ProgramInstruction doInstruction = [[doInstructionSet objectAtIndex:0] intValue];
        switch (doInstruction) {
            case MoveProgramInstruction:
            case TurnLeftProgramInstruction:
            case PutSensorProgramInstruction:
            case GetSampleProgramInstruction:
                exeInstruction = doInstructionSet;
                [self incrementLineCounter:_instructionSet];
                break;
            case DoUntilProgramInstruction:
                exeInstruction = [self doUntilNextInstruction:_mapScene forInstructionSet:doInstructionSet];
                break;
            default:
                break;
        }
    } else {
        if ([parent isKindOfClass:[NSMutableArray class]]) {
            [self incrementLineCounter:parent];
        } else {
            self.codeLine++;
        }
        if (self.callStackDepth < self.maxCallStackDepth) {
            self.callStackDepth++;
            exeInstruction = [self nextInstruction:_mapScene];
        }
    }    
    return exeInstruction;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)incrementLineCounter:(NSMutableArray*)_instructionSet {
    NSInteger instructionLines = [[_instructionSet objectAtIndex:3] count];
    NSInteger instructionLine = [[_instructionSet objectAtIndex:4] intValue];
    instructionLine++;
    if (instructionLine >= instructionLines) {
        instructionLine = 0;
    }
    [_instructionSet insertObject:[NSNumber numberWithInt:instructionLine] atIndex:4];
}

//===================================================================================================================================
#pragma mark ProgramNgin Predicates

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)hasItem:(MapScene*)_mapScene withValue:(NSString*)_value {
    BOOL status = NO;
    CGPoint position = [_mapScene getSeekerTile];
    NSDictionary* item = [_mapScene getTileProperties:position forLayer:_mapScene.itemsLayer];
    if (item) {
        NSString* itemID = [item valueForKey:@"itemID"];
        if ([itemID isEqualToString:_value]) {
            status = YES;
        } 
    } 
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)pathBlocked:(MapScene*)_mapScene {
    BOOL status = YES;
    CGPoint position = [_mapScene nextPosition];
    NSInteger gradient = [_mapScene terrainGradient];
    if ([_mapScene positionIsInPlayingArea:position] && [_mapScene isTerrainClear:gradient]) {
        status = NO;
    } 
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)sensorBinEmpty:(MapScene*)_mapScene {
    return [_mapScene.seeker1 isSensorBinEmpty];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)sampleBinFull:(MapScene*)_mapScene {
    return [_mapScene.seeker1 isSampleBinFull];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)atStation:(MapScene*)_mapScene {
    return [self hasItem:_mapScene withValue:@"station"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)atSample:(MapScene*)_mapScene {
    return [self hasItem:_mapScene withValue:@"sample"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)atSensorSite:(MapScene*)_mapScene {
    return [self hasItem:_mapScene withValue:@"sensorSite"];
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
        self.codeLine = 0;
        self.callStackDepth = 0;
        self.maxCallStackDepth = 0;
	}
	return self;
}

//===================================================================================================================================
#pragma mark ProgramNgin Data

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getPrimitiveInstructions {
    NSMutableArray* primatives = [NSMutableArray arrayWithCapacity:10];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:MoveProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:TurnLeftProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:PutSensorProgramInstruction], nil]];
    [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:GetSampleProgramInstruction], nil]];
    NSInteger level = [UserModel level];
    if (level >= kLEVEL_FOR_TIMES) {
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
    NSInteger level = [UserModel level];
    if (level >= kLEVEL_FOR_BINS) {
        [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:AtSampleProgramInstruction], nil]];
        [primatives addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:AtSensorSiteProgramInstruction], nil]];
    }
    return primatives;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getSubroutines {
    return [SubroutineModel modelsToInstructions:[SubroutineModel findAll]];
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
        case AtSampleProgramInstruction:
            instructionString = @"at sample";
            break;
        case AtSensorSiteProgramInstruction:
            instructionString = @"at sensor site";
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

//===================================================================================================================================
#pragma mark ProgramNgin Manage

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadProgram:(NSMutableArray*)_program {
    self.program = [NSMutableArray arrayWithArray:_program];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)saveProgram:(NSMutableArray*)_program {
    [ProgramModel insertProgram:_program forLevel:[UserModel level]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)deleteProgram {
    [self.program removeAllObjects];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)runProgram {
    [self compile];
    self.codeLine = 0;
    self.programRunning = YES;
    self.programHalted = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stopProgram {
    self.codeLine = 0;
    self.programRunning = NO;
    self.programHalted = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)haltProgram {
    self.codeLine = 0;
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
- (NSMutableArray*)nextInstruction:(MapScene*)_mapScene {
    NSInteger compiledCodeLines = [self.compiledProgram count];
    if (self.codeLine > compiledCodeLines - 1) {
        self.codeLine = 0;
    } 
    NSMutableArray* instructionSet = [self getInstructionSet:_mapScene];
    self.callStackDepth = 0;
    return instructionSet;
}

@end
