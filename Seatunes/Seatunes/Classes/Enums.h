//
//  Enums.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

typedef enum {
    kC4,
    kD4,
    kE4,
    kF4,
    kG4,
    kA4,
    kB4,
    kC5,
    kBlankNote
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
    kMetallic
} InstrumentType;

typedef enum {
    kDummy
} SoundType;

typedef enum {
    kSeaAnemone
} CreatureType;

typedef enum {
    kWhaleInstructor
} InstructorType;

typedef enum {
    kNoteRepeat,
    kTimedNoteRepeat,
    kSectionRepeat
} ProcessorType;

typedef enum {
    kExercisePack,
    kNurseryPack,
    kAmericanClassicsPack
} PackType;