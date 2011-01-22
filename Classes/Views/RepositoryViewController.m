    //
//  RepositoryViewController.m
//  seeker1
//
//  Created by Troy Stribling on 1/20/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "cocos2d.h"
#import "ViewControllerManager.h"
#import "RepositoryViewController.h"
#import "RepositoryCell.h"
#import "TerminalCellFactory.h"
#import "ProgramModel.h"
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kREPOSITORY_LAUNCHER_BACK_TAG     1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RepositoryViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RepositoryViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize repositoryView;
@synthesize containerView;
@synthesize programsList;

//===================================================================================================================================
#pragma mark RepositoryViewController PrivateAPI

//===================================================================================================================================
#pragma mark RepositoryViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    return [[RepositoryViewController alloc] initWithNibName:@"RepositoryViewController" bundle:nil inView:_containerView];
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
    self.repositoryView.separatorColor = [UIColor blackColor];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.programsList = [ProgramModel findAll];
    [self.repositoryView reloadData];
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
        case kREPOSITORY_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            break;
       default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.programsList count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgramModel* model = [self.programsList objectAtIndex:indexPath.row];
    return [RepositoryCell tableView:tableView cellForRowAtIndexPath:indexPath forProgramModel:model];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//===================================================================================================================================
#pragma mark UITableViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgramModel* model = [self.programsList objectAtIndex:indexPath.row];
    [UserModel setLevel:model.level];
    [[ViewControllerManager instance] showTerminalView:[[CCDirector sharedDirector] openGLView]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return kTERMINAL_DEFAULT_CELL_HEIGHT;
}

//===================================================================================================================================
#pragma mark NSObject

@end
