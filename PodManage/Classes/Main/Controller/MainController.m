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
#import "CreateRepo.h"
#import "PodDetailVC.h"

#import "DataManager.h"

#import "RepoModel.h"
#import "PodModel.h"

@interface MainController ()<NSTableViewDataSource,NSTableViewDelegate,PodCellDelegate>

@property (weak) IBOutlet NSTableView *repoTableView;
@property (weak) IBOutlet NSTableView *podTableView;
///当前选中的repo仓库
@property (strong,nonatomic) RepoModel *selectRepo;


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
    
    [self.repoTableView reloadData];
    if ([DataManager sharedInstance].repoDataArray.count > 0) {
        
        self.selectRepo = [DataManager sharedInstance].repoDataArray.firstObject;
        [self.podTableView reloadData];
    }
}
- (void)setUpSubView {
    
    
}
- (void)setUpConstraint {
    
    
}

#pragma mark - public

#pragma mark - delegate
#pragma mark - PodCellDelegate
- (void)podCell:(PodCell *)podCell didClickBtnAtIndex:(NSInteger)index {

    if (index == 1) {
        
        PodDetailVC *detailVC = [[PodDetailVC alloc] init];
        PodModel *podModel = self.selectRepo.children[podCell.row];
        detailVC.podModel = podModel;
        [self presentViewControllerAsModalWindow:detailVC];
    }
}
#pragma mark - NSTableViewDataSource
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {

    if (tableView == self.repoTableView) {
        
        return 44;
        
    } else {
    
        return 76;
    }
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    if (tableView == self.repoTableView) {
        
        return [DataManager sharedInstance].repoDataArray.count;
        
    } else if (tableView == self.podTableView) {
        
        return self.selectRepo.children.count;
    }
    return 0;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableView == self.repoTableView) {

        RepoCell *cell = [tableView makeViewWithIdentifier:@"repoCell" owner:nil];
        RepoModel *repo = [DataManager sharedInstance].repoDataArray[row];
        cell.title = repo.repoName;
        
        return cell;

    } else {

        PodCell *cell = [tableView makeViewWithIdentifier:@"podCell" owner:nil];
        cell.row = row;
        cell.delegate = self;
        PodModel *podModel = self.selectRepo.children[row];
        
        cell.nameLabel.stringValue = podModel.name;
        cell.versionLabel.stringValue = podModel.version;
        
        return cell;
    }
}
#pragma mark - NSTableViewDelegate
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    if (tableView == self.repoTableView) {
        
        self.selectRepo = [DataManager sharedInstance].repoDataArray[row];
        [self.podTableView reloadData];
    }
    return YES;
}
#pragma mark - event response

- (IBAction)createRepoAction:(NSButton *)sender {
    
    CreateRepo *vc = [[CreateRepo alloc] initWithNibName:nil bundle:nil];
    __weak typeof(self) weakSelf = self;
    vc.finishBlock = ^(RepoModel *repoModel) {
      
        [[DataManager sharedInstance].repoDataArray addObject:repoModel];
        if (!weakSelf.selectRepo) {
            
            weakSelf.selectRepo = [DataManager sharedInstance].repoDataArray.firstObject;
        }
        [weakSelf.repoTableView reloadData];
        [[DataManager sharedInstance] saveRepoData];
    };
    [self presentViewControllerAsModalWindow:vc];
}
- (IBAction)createPodAction:(NSButton *)sender {
    
    NSString *messageText = @"";
    if (!self.selectRepo) {
        
        messageText = @"请先创建Repo仓库";
    }
    if (messageText.length > 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = messageText;
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    CreatePodVC *vc = [[CreatePodVC alloc] initWithNibName:nil bundle:nil];
    vc.repoName = self.selectRepo.repoName;
    __weak typeof(self) weakSelf = self;
    vc.finishBlock = ^(PodModel *podModel) {
      
        [weakSelf.selectRepo.children addObject:podModel];
        [weakSelf.podTableView reloadData];
        [[DataManager sharedInstance] saveRepoData];
    };
    [self presentViewControllerAsModalWindow:vc];
}
#pragma mark - getters and setters


@end
