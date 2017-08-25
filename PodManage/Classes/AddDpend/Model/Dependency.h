//
//  Dependency.h
//  PodManage
//
//  Created by xby on 2017/8/17.
//Copyright © 2017年 wanxue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface Dependency: NSObject

@property (copy,nonatomic) NSString *podName;
@property (copy,nonatomic) NSString *podSpecUrl;
@property (copy,nonatomic) NSString *version;


@end
