//
//  SFFolderService.m
//  SFolder
//
//  Created by hong7 on 2017/5/9.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import "SFDeviceManager.h"

#import "SFDDevice.h"
#import "SFBundle.h"
#import "SFData.h"
#import "SFApplication.h"

NSString * const kDevicesPath = @"Developer/CoreSimulator/Devices/";
NSString * const kDevicesSetFilename = @"device_set.plist";
NSString * const kDeviceFilename = @"device.plist";
NSString * const kContainerFilename = @".com.apple.mobile_container_manager.metadata.plist";
NSString * const kContainersPath = @"data/Containers";
NSString * const kBundlePath = @"data/Containers/Bundle/Application";
NSString * const kDataPath = @"data/Containers/Data/Application";

@interface SFDeviceManager ()

@property (nonatomic,strong) NSURL * deviceURL;

@end

@implementation SFDeviceManager

+(id)defaultManager {
    static SFDeviceManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SFDeviceManager alloc] init];
    });
    return manager;
}

+(NSString *)devicesPath {
    static NSString * devicesPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray<NSString *> * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
        if (paths.count > 0) {
            NSString * libraryPath = [paths objectAtIndex:0];
            devicesPath = [libraryPath stringByAppendingPathComponent:kDevicesPath];
        }
    });
    return devicesPath;
}

-(NSDictionary *)dictionaryOfPlistAtURL:(NSURL *)url {
    if ([url checkResourceIsReachableAndReturnError:nil]) {
        return [[NSDictionary alloc] initWithContentsOfURL:url];
    }
    return nil;
}

-(NSArray<NSURL *> *)contentsOfDirectoryAtURL:(NSURL *)url {
    if ([url checkResourceIsReachableAndReturnError:nil]) {
        
        //获取application目录下所有的application
        NSError * error = nil;
        NSArray<NSURL *> * applications =  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsPackageDescendants error:&error];
        
        if (error == nil && applications ) {
            return applications;
        }
    }
    return nil;
}


//根据UUID读取设备信息
-(SFDDevice *)deviceByUUID:(NSString *)uuid {
    NSURL * deviceURL = [self.deviceURL URLByAppendingPathComponent:uuid];
    NSURL * containersURL = [deviceURL URLByAppendingPathComponent:kContainersPath];
    if ([deviceURL checkResourceIsReachableAndReturnError:nil] &&
        [containersURL checkResourceIsReachableAndReturnError:nil]) {
        NSURL * devicePlistURL = [deviceURL URLByAppendingPathComponent:kDeviceFilename];
        
        NSDictionary * dict = [self dictionaryOfPlistAtURL:devicePlistURL];
        if (dict) {
            
            SFDDevice * device = [SFDDevice new];
            [device setUUID:dict[@"UDID"]];
            [device setType:dict[@"deviceType"]];
            [device setName:dict[@"name"]];
            [device setRuntime:dict[@"runtime"]];
            [device setState:[dict[@"state"] intValue]];
            return device;
        }
    }
    return nil;
}

-(NSMutableArray<SFBundle *> *)bundlesByDevice:(SFDDevice *)device {
    
    NSMutableArray * array = [NSMutableArray new];
    
    NSURL * deviceURL = [self.deviceURL URLByAppendingPathComponent:device.UUID];
    NSURL * bundleURL = [deviceURL URLByAppendingPathComponent:kBundlePath];
    NSArray<NSURL *> * applications = [self contentsOfDirectoryAtURL:bundleURL];
    
    for (NSURL * applicationURL in applications) {

        SFBundle * bundle = [SFBundle new];
        
        NSArray<NSURL *> * filenames =  [self contentsOfDirectoryAtURL:applicationURL];
        for (NSURL * filenameURL in filenames) {
            //获取App的基本信息
            if ([[filenameURL lastPathComponent] hasSuffix:@".plist"]) {
                NSDictionary * dict = [self dictionaryOfPlistAtURL:filenameURL];
                if (dict) {
                    bundle.UUID = [dict objectForKey:@"MCMMetadataUUID"];
                    bundle.identifier = [dict objectForKey:@"MCMMetadataIdentifier"];
                }
                
            }else if ([[filenameURL lastPathComponent] hasSuffix:@".app"]) {
                bundle.applicationURL = filenameURL;
                //获取app的修改时间
//                NSError * error = nil;
//                NSDictionary * appattributes = [[NSFileManager defaultManager] attributesOf
//                if (!error && appattributes) {
//                    bundle.createTime = [appattributes objectForKey:NSFileCreationDate];
//                    bundle.updateTime = [appattributes objectForKey:NSFileModificationDate];
//                }
                //获取App的info.plist中的信息
                NSURL * appPlistURL = [filenameURL URLByAppendingPathComponent:@"Info.plist"];
                NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:appPlistURL];
                if (dict) {
                    bundle.iconFiles = [[[dict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"];
                    bundle.name = [dict objectForKey:@"CFBundleDisplayName"];
                    bundle.version = [dict objectForKey:@"CFBundleVersion"];
                    bundle.shortVersion = [dict objectForKey:@"CFBundleShortVersionString"];
                }
            }else {
                NSLog(@"%@",filenameURL);
            }
        }
        
        //去掉没有包名的一些程序
        if (bundle.identifier == nil || [bundle.identifier isKindOfClass:[NSNull class]]) {
            continue;
        }
        [array addObject:bundle];
    }
    return array;
}


-(void)updateDevicesByURL:(NSURL *)url {
    
    self.deviceURL = url;
    
    NSURL * devicesSetURL = [self.deviceURL URLByAppendingPathComponent:kDevicesSetFilename];
    NSDictionary * devices = [self dictionaryOfPlistAtURL:devicesSetURL];
    if (devices == nil) {
        NSLog(@"读取设备文件错误");
        return;
    }
    
    NSMutableArray * array = [NSMutableArray new];
    NSDictionary * versions = [devices objectForKey:@"DefaultDevices"];
    for (NSString * version in versions) {
        NSDictionary * device = [versions objectForKey:version];
        
        //过滤不是模拟器的项
        if (![device isKindOfClass:[NSDictionary class]]) continue;
        
        //遍历全部的设备及其下的应用信息
        for (NSString * name in device) {
            NSString * value = [device objectForKey:name];
            SFDDevice * device = [self deviceByUUID:value];
            NSLog(@"%@",device.name);
            if (device) {
                device.bundles = [self bundlesByDevice:device];
                device.datas = [self datasByDevice:device];
                [array addObject:device];
            }
        }
    }
    //此处需要缓存这些信息吗??
    self.devices = array;
    NSLog(@"%@",array);
}







-(NSMutableArray<SFData *> *)datasByDevice:(SFDDevice *)device {
    
    NSMutableArray * array = [NSMutableArray new];
    
    NSURL * deviceURL = [self.deviceURL URLByAppendingPathComponent:device.UUID];
    NSURL * bundleURL = [deviceURL URLByAppendingPathComponent:kDataPath];
    if ([deviceURL checkResourceIsReachableAndReturnError:nil] &&
        [bundleURL checkResourceIsReachableAndReturnError:nil]) {
        
        NSArray<NSURL *> * applications =  [self contentsOfDirectoryAtURL:bundleURL];
        
        for (NSURL * applicationURL in applications) {
            NSArray<NSURL *> * apps =  [self contentsOfDirectoryAtURL:applicationURL];
            for (NSURL * appURL in apps) {
                if ([[appURL absoluteString] hasSuffix:@".plist"]) {
                    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:appURL];
                    if (dict) {
                        SFData * data = [SFData new];
                        data.UUID = [dict objectForKey:@"MCMMetadataUUID"];
                        data.identifier = [dict objectForKey:@"MCMMetadataIdentifier"];
                        data.url = applicationURL;
                        [array addObject:data];
                    }
                }
            }
        }
        
    }
    return array;
}




-(SFData *)dataByApplication:(SFApplication *)application {
    for (SFData * data in application.device.datas) {
        if ([data.identifier isEqualToString:application.bundle.identifier]) {
            return data;
        }
    }
    return nil;
}

@end
