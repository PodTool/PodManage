//
//  PodNameCell.m
//  PodManage
//
//  Created by xby on 2017/8/17.
//Copyright © 2017年 wanxue. All rights reserved.
//
#import "PodNameCell.h"

@interface PodNameCell ()


@end

@implementation PodNameCell


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

#pragma mark - getters and setters

@end
