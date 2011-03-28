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
    MainMenuAudioEffectID,
    SiteAudioEffectID,
    SiteUpAudioEffectID,
    SiteDownAudioEffectID,
    MissionAudioEffectID,
    MapMenuAudioEffectID,
} AudioEffectID;

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum audioBackgroundID {
    BootingAudioBackgroundID,
    TharsisAudioBackgroundID,
    MemnoniaAudioBackgroundID,
    ElysiumAudioBackgroundID,
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
- (void)loadAudio;

@end
