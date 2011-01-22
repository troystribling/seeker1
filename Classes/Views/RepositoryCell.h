//
//  RepositoryCell.h
//  seeker1
//
//  Created by Troy Stribling on 1/21/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class ProgramModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RepositoryCell : UITableViewCell {
    IBOutlet UILabel* levelLabel;
    IBOutlet UILabel* dateLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* levelLabel;
@property (nonatomic, retain) UILabel* dateLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath forProgramModel:(ProgramModel*)_program;

@end
