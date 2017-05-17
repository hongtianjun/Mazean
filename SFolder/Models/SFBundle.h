//
//  SFBundle.h
//  SFolder
//
//  Created by hong7 on 2017/5/9.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBundle : NSObject

@property (nonatomic,strong) NSString * UUID;
@property (nonatomic,strong) NSString * identifier;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * version;
@property (nonatomic,strong) NSString * shortVersion;
@property (nonatomic,strong) NSArray * iconFiles;
@property (nonatomic,strong) NSURL * applicationURL;

@property (nonatomic,strong) NSDate * createTime;
@property (nonatomic,strong) NSDate * updateTime;
@end
