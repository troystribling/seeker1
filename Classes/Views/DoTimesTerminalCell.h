//
//  DoTimesTerminalCell.h
//  seeker1
//
//  Created by Troy Stribling on 12/29/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesTerminalCell : UITableViewCell {
    IBOutlet UILabel* timesLabel;
    IBOutlet UILabel* timesClosingBracketLabel;
    IBOutlet UILabel* methodClosingBracketLabel;
    IBOutlet UILabel* methodLabel;
    IBOutlet UITextField* numberTextField;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* timesLabel;
@property (nonatomic, retain) UILabel* timesClosingBracketLabel;
@property (nonatomic, retain) UILabel* methodClosingBracketLabel;
@property (nonatomic, retain) UILabel* methodLabel;
@property (nonatomic, retain) UITextField* numberTextField;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forInstructionSet:(NSMutableArray*)_instructionSet;

@end
