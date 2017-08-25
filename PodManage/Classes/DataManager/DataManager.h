//
//  DataManager.h
//  PodManage
//
//  Created by xby on 2017/8/19.
//Copyright © 2017年 wanxue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoModel.h"

extern NSString *const SSUserNameKey;
extern NSString *const SSUserEmailKey;
extern NSString *const SSDemoPrefix;
extern NSString *const SSDefaultDir;

@interface DataManager: NSObject

+ (instancetype)sharedInstance;

///作者
@property (copy,nonatomic) NSString *userName;
///作者邮箱
@property (copy,nonatomic) NSString *userEmail;
///demo里面类的前缀
@property (copy,nonatomic) NSString *prefix;
///所有的repo仓库
@property (strong,nonatomic) NSMutableArray<RepoModel *> *repoDataArray;
///创建repo仓库默认的目录,默认是上一次创建pod的目录，如果上一次没有，则是桌面
@property (strong,nonatomic) NSURL *defaultDir;
///保存作者的名字
- (void)saveUserName:(NSString *)userName;
///保存作者的邮箱
- (void)saveUserEmail:(NSString *)userEmail;
///保存类的前缀
- (void)savePrefix:(NSString *)prefix;
///保存上次用过的目录
- (void)saveDefaultDir:(NSString *)dir;
///保存repo 和 pod 的数据
- (void)saveRepoData;
///清除repoData
- (void)cleanRepoData;

@end
