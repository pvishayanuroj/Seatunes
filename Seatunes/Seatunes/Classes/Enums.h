//
//  Enums.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#define kProductPurchaseNotification @"ProductPurchased"
#define kProductPurchaseFailedNotification @"ProductPurchasedFailed"
#define kProductsLoadedNotification @"ProductsLoaded"
#define kProductsLoadedFailedNotification @"ProductsLoadedFailed"

#define kAllPacks @"All Packs"
#define PACK_MENU_CELL_HEIGHT 160
#define SONG_MENU_CELL_HEIGHT 55

#define NUM_SUNBEAMS 6

#define PERCENT_FOR_BADGE 90

#define kFirstPlay @"First Play"

#define APSALAR_KEY @"pvishayanuroj"

#define APSALAR_SECRET @"8WmuWiho"

typedef enum {
    kC4 = 0,
    kD4 = 1,
    kE4 = 2,
    kF4 = 3,
    kG4 = 4,
    kA4 = 5,
    kB4 = 6,
    kC5 = 7,
    kD5 = 8,
    kE5 = 9,
    kF5 = 10,    
    kBlankNote = 11
} KeyType;

typedef enum {
    kThreeKey,
    kFourKey,
    kFiveKey,
    kEightKey
} KeyboardType;

typedef enum {
    kPiano,
    kFlute,
    kLowStrings,
    kWarmPiano,
    kMetallic,
    kMuted,
    kMenu
} InstrumentType;

typedef enum {
    kDummy,
    kApplause,
    kPageFlip,
    kBubblePop,
    kBubblePop2,
    kClamHit,
    kDing,
    kSuccess,
    kThud,
    kWahWah,
    kSwoosh1,
    kSwoosh2,
    kSwoosh3    
} SoundType;

typedef enum {
    kHappyJumper
} MusicType;

typedef enum {
    kSeaAnemone,
    kClam
} CreatureType;

typedef enum {
    kWhaleInstructor
} InstructorType;

typedef enum {
    kBubbleCurve1,
    kBubbleCurve2,
    kBubbleCurve3
} BubbleCurveType;

typedef enum {
    kNoteRepeat,
    kTimedNoteRepeat,
    kSectionRepeat
} ProcessorType;

typedef enum {
    kDifficultyEasy = 0,
    kDifficultyMedium = 1,
    kDifficultyHard = 2,
    kDifficultyMusicNoteTutorial = 3
} DifficultyType;

typedef enum {
    kNoteMissed,
    kNoteHit,
    kNoteBlank
} ScoreType;

typedef enum {
    kBadgeBubble,
    kBadgeClam,
    kBadgeNote
} BadgeType;

typedef enum {
    kSpeechIntroduction = 0,
    kSpeechEasyTutorial,
    kSpeechMediumTutorial,
    kSpeechGreetings,
    kSpeechSongStart,
    kSpeechScolding,
    kSpeechSongCompleteGood,
    kSpeechSongCompleteBad,
    kSpeechRandomSaying,
    kSpeechScoreExplanation,
    kSpeechBubbleBadge,
    kSpeechClamBadge,
    kSpeechNoteBadge,
    kSpeechTutorialPrompt,
    kTutorialIntroduction,
    kTutorialIntroduction2,    
    kTutorialStaff,
    kTutorialNotes,
    kTutorialNotes2,
    kTutorialLetters,
    kTutorialLearnC,
    kTutorialPlayC,
    kTutorialPlayDE,
    kTutorialPlayFG,
    kTutorialPlayABC,
    kTutorialMnemonic,
    kTutorialEvery,
    kTutorialGood,
    kTutorialBoy,
    kTutorialFace,
    kTutorialF,
    kTutorialA,
    kTutorialC,
    kTutorialComplete    
} SpeechType;

typedef struct {
    NSUInteger notesMissed;
    NSUInteger notesHit;
    NSUInteger percentage;
    DifficultyType difficulty;
    BOOL helpUsed;
} ScoreInfo;

enum {
    kButtonSideMenu,
    kButtonNext,
    kButtonReplay,
    kButtonMenu,
    kButtonHelp
};