//
//  Text.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/31/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Text.h"

@implementation Text

@synthesize string = text_;

static const CGFloat TXT_DEFAULT_WIDTH = 415.0f;
static const CGFloat TXT_DEFAULT_HEIGHT = 30.0f;
static const CGFloat TXT_DEFAULT_SPACE_WIDTH = 10.0f;

+ (id) text:(NSString *)text fntFile:(NSString *)fntFile
{
    return [[[self alloc] initText:text fntFile:fntFile width:TXT_DEFAULT_WIDTH height:TXT_DEFAULT_HEIGHT spaceWidth:TXT_DEFAULT_SPACE_WIDTH] autorelease];
}

+ (id) text:(NSString *)text fntFile:(NSString *)fntFile width:(CGFloat)width
{
    return [[[self alloc] initText:text fntFile:fntFile width:width height:TXT_DEFAULT_HEIGHT spaceWidth:TXT_DEFAULT_SPACE_WIDTH] autorelease];    
}

+ (id) text:(NSString *)text fntFile:(NSString *)fntFile width:(CGFloat)width height:(CGFloat)height spaceWidth:(CGFloat)spaceWidth
{
    return [[[self alloc] initText:text fntFile:fntFile width:width height:height spaceWidth:spaceWidth] autorelease];
}

- (id) initText:(NSString *)text fntFile:(NSString *)fntFile width:(CGFloat)width height:(CGFloat)height spaceWidth:(CGFloat)spaceWidth
{
    if ((self = [super init])) {
        
        components_ = [[NSMutableArray arrayWithCapacity:10] retain];
        text_ = [text retain];
        fntFiles_ = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
        width_ = width;
        height_ = height;
        spaceWidth_ = spaceWidth;
        
        [fntFiles_ setObject:fntFile forKey:[NSNumber numberWithInteger:kTextNormal]];
     
        [self updateText];
    }
    
    return self;
}

- (void) dealloc
{
    [components_ release];
    [text_ release];
    [fntFiles_ release];
    
    [super dealloc];
}

- (void) addFntFile:(NSString *)fntFile textType:(TextType)textType
{
    [fntFiles_ setObject:fntFile forKey:[NSNumber numberWithInteger:textType]];    
    [self updateText];
}

- (void) setString:(NSString *)string
{
    [text_ release];
    text_ = [string retain];
    
    [self updateText];
}

- (void) setHeight:(CGFloat)height
{
    height_ = height;    
    [self updateText];
}

- (void) setWidth:(CGFloat)width
{
    width_ = width;
    [self updateText];
}

- (void) setSpaceWidth:(CGFloat)width
{
    spaceWidth_ = width;
    [self updateText];
}

- (void) updateText
{
    // Cleanup any existing text
    for (CCLabelBMFont *label in components_) {
        [label removeFromParentAndCleanup:YES];
    }
    [components_ removeAllObjects];    
    
    // Breakup all spaces
    NSMutableArray *words = [NSMutableArray arrayWithArray:[text_ componentsSeparatedByString:@" "]];
 
    formatState_ = kTextNormal;
    for (NSString *word in words) {
        
        TextType format = [self checkForFormatter:word];
        NSString *text = [self removeFormatters:word];
        
        // Create the BM Font
        NSString *fontFile = [self getFontFile:format];
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:text fntFile:fontFile];
        label.anchorPoint = ccp(0, 0.5f);        
        [components_ addObject:label];
    }
    
    CGPoint pos = CGPointZero;
    for (CCLabelBMFont *label in components_) {
    
        // If not enough space
        if (pos.x + label.contentSize.width > width_) {
            pos.x = 0;
            pos.y -= height_;            
        }
        
        [self addChild:label];
        label.position = pos;
        
        // Add the label + space
        pos.x += (label.contentSize.width + 10.0f);
    }
    
}

- (NSString *) getFontFile:(TextType)textType
{
    NSString *fontFile = [fntFiles_ objectForKey:[NSNumber numberWithInteger:textType]];
    
    if (fontFile == nil) {
        fontFile = [fntFiles_ objectForKey:[NSNumber numberWithInteger:kTextNormal]];
    }
    
    return fontFile;
}
                                
- (TextType) checkForFormatter:(NSString *)string
{
    // Use the current text type state
    TextType textType = formatState_;
    
    NSRange start = [string rangeOfString:kBoldSTag];
    NSRange end = [string rangeOfString:kBoldETag];    
    NSRange range = NSMakeRange(0, [string length]);
    
    if (start.length > 0) {
        textType = kTextBold;
        formatState_ = kTextBold;
    }
    
    if (end.length > 0) {
        textType = kTextBold;
        formatState_ = kTextNormal;
    }
    
    string = [string substringWithRange:range];
    
    return textType;
}

- (NSString *) removeFormatters:(NSString *)string
{
    NSString *output;
    output = [string stringByReplacingOccurrencesOfString:kBoldSTag withString:@""];
    output = [output stringByReplacingOccurrencesOfString:kBoldETag withString:@""];
    
    return output;
}

#if DEBUG_SHOWTEXTBOUNDARY
- (void) draw
{
    glColor4f(1.0, 0, 0, 1.0);      
    glLineWidth(3.0f);     
    
    for (CCLabelBMFont *label in components_) {
        CGPoint origin = ccp(label.position.x, label.position.y - label.contentSize.height * 0.5f);        
        CGPoint dest = ccp(label.position.x + label.contentSize.width, label.position.y + label.contentSize.height * 0.5f);
        ccDrawRect(origin, dest);
    }   
}
#endif

@end
