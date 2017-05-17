//
//  SFFolderService.h
//  SFolder
//
//  Created by hong7 on 2017/5/9.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFDeviceManager : NSObject

@property (nonatomic,strong) NSArray * devices;

+(id)defaultManager;

//虚拟机当前目录
+(NSString *)devicesPath;

//刷新当前的设备
-(void)updateDevicesByURL:(NSURL *)url;
@end
