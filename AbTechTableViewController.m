//  AbTechTableViewController.m
//  Gemini
//
//  Created by GEMINI on 4/23/14.
//  Copyright (c) 2015 GEMINI. All rights reserved.
//
// Investment Accounts has subsections.

#import "AppDelegate.h"
#import "AbTechTableViewController.h"
#import "Section.h"
#import "Item.h"

#define ROW_TYPE_HEADER 0
#define ROW_TYPE_FOOTER 1
#define ROW_TYPE_ITEM   2

#define HEADER_HEIGHT   10.0f

@implementation AbTechTableViewController
@synthesize arraySections, selectedIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arraySections       = [[NSMutableArray alloc] init];
    selectedIndexPath   = [NSIndexPath indexPathForRow:1 inSection:0];
    
    // Get data from a .json file.
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"AbTechAssginment" ofType:@"json"];
    NSData *data        = [NSData dataWithContentsOfFile: filePath];
    NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [self fillArraySections: json subSection: nil];

    // Set Table Header
    UITableViewCell* tableHeader    = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"tableHeader"];
    self.tableView.tableHeaderView  = tableHeader;
    
    sectionSummary = arraySections.count; // 1 for summary
}

// Investment Account has 2 internal sections.
- (void) fillArraySections: (NSDictionary*) dictionary subSection: (NSMutableArray*) subArray
{
    NSArray* arraySectionOrder = [NSArray arrayWithObjects: @"Cash", @"CD's", @"Investments", @"Taxes", @"Property", nil];
    
    for (NSString* key in subArray ? dictionary : arraySectionOrder) {
        
        Section* section = [[Section alloc] initWithTitle: key];
        
        NSArray *items = [dictionary valueForKey: key];
        
        for (NSDictionary *itemDictionary in items)
        {
            NSString* title = itemDictionary[@"title"];
            
            if ([title isEqualToString: @""] || title == nil)
            {
                NSMutableArray* investmentArray = [[NSMutableArray alloc] init];
                
                // Recursive
                [self fillArraySections: itemDictionary subSection: investmentArray];
                [section.items addObject: investmentArray];
            }
            else
            {
                Item *oneItem   = [[Item alloc] initWithTitle: title];
                oneItem.q1      = [itemDictionary[@"Q1"] doubleValue];
                oneItem.q2      = [itemDictionary[@"Q2"] doubleValue];
                oneItem.q3      = [itemDictionary[@"Q3"] doubleValue];
                oneItem.q4      = [itemDictionary[@"Q4"] doubleValue];
                
                [section.items addObject: oneItem];
            }
        }
        
        // This is only for Investment Accounts
        if (subArray)
            [subArray addObject: section];
        // All other sections go to the top level array. 
        else
            [arraySections addObject: section];
    }
}

// http://stackoverflow.com/questions/16306260/setting-custom-header-view-in-uitableview
- (HeaderTableViewCell *) headerInSection:(NSInteger)section
{
    HeaderTableViewCell *headerCell = (HeaderTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    // Need this; otherwise, the summary header (purple)  may be resused.
    headerCell.contentView.backgroundColor = [AbTechTableViewController colorFromHexString: @"#640064"]; // Purple
    
    // Change the background to purple.
    if (section == sectionSummary)
    {
        headerCell.title.text = @"Summary";
        headerCell.contentView.backgroundColor = [AbTechTableViewController colorFromHexString: @"#00A000"];//Green;
    }
    else
    {
        Section* oneSection  = (Section*)[arraySections objectAtIndex: section];
        headerCell.title.text = [NSString stringWithFormat: @"Section %ld - %@", (long)(section + 1), oneSection.title];
        
        if ([oneSection.title isEqualToString: @"Taxes"])
            headerCell.contentView.backgroundColor = [UIColor redColor];
    }

    return headerCell;
}

- (FooterTableViewCell *) footerInSection:(NSInteger)section
{
    FooterTableViewCell *footerCell = (FooterTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"footerCell"];
    // Need this; otherwise, the summary footer (purple)  may be resused.
    footerCell.contentView.backgroundColor = [AbTechTableViewController colorFromHexString: @"#640064"]; // Purple

    double q1 = 0.0;
    double q2 = 0.0;
    double q3 = 0.0;
    double q4 = 0.0;
    double ytd = 0.0;

    BOOL bNegative  = NO;
    
    if (section == sectionSummary)
    {
        // Change the background to purple.
        footerCell.contentView.backgroundColor = [AbTechTableViewController colorFromHexString: @"#00A000"]; //Green;
        footerCell.title.text   = @"Grand Total";
        
        for (Section* oneSection in arraySections)
        {
            q1  += [oneSection calculate1QuaterTotal: Q1];
            q2  += [oneSection calculate1QuaterTotal: Q2];
            q3  += [oneSection calculate1QuaterTotal: Q3];
            q4  += [oneSection calculate1QuaterTotal: Q4];
            ytd += [oneSection calculateYTDTotal];
        }
    }
    else
    {
        Section* oneSection  = (Section*)[arraySections objectAtIndex: section];
        
        if ([oneSection.title isEqualToString: @"Taxes"])
        {
            footerCell.contentView.backgroundColor = [UIColor redColor];
            bNegative  = YES;
        }
        
        q1 = [oneSection calculate1QuaterTotal: Q1];
        q2 = [oneSection calculate1QuaterTotal: Q2];
        q3 = [oneSection calculate1QuaterTotal: Q3];
        q4 = [oneSection calculate1QuaterTotal: Q4];
        ytd = [oneSection calculateYTDTotal];
        
        footerCell.title.text   = [NSString stringWithFormat: @"Total - Section %ld - %@", (long)(section + 1), oneSection.title];
    }

    footerCell.q1.text  = [self formatToUSCurrency: q1 negative: bNegative];
    footerCell.q2.text  = [self formatToUSCurrency: q2 negative: bNegative];
    footerCell.q3.text  = [self formatToUSCurrency: q3 negative: bNegative];
    footerCell.q4.text  = [self formatToUSCurrency: q4 negative: bNegative];
    footerCell.ytd.text = [self formatToUSCurrency: ytd negative: bNegative];
    
    return footerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionSummary + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!arraySections.count)
        return 0;
    
    if (section == sectionSummary)
        return arraySections.count + 2;
    
    Section* oneSection  = (Section*)[arraySections objectAtIndex: section];
    return [oneSection rowCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!arraySections.count)
        return nil;
    
    // Header
    if (indexPath.row == 0)
        return [self headerInSection: indexPath.section];
    
    // Footer
    if (indexPath.row == ([self.tableView numberOfRowsInSection:indexPath.section] - 1))
        return [self footerInSection: indexPath.section];
    
    if (indexPath.section == sectionSummary)
    {
        FooterTableViewCell *cell = (FooterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"subFooterCell" forIndexPath:indexPath];
        // Set text = black and background = white.
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.q1.textColor       = [UIColor blackColor];
        cell.q2.textColor       = [UIColor blackColor];
        cell.q3.textColor       = [UIColor blackColor];
        cell.q4.textColor       = [UIColor blackColor];
        cell.ytd.textColor      = [UIColor blackColor];
        cell.title.textColor    = [UIColor blackColor];

        Section* oneSection = [arraySections objectAtIndex: indexPath.row - 1];
        
        double q1 = [oneSection calculate1QuaterTotal: Q1];
        double q2 = [oneSection calculate1QuaterTotal: Q2];
        double q3 = [oneSection calculate1QuaterTotal: Q3];
        double q4 = [oneSection calculate1QuaterTotal: Q4];
        double ytd = [oneSection calculateYTDTotal];
        
        cell.title.text = [NSString stringWithFormat: @"Section %ld - %@", (long)indexPath.row, oneSection.title];
        
        BOOL bNegative  = [oneSection.title isEqualToString: @"Taxes"];
        
        cell.q1.text    = [self formatToUSCurrency: q1 negative: bNegative];
        cell.q2.text    = [self formatToUSCurrency: q2 negative: bNegative];
        cell.q3.text    = [self formatToUSCurrency: q3 negative: bNegative];
        cell.q4.text    = [self formatToUSCurrency: q4 negative: bNegative];
        cell.ytd.text   = [self formatToUSCurrency: ytd negative: bNegative];

        return cell;
    }
    
    Section* oneSection  = (Section*)[arraySections objectAtIndex: indexPath.section];
    NSInteger currentRow = 1;
    
    for (NSInteger j = 0; j < oneSection.items.count; j++)
    {
        if ([[oneSection.items objectAtIndex: j] isKindOfClass: [NSArray class]])
        {
            NSInteger sectionHeader = currentRow; // Subsection header starts with 1.
            NSInteger sectionFooter = 2; // Subsection footer starts with 2.
            
            NSArray* arraySubSection = (NSArray*)[oneSection.items objectAtIndex: j];

            for (NSInteger i = 0; i < arraySubSection.count; i++)
            {
                Section* oneSubSection  = (Section*)[arraySubSection objectAtIndex: i];

                NSLog(@"oneSubSection.title: %@", oneSubSection.title);

                sectionFooter = sectionHeader + oneSubSection.items.count + 1;
                
                if (indexPath.row == sectionHeader)
                {
                    SubsectionHeaderTableViewCell *headerCell = (SubsectionHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"subsectionHeaderCell" forIndexPath:indexPath];

                    headerCell.title.text = oneSubSection.title;
                    return headerCell;
                }
                else if (indexPath.row > sectionHeader && indexPath.row < sectionFooter)
                {
                    ItemTableViewCell *cell = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
                    [cell setDelegate: self];
                    NSLog(@"indexPath.row: %ld", (long)indexPath.row);

                    Item* oneItem = (Item*)[oneSubSection.items objectAtIndex: (indexPath.row - 1 - sectionHeader)];
                    
                    cell.title.text  = oneItem.title;
                    
                    BOOL bNegative  = [oneSection.title isEqualToString: @"Taxes"];

                    cell.q1.text  = [self formatToUSCurrency: oneItem.q1 negative: bNegative];
                    cell.q2.text  = [self formatToUSCurrency: oneItem.q2 negative: bNegative];
                    cell.q3.text  = [self formatToUSCurrency: oneItem.q3 negative: bNegative];
                    cell.q4.text  = [self formatToUSCurrency: oneItem.q4 negative: bNegative];
                    cell.ytd.text = [self formatToUSCurrency: oneItem.q1 + oneItem.q2 + oneItem.q3 + oneItem.q4 negative: bNegative];
                    return cell;
                }
                else if (indexPath.row == sectionFooter)
                {
                    BOOL bNegative  = [oneSection.title isEqualToString: @"Taxes"];

                    FooterTableViewCell *footerCell = (FooterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"subFooterCell" forIndexPath:indexPath];
                    footerCell.contentView.backgroundColor = [UIColor lightGrayColor];
                    
                    footerCell.title.text   = [NSString stringWithFormat: @"Total - %@", oneSubSection.title];
                    footerCell.q1.text      = [self formatToUSCurrency: [oneSubSection calculate1QuaterTotal: Q1] negative: bNegative];
                    footerCell.q2.text      = [self formatToUSCurrency: [oneSubSection calculate1QuaterTotal: Q2] negative: bNegative];
                    footerCell.q3.text      = [self formatToUSCurrency: [oneSubSection calculate1QuaterTotal: Q3] negative: bNegative];
                    footerCell.q4.text      = [self formatToUSCurrency: [oneSubSection calculate1QuaterTotal: Q4] negative: bNegative];
                    footerCell.ytd.text     = [self formatToUSCurrency: [oneSubSection calculateYTDTotal] negative: bNegative];
                    
                    footerCell.q1.textColor       = [UIColor whiteColor];
                    footerCell.q2.textColor       = [UIColor whiteColor];
                    footerCell.q3.textColor       = [UIColor whiteColor];
                    footerCell.q4.textColor       = [UIColor whiteColor];
                    footerCell.ytd.textColor      = [UIColor whiteColor];
                    footerCell.title.textColor    = [UIColor whiteColor];

                    return footerCell;
                }
                sectionHeader = sectionFooter + 1;
            }
            currentRow = sectionFooter + 1;
        }
        else
        {
            if (currentRow == indexPath.row)
            {
                BOOL bNegative  = [oneSection.title isEqualToString: @"Taxes"];

                ItemTableViewCell *cell = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
                [cell setDelegate: self];
                
                Item* oneItem = (Item*)[oneSection.items objectAtIndex: indexPath.row - 1];
                
                cell.title.text  = oneItem.title;
                cell.q1.text  = [self formatToUSCurrency: oneItem.q1 negative: bNegative];
                cell.q2.text  = [self formatToUSCurrency: oneItem.q2 negative: bNegative];
                cell.q3.text  = [self formatToUSCurrency: oneItem.q3 negative: bNegative];
                cell.q4.text  = [self formatToUSCurrency: oneItem.q4 negative: bNegative];
                cell.ytd.text = [self formatToUSCurrency: oneItem.q1 + oneItem.q2 + oneItem.q3 + oneItem.q4 negative: bNegative];
                return cell;
            }
            currentRow++;
        }
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    if (sectionSummary == indexPath.section)
        return NO;
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// No decimals
- (NSString*) formatToUSCurrency: (double) price negative: (BOOL) bNegative
{
    NSDecimalNumber *decimal = [[NSDecimalNumber alloc] initWithDouble: price];
    NSLocale *priceLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; // get the locale from your SKProduct

    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [currencyFormatter setLocale: priceLocale];
    
    // These 2 lines are for no decimals.
    [currencyFormatter setGeneratesDecimalNumbers: NO];
    [currencyFormatter setMaximumFractionDigits: 0];
    
    //NSString *currencyString = [currencyFormatter internationalCurrencySymbol]; // EUR, GBP, USD...
    
    NSString *format = nil;
    
    if (bNegative)
        format = [currencyFormatter negativeFormat];
    else
        format = [currencyFormatter positiveFormat];

    format = [format stringByReplacingOccurrencesOfString:@"¤" withString: @"$"]; //currencyString
    // ¤ is a placeholder for the currency symbol
    
    if (bNegative)
        [currencyFormatter setNegativeFormat: @"-¤#,##0"]; // format
    else
        [currencyFormatter setPositiveFormat: format];

    return [currencyFormatter stringFromNumber:decimal];
}
// Round corners in header / footer sections
// http://stackoverflow.com/questions/18822619/ios-7-tableview-like-in-settings-app-on-ipad
- (void)tableView:(UITableView *)tableView willDisplayCell:(FooterTableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    float cornerSize = 15.0; // change this if necessary
    
    //CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    //cell.bounds = bounds;
    
    // round all corners if there is only 1 cell
    /*
    if (indexPath.row == 0) {
        [cell setClipsToBounds:YES];

        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerSize, cornerSize)];
        
        CAShapeLayer *mlayer = [[CAShapeLayer alloc] init];
        mlayer.frame = cell.bounds;
        mlayer.path = maskPath.CGPath;
        cell.layer.mask = mlayer;
    }
    
    // round only top cell and only top-left and top-right corners
    else*/
    if (indexPath.row == 0) {
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect: cell.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerSize, cornerSize)];
        
        CAShapeLayer *mlayer = [[CAShapeLayer alloc] init];
        mlayer.frame = cell.bounds;
        mlayer.path = maskPath.CGPath;
        cell.layer.mask = mlayer;
    }
    // round bottom-most cell of group and only bottom-left and bottom-right corners
    else if (indexPath.row == ([self.tableView numberOfRowsInSection:indexPath.section] - 1)) {
        [cell setClipsToBounds:YES];

        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect: cell.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerSize, cornerSize)];
        
        CAShapeLayer *mlayer = [[CAShapeLayer alloc] init];
        mlayer.frame = cell.bounds;
        mlayer.path = maskPath.CGPath;
        cell.layer.mask = mlayer;
    }
}

// Catch when orientation changes:
// https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIContentContainer_Ref/index.html#//apple_ref/occ/intfm/UIContentContainer/viewWillTransitionToSize:withTransitionCoordinator:
// This is necessary so that the rounded cells (section headers and footers) will be redrawn correctly.
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
    // Need to refresh because the header width changes and therefore the header lines need to be recalculated.
    [self.tableView reloadData];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)editDidFinish: (UITextField *)textField
{
    selectedIndexPath = [self.tableView indexPathForCell:(ItemTableViewCell*)[[textField superview] superview]];
    NSLog(@"indexPath.row: %ld", (long)selectedIndexPath.row);
    NSLog(@"indexPath.section: %ld", (long)selectedIndexPath.section);
    
    // Remove $ sign
    NSString* newValue = [[textField text] stringByReplacingOccurrencesOfString: @"$" withString: @""];
    NSInteger index = [textField tag];
    
    Item* oneItem = nil;
    
    // Find which data has been modified.
    Section* oneSection  = (Section*)[arraySections objectAtIndex: selectedIndexPath.section];
    
    NSInteger currentRow = 1;
    
    for (NSInteger j = 0; j < oneSection.items.count; j++)
    {
        if ([[oneSection.items objectAtIndex: j] isKindOfClass: [NSArray class]])
        {
            NSInteger sectionHeader = currentRow; // Subsection header starts with 1.
            NSInteger sectionFooter = 2; // Subsection footer starts with 2.
            
            NSArray* arraySubSection = (NSArray*)[oneSection.items objectAtIndex: j];
            
            for (NSInteger i = 0; i < arraySubSection.count; i++)
            {
                Section* oneSubSection  = (Section*)[arraySubSection objectAtIndex: i];
                
                NSLog(@"oneSubSection.title: %@", oneSubSection.title);
                
                sectionFooter = sectionHeader + oneSubSection.items.count + 1;
                
                if (selectedIndexPath.row > sectionHeader && selectedIndexPath.row < sectionFooter)
                {
                    oneItem = (Item*)[oneSubSection.items objectAtIndex: (selectedIndexPath.row - 1 - sectionHeader)];
                    break;
                }
                sectionHeader = sectionFooter + 1;
            }
            currentRow = sectionFooter + 1;
        }
        else
        {
            if (currentRow == selectedIndexPath.row)
            {
                oneItem = (Item*)[oneSection.items objectAtIndex: selectedIndexPath.row - 1];
                break;
            }
            currentRow++;
        }
    }
    
    // Not found -> don't do anything.
    if (!oneItem)
        return;
    
    // Found -> Update
    switch (index) {
        case Q1:
            oneItem.q1 = [newValue doubleValue];
            break;
            
        case Q2:
            oneItem.q2 = [newValue doubleValue];
            break;
            
        case Q3:
            oneItem.q3 = [newValue doubleValue];
            break;
            
        case Q4:
            oneItem.q4 = [newValue doubleValue];
            break;

        default:
            break;
    }

    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndexPath = indexPath;
}
@end
