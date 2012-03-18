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

typedef enum {
    kC4 = 0,
    kD4 = 1,
    kE4 = 2,
    kF4 = 3,
    kG4 = 4,
    kA4 = 5,
    kB4 = 6,
    kC5 = 7,
    kBlankNote = 8
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
    kMuted
} InstrumentType;

typedef enum {
    kDummy,
    kApplause,
    kPageFlip,
    kClamHit,
    kMenuB0,
    kMenuC1,
    kMenuD1,
    kMenuE1,
    kMenuF1,
    kMenuG1,
    kMenuA1,
    kMenuB1,
    kMenuC2,    
} SoundType;

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
    kDifficultyHard = 2
} DifficultyType;

typedef enum {
    kScoreZeroStar = 0,
    kScoreOneStar = 1,
    kScoreTwoStar = 2,
    kScoreThreeStar = 3
} ScoreType;

typedef enum {
    kEasyInstructions,
    kEasyInstructions2,    
    kEasyReplay,    
    kEasyWrongNote,
    kEasyCorrectNote,
    kMediumInstructions,
    kHardInstructions,

    kMediumReplay,
    kHardReplay,
    kSongStart,
    kPlayedTooFast,
    kFellBehind,
    kWrongNote,
    kEasyLoss,
    kEasyFinish,
    kMediumLoss,
    kMediumFinish,
    kHardLoss,
    kHardFinish,
    kNextSection,
    kHardPlay,
    kSongComplete
} SpeechType;

typedef struct {
    NSUInteger notesMissed;
    NSUInteger notesHit;
    DifficultyType difficulty;
} ScoreInfo;

enum {
    kButtonSideMenu,
    kButtonNext,
    kButtonReplay,
    kButtonMenu
};