//
//  FreePlayLayer.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "FreePlayLayer.h"
#import "Instructor.h"
#import "Keyboard.h"
#import "NoteGenerator.h"
#import "MainMenuScene.h"
#import "Menu.h"
#import "Button.h"
#import "AudioManager.h"

@implementation FreePlayLayer

static const CGFloat FPL_INSTRUCTOR_X = 200.0f;
static const CGFloat FPL_INSTRUCTOR_Y = 550.0f;
static const CGFloat FPL_KEYBOARD_X = 100.0f;
static const CGFloat FPL_KEYBOARD_Y = 100.0f;
static const CGFloat FPL_SIDEMENU_BUTTON_X = 970.0f;
static const CGFloat FPL_SIDEMENU_BUTTON_Y = 720.0f;
static const CGFloat FPL_SIDEMENU_ROTATION = 180.0f;
static const CGFloat FPL_SIDEMENU_X = 1130.0f;
static const CGFloat FPL_SIDEMENU_Y = 550.0f;
static const CGFloat FPL_SIDEMENU_MOVE_TIME = 0.5f;
static const CGFloat FPL_SIDEMENU_MOVE_AMOUNT = 200.0f;

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        sideMenuOpen_ = NO;
        sideMenuLocked_ = NO;
        sideMenuMoving_ = NO;
        isPaused_ = NO;        
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];            
        
        instructor_ = [[Instructor instructor:kWhaleInstructor] retain];
        instructor_.position = ccp(FPL_INSTRUCTOR_X, FPL_INSTRUCTOR_Y);
        [self addChild:instructor_];           
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];       
        [self addChild:noteGenerator_];  
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];        
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.isKeyboardMuted = NO;
        keyboard_.position = ccp(FPL_KEYBOARD_X, FPL_KEYBOARD_Y);
        [self addChild:keyboard_];         
        
        sideMenuButton_ = [[ImageButton imageButton:kButtonSideMenu unselectedImage:@"Starfish Button.png" selectedImage:@"Starfish Button.png"] retain];
        sideMenuButton_.delegate = self;
        sideMenuButton_.position = ccp(FPL_SIDEMENU_BUTTON_X, FPL_SIDEMENU_BUTTON_Y);
        
        sideMenu_ = [[Menu menu:150.0f isVertical:YES offset:15.0f] retain];
        sideMenu_.delegate = self; 
        sideMenu_.position = ccp(FPL_SIDEMENU_X, FPL_SIDEMENU_Y);
        
        [sideMenu_ addMenuBackground:@"Side Parchment.png" pos:ccp(0, -140.0f)];
        
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonMenu image:@"Home Button.png" scale:0.9f];        
        
        [sideMenu_ addMenuItem:menuButton];         
        [self addChild:sideMenuButton_];        
        [self addChild:sideMenu_];           
    }
    return self;
}

- (void) dealloc
{
    [instructor_ release];
    [noteGenerator_ release];
    [keyboard_ release];
    [sideMenu_ release];
    [sideMenuButton_ release];
    
    [super dealloc];
}

#pragma mark - Touch Handlers

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {
        [keyboard_ touchesBegan:touches];
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {    
        [keyboard_ touchesMoved:touches];
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {
        [keyboard_ touchesEnded:touches];
    }
}

#pragma mark - Delegate Methods

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kButtonSideMenu:
            if (!sideMenuLocked_) {
                if (sideMenuOpen_) {
                    [self hideSideMenu];                    
                }
                else {
                    [self showSideMenu];
                }
            }
            break;
        default:
            break;
    }
}

- (void) menuItemSelected:(Button *)button
{
    [self menuSelection:button];
}

#pragma mark - Helper Methods

- (void) menuSelection:(Button *)button
{
    CCScene *scene;
    switch (button.numID) {
        case kButtonMenu:
            [[AudioManager audioManager] playSound:kE4 instrument:kMenu];               
            scene = [MainMenuScene node];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];        
            [[AudioManager audioManager] playSoundEffect:kPageFlip];
            break;
        default:
            break;
    }    
}

- (void) showSideMenu
{ 
    if (!sideMenuMoving_) {
        sideMenuMoving_ = YES;
        
        [self pauseGame];
        
        CCActionInterval *move = [CCMoveBy actionWithDuration:FPL_SIDEMENU_MOVE_TIME position:ccp(-FPL_SIDEMENU_MOVE_AMOUNT, 0)];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneShowSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:FPL_SIDEMENU_MOVE_TIME angle:-FPL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];
        
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:8];
        NSMutableArray *tones = [NSMutableArray arrayWithCapacity:4];
        
        [tones addObject:[NSNumber numberWithInteger:kC4]];
        [tones addObject:[NSNumber numberWithInteger:kE4]];
        [tones addObject:[NSNumber numberWithInteger:kG4]];
        [tones addObject:[NSNumber numberWithInteger:kC5]];        
        
        for (NSNumber *tone in tones) {
            CCActionInstant *sound = [CCCallBlock actionWithBlock:^{
                [[AudioManager audioManager] playSound:[tone integerValue] instrument:kMenu];
            }];
            CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1f];
            [actions addObject:sound];
            [actions addObject:delay];
        }
        
        [self runAction:[CCSequence actionsWithArray:actions]];        
    }
}

- (void) doneShowSideMenu
{
    sideMenuMoving_ = NO;
    sideMenuOpen_ = YES;
}

- (void) hideSideMenu
{
    if (!sideMenuMoving_) {        
        sideMenuMoving_ = YES;
        
        [self resumeGame];
        
        CCActionInterval *move = [CCMoveBy actionWithDuration:FPL_SIDEMENU_MOVE_TIME position:ccp(FPL_SIDEMENU_MOVE_AMOUNT, 0)];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneHideSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];    
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:FPL_SIDEMENU_MOVE_TIME angle: FPL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];     
        
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:8];
        NSMutableArray *tones = [NSMutableArray arrayWithCapacity:4];
        
        [tones addObject:[NSNumber numberWithInteger:kC5]];
        [tones addObject:[NSNumber numberWithInteger:kG4]];
        [tones addObject:[NSNumber numberWithInteger:kE4]];
        [tones addObject:[NSNumber numberWithInteger:kC4]];        
        
        for (NSNumber *tone in tones) {
            CCActionInstant *sound = [CCCallBlock actionWithBlock:^{
                [[AudioManager audioManager] playSound:[tone integerValue] instrument:kMenu];
            }];
            CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1f];
            [actions addObject:sound];
            [actions addObject:delay];
        }
        
        [self runAction:[CCSequence actionsWithArray:actions]];               
    }
}

- (void) doneHideSideMenu
{
    sideMenuMoving_ = NO;
    sideMenuOpen_ = NO;    
}

- (void) pauseGame
{
    isPaused_ = YES;
}

- (void) resumeGame
{
    isPaused_ = NO;
}

@end
