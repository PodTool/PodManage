//
//  PodModel.m
//  PodManage
//
//  Created by xby on 2017/8/24.
//Copyright © 2017年 wanxue. All rights reserved.
//
#import "PodModel.h"

@interface PodModel ()

@end

@implementation PodModel

MJCodingImplementation

#pragma mark - life cycle
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

#pragma mark - private

#pragma mark - public

#pragma mark - delegate

#pragma mark - event response

#pragma mark - getters and setters

- (NSMutableArray *)myDependency {

    if (!_myDependency) {
        
        _myDependency = [[NSMutableArray alloc] init];
    }
    return _myDependency;
}

@end
