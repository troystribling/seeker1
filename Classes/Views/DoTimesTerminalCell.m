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

- (CGSize)itemSize:(NSString*)_item;

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
@synthesize parentType;

//===================================================================================================================================
#pragma mark DoTimesTerminalCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGSize)itemSize:(NSString*)_item {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize textSize = {0.8 * winSize.width, 20000.0f};
    return [_item sizeWithFont:[UIFont fontWithName:@"Courier" size:22.0] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
}

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//===================================================================================================================================
#pragma mark TrminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet andParentType:(TerminalCellParentType)_parentType{

    DoTimesTerminalCell* cell = (DoTimesTerminalCell*)[CellUtils createCell:[DoTimesTerminalCell class] forTableView:tableView];
    cell.parentType = _parentType;
    cell.instructionLabel.userInteractionEnabled = YES;
    cell.numberLabel.userInteractionEnabled = YES;

    NSString* instructionString = [[ProgramNgin instance] iteratedInstructionString:_instructionSet];
    CGSize instructionSize = [cell itemSize:instructionString];
    CGRect instructionRect = cell.instructionLabel.frame;
    CGRect instructionClosingBracketRect = cell.instructionClosingBracketLabel.frame;
    cell.instructionLabel.frame = CGRectMake(instructionRect.origin.x, instructionRect.origin.y, instructionSize.width, instructionRect.size.height);
    cell.instructionClosingBracketLabel.frame = CGRectMake(instructionRect.origin.x + instructionSize.width, instructionClosingBracketRect.origin.y, 
                                                           instructionClosingBracketRect.size.width, instructionClosingBracketRect.size.height);
    cell.instructionLabel.text = instructionString;

    NSString* numberString = [NSString stringWithFormat:@"%d", [[_instructionSet objectAtIndex:2] intValue]];
    CGSize numberSize = [cell itemSize:numberString];
    CGRect numberRect = cell.numberLabel.frame; 
    CGRect timesClosingBracketRect = cell.timesClosingBracketLabel.frame;
    CGRect timesRect = cell.timesLabel.frame;
    cell.numberLabel.frame = CGRectMake(numberRect.origin.x, numberRect.origin.y, numberSize.width, numberRect.size.height);
    cell.timesClosingBracketLabel.frame = CGRectMake(numberRect.origin.x + numberSize.width, timesClosingBracketRect.origin.y, 
                                                     timesClosingBracketRect.size.width, timesClosingBracketRect.size.height);
    cell.timesLabel.frame = CGRectMake(numberRect.origin.x + numberSize.width + timesClosingBracketRect.size.width, 
                                       timesRect.origin.y, timesRect.size.width, timesRect.size.height);
    cell.numberLabel.text = numberString;

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
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    CGRect instructionRect = self.instructionLabel.frame;
//    if (editing) {
//        instructionRect.size.width = kTERMINAL_INSTRUCTION_EDIT_WIDTH;
//    } else {
//        instructionRect.size.width = kTERMINAL_INSTRUCTION_WIDTH;
//    }
//    self.instructionLabel.frame = instructionRect;
//    [super setEditing:editing animated:animated];
}

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
            if (self.parentType == TerminalTerminalCellParentType) {
                [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:TerminalDoTimesInstructionType andInstructionSet:self.instructionSet];
            } else {
                [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:SubroutineDoTimesInstructionType andInstructionSet:self.instructionSet];
            }
            break;
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

@end
