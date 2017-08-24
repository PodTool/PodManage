//
//  PodDeleteCell.m
//  PodManage
//
//  Created by xby on 2017/8/18.
//Copyright © 2017年 wanxue. All rights reserved.
//
#import "PodDeleteCell.h"

@interface PodDeleteCell ()

@end

@implementation PodDeleteCell


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
    
    
}

- (void)setUpConstraint {
    
    
}
#pragma mark - public

#pragma mark - delegate

#pragma mark - event response

- (IBAction)deleteAction:(NSButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickDeleteBtnAtCell:)]) {
        
        [self.delegate didClickDeleteBtnAtCell:self];
    }
}
#pragma mark - getters and setters



@end
