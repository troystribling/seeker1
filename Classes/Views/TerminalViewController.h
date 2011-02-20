//
//  TerminalViewController.h
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* programView;
    IBOutlet UIImageView* editImageView;
    IBOutlet UIImageView* runImageView;
    IBOutlet UISlider* opacitySlider;
    IBOutlet UIImageView* opacityImage;
    IBOutlet UILabel* opacityLabel;
    UIView* containerView;
	NSMutableArray* programListing;
    NSString* functionUpdate;
    NSIndexPath* selectedLine;    
    BOOL launchedFromMap;
    BOOL editingEnabled;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* programView;
@property (nonatomic, retain) UIImageView* editImageView;
@property (nonatomic, retain) UIImageView* runImageView;
@property (nonatomic, retain) UISlider* opacitySlider;
@property (nonatomic, retain) UIImageView* opacityImage;
@property (nonatomic, retain) UILabel* opacityLabel;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* programListing;
@property (nonatomic, retain) NSString* functionUpdate;
@property (nonatomic, retain) NSIndexPath* selectedLine;
@property (nonatomic, assign) BOOL launchedFromMap;
@property (nonatomic, assign) BOOL editingEnabled;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (IBAction)opacityValueChanged:(id)sender; 

@end
