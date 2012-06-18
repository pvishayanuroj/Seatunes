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
#define PACK_MENU_CELL_HEIGHT_M 80
#define SONG_MENU_CELL_HEIGHT_M 25

#define NUM_SUNBEAMS 6

#define PERCENT_FOR_BADGE 90

#define kFirstPlay @"First Play"

#define APSALAR_KEY @"pvishayanuroj"

#define APSALAR_SECRET @"8WmuWiho"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IPAD_SCREEN_WIDTH 1024
#define IPAD_SCREEN_HEIGHT 768
#define IPHONE_SCREEN_WIDTH 480
#define IPHONE_SCREEN_HEIGHT 320

#define ADJUST_REL_CCP(__p__) \
(IS_IPAD() == YES ? ccp(IPAD_SCREEN_WIDTH * __p__.x, IPAD_SCREEN_HEIGHT * __p__.y) : ccp(IPHONE_SCREEN_WIDTH * __p__.x, IPHONE_SCREEN_HEIGHT * __p__.y))

#define ADJUST_IPAD_CCP(__p__) \
(IS_IPAD() == YES ? __p__ : ccp(IPHONE_SCREEN_WIDTH * (__p__.x / IPAD_SCREEN_WIDTH), IPHONE_SCREEN_HEIGHT * (__p__.y / IPAD_SCREEN_HEIGHT)))

#define ADJUST_IPAD_RECT(__r__) \
(IS_IPAD() == YES ? __r__ : CGRectMake(IPHONE_SCREEN_WIDTH * (__r__.origin.x / IPAD_SCREEN_WIDTH), IPHONE_SCREEN_HEIGHT * (__r__.origin.y / IPAD_SCREEN_HEIGHT), \
IPHONE_SCREEN_WIDTH * (__r__.size.width / IPAD_SCREEN_WIDTH), IPHONE_SCREEN_HEIGHT * (__r__.size.height / IPAD_SCREEN_HEIGHT)))

#define ADJUST_IPAD_HEIGHT(__h__) (IS_IPAD() == YES ? __h__ : IPHONE_SCREEN_HEIGHT * (__h__ / IPAD_SCREEN_HEIGHT))

#define ADJUST_IPAD_WIDTH(__w__) (IS_IPAD() == YES ? __w__ : IPHONE_SCREEN_WIDTH * (__w__ / IPAD_SCREEN_WIDTH))

#define CHOOSE_REL_CCP(__ipad__, __iphone__) (IS_IPAD() == YES ? __ipad__ : __iphone__)

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