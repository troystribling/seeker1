//
//  TerminalCell.m
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TerminalCell.h"
#import "CellUtils.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kTERMINAL_INSTRUCTION_WIDTH         227
#define kTERMINAL_INSTRUCTION_EDIT_WIDTH    147 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalCell (PrivateAPI)

+ (NSString*)instructionToString:(NSMutableArray*)_instructionSet;
+ (UITableViewCell*)tableView:(UITableView*)tableView promptCellForRowAtIndexPath:(NSIndexPath*)indexPath;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize promtLabel;
@synthesize instructionLabel;

//===================================================================================================================================
#pragma mark TerminalCell PrivateAPI

//===================================================================================================================================
#pragma mark TerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView promptCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    cell.promtLabel.text = @">  ";
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)instructionToString:(NSMutableArray*)_instructionSet {
    ProgramInstruction instruction = [[_instructionSet objectAtIndex:0] intValue];
    NSString* instructionString;
    if (instruction == SubroutineProgramInstruction) {
        instructionString = [_instructionSet objectAtIndex:1];
    } else {
        instructionString = [[ProgramNgin instance] instructionToString:instruction];
    }
    return instructionString;
}

//===================================================================================================================================
#pragma mark TerminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet andParentType:(TerminalCellParentType)_parentType{
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    NSString* instructionString = [self instructionToString:_instructionSet];
    cell.promtLabel.text = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
    cell.instructionLabel.text = instructionString;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    NSString* instructionString = [self instructionToString:_instructionSet];
    cell.promtLabel.text = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
    cell.instructionLabel.text = instructionString;
    return cell;
}

//===================================================================================================================================
#pragma mark TerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    CGRect instructionRect = self.instructionLabel.frame;
    if (editing) {
        instructionRect.size.width = kTERMINAL_INSTRUCTION_EDIT_WIDTH;
    } else {
        instructionRect.size.width = kTERMINAL_INSTRUCTION_WIDTH;
    }
    self.instructionLabel.frame = instructionRect;
    [super setEditing:editing animated:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
}

@end
