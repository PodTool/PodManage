//
//  MainController.m
//  PodManage
//
//  Created by xby on 2017/8/9.
//Copyright © 2017年 wanxue. All rights reserved.
//

#import "MainController.h"
#import "RepoCell.h"
#import "PodCell.h"
#import "CreatePodVC.h"

@interface MainController ()<NSTableViewDataSource,NSTableViewDelegate>

@property (strong,nonatomic) NSArray *dataArray;
@property (weak) IBOutlet NSTableView *repoTableView;
@property (weak) IBOutlet NSTableView *podTableView;

@end

@implementation MainController

#pragma mark - life cycle
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    [self setUpSubView];
    [self setUpConstraint];
    
}
#pragma mark - private

- (void)setUpData {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 10; i++) {
        
        NSString *string = [NSString stringWithFormat:@"testData_%zd",i];
        [tempArray addObject:string];
    }
    self.dataArray = tempArray;
    [self.repoTableView reloadData];
}
- (void)setUpSubView {
    
    
}
- (void)setUpConstraint {
    
    
}

#pragma mark - public

#pragma mark - delegate
#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.dataArray.count;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableView == self.repoTableView) {

        RepoCell *cell = [tableView makeViewWithIdentifier:@"repoCell" owner:nil];
        cell.title = self.dataArray[row];
        return cell;

    } else {

        PodCell *cell = [tableView makeViewWithIdentifier:@"podCell" owner:nil];
        return cell;
    }
}

#pragma mark - event response

- (IBAction)createRepoAction:(NSButton *)sender {
    
    
}
- (IBAction)createPodAction:(NSButton *)sender {
    
    NSViewController *vc = [[CreatePodVC alloc] initWithNibName:nil bundle:nil];
    [self presentViewControllerAsModalWindow:vc];
}
#pragma mark - getters and setters


@end
