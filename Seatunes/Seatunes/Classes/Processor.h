//
//  Processor.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/16/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ProcessorDelegate.h"

@interface Processor : CCNode  {
 
    NSMutableArray *notes_;
    
    NSMutableArray *inputNotes_;
    
    NSUInteger sectionIndex_;
    
    NSUInteger noteIndex_;
    
    KeyType expectedNote_;
    
    BOOL waitingForNote_;
    
    id <ProcessorDelegate> delegate_;
    
}

@property (nonatomic, assign) id <ProcessorDelegate> delegate;

+ (id) processor;

- (id) initProcessor;

- (void) loadSong:(NSString *)filename;

- (void) notePlayed:(KeyType)keyType;

- (void) forward;

@end
