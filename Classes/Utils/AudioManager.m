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

//===================================================================================================================================
#pragma mark AudioManager Effects

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playMainMenuAudio {
    [[SimpleAudioEngine sharedEngine] playEffect:@"main-menu.wav"];
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
        switch (_audioID) {
            case StartAudioBackgroundID:
                [self playStartAudio];
                break;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)pauseBackgroundMusic {
    if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAudio {
    SimpleAudioEngine* sae = [SimpleAudioEngine sharedEngine];
    if (sae != nil) {
        [sae preloadEffect:@"main-menu.wav"];
        if (sae.willPlayBackgroundMusic) {
            sae.effectsVolume = 1.0;
            sae.backgroundMusicVolume = 1.0;
        }
    }
}
@end
