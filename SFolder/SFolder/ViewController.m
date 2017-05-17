//
//  ViewController.m
//  SFolder
//
//  Created by hong7 on 2017/5/8.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import "ViewController.h"

#import "SFDeviceManager.h"

#import <Masonry/Masonry.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    
    
    
    
//    NSArray<NSString *> * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
//    if (paths.count > 0) {
//        NSString * libraryPath = [paths objectAtIndex:0];
//        NSString * devicesPath = [libraryPath stringByAppendingPathComponent:kDevicesPath];
//        NSString * devicesSetPath = [devicesPath stringByAppendingPathComponent:kDevicesSetFilename];
//    
//        if ([[NSFileManager defaultManager] fileExistsAtPath:devicesSetPath]) {
//            
//            NSMutableArray * array = [NSMutableArray new];
//            //读取所有设备列表
//            NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:devicesSetPath];
//            NSLog(@"%@",dict);
//            NSDictionary * versions = [dict objectForKey:@"DefaultDevices"];
//            for (NSString * version in versions) {
//                NSDictionary * device = [versions objectForKey:version];
//                if (![device isKindOfClass:[NSDictionary class]]) continue;
//                
//                for (NSString * name in device) {
//                    NSString * value = [device objectForKey:name];
//                    [array addObject:value];
//                }
//            }
//            
//            for (NSString * name in array) {
//                NSString * devicePath = [devicesPath stringByAppendingPathComponent:name];
//                NSLog(@"%@",devicePath);
//                if ([[NSFileManager defaultManager] fileExistsAtPath:devicePath]) {
//                    NSString * path = [devicePath stringByAppendingPathComponent:KDeviceFilename];
//                    NSString * bundlePath = [devicePath stringByAppendingPathComponent:@"data/Containers/Bundle/Application"];
//                    NSString * DataPath = [devicePath stringByAppendingPathComponent:@"data/Containers/Data/Application"];
//                    if ([[NSFileManager defaultManager] fileExistsAtPath:bundlePath] &&
//                        [[NSFileManager defaultManager] fileExistsAtPath:DataPath] &&
//                        [[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                        
//                        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
//                        
//                        NSLog(@"%@",dict);
//                        
//                        NSArray<NSString *> * applications =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DataPath error:nil];
//                        
//                        for (NSString * application in applications) {
//                            NSString * applicationPath = [DataPath stringByAppendingPathComponent:application];
//                            NSLog(@"%@",applicationPath);
//                            NSArray<NSString *> * apps =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:applicationPath error:nil];
//                            NSLog(@"%@",apps);
//                            for (NSString * app in apps) {
//                                NSLog(@"%@",app);
//                                if ([app hasSuffix:@".plist"]) {
//                                    NSString * metadataPath = [applicationPath stringByAppendingPathComponent:app];
//                                    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:metadataPath];
//                                    NSLog(@"%@",dict);
//                                }
//                            }
//                        }
//                        
//                        
//                        NSArray<NSString *> * applications2 =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundlePath error:nil];
//                        for (NSString * application in applications2) {
//                            NSString * applicationPath = [bundlePath stringByAppendingPathComponent:application];
//                            NSArray<NSString *> * apps =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:applicationPath error:nil];
//                            NSLog(@"%@",apps);
//                            for (NSString * app in apps) {
//                                NSLog(@"%@",app);
//                                if ([app hasSuffix:@".plist"]) {
//                                    NSString * metadataPath = [applicationPath stringByAppendingPathComponent:app];
//                                    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:metadataPath];
//                                    NSLog(@"%@",dict);
//                                }else if ([app hasSuffix:@".app"]) {
//                                    NSString * appPath = [applicationPath stringByAppendingPathComponent:app];
//                                    appPath = [appPath stringByAppendingPathComponent:@"Info.plist"];
//                                    NSLog(@"%@",appPath);
//                                    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:appPath];
//                                    NSLog(@"%@",[[[dict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]);
//                                    NSLog(@"%@",[dict objectForKey:@"CFBundleDisplayName"]);
//                                    NSLog(@"%@",[dict objectForKey:@"CFBundleIdentifier"]);
//                                    NSLog(@"%@",[dict objectForKey:@"CFBundleIdentifier"]);
//                                    NSLog(@"%@",[dict objectForKey:@"CFBundleShortVersionString"]);
//                                }else {
//                                    
//                                }
//                            }
//                            //NSLog(@"%@",app);
//                            
//                        }
//                        
//                    }
//                }
//                
//            }
//        }
//        
//    }
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
