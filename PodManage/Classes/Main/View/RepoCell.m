//
//  RepoCell.m
//  PodManage
//
//  Created by xby on 2017/8/13.
//Copyright © 2017年 wanxue. All rights reserved.
//
#import "RepoCell.h"

@interface RepoCell ()

@property (weak) IBOutlet NSTextFieldCell *titleLabel;

@end

@implementation RepoCell


#pragma mark - life cycle
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpSubView];
        [self setUpConstraint];
        
    }
    return self;
}

#pragma mark - private
- (void)setUpSubView {
    
    self.titleLabel.stringValue = @"testData";
}

- (void)setUpConstraint {
    
}
#pragma mark - public

#pragma mark - delegate

#pragma mark - event response

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.stringValue = _title;
}

@end