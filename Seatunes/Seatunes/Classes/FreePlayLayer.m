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
#import "BubbleGroup.h"
#import "CCNode+PauseResume.h"
#import "DataUtility.h"
#import "Sunbeams.h"

@implementation FreePlayLayer

static const CGFloat FPL_INSTRUCTOR_X = 200.0f;
static const CGFloat FPL_INSTRUCTOR_Y = 550.0f;
static const CGFloat FPL_KEYBOARD_X = 100.0f;
static const CGFloat FPL_KEYBOARD_Y = 75.0f;
static const CGFloat FPL_SIDEMENU_BUTTON_X = 970.0f;
static const CGFloat FPL_SIDEMENU_BUTTON_Y = 720.0f;
static const CGFloat FPL_SIDEMENU_BUTTON_LABEL_X = 970.0f;
static const CGFloat FPL_SIDEMENU_BUTTON_LABEL_Y = 670.0f;
static const CGFloat FPL_SIDEMENU_ROTATION = 180.0f;
static const CGFloat FPL_SIDEMENU_ITEM_PADDING = 150.0f;
static const CGFloat FPL_SIDEMENU_X = 1150.0f;
static const CGFloat FPL_SIDEMENU_Y = 450.0f;
static const CGFloat FPL_SIDEMENU_SPRITE_Y = -70.0f;
static const CGFloat FPL_SIDEMENU_MOVE_TIME = 0.5f;
static const CGFloat FPL_SIDEMENU_MOVE_AMOUNT = 200.0f;
static const CGFloat FPL_BUBBLE_X = 550.0f;
static const CGFloat FPL_BUBBLE_Y = 150.0f;

static const NSInteger FPL_BACKGROUND_Z = 1;
static const NSInteger FPL_SUNBEAMS_Z = 2;
static const NSInteger FPL_BUBBLES_Z = 3;
static const NSInteger FPL_INSTRUCTOR_Z = 4;
static const NSInteger FPL_NOTE_Z = 5;
static const NSInteger FPL_FOREGROUND_Z = 6;
static const NSInteger FPL_KEYBOARD_Z = 7;
static const NSInteger FPL_SIDEMENU_BUTTON_Z = 8;
static const NSInteger FPL_SIDEMENU_Z = 9;
static const NSInteger FPL_MENU_LABEL_Z = 10;

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        sideMenuOpen_ = NO;
        sideMenuLocked_ = NO;
        sideMenuMoving_ = NO;
        isPaused_ = NO;        
        
        [[AudioManager audioManager] pauseBackgroundMusic];
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:FPL_BACKGROUND_Z];            
        
        sunbeams_ = [[Sunbeams sunbeamsRandom:NUM_SUNBEAMS] retain];
        [self addChild:sunbeams_ z:FPL_SUNBEAMS_Z];        
        
        bubbles_ = [[BubbleGroup bubbleGroupWithBubbles:0.02f] retain];
        bubbles_.position = ccp(FPL_BUBBLE_X, FPL_BUBBLE_Y);
        [self addChild:bubbles_ z:FPL_BUBBLES_Z];            
        
        instructor_ = [[Instructor instructor:kWhaleInstructor] retain];
        instructor_.position = ccp(FPL_INSTRUCTOR_X, FPL_INSTRUCTOR_Y);
        [self addChild:instructor_ z:FPL_INSTRUCTOR_Z];           
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];       
        [self addChild:noteGenerator_ z:FPL_NOTE_Z];  
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground z:FPL_FOREGROUND_Z];        
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.isKeyboardMuted = NO;
        keyboard_.position = ccp(FPL_KEYBOARD_X, FPL_KEYBOARD_Y);
        [self addChild:keyboard_ z:FPL_KEYBOARD_Z];         
        
        sideMenuButton_ = [[ImageButton imageButton:kButtonSideMenu unselectedImage:@"Starfish Button.png" selectedImage:@"Starfish Button.png"] retain];
        sideMenuButton_.delegate = self;
        sideMenuButton_.position = ccp(FPL_SIDEMENU_BUTTON_X, FPL_SIDEMENU_BUTTON_Y);
        
        sideMenu_ = [[Menu menu:FPL_SIDEMENU_ITEM_PADDING isVertical:YES offset:0.0f] retain];
        sideMenu_.delegate = self; 
        sideMenu_.position = ccp(FPL_SIDEMENU_X, FPL_SIDEMENU_Y);
        
        [sideMenu_ addMenuBackground:@"Side Parchment.png" pos:ccp(0, FPL_SIDEMENU_SPRITE_Y)];
           
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonReplay image:@"Restart Button Disabled.png" scale:0.9f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonMenu image:@"Home Button.png" scale:0.9f];        
        
        [sideMenu_ addMenuItem:replayButton];        
        [sideMenu_ addMenuItem:menuButton];  
        
        [self addChild:sideMenuButton_ z:FPL_SIDEMENU_BUTTON_Z];        
        [self addChild:sideMenu_ z:FPL_SIDEMENU_Z];           
        
        CCLabelBMFont *menuLabel = [CCLabelBMFont labelWithString:@"Menu" fntFile:@"MenuFont.fnt"];
        menuLabel.position = ccp(FPL_SIDEMENU_BUTTON_LABEL_X, FPL_SIDEMENU_BUTTON_LABEL_Y);
        [self addChild:menuLabel z:FPL_MENU_LABEL_Z];       
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
    [bubbles_ release];
    [sunbeams_ release];
    
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
        case kButtonReplay:
            [[AudioManager audioManager] playSound:kE4 instrument:kMuted];               
            break;
        case kButtonMenu:
            [[AudioManager audioManager] playSound:kE4 instrument:kMenu];               
            scene = [MainMenuScene node];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];        
            [[AudioManager audioManager] playSoundEffect:kPageFlip];
            
            if ([DataUtility manager].backgroundMusicOn) {
                [[AudioManager audioManager] resumeBackgroundMusic];            
            }
            
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
    [bubbles_ pauseHierarchy];
}

- (void) resumeGame
{
    [bubbles_ resumeHierarchy];
    isPaused_ = NO;
}

@end
