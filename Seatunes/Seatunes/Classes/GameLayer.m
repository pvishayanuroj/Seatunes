//
//  GameLayer.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLayer.h"
#import "Keyboard.h"
#import "AudioManager.h"
#import "Note.h"
#import "Instructor.h"
#import "Processor.h"
#import "GameLogicB.h"
#import "Menu.h"
#import "Button.h"

@implementation GameLayer

const static CGFloat GL_INSTRUCTOR_X = 200.0f;
const static CGFloat GL_INSTRUCTOR_Y = 550.0f;
const static CGFloat GL_KEYBOARD_X = 100.0f;
const static CGFloat GL_KEYBOARD_Y = 100.0f;

const static CGFloat GL_SIDEMENU_BUTTON_X = 970.0f;
const static CGFloat GL_SIDEMENU_BUTTON_Y = 720.0f;
const static CGFloat GL_SIDEMENU_ROTATION = 180.0f;
const static CGFloat GL_SIDEMENU_X = 1130.0f;
const static CGFloat GL_SIDEMENU_Y = 550.0f;
const static CGFloat GL_SIDEMENU_MOVE_TIME = 0.5f;
const static CGFloat GL_SIDEMENU_MOVE_AMOUNT = 200.0f;

+ (id) start
{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        sideMenuOpen_ = NO;
        sideMenuLocked_ = NO;
        sideMenuMoving_ = NO;
        [AudioManager audioManager];
        
        sideMenuButton_ = [[ImageButton imageButton:kButtonSideMenu unselectedImage:@"Starfish Button.png" selectedImage:@"Starfish Button.png"] retain];
        sideMenuButton_.delegate = self;
        sideMenuButton_.position = ccp(GL_SIDEMENU_BUTTON_X, GL_SIDEMENU_BUTTON_Y);
        [self addChild:sideMenuButton_];
        
        sideMenu_ = [[Menu menu:150.0f isVertical:YES offset:15.0f] retain];
        sideMenu_.delegate = self; 
        sideMenu_.position = ccp(GL_SIDEMENU_X, GL_SIDEMENU_Y);
        
        [sideMenu_ addMenuBackground:@"Side Menu.png" pos:ccp(0, -140.0f)];
        
        Button *nextButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Next Button.png" scale:0.9f];
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Replay Button.png" scale:0.9f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Menu Button.png" scale:0.9f];        
        
        [sideMenu_ addMenuItem:nextButton];
        [sideMenu_ addMenuItem:replayButton];
        [sideMenu_ addMenuItem:menuButton];        
        
        [self addChild:sideMenu_];
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GL_INSTRUCTOR_X, GL_INSTRUCTOR_Y);
        [self addChild:instructor_ z:-1];
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.position = ccp(GL_KEYBOARD_X, GL_KEYBOARD_Y);
        [self addChild:keyboard_];
        
        GameLogicB *gameLogicB = [GameLogicB gameLogicB:@"Twinkle Twinkle"];
        [gameLogicB setInstructor:instructor_];
        [gameLogicB setKeyboard:keyboard_];
        [self addChild:gameLogicB];
        
        //[gameLogicB start];
    }
    return self;
}

- (void) dealloc
{
    [instructor_ release];
    [keyboard_ release];
    [processor_ release];
    [sideMenu_ release];
    [sideMenuButton_ release];
    
    [super dealloc];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesBegan:touches];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesMoved:touches];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesEnded:touches];
}

- (void) sectionComplete
{
    
}

- (void) songComplete
{
    
}

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
    switch (button.numID) {
        case kButtonNext:
            break;
        case kButtonReplay:
            break;
        case kButtonMenu:
            break;
        default:
            break;
    }
}

- (void) showSideMenu
{
    if (!sideMenuMoving_) {
        sideMenuMoving_ = YES;
        CCActionInterval *move = [CCMoveBy actionWithDuration:GL_SIDEMENU_MOVE_TIME position:ccp(-GL_SIDEMENU_MOVE_AMOUNT, 0)];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneShowSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:GL_SIDEMENU_MOVE_TIME angle:-GL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];
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
        CCActionInterval *move = [CCMoveBy actionWithDuration:GL_SIDEMENU_MOVE_TIME position:ccp(GL_SIDEMENU_MOVE_AMOUNT, 0)];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneHideSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];    
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:GL_SIDEMENU_MOVE_TIME angle: GL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];        
    }
}

- (void) doneHideSideMenu
{
    sideMenuMoving_ = NO;
    sideMenuOpen_ = NO;    
}

@end
