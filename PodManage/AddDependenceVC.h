//
//  AddDependenceVC.h
//  PodManage
//
//  Created by xby on 2017/8/16.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Dependency.h"

@interface AddDependenceVC : NSViewController

@property (copy,nonatomic) void(^finishBlock)(NSArray<Dependency *> *);

@end
