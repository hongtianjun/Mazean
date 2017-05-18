//
//  SFDeviceView.m
//  SFolder
//
//  Created by hong7 on 2017/5/14.
//  Copyright © 2017年 hong7. All rights reserved.
//

#import "SFDeviceView.h"

#import <Masonry/Masonry.h>

@interface SFDeviceView ()
    

@end

@implementation SFDeviceView

-(instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {

        [self addSubview:self.nameLabel];
        [self addSubview:self.versionLabel];
        
        [self updateConstraints];
    }
    return self;
}

-(void)updateConstraints {
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5.0f);
        make.top.left.equalTo(self).offset(10.0f);
        make.right.equalTo(self).offset(-10.0f);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5.0f);
        make.height.equalTo(@10.0f);
    }];
    
    [super updateConstraints];
}

-(NSTextField *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [NSTextField new];
        _nameLabel.bordered = NO;
        _nameLabel.enabled = NO;
        _nameLabel.backgroundColor = [NSColor clearColor];
    }
    return _nameLabel;
}


-(NSTextField *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [NSTextField new];
        _versionLabel.bordered = NO;
        _versionLabel.editable = NO;
        _versionLabel.bezeled = YES;
        _versionLabel.bezelStyle = NSBezelStyleRounded;
        _versionLabel.enabled = NO;
        _versionLabel.backgroundColor = [NSColor lightGrayColor];
        _versionLabel.font = [NSFont systemFontOfSize:5];
        NSLog(@"%f",_versionLabel.alignmentRectInsets.top);
    }
    return _versionLabel;
}
@end
