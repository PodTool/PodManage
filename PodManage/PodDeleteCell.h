//
//  PodDeleteCell.h
//  PodManage
//
//  Created by xby on 2017/8/18.
//Copyright © 2017年 wanxue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PodDeleteCell;
@protocol PodDeleteCellDelegate<NSObject>

- (void)didClickDeleteBtnAtCell:(PodDeleteCell *)cell;

@end


@interface PodDeleteCell: NSTableCellView

@property (weak,nonatomic) id <PodDeleteCellDelegate> delegate;
@property (assign,nonatomic) NSInteger row;

@end


