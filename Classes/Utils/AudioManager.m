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
                [[SimpleAudioEngine sharedEngine] playEffect:@"main-menu.wav"];
                break;
            case SiteAudioEffectID:
                [[SimpleAudioEngine sharedEngine] playEffect:@"site.wav"];
                break;
            case SiteUpAudioEffectID:
                break;
            case SiteDownAudioEffectID:
                break;
            case MissionAudioEffectID:
                [[SimpleAudioEngine sharedEngine] playEffect:@"mission.wav"];
                break;
            case MapMenuAudioEffectID:
                break;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playBackgroundMusic:(AudioBackgroundID)_audioID {
    if ([UserModel audioEnabled]) {
        switch (_audioID) {
            case BootingAudioBackgroundID:
                break;
            case TharsisAudioBackgroundID:
                break;
            case MemnoniaAudioBackgroundID:
                break;
            case ElysiumAudioBackgroundID:
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
- (void)resumeBackgroundMusic {
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stopBackgroundMusic {
    if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAudio {
    SimpleAudioEngine* sae = [SimpleAudioEngine sharedEngine];
    if (sae != nil) {
        [sae preloadEffect:@"main-menu.wav"];
        [sae preloadEffect:@"site.wav"];
        [sae preloadEffect:@"mission.wav"];
        if (sae.willPlayBackgroundMusic) {
            sae.effectsVolume = 1.0;
            sae.backgroundMusicVolume = 1.0;
        }
    }
}
@end
