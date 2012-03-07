//
//  StaffNote.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "StaffNoteDelegate.h"

@interface StaffNote : CCNode {
    
    CCSprite *sprite_;
    
    CCSprite *line_;
    
    id <StaffNoteDelegate> delegate_;
    
}

+ (id) staffNote:(KeyType)keyType pos:(CGPoint)pos;

- (id) initStaffNote:(KeyType)keyType pos:(CGPoint)pos;

- (void) move;

- (void) appear;

- (void) disappear;

@end
