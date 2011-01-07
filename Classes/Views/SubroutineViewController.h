//
//  SubroutineViewController.h
//  seeker1
//
//  Created by Troy Stribling on 1/5/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SubroutineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* subroutineView;
    IBOutlet UIImageView* editImageView;
    UIView* containerView;
	NSMutableArray* subroutineListing;
    NSIndexPath* selectedLine; 
    NSString* subroutineName;
    BOOL editingEnabled;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* subroutineView;
@property (nonatomic, retain) UIImageView* editImageView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* subroutineListing;
@property (nonatomic, retain) NSIndexPath* selectedLine;
@property (nonatomic, retain) NSString* subroutineName;
@property (nonatomic, assign) BOOL editingEnabled;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
