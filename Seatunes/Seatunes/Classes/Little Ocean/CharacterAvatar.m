//
//  CharacterAvatar.m
//  Little Ocean
//
//  Created by Jamorn Horathai on 3/22/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import "CharacterAvatar.h"

@interface CharacterAvatar (Private)
- (void) update:(ccTime)dt;
@end

@implementation CharacterAvatar

+ (id) characterAvatarWithTarget:(id<CharacterAvatarDelegate>)target
{
    CharacterAvatar *avatar = [[[CharacterAvatar alloc] initWithTarget:target] autorelease];
    return avatar;
}

- (id) initWithTarget:(id<CharacterAvatarDelegate>)target
{
    if ((self  = [super initWithFile:@"sam-bg.png" touchPriority:0 swallowsTouches:YES])) {
        
        delegate_ = target;
        
        tank_ = [CCSprite spriteWithFile:@"sam-tank.png"];
        [self addChild:tank_];
        
        feet_ = [CCSprite spriteWithFile:@"sam-legs.png"];
        [self addChild:feet_];
        
        armLeft_ = [CCSprite spriteWithFile:@"sam-hand-left.png"];
        [self addChild:armLeft_];
        
        armRight_ = [CCSprite spriteWithFile:@"sam-hand-right.png"];
        [self addChild:armRight_];
        
        body_ = [CCSprite spriteWithFile:@"sam-body.png"];
        body_.position = ccp(self.contentSize.width/2, self.contentSize.height/2 - (50.0f/475.0f) * self.contentSize.height);
        [self addChild:body_];
        
        tank_.position = ccp(body_.position.x + (85.0f/280.0f) * self.contentSize.width, body_.position.y + (50.0f/475.0f) * self.contentSize.height);
        feet_.position = ccp(body_.position.x, body_.position.y - (150.0f/475.0f) * self.contentSize.height);
        
        armLeft_.anchorPoint = ccp(0, 0.5f);
        armRight_.anchorPoint = ccp(1.0f, 0.5f);
        
        armLeft_.position = ccp(body_.position.x + (100.0f/280.0f) * self.contentSize.width, body_.position.y + (80.0f/475.0f) * self.contentSize.height);
        armRight_.position = ccp(body_.position.x - (100.0f/280.0f) * self.contentSize.width, body_.position.y + (80.0f/475.0f) * self.contentSize.height);
        
        head_ = [CCSprite spriteWithFile:@"sam-head.png"];
        head_.position = ccp(body_.position.x, body_.position.y + (190.0f/475.0f) * self.contentSize.height);
        [self addChild:head_];
        
        pipe_ = [CCSprite spriteWithFile:@"sam-pipe.png"];
        pipe_.position = ccp(head_.position.x + (63.0f/280.0f) * self.contentSize.width, head_.position.y - (90.0f/475.0f) * self.contentSize.height);
        [self addChild:pipe_];
        
        regulator_ = [CCSprite spriteWithFile:@"sam-mouth-piece.png"];
        regulator_.position = ccp(head_.position.x, head_.position.y - (85.0f/475.0f) * self.contentSize.height);
        [self addChild:regulator_];
        
        // Sprites Loader Codes
        // Load the spritesheet and add it to the game scene
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sam-eyes" ofType:@"png"];
        CCSpriteBatchNode *batchNode2 = [CCSpriteBatchNode batchNodeWithFile:path];
        [self addChild:batchNode2];
        
        // Load the frames from the spritesheet into the shared cache
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        path = [[NSBundle mainBundle] pathForResource:@"sam-eyes" ofType:@"plist"];
        [cache addSpriteFramesWithFile:path];
        
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:2];
        
        // Store each frame in the array
        for (int i = 0; i < 2; i++) {
            
            // Formulate the frame name based off the unit's name and the animation's name and add each frame
            // to the animation array
            NSString *frameName = [NSString stringWithFormat:@"sam-eyes-%02d.png", i+1];
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
            [frames addObject:frame];
        }
        
        // Create the animation object from the frames we just processed
        CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:0.3f];
        
        // Store the animation
        [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:@"sam-eyes-blink"];
        
        eyes_ = [CCSprite spriteWithSpriteFrameName:@"sam-eyes-02.png"];
        eyes_.position = ccp(head_.position.x, head_.position.y + (40.0f/475.0f) * self.contentSize.height);
        [self addChild:eyes_];
        
        faceMask_ = [CCSprite spriteWithFile:@"sam-goggles.png"];
        faceMask_.position = ccp(head_.position.x + (10.0f/280.0f * self.contentSize.width), head_.position.y + (35.0f/475.0f) * self.contentSize.height);
        [self addChild:faceMask_];
        
        eyeBlinkAction_ = [[CCAnimate actionWithAnimation:animation] retain];
        
        [self schedule:@selector(update:) interval:1.0f/3.0f];
    }
    return self;
}

- (void) dealloc
{
    NSLog(@"dealloc");
    
    [eyeBlinkAction_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{
    int rand = arc4random() % 100;
    
    if (rand <= 20) {
        [eyes_ stopAction:eyeBlinkAction_];
        [eyes_ runAction:[[eyeBlinkAction_ copy] autorelease]];
    }
}

- (void) startTalking
{
    [self stopTalking];
    
    CCScaleTo *scaleSqueeze = [CCScaleTo actionWithDuration:0.3f scaleX:1.2f scaleY:0.8f];
    CCScaleTo *scaleStretch = [CCScaleTo actionWithDuration:0.3f scaleX:0.8f scaleY:1.2f];
    CCSequence *wobble = [CCSequence actions:scaleSqueeze, scaleStretch, nil];
    talkWobbleAction_ = [CCRepeatForever actionWithAction:wobble];
    
    [regulator_ runAction:talkWobbleAction_];
}

- (void) stopTalking
{
    [regulator_ stopAction:talkWobbleAction_];
    regulator_.scale = 1.0f;
    talkWobbleAction_ = nil;
}

- (void) startIdleAnimation
{
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:2.0f position:ccp(0, (10.0f/475.0f) * self.contentSize.height)];
    CCMoveBy *moveDown = [CCMoveBy actionWithDuration:2.0f position:ccp(0, (-10.0f/475.0f) * self.contentSize.height)];
    CCDelayTime *wait50 = [CCDelayTime actionWithDuration:0.5f];
    CCDelayTime *wait25 = [CCDelayTime actionWithDuration:0.25f];
    
    CCSequence *moveUpDown = [CCSequence actions:moveUp, moveDown, nil];
    CCRepeatForever *repeatMoveForever = [CCRepeatForever actionWithAction:moveUpDown];
    
    CCCallBlockN *addRepeatAction = [CCCallBlockN actionWithBlock:^(CCNode *sender) {
        [sender runAction:[[repeatMoveForever copy] autorelease]];
    }];
    
    CCSequence *actionForHeadObjects = [CCSequence actions:wait50, addRepeatAction, nil];
    CCSequence *actionForArms = [CCSequence actions:wait25, addRepeatAction, nil];
    
    [body_ runAction:[[repeatMoveForever copy] autorelease]];
    [tank_ runAction:[[repeatMoveForever copy] autorelease]];
    
    [armLeft_ runAction:[[actionForArms copy] autorelease]];
    [armRight_ runAction:[[actionForArms copy] autorelease]];
    [feet_ runAction:[[actionForArms copy] autorelease]];
    
    [head_ runAction:[[actionForHeadObjects copy] autorelease]];
    [eyes_ runAction:[[actionForHeadObjects copy] autorelease]];
    [faceMask_ runAction:[[actionForHeadObjects copy] autorelease]];
    [pipe_ runAction:[[actionForHeadObjects copy] autorelease]];
    [regulator_ runAction:[[actionForHeadObjects copy] autorelease]];
}

- (void) startArmWavingAnimation
{
    CCRotateBy *rotateClockwise = [CCRotateBy actionWithDuration:1.0f angle:-20.0f];
    CCRotateBy *rotateCounterClockwise = [CCRotateBy actionWithDuration:1.0f angle:20.0f];
    
    CCSequence *rotateClockCounterClock = [CCSequence actions:[[rotateClockwise copy] autorelease], [[rotateCounterClockwise copy] autorelease], nil];
    CCSequence *rotateCounterClockClock = [CCSequence actions:[[rotateCounterClockwise copy] autorelease], [[rotateClockwise copy] autorelease], nil];
    
    CCRepeatForever *repeatClockCounterClock = [CCRepeatForever actionWithAction:rotateClockCounterClock];
    CCRepeatForever *repeatCounterClockClock = [CCRepeatForever actionWithAction:rotateCounterClockClock];
    
    [armLeft_ runAction:repeatClockCounterClock];
    [armRight_ runAction:repeatCounterClockClock];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isEnabled_ && [self containsTouchLocation:touch]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isEnabled_ && [self containsTouchLocation:touch]) {
        if ([delegate_ respondsToSelector:@selector(characterAvatarPressed)]) {
            [delegate_ characterAvatarPressed];
        }
    }
}

@end
