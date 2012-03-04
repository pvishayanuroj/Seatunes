//
//  SpeechBubble.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpeechBubbleDelegate.h"

typedef struct {
    NSUInteger numChars;
    NSUInteger numRows;
    CGFloat rowHeight;
    CGPoint textOffset;
} SpeechBubbleDim;

typedef enum {  
    kBubbleClick,
    kBubbleTimed,
    kBubbleTimedClick
} BubbleType;

@interface SpeechBubble : CCNode <CCTargetedTouchDelegate> {
    
    CCSprite *sprite_;
    
    SpeechBubbleDim dim_;
    
    CGFloat time_;
    
    BOOL fullScreenTap_;
    
    BOOL isClickable_;
    
    BubbleType bubbleType_;
    
    NSMutableArray *textContainer_;
    
    id <SpeechBubbleDelegate> delegate_;
    
}

@property (nonatomic, assign) id <SpeechBubbleDelegate> delegate;

+ (id) tapSpeechBubble:(SpeechBubbleDim)dim fullScreenTap:(BOOL)fullScreenTap;

+ (id) timedSpeechBubble:(SpeechBubbleDim)dim time:(CGFloat)time;

+ (id) timedClickSpeechBubble:(SpeechBubbleDim)dim fullScreenTap:(BOOL)fullScreenTap time:(CGFloat)time;

- (id) initSpeechBubble:(SpeechBubbleDim)dim bubbleType:(BubbleType)bubbleType fullScreenTap:(BOOL)fullScreenTap time:(CGFloat)time;

- (NSString *) parseText:(NSString *)text;

- (NSString *) flatten:(NSArray *)components;

- (NSArray *) separateWords:(NSString *)text;

- (NSString *) setTextWithBMFont:(NSString*)string fntFile:(NSString*)fntFile;

- (NSString *) setTextWithTTF:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size;

- (void) destroyBubble;

@end
