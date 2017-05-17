//
//  SFDevice.m
//  SFolder
//
//  Created by hong7 on 2017/5/9.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import "SFDDevice.h"

@implementation SFDDevice


-(SFData *)dataByBundle:(SFBundle *)bundle {
    for (SFData * data in self.datas) {
        if ([data.identifier isEqualToString:bundle.identifier]) {
            return data;
        }
    }
    return nil;
}

-(NSString *)version {
    
    NSString *ver = [self.runtime stringByReplacingOccurrencesOfString:@"com.apple.CoreSimulator.SimRuntime." withString:@""];
    return [ver stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@,%@",self.name,self.runtime];
}
@end
