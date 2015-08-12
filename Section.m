//
//  Events.m
//  Zekken
//
//  Created by OPIX on 9/23/12.
//  Copyright (c) 2012 OPIX. All rights reserved.
//

#import "Section.h"
#import "Item.h"

@implementation Section
@synthesize items, title;

- (id) initWithTitle: (NSString*) newTitle
{
    self = [super init];
    
    if (self) {
        items = [[NSMutableArray alloc] init];
        title = newTitle;
    }
    return self;
}

- (double) calculate1QuaterTotal: (NSInteger) index
{
    double total = 0.0;
    
    for (Item* oneItem in items)
    {
        switch (index) {
            case Q1:
                total += oneItem.q1;
                break;
                
            case Q2:
                total += oneItem.q2;
                break;
                
            case Q3:
                total += oneItem.q3;
                break;
                
            case Q4:
                total += oneItem.q4;
                break;
                
            default:
                break;
        }
    }
    return total;
}

// Calculate YTD for one row.
- (double) calculateYTD: (NSInteger) index
{
    double total = 0.0;
    if (index >= 0 && items.count > index) {
        Item* oneItem = (Item*)[items objectAtIndex: index];
        
        total = oneItem.q1 + oneItem.q2 + oneItem.q3 + oneItem.q4;
    }
    return total;
}

// Calculate Total of YTD
- (double) calculateYTDTotal
{
    double total = 0.0;
    
    for (NSInteger i = 0; i < items.count; i++)
        total += [self calculateYTD: i];
    
    return total;
}

@end
