//
//  DoUntilTerminalCell.h
//  seeker1
//
//  Created by Troy Stribling on 1/3/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "TerminalCellFactory.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoUntilTerminalCell : UITableViewCell <TerminalCellInterface> {
    IBOutlet UILabel* promtLabel;
    IBOutlet UILabel* instructionClosingBracketLabel;
    IBOutlet UILabel* instructionLabel;
    IBOutlet UILabel* untilLabel;
    IBOutlet UILabel* predicateClosingBracketLabel;
    IBOutlet UILabel* predicateLabel;
    NSMutableArray* instructionSet;
    TerminalCellParentType parentType;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* promtLabel;
@property (nonatomic, retain) UILabel* instructionClosingBracketLabel;
@property (nonatomic, retain) UILabel* instructionLabel;
@property (nonatomic, retain) UILabel* untilLabel;
@property (nonatomic, retain) UILabel* predicateClosingBracketLabel;
@property (nonatomic, retain) UILabel* predicateLabel;
@property (nonatomic, retain) NSMutableArray* instructionSet;
@property (nonatomic, assign) TerminalCellParentType parentType;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
