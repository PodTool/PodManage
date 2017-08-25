//
//  RepoModel.m
//  PodManage
//
//  Created by xby on 2017/8/24.
//  Copyright © 2017年 wanxue. All rights reserved.
//
#import "RepoModel.h"

@interface RepoModel ()

@end

@implementation RepoModel

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
- (NSMutableArray<PodModel *> *)children {

    if (!_children) {
        
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}


@end
