//
//  AddDependenceVC.m
//  PodManage
//
//  Created by xby on 2017/8/16.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import "AddDependenceVC.h"

#import "PodNameCell.h"
#import "PodUrlCell.h"
#import "PodVersionCell.h"
#import "PodDeleteCell.h"


@interface AddDependenceVC ()<NSTableViewDelegate,NSTableViewDataSource,PodDeleteCellDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *podNameField;
@property (weak) IBOutlet NSTextField *versionField;
@property (weak) IBOutlet NSTextField *specFielUrl;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak) IBOutlet NSButton *addBtn;

@end

@implementation AddDependenceVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpData];
}
#pragma mark - private
- (void)setUpData {
    
    [self.dataArray addObjectsFromArray:self.originDataArray];
    [self.tableView reloadData];
}
#pragma mark - PodDeleteCellDelegate
- (void)didClickDeleteBtnAtCell:(PodDeleteCell *)cell {
    
    NSInteger row = cell.row;
    [self.dataArray removeObjectAtIndex:cell.row];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:row];
    [self.tableView removeRowsAtIndexes:set withAnimation:NSTableViewAnimationEffectFade];
}
#pragma mark - NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.dataArray.count;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    
    Dependency *depend = self.dataArray[row];
    
    NSString *columnIdentifier = tableColumn.identifier;
    if ([columnIdentifier isEqualToString:@"podNameClo"]) {
        
        PodNameCell *cell = [tableView makeViewWithIdentifier:@"podNameCell" owner:nil];
        cell.titleLabel.stringValue = depend.podName;
        return cell;
        
    } else if ([columnIdentifier isEqualToString:@"podUrlClo"]) {
        
        PodUrlCell *cell = [tableView makeViewWithIdentifier:@"podUrlCell" owner:nil];
        cell.titleLabel.stringValue = depend.podSpecUrl;
        return cell;

    } else if ([columnIdentifier isEqualToString:@"podVersionClo"]) {
        
        PodVersionCell *cell = [tableView makeViewWithIdentifier:@"podVersionCell" owner:nil];
        cell.titleLabel.stringValue = depend.version;
        return cell;
        
    } else {
        
        PodDeleteCell *cell = [tableView makeViewWithIdentifier:@"podDeleteCell" owner:nil];
        cell.delegate = self;
        cell.row = row;
        return cell;
    }
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    Dependency *depend = self.dataArray[row];
    
    self.podNameField.stringValue = depend.podName;
    self.specFielUrl.stringValue = depend.podSpecUrl;
    self.versionField.stringValue = depend.version;
    self.addBtn.title = @"修改";
    
    return YES;
}
#pragma mark - event response
- (IBAction)addAction:(NSButton *)sender {
    
    NSString *podName = self.podNameField.stringValue;
    NSString *version = self.versionField.stringValue;
    NSString *repoUrl = self.specFielUrl.stringValue;
    
    NSString *alertMessage;
    if (podName.length == 0) {
        
        alertMessage = @"仓库名字不能为空";
    }
    if (alertMessage.length > 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = alertMessage;
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    for (NSInteger i = 0;i < self.dataArray.count;i++) {
        
        Dependency *depend = self.dataArray[i];
        
        NSString *name = depend.podName;
        if ([name isEqualToString:podName]) {
            
            depend.version = version;
            depend.podSpecUrl = repoUrl;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:i];
            NSIndexSet *columnSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
            [self.tableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
            return;
        }
    }
    Dependency *depend = [[Dependency alloc] init];
    depend.podName = podName;
    depend.version = version;
    depend.podSpecUrl = repoUrl;
    
    [self.dataArray insertObject:depend atIndex:0];
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [self.tableView insertRowsAtIndexes:set withAnimation:NSTableViewAnimationSlideUp];
    
    self.podNameField.stringValue = @"";
    self.specFielUrl.stringValue = @"";
    self.versionField.stringValue = @"";
    
    self.addBtn.title = @"添加";
}
- (IBAction)finishAction:(NSButton *)sender {
    
    if (self.finishBlock) {
        
        self.finishBlock(self.dataArray);
    }
    [self.presentingViewController dismissViewController:self];
}
#pragma mark - getters and setters
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
