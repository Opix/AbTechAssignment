//
//  AbTechTableViewController.h
//
//  Created by Osamu on 4/23/14.
//  Copyright (c) 2015 Osamu. All rights reserved.
//

#import "ItemTableViewCell.h"

@interface AbTechTableViewController : UITableViewController <ItemTableViewCellDelegate>
{
    NSMutableArray* arraySections;
    NSIndexPath* selectedIndexPath;
}

@property NSMutableArray* arraySections;
@property NSArray* arraySectionOrder;
@property NSIndexPath* selectedIndexPath;

- (NSString*) formatToUSCurrency: (double) price;
- (void) fillArraySections: (NSDictionary*) dictionary subSection: (NSMutableArray*) subArray;
- (HeaderTableViewCell *) headerInSection:(NSInteger)section;
- (FooterTableViewCell *) footerInSection:(NSInteger)section;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
