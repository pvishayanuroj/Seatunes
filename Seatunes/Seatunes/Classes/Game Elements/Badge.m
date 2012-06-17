//
//  Badge.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 4/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Badge.h"


@implementation Badge

+ (id) badge:(DifficultyType)difficultyType
{
    return [[[self alloc] initBadge:difficultyType] autorelease];
}

- (id) initBadge:(DifficultyType)difficultyType
{
    if ((self = [super init])) {
     
        //particles_ = [[self createPS] retain];
        //[self addChild:particles_];        
        
        NSString *spriteName;
        switch (difficultyType) {
            case kDifficultyEasy:
                spriteName = @"Bubble Button.png";
                break;
            case kDifficultyMedium:
                spriteName = @"Clam Button.png";
                break;
            case kDifficultyHard:
                spriteName = @"Note Button.png";
                break;
            default:
                break;
        }
        sprite_ = [[CCSprite spriteWithFile:spriteName] retain];
        [self addChild:sprite_];
        

    }
    
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [particles_ release];
    
    [super dealloc];
}

- (CCParticleSystem *) createPS
{
    CCParticleSystem *particle=[[[CCParticleSystemQuad alloc] initWithTotalParticles:250] autorelease];
    ///////**** Assignment Texture Filename!  ****///////
    CCTexture2D *texture=[[CCTextureCache sharedTextureCache] addImage:@"Star.png"];
    particle.texture=texture;
    particle.emissionRate=83.33;
    particle.angle=268.6;
    particle.angleVar=10.0;
    ccBlendFunc blendFunc={GL_ONE,GL_ONE_MINUS_SRC_ALPHA};
    particle.blendFunc=blendFunc;
    particle.duration=-1.00;
    particle.emitterMode=kCCParticleModeGravity;
    ccColor4F startColor={0.23,0.28,0.76,1.00};
    particle.startColor=startColor;
    ccColor4F startColorVar={1.00,1.00,1.00,1.00};
    particle.startColorVar=startColorVar;
    ccColor4F endColor={0.00,0.00,0.00,1.00};
    particle.endColor=endColor;
    ccColor4F endColorVar={1.00,1.00,1.00,1.00};
    particle.endColorVar=endColorVar;
    particle.startSize=41.00;
    particle.startSizeVar=10.00;
    particle.endSize=-1.00;
    particle.endSizeVar=0.00;
    particle.gravity=ccp(0.00,0.00);
    particle.radialAccel=0.00;
    particle.radialAccelVar=0.00;
    particle.speed=100;
    particle.speedVar=20;
    particle.tangentialAccel= 0;
    particle.tangentialAccelVar= 0;
    particle.totalParticles=250;
    particle.life=3.00;
    particle.lifeVar=0.25;
    particle.startSpin=0.00;
    particle.startSpinVar=0.00;
    particle.endSpin=0.00;
    particle.endSpinVar=0.00;
    particle.position=ccp(0,0);
    particle.posVar=ccp(53.23,20.00);
    
    return particle;
}

@end
