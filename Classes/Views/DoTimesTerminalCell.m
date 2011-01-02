//
//  DoTimesTerminalCell.m
//  seeker1
//
//  Created by Troy Stribling on 12/29/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "DoTimesTerminalCell.h"
#import "cocos2d.h"
#import "TerminalViewController.h"
#import "CellUtils.h"
#import "ViewControllerManager.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kDOTIMES_NUMBER_TAG         1
#define kDOTIMES_INSTRUCTION_TAG    2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesTerminalCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize promtLabel;
@synthesize timesLabel;
@synthesize timesClosingBracketLabel;
@synthesize instructionClosingBracketLabel;
@synthesize instructionLabel;
@synthesize numberLabel;
@synthesize instructionSet;

//===================================================================================================================================
#pragma mark DoTimesTerminalCell PrivateAPI

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//===================================================================================================================================
#pragma mark TrminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    DoTimesTerminalCell* cell = (DoTimesTerminalCell*)[CellUtils createCell:[DoTimesTerminalCell class] forTableView:tableView];
    cell.instructionLabel.userInteractionEnabled = YES;
    cell.numberLabel.userInteractionEnabled = YES;
    cell.instructionLabel.text = [[ProgramNgin instance] instructionToString:[[_instructionSet objectAtIndex:1] intValue]];
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", [[_instructionSet objectAtIndex:2] intValue]];
    cell.instructionSet = _instructionSet;
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    DoTimesTerminalCell* cell = (DoTimesTerminalCell*)[CellUtils createCell:[DoTimesTerminalCell class] forTableView:tableView];
    cell.promtLabel.text = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
    cell.instructionLabel.userInteractionEnabled = NO;
    cell.numberLabel.userInteractionEnabled = NO;
    return cell;
}

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
}

//===================================================================================================================================
#pragma mark UIResponder

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    NSInteger touchTag = touch.view.tag;
    switch (touchTag) {
        case kDOTIMES_NUMBER_TAG:
            [[ViewControllerManager instance] showDoTimesEditView:[[CCDirector sharedDirector] openGLView] forTerminalCell:self];
            break;
        case kDOTIMES_INSTRUCTION_TAG:
            break;
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

@end
