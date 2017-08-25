//
//  CreateRepo.h
//  PodManage
//
//  Created by xby on 2017/8/24.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RepoModel.h"

@interface CreateRepo: NSViewController

@property (copy,nonatomic) void (^finishBlock)(RepoModel *repoModel);

@end
