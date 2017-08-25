//
//  PodDetailVC.m
//  PodManage
//
//  Created by xby on 2017/8/25.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import "PodDetailVC.h"

@interface PodDetailVC ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;


@end

@implementation PodDetailVC

#pragma mark - life cycle
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s  %@",__func__,self);
    
    [self setUpData];
    [self setUpSubView];
    [self setUpConstraint];
    
}
#pragma mark - private

- (void)setUpData {

    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"\n\n==========基本信息============\n\n"];
    [string appendFormat:@"仓库名字：%@\n\n",self.podModel.name];
    [string appendFormat:@"作者：%@\n\n",self.podModel.author];
    [string appendFormat:@"描述信息：%@\n\n",self.podModel.desc];
    [string appendFormat:@"版本：%@\n\n",self.podModel.version];
    [string appendFormat:@"Home地址：%@\n\n",self.podModel.homeUrl];
    [string appendFormat:@"仓库地址：%@\n\n",self.podModel.podUrl];
    [string appendFormat:@"目录：%@\n\n",self.podModel.podDir];
    [string appendString:@"=============================\n\n"];
    
    if (self.podModel.myDependency.count > 0) {
        
        [string appendString:@"==========依赖信息===========\n\n"];
    }
    for (Dependency *depend in self.podModel.myDependency) {
        
        [string appendFormat:@"名字：%@",depend.podName];
        if (depend.version.length > 0) {
            
            [string appendFormat:@"，版本：%@",depend.version];
        }
        if (depend.podSpecUrl.length > 0) {
            
            [string appendFormat:@"，仓库地址：%@",depend.podSpecUrl];
        }
        [string appendString:@"\n"];
    }
    if (self.podModel.myDependency.count > 0) {
        
        [string appendString:@"=============================="];
    }
    self.textView.string = string;
}
- (void)setUpSubView {
    
    
}
- (void)setUpConstraint {
    
    
}

#pragma mark - public

#pragma mark - delegate

#pragma mark - event response

#pragma mark - getters and setters



@end
