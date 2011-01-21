//
//  CodeModel.m
//  seeker1
//
//  Created by Troy Stribling on 1/20/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CodeModel.h"
#import "ProgramNgin.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CodeModel (PrivateAPI)

+ (NSString*)doInstructionsToCodeListing:(NSMutableArray*)_instructionSet;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CodeModel

//===================================================================================================================================
#pragma mark CodeModel PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)doInstructionsToCodeListing:(NSMutableArray*)_instructionSet {
    ProgramInstruction instruction = [[_instructionSet objectAtIndex:0] intValue];
    NSString* instructionString = nil;
    switch (instruction) {
        case MoveProgramInstruction:
        case TurnLeftProgramInstruction:
        case PutSensorProgramInstruction:
        case GetSampleProgramInstruction:
            instructionString = [NSString stringWithFormat:@"%d", instruction];
            break;
        case SubroutineProgramInstruction:
            instructionString = [NSString stringWithFormat:@"%d*%@", instruction, 
                                 [_instructionSet objectAtIndex:1]];
            break;
        default:
            break;
    }
    return instructionString;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSMutableArray*)codeListingToDoInstructions:(NSArray*)_instructionSetStrings {
    NSMutableArray* instructionSet = [NSMutableArray arrayWithCapacity:10];
    ProgramInstruction doIntruction = [[_instructionSetStrings objectAtIndex:1] intValue];
    if (doIntruction == SubroutineProgramInstruction) {
        instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:[[_instructionSetStrings objectAtIndex:0] intValue]], 
                          [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:doIntruction],
                           [_instructionSetStrings objectAtIndex:2], nil],
                          [NSNumber numberWithInt:[[_instructionSetStrings objectAtIndex:3] intValue]], nil];
    } else {
        instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:[[_instructionSetStrings objectAtIndex:0] intValue]], 
                          [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:doIntruction], nil],
                          [NSNumber numberWithInt:[[_instructionSetStrings objectAtIndex:2] intValue]], nil];
    }
    return instructionSet;
}

//===================================================================================================================================
#pragma mark CodeModel

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
                instructionString = [NSString stringWithFormat:@"%d*%@*%d", instruction, 
                                     [self doInstructionsToCodeListing:[instructionSet objectAtIndex:1]], 
                                     [[instructionSet objectAtIndex:2] intValue]];
                break;
            case DoUntilProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d*%@*%d", instruction, 
                                     [self doInstructionsToCodeListing:[instructionSet objectAtIndex:1]], 
                                     [[instructionSet objectAtIndex:2] intValue]];
                break;
            case SubroutineProgramInstruction:
                instructionString = [NSString stringWithFormat:@"%d*%@", instruction, 
                                     [instructionSet objectAtIndex:1]];
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
                    instructionSet = [self codeListingToDoInstructions:instructionSetStrings];
                    break;
                case DoUntilProgramInstruction:
                    instructionSet = [self codeListingToDoInstructions:instructionSetStrings];
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

@end
