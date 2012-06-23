//
//  CreditsScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CreditsScene.h"
#import "Button.h"
#import "AudioManager.h"
#import "MainMenuScene.h"
#import "Apsalar.h"

@implementation CreditsScene

static const CGFloat CS_BACK_BUTTON_X = 50.0f;
static const CGFloat CS_BACK_BUTTON_Y = 730.0f;
static const CGFloat CS_MENU_FRAME_X = 515.0f;
static const CGFloat CS_MENU_FRAME_Y = 380.0f;
static const CGFloat CS_LOGO_X = 800.0f;
static const CGFloat CS_LOGO_Y = 550.0f;

static const CGFloat CS_FADEIN_INTERVAL = 1.0f;
static const CGFloat CS_FADEIN_DURATION = 0.35f;

static const CGFloat CS_ROLE_X = 125.0f;
static const CGFloat CS_VALUE_X = 400.0f;
static const CGFloat CS_MAX_Y = 600.0f;
static const CGFloat CS_PADDING_Y = 90.0f;

- (id) init
{
    if ((self = [super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];            
        
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Main Parchment.png"];
        menuFrame.position = ADJUST_IPAD_CCP(ccp(CS_MENU_FRAME_X, CS_MENU_FRAME_Y));
        [self addChild:menuFrame];        
        
        // Add back button
        Button *backButton = [ScaledImageButton scaledImageButton:kCSBack image:@"Back Button.png"];
        backButton.delegate = self;
        backButton.position = ADJUST_IPAD_CCP(ccp(CS_BACK_BUTTON_X, CS_BACK_BUTTON_Y));
        [self addChild:backButton];           
        
        [[AudioManager audioManager] playSoundEffect:kPageFlip];        
     
        credits_ = [[self generateCredits] retain];
        currentLine_ = 0;
        
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary *entry in credits_) {
            
            NSString *role = [entry objectForKey:@"role"];
            NSString *value = [entry objectForKey:@"value"];
            
            CCActionInterval *delay = [CCDelayTime actionWithDuration:CS_FADEIN_INTERVAL];            
            CCActionInstant *place = [CCCallBlock actionWithBlock:^{
                [self placeLine:role value:value];
            }];
            
            [actions addObject:delay];
            [actions addObject:place];
        }
        
        CCActionInterval *delay = [CCDelayTime actionWithDuration:CS_FADEIN_INTERVAL];            
        CCActionInstant *place = [CCCallBlock actionWithBlock:^{
            [self placeLogo];
        }];
        
        [actions addObject:delay];
        [actions addObject:place];        
        
        [self runAction:[CCSequence actionsWithArray:actions]];
        
#if ANALYTICS_ON
        [Apsalar event:@"Credits"];
#endif         
    }
    return self;
}

- (void) dealloc
{    
    [credits_ release];
    
    [super dealloc];
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kCSBack:
            [self loadMainMenu];            
            break;
        default:
            break;
    }
}

- (void) placeLine:(NSString *)role value:(NSString *)value
{
    [[AudioManager audioManager] playSoundEffect:kBubblePop];    
    
    // Create labels
    CCLabelBMFont *roleLabel = [CCLabelBMFont labelWithString:role fntFile:@"MenuFont.fnt"];
    CCLabelBMFont *valueLabel = [CCLabelBMFont labelWithString:value fntFile:@"Dialogue Font.fnt"];
    
    roleLabel.anchorPoint = ccp(0, 0.5f);
    valueLabel.anchorPoint = ccp(0, 0.5f);
    
    CGFloat yPos = CS_MAX_Y - CS_PADDING_Y * currentLine_;
    roleLabel.position = ADJUST_IPAD_CCP(ccp(CS_ROLE_X, yPos));
    valueLabel.position = ADJUST_IPAD_CCP(ccp(CS_VALUE_X, yPos));
    currentLine_++;
    
    roleLabel.opacity = 0;
    valueLabel.opacity = 0;
    
    [self addChild:roleLabel];
    [self addChild:valueLabel];
    
    // Fading animation
    CCActionInterval *fadeRole = [CCFadeIn actionWithDuration:CS_FADEIN_DURATION];
    CCActionInterval *fadeValue = [CCFadeIn actionWithDuration:CS_FADEIN_DURATION];    
    
    [roleLabel runAction:fadeRole];
    [valueLabel runAction:fadeValue];
}

- (void) placeLogo
{
    [[AudioManager audioManager] playSoundEffect:kSuccess];   
    
    CCSprite *logo = [CCSprite spriteWithFile:@"Ink Blot Logo.png"];
    logo.scale = 0.8f;
    logo.position = ADJUST_IPAD_CCP(ccp(CS_LOGO_X, CS_LOGO_Y));
    logo.opacity = 0;
    
    [self addChild:logo];
    
    CCActionInterval *fade = [CCFadeIn actionWithDuration:CS_FADEIN_DURATION];  
    [logo runAction:fade];    
}

- (NSDictionary *) createEntry:(NSString *)value role:(NSString *)role
{
    NSMutableDictionary *entry = [NSMutableDictionary dictionaryWithCapacity:1];
    [entry setObject:value forKey:@"value"];
    [entry setObject:role forKey:@"role"];
    
    return entry;
}
             
- (NSArray *) generateCredits
{
    NSMutableArray *credits = [NSMutableArray arrayWithCapacity:5];
    
    [credits addObject:[self createEntry:@"Paul Vishayanuroj" role:@"Programming"]];
    [credits addObject:[self createEntry:@"Danpob Pairoj-Boriboon" role:@"Art by"]];
    [credits addObject:[self createEntry:@"Jibrahn Khoury" role:@"Narrated by"]];
    [credits addObject:[self createEntry:@"Jamorn Horathai, Jantorn Jiambutr,\nPatrick Vishayanuroj" role:@"Special Thanks to"]];
    
    return credits;
}

- (void) loadMainMenu
{
    [[AudioManager audioManager] stopNarration];
    [[AudioManager audioManager] playSound:kA4 instrument:kMenu];       
    CCScene *scene = [MainMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:YES]];    
    [[AudioManager audioManager] playSoundEffect:kPageFlip];  
}

@end
