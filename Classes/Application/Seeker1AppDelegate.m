//
//  Seeker1AppDelegate.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "Seeker1AppDelegate.h"
#import "SeekerDbi.h"
#import "cocos2d.h"
#import "BootScene.h"
#import "UserModel.h"
#import "LevelModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Seeker1AppDelegate (PrivateAPI)

- (void)initDb;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation Seeker1AppDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize window;

//===================================================================================================================================
#pragma mark Seeker1AppDelegate PrivateAPI

//===================================================================================================================================
#pragma mark Seeker1AppDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) applicationDidFinishLaunching:(UIApplication*)application {
    [self initDb];
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	
	// Turn on display FPS
	[director setDisplayFPS:NO];
	
	// Turn on multiple touches
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
	
    // startup scene
	[[CCDirector sharedDirector] runWithScene: [BootScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initDb {
	SeekerDbi* dbi = [SeekerDbi instance];
	if (![dbi copyDbFile]) {
		NSLog (@"Database inilaization failed");
		return;
	}	
	[dbi open];
    UserModel* user = [UserModel findFirst];
    if (user == nil) {
        [UserModel insert];
        [LevelModel insertForLevel:1];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
