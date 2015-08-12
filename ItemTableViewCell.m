//
//  Events.m
//  Zekken
//
//  Created by OPIX on 9/23/12.
//  Copyright (c) 2012 OPIX. All rights reserved.
//


#import "ItemTableViewCell.h"
@interface HeaderTableViewCell ()
@end

@interface ItemTableViewCell()
@end

@interface FooterTableViewCell ()
@end

@interface SubsectionHeaderTableViewCell ()
@end

@implementation HeaderTableViewCell
@end

@implementation SubsectionHeaderTableViewCell
@end

@implementation FooterTableViewCell
@synthesize title;
@synthesize q1;
@synthesize q2;
@synthesize q3;
@synthesize q4;
@synthesize ytd;
@end

@implementation ItemTableViewCell
@synthesize title;
@synthesize q1;
@synthesize q2;
@synthesize q3;
@synthesize q4;
@synthesize ytd;
@synthesize delegate;

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[self delegate] editDidFinish: textField];
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.q1 ||textField == self.q2 ||textField == self.q3 || textField == self.q4) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
