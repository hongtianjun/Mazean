//
//  SFGeneralPreferencesViewController.m
//  SFolder
//
//  Created by hong7 on 2017/5/17.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import "SFGeneralPreferencesViewController.h"

@interface SFGeneralPreferencesViewController ()

@end

@implementation SFGeneralPreferencesViewController

- (id)init
{
    return [super initWithNibName:@"SFGeneralPreferencesViewController" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"SFGeneralPreferencesViewController";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the Advanced preference pane");
}

//- (NSView *)initialKeyView
//{
//    //NSInteger focusedControlIndex = [[NSApp valueForKeyPath:@"delegate.focusedAdvancedControlIndex"] integerValue];
//    return [NSTextField new];
//}


@end
