//
//  DoUntilTerminalCell.m
//  seeker1
//
//  Created by Troy Stribling on 1/3/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "DoUntilTerminalCell.h"
#import "cocos2d.h"
#import "TerminalViewController.h"
#import "CellUtils.h"
#import "ViewControllerManager.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kDOUNTIL_INSTRUCTION_TAG    2
#define kDOUNTIL_PREDICATE_TAG      1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoUntilTerminalCell (PrivateAPI)

- (CGSize)itemSize:(NSString*)_item;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DoUntilTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize promtLabel;
@synthesize instructionClosingBracketLabel;
@synthesize instructionLabel;
@synthesize untilLabel;
@synthesize predicateClosingBracketLabel;
@synthesize predicateLabel;
@synthesize instructionSet;
@synthesize parentType;

//===================================================================================================================================
#pragma mark DoUntilTerminalCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGSize)itemSize:(NSString*)_item {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize textSize = {0.8 * winSize.width, 20000.0f};
    return [_item sizeWithFont:[UIFont fontWithName:@"Courier" size:22.0] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
}

//===================================================================================================================================
#pragma mark DoUntilTerminalCell

//===================================================================================================================================
#pragma mark TrminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet andParentType:(TerminalCellParentType)_parentType {
    
    DoUntilTerminalCell* cell = (DoUntilTerminalCell*)[CellUtils createCell:[DoUntilTerminalCell class] forTableView:tableView];
    cell.parentType = _parentType;
    cell.instructionLabel.userInteractionEnabled = YES;
    cell.predicateLabel.userInteractionEnabled = YES;
    
    NSString* instructionString = [[ProgramNgin instance] iteratedInstructionString:_instructionSet];
    CGSize instructionSize = [cell itemSize:instructionString];
    CGRect instructionRect = cell.instructionLabel.frame;
    CGRect instructionClosingBracketRect = cell.instructionClosingBracketLabel.frame;
    CGRect untilRect = cell.untilLabel.frame;
    cell.instructionLabel.frame = CGRectMake(instructionRect.origin.x, instructionRect.origin.y, instructionSize.width, instructionRect.size.height);
    cell.instructionClosingBracketLabel.frame = CGRectMake(instructionRect.origin.x + instructionSize.width, instructionClosingBracketRect.origin.y, 
                                                           instructionClosingBracketRect.size.width, instructionClosingBracketRect.size.height);
    cell.untilLabel.frame = CGRectMake(instructionRect.origin.x + instructionSize.width + instructionClosingBracketRect.size.width,
                                       untilRect.origin.y, untilRect.size.width, untilRect.size.height);
    cell.instructionLabel.text = instructionString;
    
    NSString* predicateString = [[ProgramNgin instance] instructionToString:[[_instructionSet objectAtIndex:2] intValue]];
    CGSize predicateSize = [cell itemSize:predicateString];
    CGRect predicateRect = cell.predicateLabel.frame;
    CGRect predicateClosingBracketRect = cell.predicateClosingBracketLabel.frame;
    cell.predicateLabel.frame = CGRectMake(predicateRect.origin.x, predicateRect.origin.y, predicateSize.width, predicateRect.size.height);
    cell.predicateClosingBracketLabel.frame = CGRectMake(predicateRect.origin.x + predicateSize.width, predicateClosingBracketRect.origin.y, 
                                                         predicateClosingBracketRect.size.width, predicateClosingBracketRect.size.height);
    cell.predicateLabel.text = predicateString;
    
    cell.instructionSet = _instructionSet;
    
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    DoUntilTerminalCell* cell = (DoUntilTerminalCell*)[CellUtils createCell:[DoUntilTerminalCell class] forTableView:tableView];
    cell.promtLabel.text = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
    cell.instructionLabel.userInteractionEnabled = NO;
    cell.predicateLabel.userInteractionEnabled = NO;
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
        case kDOUNTIL_INSTRUCTION_TAG:
            if (self.parentType == TerminalTerminalCellParentType) {
                [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:TerminalDoUntilInstructionType andInstructionSet:self.instructionSet];
            } else {
                [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:SubroutineDoUntilInstructionType andInstructionSet:self.instructionSet];
            }
            break;
        case kDOUNTIL_PREDICATE_TAG:
            if (self.parentType == TerminalTerminalCellParentType) {
                [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:TerminalDoUntilPredicateInstructionType andInstructionSet:self.instructionSet];
            } else {
                [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:SubroutineDoUntilPredicateInstructionType andInstructionSet:self.instructionSet];
            }
            break;
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

@end
