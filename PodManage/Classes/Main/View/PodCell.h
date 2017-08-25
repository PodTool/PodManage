//
//  PodCell.h
//  PodManage
//
//  Created by xby on 2017/8/13.
//Copyright © 2017年 wanxue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PodCell;
@protocol PodCellDelegate <NSObject>

@optional;

- (void)podCell:(PodCell *)podCell didClickBtnAtIndex:(NSInteger)index;

@end

@interface PodCell: NSTableCellView

@property (weak) IBOutlet NSTextField *nameLabel;
@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak,nonatomic) id <PodCellDelegate> delegate;
@property (assign,nonatomic) NSInteger row;

@end

