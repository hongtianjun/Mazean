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
        [self addSubview:self.moreView];
        
        [self updateConstraints];
    }
    return self;
}

-(void)updateConstraints {
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5.0f);
        make.height.width.equalTo(@30.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5.0f);
        make.left.equalTo(self).offset(20.0f);
        make.right.equalTo(self).offset(-20.0f);
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
        _versionLabel.enabled = NO;
        _versionLabel.backgroundColor = [NSColor clearColor];
        _versionLabel.textColor = [NSColor grayColor];
        _versionLabel.font = [NSFont systemFontOfSize:10.0f];
    }
    return _versionLabel;
}

-(NSImageView *)moreView {
    if (!_moreView) {
        _moreView = [NSImageView imageViewWithImage:[NSImage imageNamed:NSImageNameTouchBarPlayTemplate]];
        //_moreButton.bordered = NO;
    }
    return _moreView;
}
@end
