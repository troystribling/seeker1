//
//  ProgramNgin.m
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ProgramNgin* thisProgramNgin = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramNgin (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ProgramNgin

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize program;
@synthesize programHalted;
@synthesize programRunning;
@synthesize nextLine;

//===================================================================================================================================
#pragma mark ProgramNgin PrivateApi

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
        self.nextLine = 0;
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getPrimativeFunctions {
    return [NSMutableArray arrayWithObjects:@"move", @"turn left", @"get sample", @"put sensor", nil];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)getUserFunctions {
    return [NSMutableArray arrayWithCapacity:10];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadProgram:(NSMutableArray*)_program {
    self.program = _program;
    [self runProgram];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)deleteProgram {
    [self stopProgram];
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
- (NSString*)nextInstruction {
    NSString* instruction = nil;
    if (self.nextLine < [self.program count] - 1) {
        instruction = [self.program objectAtIndex:self.nextLine];
        self.nextLine++;
    } else if (self.nextLine == [self.program count] - 1) {
        instruction = [self.program objectAtIndex:self.nextLine];
        self.nextLine = 0;
    } else {
        [self stopProgram];
    }   
    return instruction;
}

@end
