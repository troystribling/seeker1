//
//  DoTimesTerminalCell.m
//  seeker1
//
//  Created by Troy Stribling on 12/29/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "DoTimesTerminalCell.h"
#import "TerminalViewController.h"
#import "CellUtils.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesTerminalCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize promtLabel;
@synthesize timesLabel;
@synthesize timesClosingBracketLabel;
@synthesize methodClosingBracketLabel;
@synthesize methodLabel;
@synthesize numberTextField;

//===================================================================================================================================
#pragma mark DoTimesTerminalCell PrivateAPI

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//===================================================================================================================================
#pragma mark TerminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    DoTimesTerminalCell* cell = (DoTimesTerminalCell*)[CellUtils createCell:[DoTimesTerminalCell class] forTableView:tableView];
    cell.methodLabel.userInteractionEnabled = YES;
    cell.numberTextField.userInteractionEnabled = YES;
    cell.numberTextField.delegate = (TerminalViewController*)tableView;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    DoTimesTerminalCell* cell = (DoTimesTerminalCell*)[CellUtils createCell:[DoTimesTerminalCell class] forTableView:tableView];
    cell.promtLabel.text = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
    cell.methodLabel.userInteractionEnabled = NO;
    cell.numberTextField.userInteractionEnabled = NO;
    return cell;
}

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
}

@end
