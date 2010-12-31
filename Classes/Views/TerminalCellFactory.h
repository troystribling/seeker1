//
//  TerminalCellFactory.h
//  seeker1
//
//  Created by Troy Stribling on 12/30/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol TerminalCellInterface <NSObject>

@required

+ (UITableViewCell*)tableView:(UITableView *)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet;
+ (UITableViewCell*)tableView:(UITableView *)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalCellFactory : NSObject {

}

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithInstructionSet:(NSMutableArray*)_instructionSet;
+ (UITableViewCell*)tableView:(UITableView *)tableView terminalCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet;
+ (UITableViewCell*)tableView:(UITableView *)tableView listCellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet;

@end
