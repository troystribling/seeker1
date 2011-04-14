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
#import "QuadsScene.h"

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
            case SelectAudioEffectID:
                [[SimpleAudioEngine sharedEngine] playEffect:@"select.wav"];
                break;
            case ItemDisplayedAudioEffectID:
                [[SimpleAudioEngine sharedEngine] playEffect:@"item-displayed.wav"];
                break;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playBackgroundMusic:(AudioBackgroundID)_audioID {
    if ([UserModel audioEnabled]) {
        if (![[AudioManager instance] isBackgroundMusicPlaying]) {
            switch (_audioID) {
                case BootAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"boot.mp3" loop:YES];
                    break;
                case CrashAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"crash.mp3" loop:YES];
                    break;
                case TharsisAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"tharsis.mp3" loop:YES];
                    break;
                case MemnoniaAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"memnonia.mp3" loop:YES];
                    break;
                case ElysiumAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"elysium.mp3" loop:YES];
                    break;
                case GameOverAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game-over.mp3" loop:YES];
                    break;
                case FeatureUnlockedAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"feature-unlocked.mp3" loop:YES];
                    break;
                case MissionCompletedAudioBackgroundID:
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mission-completed.mp3" loop:YES];
                    break;
            }
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)playQuadBackgroundMusic {
    QuadType quadID = [UserModel quadrangle];
    if ([UserModel audioEnabled]) {
        if (![[AudioManager instance] isBackgroundMusicPlaying]) {
            switch (quadID) {
                case TharsisQuadType:
                    [self playBackgroundMusic:TharsisAudioBackgroundID];
                    break;
                case MemnoniaQuadType:
                    [self playBackgroundMusic:MemnoniaAudioBackgroundID];
                    break;
                case ElysiumQuadType:
                    [self playBackgroundMusic:ElysiumAudioBackgroundID];
                    break;
            }
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
- (BOOL)isBackgroundMusicPlaying {
    return [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadAudio {
    SimpleAudioEngine* sae = [SimpleAudioEngine sharedEngine];
    if (sae != nil) {
        [sae preloadEffect:@"select.wav"];
        [sae preloadEffect:@"item-displayed.wav"];
        [sae preloadEffect:@"boot.mp3"];
        [sae preloadEffect:@"crash.mp3"];
        [sae preloadEffect:@"elysium.mp3"];
        [sae preloadEffect:@"game-over.mp3"];
        [sae preloadEffect:@"memnonia.mp3"];
        [sae preloadEffect:@"mission-completed.mp3"];
        [sae preloadEffect:@"tharsis.mp3"];
        if (sae.willPlayBackgroundMusic) {
            sae.effectsVolume = 1.0;
            sae.backgroundMusicVolume = 1.0;
        }
    }
}
@end
