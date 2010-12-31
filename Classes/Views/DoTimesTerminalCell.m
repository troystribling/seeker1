//
//  DoTimesTerminalCell.m
//  seeker1
//
//  Created by Troy Stribling on 12/29/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "DoTimesTerminalCell.h"
#import "CellUtils.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesTerminalCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize timesLabel;
@synthesize timesClosingBracketLabel;
@synthesize methodClosingBracketLabel;
@synthesize methodLabel;
@synthesize numberTextField;

//===================================================================================================================================
#pragma mark DoTimesTerminalCell PrivateAPI

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    DoTimesTerminalCell* cell = (DoTimesTerminalCell*)[CellUtils createCell:[DoTimesTerminalCell class] forTableView:tableView];
    return cell;
}

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
}

@end
