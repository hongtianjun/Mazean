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

@interface AppDelegate ()

@property (nonatomic,strong) NSStatusItem * statusItem;
@property (nonatomic,strong) NSMenu * statusMenu;
@end

@implementation AppDelegate

-(void)beginAccessDevicesURLWithCompletionHandler:(void (^)(NSURL * url))handler{
    
    NSData * bookmarkData = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmark"];
    NSError * error = nil;
    NSURL * url = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:nil error:&error];
    if (error == nil && url) {
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
    }];
    
    [self createStatusBarMenu];
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
        
        SFDeviceView * view = [[SFDeviceView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 50.0f)];
        [view.nameLabel setStringValue:device.name];
        [view.versionLabel setStringValue:device.version];
        item.view = view;
        
        NSInteger count = 0;
        NSMenu * subMenu = [[NSMenu alloc] initWithTitle:@""];
        for (SFBundle * bundle in device.bundles) {
            
            NSMenuItem * mm = [subMenu addItemWithTitle:bundle.identifier action:@selector(hi:) keyEquivalent:@""];
            
            NSImage * iconImage = nil;
            if (bundle.iconFiles.count > 0) {
                NSURL * path = [bundle.applicationURL URLByAppendingPathComponent:bundle.iconFiles[0]];
                path = [path URLByAppendingPathExtension:@"png"];
                iconImage = [[NSImage alloc] initWithContentsOfURL:path];
            }
            if (iconImage == nil) iconImage = [NSImage imageNamed:@"DefaultIcon"];
            
            [mm setImage:iconImage];
            [mm setTag:p * 1000 + count++];
            
            [subMenu addItem:[NSMenuItem separatorItem]];
            
        }
        [_statusMenu setSubmenu:subMenu forItem:item];
        [_statusMenu addItem:[NSMenuItem separatorItem]];
        p++;
    }
    
    //增加退出按钮
    [_statusMenu addItem:[NSMenuItem separatorItem]];
    [_statusMenu addItemWithTitle:@"退出" action:@selector(quit:) keyEquivalent:@""];
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
