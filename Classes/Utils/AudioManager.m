//
//  AudioManager.m
//  seeker1
//
//  Created by Troy Stribling on 3/26/11.
//  Copyright 2010 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "AudioManager.h"
#import "SimpleAudioEngine.h"
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static AudioManager* thisAudioManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AudioManager (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AudioManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize backgroundMusicIsPlaying;

//===================================================================================================================================
#pragma mark AudioManager Effects

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playMainMenuAudio {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playMapMenuAudio {
}

//===================================================================================================================================
#pragma mark AudioManager Background Music

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playStartAudio {
}

//===================================================================================================================================
#pragma mark AudioManager

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AudioManager*)instance {	
    @synchronized(self) {
        if (thisAudioManager == nil) {
            thisAudioManager = [[self alloc] init];
            thisAudioManager.backgroundMusicIsPlaying = NO;
        }
    }
    return thisAudioManager;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playEffect:(AudioEffectID)_audioID {
    if ([UserModel audioEnabled]) {
        switch (_audioID) {
            case MainMenuAudioEffectID:
                [self playMainMenuAudio];
                break;
            case MapMenuAudioEffectID:
                [self playMapMenuAudio];
                break;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playBackgroundMusic:(AudioBackgroundID)_audioID {
    if ([UserModel audioEnabled]) {
        self.backgroundMusicIsPlaying = YES;
        switch (_audioID) {
            case StartAudioBackgroundID:
                [self playStartAudio];
                break;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)pauseBackgroundMusic {
    if (self.backgroundMusicIsPlaying) {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
    self.backgroundMusicIsPlaying = NO;
}

@end
