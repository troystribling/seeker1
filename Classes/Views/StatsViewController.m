//
//  StatsViewController.m
//  seeker1
//
//  Created by Troy Stribling on 3/3/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "StatsViewController.h"
#import "LevelModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kSTATS_LAUNCHER_BACK_TAG     1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StatsViewController (PrivateAPI)

- (UIColor*)getColor:(NSInteger)_metric;
- (void)setLevels;
- (void)setTotalScore;
- (void)setCodeScore;
- (void)setProgress;
- (void)setPerformance;
- (void)setExpertise;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StatsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize totalScoreLabel;
@synthesize totalLevelsLabel;
@synthesize totalCodeScoreLabel;
@synthesize progressLabel;
@synthesize performanceLabel;
@synthesize expertiseLabel;
@synthesize containerView;

//===================================================================================================================================
#pragma mark StatsViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIColor*)getColor:(NSInteger)_metric {
    if (_metric < 75) {
        return [UIColor colorWithRed:0.8 green:0.2 blue:0.0 alpha:1.0];
    } else if (_metric < 90) {
        return [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    } else {
        return [UIColor colorWithRed:0.0 green:0.667 blue:0.0 alpha:1.0];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setLevels {
    NSInteger levels = [LevelModel count];
    self.totalLevelsLabel.text = [NSString stringWithFormat:@"%d", levels];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setTotalScore {
    NSInteger totScore = [LevelModel totalScore];
    NSInteger maxScore =[LevelModel maxScore];
    NSInteger scoreRatio = (NSInteger)(100.0*(float)totScore/(float)maxScore);
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%d", totScore];
    self.totalScoreLabel.textColor = [self getColor:scoreRatio];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setCodeScore {
    NSInteger cScore = [LevelModel avgCodeScore];
    self.totalCodeScoreLabel.text = [NSString stringWithFormat:@"%d%%", cScore];
    self.totalCodeScoreLabel.textColor = [self getColor:cScore];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setProgress {
    NSInteger totLevels = [LevelModel count];
    NSInteger progress = (NSInteger)(100.0*(float)totLevels/(float)(kMISSIONS_PER_QUAD*kQUADS_TOTAL));
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
    self.progressLabel.textColor = [self getColor:progress];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setPerformance {
    NSInteger totLevels = [LevelModel count];
    NSInteger compLevels = [LevelModel completedLevels];
    NSInteger perf = 0;
    if (compLevels > 0) {
        perf = (NSInteger)(100.0*(float)totLevels/(float)compLevels);
    }
    self.performanceLabel.text = [NSString stringWithFormat:@"%d%%", perf];
    self.performanceLabel.textColor = [self getColor:perf];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setExpertise {
    NSInteger totScore = [LevelModel totalScore];
    NSInteger maxScore =[LevelModel maxScore];
    NSInteger scoreRatio = (NSInteger)(100.0*(float)totScore/(float)maxScore);
    NSInteger cScore = [LevelModel avgCodeScore];
    NSInteger expert = (NSInteger)((float)(cScore + scoreRatio)/2.0);
    self.expertiseLabel.text = [NSString stringWithFormat:@"%d%%", expert];
    self.expertiseLabel.textColor = [self getColor:expert];
}

        
//===================================================================================================================================
#pragma mark StatsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    StatsViewController* viewController = 
        [[StatsViewController alloc] initWithNibName:@"StatsViewController" bundle:nil inView:_containerView];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self setTotalScore];
    [self setLevels];
    [self setCodeScore];
    [self setProgress];
    [self setPerformance];
    [self setExpertise];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//===================================================================================================================================
#pragma mark UIResponder

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    NSInteger touchTag = touch.view.tag;
    switch (touchTag) {
        case kSTATS_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            break;
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

@end
