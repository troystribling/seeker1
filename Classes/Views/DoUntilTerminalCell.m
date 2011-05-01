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
#import "AudioManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kDOUNTIL_INSTRUCTION_TAG            2
#define kDOUNTIL_PREDICATE_TAG              1
#define kDOUNTIL_PREDICATE_MAX_WIDTH        187
#define kDOUNTIL_PREDICATE_EDIT_MAX_WIDTH   125
#define kDOUNTIL_INSTRUCTION_MAX_WIDTH      121
#define kDOUNTIL_INSTRUCTION_EDIT_MAX_WIDTH 30

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoUntilTerminalCell (PrivateAPI)

- (CGSize)itemSize:(NSString*)_item;
- (void)setItemsContrainedToInstructionWidth:(NSInteger)_maxInstructionWidth andPredicateWidth:(NSInteger)_maxPredicateWidth;

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

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setItemsContrainedToInstructionWidth:(NSInteger)_maxInstructionWidth andPredicateWidth:(NSInteger)_maxPredicateWidth {
    // set instruction rect
    NSString* instructionString = [[ProgramNgin instance] iteratedInstructionString:self.instructionSet];
    CGSize instructionSize = [self itemSize:instructionString];
    CGRect instructionRect = self.instructionLabel.frame;
    instructionRect.size.width = MIN(instructionSize.width, _maxInstructionWidth);    

    // get bracket and until rect
    CGRect instructionClosingBracketRect = self.instructionClosingBracketLabel.frame;
    CGRect untilRect = self.untilLabel.frame;

    // set instruction rectangles and string
    self.instructionLabel.frame = instructionRect;
    self.instructionClosingBracketLabel.frame = CGRectMake(instructionRect.origin.x + instructionRect.size.width, instructionClosingBracketRect.origin.y, 
                                                           instructionClosingBracketRect.size.width, instructionClosingBracketRect.size.height);
    self.untilLabel.frame = CGRectMake(instructionRect.origin.x + instructionRect.size.width + instructionClosingBracketRect.size.width,
                                       untilRect.origin.y, untilRect.size.width, untilRect.size.height);
    self.instructionLabel.text = instructionString;
    
    // set predicate rect
    NSString* predicateString = [[ProgramNgin instance] instructionToString:[[self.instructionSet objectAtIndex:2] intValue]];
    CGSize predicateSize = [self itemSize:predicateString];
    CGRect predicateRect = self.predicateLabel.frame;
    predicateRect.size.width = MIN(predicateSize.width, _maxPredicateWidth);
    
    // get bracket rect
    CGRect predicateClosingBracketRect = self.predicateClosingBracketLabel.frame;

    // set predicate rectangles and strings
    self.predicateLabel.frame = predicateRect;
    self.predicateClosingBracketLabel.frame = CGRectMake(predicateRect.origin.x + predicateRect.size.width, predicateClosingBracketRect.origin.y, 
                                                         predicateClosingBracketRect.size.width, predicateClosingBracketRect.size.height);
    self.predicateLabel.text = predicateString;
}

//===================================================================================================================================
#pragma mark DoUntilTerminalCell

//===================================================================================================================================
#pragma mark TerminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet andParentType:(TerminalCellParentType)_parentType {    
    DoUntilTerminalCell* cell = (DoUntilTerminalCell*)[CellUtils createCell:[DoUntilTerminalCell class] forTableView:tableView];
    cell.instructionSet = _instructionSet;
    cell.parentType = _parentType;
    cell.instructionLabel.userInteractionEnabled = YES;
    cell.predicateLabel.userInteractionEnabled = YES;
    [cell setItemsContrainedToInstructionWidth:kDOUNTIL_INSTRUCTION_MAX_WIDTH andPredicateWidth:kDOUNTIL_PREDICATE_MAX_WIDTH];        
    cell.promtLabel.text = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet {
    DoUntilTerminalCell* cell = (DoUntilTerminalCell*)[CellUtils createCell:[DoUntilTerminalCell class] forTableView:tableView];
    cell.promtLabel.text = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
    cell.instructionSet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:DoUntilProgramInstruction],
                                                           [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:MoveProgramInstruction], nil], 
                                                           [NSNumber numberWithInt:PathBlockedPredicateProgramInstruction], nil];
    cell.instructionLabel.userInteractionEnabled = NO;
    cell.predicateLabel.userInteractionEnabled = NO;
    return cell;
}

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (editing) {
        [self setItemsContrainedToInstructionWidth:kDOUNTIL_INSTRUCTION_EDIT_MAX_WIDTH andPredicateWidth:kDOUNTIL_PREDICATE_EDIT_MAX_WIDTH];        
    } else {
        [self setItemsContrainedToInstructionWidth:kDOUNTIL_INSTRUCTION_MAX_WIDTH andPredicateWidth:kDOUNTIL_PREDICATE_MAX_WIDTH];        
    }
    [super setEditing:editing animated:animated];
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
