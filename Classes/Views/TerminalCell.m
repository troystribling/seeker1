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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize instructionLabel;

//===================================================================================================================================
#pragma mark TerminalCell PrivateAPI

//===================================================================================================================================
#pragma mark TerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView promptCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    cell.instructionLabel.text = @"~>";
    return cell;
}

//===================================================================================================================================
#pragma mark TerminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    NSString* instructionString = [[ProgramNgin instance] instructionToString:_instructionSet];
    cell.instructionLabel.text = [NSString stringWithFormat:@"~> %@", instructionString];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    NSString* instructionString = [[ProgramNgin instance] instructionToString:_instructionSet];
    cell.instructionLabel.text = [NSString stringWithFormat:@"%d. %@", (indexPath.row + 1), instructionString];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)enableUserInteraction {
}

//===================================================================================================================================
#pragma mark TerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
}

@end
