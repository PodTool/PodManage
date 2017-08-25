//
//  PodModel.h
//  PodManage
//
//  Created by xby on 2017/8/24.
//Copyright © 2017年 wanxue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>


@interface PodModel: NSObject

@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *author;
@property (copy,nonatomic) NSString *desc;
@property (copy,nonatomic) NSString *version;
@property (copy,nonatomic) NSString *homeUrl;
@property (copy,nonatomic) NSString *podUrl;
@property (copy,nonatomic) NSString *podDir;
@property (strong,nonatomic) NSMutableArray *myDependency;

@end
