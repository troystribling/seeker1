//
//  TerminalCell.h
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "TerminalCellFactory.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalCell : UITableViewCell <TerminalCellInterface> {
    IBOutlet UILabel* promtLabel;
    IBOutlet UILabel* instructionLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* promtLabel;
@property (nonatomic, retain) UILabel* instructionLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView promptCellForRowAtIndexPath:(NSIndexPath*)indexPath;

@end
