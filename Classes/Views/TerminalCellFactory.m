//
//  TerminalCellFactory.m
//  seeker1
//
//  Created by Troy Stribling on 12/30/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TerminalCellFactory.h"
#import "TerminalCell.h"
#import "DoTimesTerminalCell.h"
#import "DoUntilTerminalCell.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalCellFactory (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TerminalCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark TerminalCellFactory PrivateAPI

//===================================================================================================================================
#pragma mark TerminalCellFactory

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView*)tableView heightForRowWithInstructionSet:(NSMutableArray*)_instructionSet {
	CGFloat cellHeight = kTERMINAL_DEFAULT_CELL_HEIGHT;
    ProgramInstruction instruction = [[_instructionSet objectAtIndex:0] intValue];
    switch (instruction) {
        case DoTimesProgramInstruction:
            cellHeight = kTERMINAL_DO_TIMES_CELL_HEIGHT;
            break;
        case DoUntilProgramInstruction:
            cellHeight = kTERMINAL_DO_UNTIL_CELL_HEIGHT;
            break;
        default:
            break;
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet andParentType:(TerminalCellParentType)_parentType {
    UITableViewCell* tableCell = nil;
    ProgramInstruction instruction = [[_instructionSet objectAtIndex:0] intValue];
    switch (instruction) {
        case MoveProgramInstruction:
        case TurnLeftProgramInstruction:
        case PutSensorProgramInstruction:
        case GetSampleProgramInstruction:
            tableCell = [TerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet andParentType:_parentType];
            break;
        case DoTimesProgramInstruction:
            tableCell = [DoTimesTerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet andParentType:_parentType];
            break;
        case DoUntilProgramInstruction:
            tableCell = [DoUntilTerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet andParentType:_parentType];
            break;
        case SubroutineProgramInstruction:
        case PathBlockedPredicateProgramInstruction:
        case SensorBinEmptyPredicateProgramInstruction:
        case SampleBinFullPredicateProgramInstruction:
        case AtStationPredicateProgramInstruction:
        case AtSampleProgramInstruction:
        case AtSensorSiteProgramInstruction:
            tableCell = [TerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet andParentType:_parentType];
            break;
    }
    return tableCell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    UITableViewCell* tableCell = nil;
    ProgramInstruction instruction = [[_instructionSet objectAtIndex:0] intValue];
    switch (instruction) {
        case MoveProgramInstruction:
        case TurnLeftProgramInstruction:
        case PutSensorProgramInstruction:
        case GetSampleProgramInstruction:
            tableCell = [TerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case DoTimesProgramInstruction:
            tableCell = [DoTimesTerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case DoUntilProgramInstruction:
            tableCell = [DoUntilTerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case SubroutineProgramInstruction:
        case PathBlockedPredicateProgramInstruction:
        case SensorBinEmptyPredicateProgramInstruction:
        case SampleBinFullPredicateProgramInstruction:
        case AtStationPredicateProgramInstruction:
        case AtSampleProgramInstruction:
        case AtSensorSiteProgramInstruction:
            tableCell = [TerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
    }
    return tableCell;
}

@end
