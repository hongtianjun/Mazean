//
//  SFDevice.h
//  SFolder
//
//  Created by hong7 on 2017/5/9.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFBundle.h"
#import "SFData.h"

@interface SFDDevice : NSObject

@property (nonatomic,strong) NSString * UUID;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * runtime;
@property (nonatomic,assign) NSInteger state;

@property (nonatomic,strong) NSArray<SFBundle *> * bundles;
@property (nonatomic,strong) NSArray<SFData *> * datas;

-(NSString *)version;

-(SFData *)dataByBundle:(SFBundle *)bundle;
@end
