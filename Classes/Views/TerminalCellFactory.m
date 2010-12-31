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
        case MoveProgramInstruction:
            break;
        case TurnLeftProgramInstruction:
            break;
        case PutSensorProgramInstruction:
            break;
        case GetSampleProgramInstruction:
            break;
        case DoTimesProgramInstruction:
            cellHeight = kTERMINAL_DO_TIMES_CELL_HEIGHT;
            break;
        case DoWhileProgramInstruction:
            cellHeight = kTERMINAL_DO_WHILE_CELL_HEIGHT;
            break;
        case DoUntilProgramInstruction:
            cellHeight = kTERMINAL_DO_UNTIL_CELL_HEIGHT;
            break;
    }
    return cellHeight;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    UITableViewCell* tableCell = nil;
    ProgramInstruction instruction = [[_instructionSet objectAtIndex:0] intValue];
    switch (instruction) {
        case MoveProgramInstruction:
            tableCell = [TerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case TurnLeftProgramInstruction:
            tableCell = [TerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case PutSensorProgramInstruction:
            tableCell = [TerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case GetSampleProgramInstruction:
            tableCell = [TerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case DoTimesProgramInstruction:
            tableCell = [DoTimesTerminalCell tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case DoWhileProgramInstruction:
            break;
        case DoUntilProgramInstruction:
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
            tableCell = [TerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case TurnLeftProgramInstruction:
            tableCell = [TerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case PutSensorProgramInstruction:
            tableCell = [TerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case GetSampleProgramInstruction:
            tableCell = [TerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case DoTimesProgramInstruction:
            tableCell = [DoTimesTerminalCell tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:_instructionSet];
            break;
        case DoWhileProgramInstruction:
            break;
        case DoUntilProgramInstruction:
            break;
    }
    return tableCell;
}

@end
