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
#define kDOTIMES_NUMBER_TAG                     1
#define kDOTIMES_INSTRUCTION_TAG                2
#define kDOTIMES_INSTRUCTION_MAX_WIDTH          206
#define kDOTIMES_INSTRUCTION_EDIT_MAX_WIDTH     125
#define kDOTIMES_NUMBER_MAX_WIDTH               128
#define kDOTIMES_NUMBER_EDIT_MAX_WIDTH          40

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesTerminalCell (PrivateAPI)

- (CGSize)itemSize:(NSString*)_item;
- (void)setItemsContrainedToInstructionWidth:(NSInteger)_maxInstructionWidth andNumberWidth:(NSInteger)_maxNumberWidth;

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

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setItemsContrainedToInstructionWidth:(NSInteger)_maxInstructionWidth andNumberWidth:(NSInteger)_maxNumberWidth {
    // set instruction rect
    NSString* instructionString = [[ProgramNgin instance] iteratedInstructionString:self.instructionSet];
    CGSize instructionSize = [self itemSize:instructionString];
    CGRect instructionRect = self.instructionLabel.frame;
    instructionRect.size.width = MIN(instructionSize.width, _maxInstructionWidth);    

    // get bracket rect
    CGRect instructionClosingBracketRect = self.instructionClosingBracketLabel.frame;

    // set instruction rectangles and string
    self.instructionLabel.frame = instructionRect;
    self.instructionClosingBracketLabel.frame = CGRectMake(instructionRect.origin.x + instructionRect.size.width, instructionClosingBracketRect.origin.y, 
                                                           instructionClosingBracketRect.size.width, instructionClosingBracketRect.size.height);
    self.instructionLabel.text = instructionString;
    
    // set number rect
    NSString* numberString = [NSString stringWithFormat:@"%d", [[self.instructionSet objectAtIndex:2] intValue]];
    CGSize numberSize = [self itemSize:numberString];
    CGRect numberRect = self.numberLabel.frame; 
    numberRect.size.width = MIN(numberSize.width, _maxNumberWidth);    

    // get bracket and times rect
    CGRect timesClosingBracketRect = self.timesClosingBracketLabel.frame;
    CGRect timesRect = self.timesLabel.frame;

    // set number rectangles and string
    self.numberLabel.frame = numberRect;
    self.timesClosingBracketLabel.frame = CGRectMake(numberRect.origin.x + numberRect.size.width, timesClosingBracketRect.origin.y, 
                                                     timesClosingBracketRect.size.width, timesClosingBracketRect.size.height);
    self.timesLabel.frame = CGRectMake(numberRect.origin.x + numberRect.size.width + timesClosingBracketRect.size.width, 
                                       timesRect.origin.y, timesRect.size.width, timesRect.size.height);
    self.numberLabel.text = numberString;
}

//===================================================================================================================================
#pragma mark DoTimesTerminalCell

//===================================================================================================================================
#pragma mark TrminalCellInterface

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet andParentType:(TerminalCellParentType)_parentType{

    DoTimesTerminalCell* cell = (DoTimesTerminalCell*)[CellUtils createCell:[DoTimesTerminalCell class] forTableView:tableView];
    cell.instructionSet = _instructionSet;
    cell.parentType = _parentType;
    cell.instructionLabel.userInteractionEnabled = YES;
    cell.numberLabel.userInteractionEnabled = YES;
    [cell setItemsContrainedToInstructionWidth:kDOTIMES_INSTRUCTION_MAX_WIDTH andNumberWidth:kDOTIMES_NUMBER_MAX_WIDTH];        
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
    if (editing) {
        [self setItemsContrainedToInstructionWidth:kDOTIMES_INSTRUCTION_EDIT_MAX_WIDTH andNumberWidth:kDOTIMES_NUMBER_EDIT_MAX_WIDTH];        
    } else {
        [self setItemsContrainedToInstructionWidth:kDOTIMES_INSTRUCTION_MAX_WIDTH andNumberWidth:kDOTIMES_NUMBER_MAX_WIDTH];        
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
