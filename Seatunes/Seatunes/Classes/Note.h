//
//  Note.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/16/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NoteDelegate.h"

@interface Note : CCNode {
    
    CCSprite *sprite_;
    
    BubbleCurveType curveType_;
    
    BOOL boundaryCrossFlag_;
    
    id <NoteDelegate> delegate_; 
}

@property (nonatomic, assign) id <NoteDelegate> delegate;

+ (id) note:(KeyType)keyType curveType:(BubbleCurveType)curveType;

- (id) initNote:(KeyType)keyType curveType:(BubbleCurveType)curveType;

- (void) destroy;

- (void) blowAction;

- (void) wobbleAction;

- (void) curveAction;

- (void) scaleAction;

@end
