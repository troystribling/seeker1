//
//  DoTimesTerminalCell.h
//  seeker1
//
//  Created by Troy Stribling on 12/29/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "TerminalCellFactory.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesTerminalCell : UITableViewCell <TerminalCellInterface> {
    IBOutlet UILabel* promtLabel;
    IBOutlet UILabel* timesLabel;
    IBOutlet UILabel* timesClosingBracketLabel;
    IBOutlet UILabel* instructionClosingBracketLabel;
    IBOutlet UILabel* instructionLabel;
    IBOutlet UILabel* numberLabel;
    NSMutableArray* instructionSet;
    TerminalCellParentType parentType;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* promtLabel;
@property (nonatomic, retain) UILabel* timesLabel;
@property (nonatomic, retain) UILabel* timesClosingBracketLabel;
@property (nonatomic, retain) UILabel* instructionClosingBracketLabel;
@property (nonatomic, retain) UILabel* instructionLabel;
@property (nonatomic, retain) UILabel* numberLabel;
@property (nonatomic, retain) NSMutableArray* instructionSet;
@property (nonatomic, assign) TerminalCellParentType parentType;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
