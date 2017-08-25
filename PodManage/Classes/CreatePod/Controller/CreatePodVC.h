//
//  CreatePodVC.h
//  PodManage
//
//  Created by xby on 2017/8/16.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PodModel.h"

@interface CreatePodVC : NSViewController

@property (copy,nonatomic) NSString *repoName;
@property (copy,nonatomic) void (^finishBlock)(PodModel *podModel);

@end
