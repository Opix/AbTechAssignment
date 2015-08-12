//
//  Events.h
//  Zekken
//
//
//  Created by OPIX on 9/23/12.
//  Copyright (c) 2012 OPIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject
{
    NSString* title;
    NSMutableArray* items;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readwrite) NSMutableArray* items;

- (id) initWithTitle: (NSString*) newTitle;
- (double) calculate1QuaterTotal: (NSInteger) index;
- (double) calculateYTD: (NSInteger) index;
- (double) calculateYTDTotal;

@end
