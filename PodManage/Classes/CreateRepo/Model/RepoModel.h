//
//  RepoModel.h
//  PodManage
//
//  Created by xby on 2017/8/24.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@class PodModel;
@interface RepoModel: NSObject

@property (copy,nonatomic) NSString *repoName;
@property (copy,nonatomic) NSString *repoUrl;
@property (strong,nonatomic) NSMutableArray<PodModel *> *children;

@end
