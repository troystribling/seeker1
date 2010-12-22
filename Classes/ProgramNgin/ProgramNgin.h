//
//  ProgramNgin.h
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramNgin : NSObject {
    NSMutableArray* program;
    BOOL programHalted;
    BOOL programRunning;
    NSInteger nextLine;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* program;
@property (nonatomic, assign) BOOL programHalted;
@property (nonatomic, assign) BOOL programRunning;
@property (nonatomic, assign) NSInteger nextLine;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ProgramNgin*)instance;
- (NSMutableArray*)getPrimativeFunctions;
- (NSMutableArray*)getUserFunctions;
- (void)loadProgram:(NSMutableArray*)_program;
- (void)deleteProgram;
- (void)runProgram;
- (void)stopProgram;
- (void)haltProgram;
- (BOOL)programIsLoaded;
- (BOOL)programIsRunning;
- (BOOL)programIsHalted;
- (NSString*)nextInstruction;

@end
