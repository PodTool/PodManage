//
//  CreateRepo.m
//  PodManage
//
//  Created by xby on 2017/8/24.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import "CreateRepo.h"
#import "DataManager.h"

@interface CreateRepo ()

@property (weak) IBOutlet NSTextField *nameTF;
@property (weak) IBOutlet NSTextFieldCell *urlTF;

@end

@implementation CreateRepo

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

    
}
- (void)setUpSubView {
    
    
}
- (void)setUpConstraint {
    
    
}
- (void)createRepoWithName:(NSString *)repoName url:(NSString *)url {
    
    NSTask *podInstallAction = [[NSTask alloc] init];
    podInstallAction.arguments = @[@"repo",@"add",repoName,url];
    podInstallAction.launchPath = @"/usr/local/bin/pod";
    
    NSPipe *pipeOut = [NSPipe pipe];
    [podInstallAction setStandardOutput:pipeOut];
    NSFileHandle *output = [pipeOut fileHandleForReading];
    
    [output setReadabilityHandler:^(NSFileHandle * _Nonnull fileHandler) {
        NSData *data = [fileHandler availableData];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"text is %@", text);
    }];
    
    [podInstallAction launch];
    [podInstallAction waitUntilExit];
}

#pragma mark - public

#pragma mark - delegate

#pragma mark - event response
- (IBAction)finishAction:(NSButton *)sender {
    
    NSString *messageText;
    if (self.nameTF.stringValue.length == 0) {
        
        messageText = @"仓库名字不能为空";
    }
    if (self.urlTF.stringValue.length == 0) {
        
        messageText = @"仓库地址不能为空";
    }
    if (messageText.length > 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = messageText;
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    [self createRepoWithName:self.nameTF.stringValue url:self.urlTF.stringValue];
    if (self.finishBlock) {
        
        RepoModel *repoModel = [[RepoModel alloc] init];
        repoModel.repoName = self.nameTF.stringValue;
        repoModel.repoUrl = self.urlTF.stringValue;
        
        self.finishBlock(repoModel);
    }
    [self.presentingViewController dismissViewController:self];
}
#pragma mark - getters and setters



@end
