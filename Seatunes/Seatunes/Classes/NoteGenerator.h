//
//  NoteGenerator.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/5/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NoteGeneratorDelegate.h"
#import "NoteDelegate.h"

enum {
    kPosInstructor,
    kPosRock1,
    kPosRock2,
    kPosRock3
};

@interface NoteGenerator : CCNode <NoteDelegate> {
    
    NSMutableArray *notes_;    
    
    NSUInteger curveCounter_;    
    
    id <NoteGeneratorDelegate> delegate_;
    
}

@property (nonatomic, assign) id <NoteGeneratorDelegate> delegate;

+ (id) noteGenerator;

- (id) initNoteGenerator;

- (void) popOldestNote;

- (void) popNewestNote;

- (void) addInstructorNote:(KeyType)keyType numID:(NSUInteger)numID;

- (void) addFloorNote:(KeyType)keyType numID:(NSUInteger)numID;

- (void) addNote:(KeyType)keyType poppable:(BOOL)poppable curveType:(BubbleCurveType)curveType pos:(CGPoint)pos numID:(NSUInteger)numID;

@end
