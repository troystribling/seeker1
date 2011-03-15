//
//  TutorialSectionViewController.h
//  seeker1
//
//  Created by Troy Stribling on 1/30/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tutorialSectionID {
    GettingStartedTutorialSectionID,
    SubroutinesTutorialSectionID,
    TimesLoopTutorialSectionID,
    UntilLoopTutorialSectionID,
    RoverBinsTutorialSectionID
} TutorialSectionID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialSectionViewController : UIViewController {
    IBOutlet UIImageView* tutorialView;
    IBOutlet UIImageView* nextView;
    NSArray* sectionList;
    NSArray* tutorialList;
    UIView* containerView;
    NSInteger selectedTutorial;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIImageView* tutorialView;
@property (nonatomic, retain) UIImageView* nextView;
@property (nonatomic, retain) NSArray* sectionList;
@property (nonatomic, retain) NSArray* tutorialList;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, assign) NSInteger selectedTutorial;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
+ (void)nextLevel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)setTutorialSection:(TutorialSectionID)_sectionID;

@end
