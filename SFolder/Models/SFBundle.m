//
//  SFBundle.m
//  SFolder
//
//  Created by hong7 on 2017/5/9.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import "SFBundle.h"

@implementation SFBundle

-(NSString *)description {
    return [NSString stringWithFormat:@"%@",self.identifier];
//    return [NSString stringWithFormat:@"%@",@{@"identifier":self.identifier,@"name":self.name,@"version":self.version,@"shortVersion":self.shortVersion,@"createTime":self.createTime,@"updateTime":self.updateTime}];
}
@end
