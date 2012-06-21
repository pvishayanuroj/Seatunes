//
//  CreditsScene.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"

enum {
    kCSBack
};

@interface CreditsScene : CCScene <ButtonDelegate> {
 
    NSArray *credits_;
    
    NSInteger currentLine_;
    
}

- (void) placeLine:(NSString *)role value:(NSString *)value;

- (NSDictionary *) createEntry:(NSString *)value role:(NSString *)role;

- (NSArray *) generateCredits;

- (void) loadMainMenu;

@end
