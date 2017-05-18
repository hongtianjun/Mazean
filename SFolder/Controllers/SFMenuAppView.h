//
//  SFMenuAppView.h
//  SFolder
//
//  Created by hong7 on 2017/5/18.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SFMenuAppView : NSView

@property (nonatomic,assign) NSMenu * menu;
@property (nonatomic,assign) NSMenuItem * item;
@property (nonatomic,strong) NSTextField * nameLabel;
@property (nonatomic,strong) NSTextField * versionLabel;
@property (nonatomic,strong) NSImageView * logoImageView;

@end
