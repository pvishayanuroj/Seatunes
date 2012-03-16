//
//  EngineParticleSystem.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ParticleGenerator.h"


@implementation ParticleGenerator

+ (id) PSForNoteVanish
{
    return [[[self alloc] initPSForNoteVanish] autorelease];
}

- (id) initPSForNoteVanish
{
    if ((self = [super initWithTotalParticles:500])) {
        
        self.emissionRate = 1000.0f;
        self.angle = 90.0f;
        self.angleVar = 360.0f;
        ccBlendFunc blendFunc = {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA};
        self.blendFunc = blendFunc;
        self.duration = 0.1f;
        self.emitterMode = kCCParticleModeGravity;
        ccColor4F _startColor = {0.0f, 0.0f, 0.0f, 1.0f};
        self.startColor = _startColor;
        ccColor4F _startColorVar = {0.0f, 0.0f, 0.0f, 0.5f};
        self.startColorVar = _startColorVar;
        ccColor4F _endColor = {0.0f, 0.0f, 0.0f, 1.0f};
        self.endColor = _endColor;
        ccColor4F _endColorVar = {0.0f, 0.0f, 0.0f, 1.0f};
        self.endColorVar = _endColorVar;
        self.startSize = 10.0f;
        self.startSizeVar = 10.0f;
        self.endSize = 1.0f;
        self.endSizeVar = 0.0f;
        self.gravity = ccp(0.0f, 200.0f);
        self.radialAccel = 15.0f;
        self.radialAccelVar = 0.0f;
        self.speed = 30.0f;
        self.speedVar = 10.0f;
        self.tangentialAccel = 15.0f;
        self.tangentialAccelVar = 0.0f;
        self.life = 0.5f;
        self.lifeVar = 0.1f;
        self.startSpin = 0.0f;   
    }
    return self;
}


@end
