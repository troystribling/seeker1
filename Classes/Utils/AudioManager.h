//
//  AudioManager.h
//  seeker1
//
//  Created by Troy Stribling on 3/26/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//  Copyright imaginary products 2010. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum audioEffectID {
    SelectAudioEffectID,
    ItemDisplayedAudioEffectID,
} AudioEffectID;

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum audioBackgroundID {
    BootAudioBackgroundID,
    CrashAudioBackgroundID,
    TharsisAudioBackgroundID,
    MemnoniaAudioBackgroundID,
    ElysiumAudioBackgroundID,
    GameOverAudioBackgroundID,
    FeatureUnlockedAudioBackgroundID,
    MissionCompletedAudioBackgroundID,
} AudioBackgroundID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AudioManager : NSObject {
}

//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AudioManager*)instance;
- (void)playEffect:(AudioEffectID)_audioID;
- (void)playBackgroundMusic:(AudioBackgroundID)_audioID;
- (void)pauseBackgroundMusic;
- (void)resumeBackgroundMusic;
- (void)stopBackgroundMusic;
- (BOOL)isBackgroundMusicPlaying;
- (void)loadAudio;

@end
