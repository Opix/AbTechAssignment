//
//  Events.h
//  Zekken
//
// This stores [Events] table's info.
//
//  Created by GEMINI on 9/23/12.
//  Copyright (c) 2012 GEMINI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Q1    1
#define Q2    2
#define Q3    3
#define Q4    4

@interface Item : NSObject
{
    NSString* title;
}

@property (nonatomic, copy)         NSString *title;
@property (nonatomic, assign)       double q1;
@property (nonatomic, assign)       double q2;
@property (nonatomic, assign)       double q3;
@property (nonatomic, assign)       double q4;

- (id) initWithTitle: (NSString*) newTitle;

@end