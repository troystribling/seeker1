//
//  RepositoryCell.m
//  seeker1
//
//  Created by Troy Stribling on 1/21/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RepositoryCell.h"
#import "CellUtils.h"
#import "ProgramModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RepositoryCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RepositoryCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize levelLabel;
@synthesize dateLabel;

//===================================================================================================================================
#pragma mark RepositoryCell PrivateAPI

//===================================================================================================================================
#pragma mark RepositoryCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forProgramModel:(ProgramModel*)_program {
    RepositoryCell* cell = (RepositoryCell*)[CellUtils createCell:[RepositoryCell class] forTableView:tableView];
    cell.levelLabel.text = [NSString stringWithFormat:@"%d.", _program.level];
    cell.dateLabel.text = [_program updatedAtAsString];
    return cell;
}

//===================================================================================================================================
#pragma mark TerminalCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
}


@end
