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
    BOOL runProgram;
    NSInteger nextLine;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* program;
@property (nonatomic, assign) BOOL runProgram;
@property (nonatomic, assign) NSInteger nextLine;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ProgramNgin*)instance;
- (NSMutableArray*)getPrimativeFunctions;
- (NSMutableArray*)getUserFunctions;
- (void)loadProgram:(NSMutableArray*)_program;
- (void)stopProgram;
- (BOOL)programLoaded;
- (NSString*)nextInstruction;

@end
