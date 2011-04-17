//
//  CreateSubroutineViewController.m
//  seeker1
//
//  Created by Troy Stribling on 1/5/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CreateSubroutineViewController.h"
#import "cocos2d.h"
#import "ViewControllerManager.h"
#import "SubroutineModel.h"
#import "AudioManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kCREATE_SUBROUTINE_LAUNCHER_BACK_TAG    1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CreateSubroutineViewController (PrivateAPI)

- (void)showAlert:(NSString*)title;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CreateSubroutineViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize nameTextField;
@synthesize containerView;

//===================================================================================================================================
#pragma mark CreateSubroutineViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showAlert:(NSString*)title {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];	
    [alert release];
}

//===================================================================================================================================
#pragma mark CreateSubroutineViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    CreateSubroutineViewController* viewController = 
        [[CreateSubroutineViewController alloc] initWithNibName:@"CreateSubroutineViewController" bundle:nil inView:_containerView];
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
    self.nameTextField.text = nil;
    [self.nameTextField becomeFirstResponder];
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
        case kCREATE_SUBROUTINE_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:SubroutineInstructionType];
            [[AudioManager instance] playEffect:SelectAudioEffectID];
            break;
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

//===================================================================================================================================
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString* subroutineName = self.nameTextField.text;
    BOOL returnStatus = YES;
    if ([subroutineName isEqualToString:@""]) {
        returnStatus = NO;
        [self showAlert:@"no name"];
    } else if ([subroutineName rangeOfString:@"~"].location != NSNotFound) {
        returnStatus = NO;
        [self showAlert:@"name invalid"];
    } else if ([subroutineName rangeOfString:@"*"].location != NSNotFound) {  
        returnStatus = NO;
        [self showAlert:@"name invalid"];
    } else {
        SubroutineModel* model = [SubroutineModel findByName:subroutineName];
        if (model == nil) {
            [SubroutineModel createSubroutineWithName:subroutineName];
            [self.view removeFromSuperview];
            [[ViewControllerManager instance] showSubroutineView:[[CCDirector sharedDirector] openGLView] withName:subroutineName];
        } else {
            returnStatus = NO;
            [self showAlert:@"subroutine exists"];
        }
    }
	return returnStatus; 
}


@end
