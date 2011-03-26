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
    MapMenuAudioEffectID,
} AudioEffectID;

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum audioBackgroundID {
    StartAudioBackgroundID,
} AudioBackgroundID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AudioManager : NSObject {
    BOOL backgroundMusicIsPlaying;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) BOOL backgroundMusicIsPlaying;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (AudioManager*)instance;
- (void)playEffect:(AudioEffectID)_audioID;
- (void)playBackgroundMusic:(AudioBackgroundID)_audioID;
- (void)pauseBackgroundMusic;

@end
