//
//  Events.m
//  Zekken
//
//  Created by OPIX on 9/23/12.
//  Copyright (c) 2012 OPIX. All rights reserved.
//

// Response to tap is slow -> fix:
// http://stackoverflow.com/questions/9357026/super-slow-lag-delay-on-initial-keyboard-animation-of-uitextfield

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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
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
