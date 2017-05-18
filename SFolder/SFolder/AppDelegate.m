//
//  AppDelegate.m
//  SFolder
//
//  Created by hong7 on 2017/5/8.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import "AppDelegate.h"

#import "SFDeviceManager.h"
#import "SFApplication.h"

#import "SFDeviceView.h"
#import "SFMenuAppView.h"

#import <MASPreferences/MASPreferences.h>
#import "SFGeneralPreferencesViewController.h"

@interface AppDelegate ()

@property (nonatomic,strong) NSStatusItem * statusItem;
@property (nonatomic,strong) NSMenu * statusMenu;
@property (nonatomic,strong) MASPreferencesWindowController * preferencesController;
@end

@implementation AppDelegate

-(void)beginAccessDevicesURLWithCompletionHandler:(void (^)(NSURL * url))handler{
    
    NSData * bookmarkData = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmark"];
    NSError * error = nil;
    NSURL * url = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:nil error:&error];
    if (error == nil && url != nil) {
        if ([url startAccessingSecurityScopedResource]) {
            
            handler(url);
            
            [url stopAccessingSecurityScopedResource];
        }
    }else {
        NSString * path = [SFDeviceManager devicesPath];
        
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:YES];
        [panel setCanChooseFiles:NO];
        [panel setShowsToolbarButton:YES];
        [panel setPrompt:@"允许"];
        [panel setDirectoryURL:[NSURL URLWithString:path]];
        [panel beginWithCompletionHandler:^(NSInteger result) {
            if (result == NSModalResponseOK) {
                
                
                NSLog(@"kkkkkk%@",panel.URLs);
                NSURL * url = [panel.URLs objectAtIndex:0];
                
                NSError * error = nil;
                NSData *bookmarkData = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope
                                     includingResourceValuesForKeys:nil
                                                      relativeToURL:nil
                                                              error:&error];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:bookmarkData forKey:@"bookmark"];
                [userDefaults synchronize];
                
                NSLog(@"%@",error);
                if ([url startAccessingSecurityScopedResource]) {
                    
                    handler(url);
                    
                    [url stopAccessingSecurityScopedResource];
                }
            }
        }];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self beginAccessDevicesURLWithCompletionHandler:^(NSURL * url) {
        [[SFDeviceManager defaultManager] updateDevicesByURL:url];
        [self createStatusBarMenu];
    }];
    
    
}

-(void)createStatusBarMenu {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage * image = [NSImage imageNamed:@"TrayLogo"];
    image.template = YES;
    [_statusItem setImage:image];
    _statusMenu = [[NSMenu alloc] initWithTitle:@"Menu"];
    [_statusItem setMenu:_statusMenu];
    
    
    NSInteger p = 0;
    NSArray * devices = [[SFDeviceManager defaultManager] devices];
    for (SFDDevice * device in devices) {
        NSString * title = [NSString stringWithFormat:@"%@ %@",device.name,device.version];
        NSMenuItem * item = [_statusMenu addItemWithTitle:title action:@selector(hi:) keyEquivalent:@""];
        
        SFDeviceView * view = [[SFDeviceView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 40.0f)];
        [view.nameLabel setStringValue:device.name];
        [view.versionLabel setStringValue:device.version];
        item.view = view;
        
        NSInteger count = 0;
        NSMenu * subMenu = [[NSMenu alloc] initWithTitle:@""];
        for (SFBundle * bundle in device.bundles) {
            
            NSMenuItem * mm = [subMenu addItemWithTitle:bundle.identifier action:@selector(hi:) keyEquivalent:@""];
            
            SFMenuAppView * appView = [[SFMenuAppView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 50.0f)];
            [appView.nameLabel setStringValue:bundle.identifier];
            [appView.versionLabel setStringValue:[NSString stringWithFormat:@"%@ (%@)",bundle.shortVersion,bundle.version]];
            [appView setItem:mm];
            mm.view = appView;
            
            NSImage * iconImage = nil;
            if (bundle.iconFiles.count > 0) {
                NSURL * path = [bundle.applicationURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",bundle.iconFiles[0],@"@3x"]];
                iconImage = [[NSImage alloc] initWithContentsOfURL:path];
            }
            if (iconImage == nil) iconImage = [NSImage imageNamed:NSImageNameApplicationIcon];
            [appView.logoImageView setImage:iconImage];
            
            //[mm setImage:iconImage];
            [mm setTag:p * 1000 + count++];
            
            [subMenu addItem:[NSMenuItem separatorItem]];
            
        }
        [_statusMenu setSubmenu:subMenu forItem:item];
        //[_statusMenu addItem:[NSMenuItem separatorItem]];
        p++;
    }
    
    
    [_statusMenu addItem:[NSMenuItem separatorItem]];
    //设置
//    [_statusMenu addItemWithTitle:@"偏好设置" action:@selector(setup:) keyEquivalent:@","];
    //反馈
    [_statusMenu addItemWithTitle:@"联系我们" action:@selector(contact:) keyEquivalent:@""];
    //增加退出按钮
    [_statusMenu addItem:[NSMenuItem separatorItem]];
    [_statusMenu addItemWithTitle:@"退出" action:@selector(quit:) keyEquivalent:@"q"];
}

-(void)setup:(NSMenuItem *)item {

    if (self.preferencesController == nil) {
        SFGeneralPreferencesViewController * viewController = [[SFGeneralPreferencesViewController alloc] initWithNibName:@"SFGeneralPreferencesViewController" bundle:nil];;
        MASPreferencesWindowController * preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:@[viewController] title:nil];
        
        self.preferencesController = preferencesWindowController;
    }
    [self.preferencesController showWindow:self];
}

-(void)contact:(NSMenuItem *)item {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:htj0414@163.com"]];
}

-(void)hi:(NSMenuItem *)item {
    NSInteger p = item.tag / 1000;
    NSInteger count = item.tag % 1000;
    
    NSArray * devices = [[SFDeviceManager defaultManager] devices];
    SFDDevice * device = devices[p];
    SFBundle * bundle = device.bundles[count];

    SFData * data = [device dataByBundle:bundle];
    if (data) {
        [self beginAccessDevicesURLWithCompletionHandler:^(NSURL *url) {
            [[NSWorkspace sharedWorkspace] openURL:data.url];
        }];
        
    }
}

-(void)quit:(id)sender {
    
    [[NSApplication sharedApplication] terminate:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
