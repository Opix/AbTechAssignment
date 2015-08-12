//
//  AbTechTableViewController.h
//
//  Created by Osamu on 4/23/14.
//  Copyright (c) 2015 Osamu. All rights reserved.
//

@class ItemTableViewCell;

@protocol ItemTableViewCellDelegate <NSObject>

// we will make one function mandatory to include
- (void)editDidFinish: (UITextField *)textField;

@optional
// and the other one is optional (this function has not been used in this tutorial)
- (void)editStarted:(UITextField *)field;

@end

@interface ItemTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    IBOutlet UITextField *q1;
    IBOutlet UITextField *q2;
    IBOutlet UITextField *q3;
    IBOutlet UITextField *q4;    
}
@property (weak) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UITextField *q1;
@property (nonatomic, retain) IBOutlet UITextField *q2;
@property (nonatomic, retain) IBOutlet UITextField *q3;
@property (nonatomic, retain) IBOutlet UITextField *q4;
@property (weak) IBOutlet UILabel *ytd;
@property (nonatomic, weak) id <ItemTableViewCellDelegate> delegate;
@end
@interface FooterTableViewCell : UITableViewCell

@property (weak) IBOutlet UILabel *title;
@property (weak) IBOutlet UILabel *q1;
@property (weak) IBOutlet UILabel *q2;
@property (weak) IBOutlet UILabel *q3;
@property (weak) IBOutlet UILabel *q4;
@property (weak) IBOutlet UILabel *ytd;

@end

@interface HeaderTableViewCell : FooterTableViewCell
@end

@interface SubsectionHeaderTableViewCell : FooterTableViewCell
@end

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
