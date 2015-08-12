//
//  Events.m
//  Zekken
//
//  Created by GEMINI on 9/23/12.
//  Copyright (c) 2012 GEMINI. All rights reserved.
//

#import "Item.h"

@implementation Item
@synthesize title, q1, q2, q3, q4;

- (id) initWithTitle: (NSString*) newTitle
{
    self = [super init];
    
    if (self) {
        title = newTitle;
        q1 = 0.0;
        q2 = 0.0;
        q3 = 0.0;
        q4 = 0.0;
    }
    return self;
}

@end