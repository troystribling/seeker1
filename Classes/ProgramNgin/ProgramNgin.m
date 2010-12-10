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
@synthesize runProgram;
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
    self.nextLine = 0;
    self.runProgram = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)restartProgram {
    self.nextLine = 0;
    self.runProgram = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)nextInstruction {
    NSString* instruction = nil;
    if (self.nextLine < [self.program count]) {
        instruction = [self.program objectAtIndex:self.nextLine];
        self.nextLine++;
    } else {
        self.runProgram = NO;
    }    
    return instruction;
}

@end
