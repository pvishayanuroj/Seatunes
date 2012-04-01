//
//  Text.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/31/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define kBoldSTag @"<b>"
#define kBoldETag @"</b>"

typedef enum {
    kTextNormal,
    kTextBold
} TextType;

@interface Text : CCNode {
    
    NSString *text_;
    
    NSMutableDictionary *fntFiles_;
    
    NSMutableArray *components_;
    
    CGFloat width_;
    
    CGFloat height_;
    
    CGFloat spaceWidth_;
    
    TextType formatState_;
    
}

+ (id) text:(NSString *)text fntFile:(NSString *)fntFile;

+ (id) text:(NSString *)text fntFile:(NSString *)fntFile width:(CGFloat)width;

+ (id) text:(NSString *)text fntFile:(NSString *)fntFile width:(CGFloat)width height:(CGFloat)height spaceWidth:(CGFloat)spaceWidth;

- (id) initText:(NSString *)text fntFile:(NSString *)fntFile width:(CGFloat)width height:(CGFloat)height spaceWidth:(CGFloat)spaceWidth;

- (void) addFntFile:(NSString *)fntFile textType:(TextType)textType;

- (void) setString:(NSString *)string;

- (void) setWidth:(CGFloat)width;

- (void) updateText;

- (NSString *) getFontFile:(TextType)textType;

- (TextType) checkForFormatter:(NSString *)string;

- (NSString *) removeFormatters:(NSString *)string;

@end
