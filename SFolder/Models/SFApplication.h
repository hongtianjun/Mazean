//
//  SFApplication.h
//  SFolder
//
//  Created by hong7 on 2017/5/9.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFBundle.h"
#import "SFData.h"
#import "SFDDevice.h"

@interface SFApplication : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) SFBundle * bundle;
@property (nonatomic,strong) SFData * date;
@property (nonatomic,strong) SFDDevice * device;

@end
