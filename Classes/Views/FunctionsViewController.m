//
//  FunctionsViewController.m
//  seeker1
//
//  Created by Troy Stribling on 12/7/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "FunctionsViewController.h"
#import "TerminalViewController.h"
#import "CellUtils.h"
#import "TerminalCell.h"
#import "ProgramNgin.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface FunctionsViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FunctionsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize functionsView;
@synthesize containerView;
@synthesize functionList;
@synthesize terminalViewController;

//===================================================================================================================================
#pragma mark FunctionsViewController PrivateAPI

//===================================================================================================================================
#pragma mark FunctionsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inTerminalViewController:(TerminalViewController*)_terminalViewController {
    FunctionsViewController* viewController = 
    [[FunctionsViewController alloc] initWithNibName:@"FunctionsViewController" bundle:nil inView:_terminalViewController.containerView];
    viewController.terminalViewController = _terminalViewController;
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.functionList = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [FunctionsLauncherView inView:self.view andDelegate:self];
    self.functionsView.separatorColor = [UIColor blackColor];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.functionList = [[ProgramNgin instance] getPrimativeFunctions];
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
#pragma mark LauncherViewDelegate 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewTouchedNamed:(NSString*)name {
    if ([name isEqualToString:@"back"]) {
        [self.view removeFromSuperview];
    } else if ([name isEqualToString:@"run"]) {
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
    return [self.functionList count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    cell.lineLabel.text = [self.functionList objectAtIndex:indexPath.row];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//===================================================================================================================================
#pragma mark UITableViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* function = [self.functionList objectAtIndex:indexPath.row];
    if (self.terminalViewController.rowUpdated < [self.terminalViewController.programListing count]) {
        [self.terminalViewController.programListing replaceObjectAtIndex:self.terminalViewController.rowUpdated withObject:function];
    } else {
        [self.terminalViewController.programListing addObject:function];
    }
    [self.terminalViewController.programView reloadData];
    [self.view removeFromSuperview];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return kTERMINAL_LINE_CELL_HEIGHT;
}

//===================================================================================================================================
#pragma mark NSObject

@end
