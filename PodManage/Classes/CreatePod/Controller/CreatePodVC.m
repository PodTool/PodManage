//
//  CreatePodVC.m
//  PodManage
//
//  Created by xby on 2017/8/16.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import "CreatePodVC.h"
#import "AddDependenceVC.h"
#import <SSZipArchive/SSZipArchive.h>
#import "DataManager.h"

@interface CreatePodVC ()<NSPathControlDelegate,NSTextFieldDelegate>

@property (weak) IBOutlet NSTextField *repoNameTF;

@property (weak) IBOutlet NSPathControl *pathControl;
@property (unsafe_unretained) IBOutlet NSTextView *dependTextView;
@property (strong,nonatomic) NSArray *dependArray;

@property (weak) IBOutlet NSTextField *podName;
@property (weak) IBOutlet NSTextField *podDesc;
@property (weak) IBOutlet NSTextField *podHomeUrl;
@property (weak) IBOutlet NSTextField *podUrl;

@property (weak) IBOutlet NSButton *kiwiTestF;
@property (weak) IBOutlet NSButton *noneTestF;
@property (weak) IBOutlet NSButton *spectTestF;

@property (copy) NSString *language;
@property (copy) NSString *containsDemo;
@property (copy) NSString *testFrameworks;
@property (copy) NSString *containsViewTest;

@property (unsafe_unretained) IBOutlet NSTextView *resultTextView;
@property (copy,nonatomic) NSMutableString *resultString;

@end

@implementation CreatePodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.repoNameTF.stringValue = self.repoName;
    
    self.language = @"ObjC".lowercaseString;
    self.containsDemo = @"Yes".lowercaseString;
    self.testFrameworks = @"None".lowercaseString;
    self.containsViewTest = @"No".lowercaseString;
    
    self.pathControl.target = self;
    self.pathControl.action = @selector(clickPathControl:);
    self.pathControl.URL = [DataManager sharedInstance].defaultDir;
    
    self.podName.delegate = self;
}
#pragma mark - private
- (void)getExecResult:(NSFileHandle *)fileHandle {

    __weak typeof(self) weakSelf = self;
    [fileHandle setReadabilityHandler:^(NSFileHandle * _Nonnull fileHandler) {
        
        NSData *data = [fileHandler availableData];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"执行结果：%@",text);
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf.resultString appendFormat:@"\n %@",text];
            weakSelf.resultTextView.string = weakSelf.resultString;
            NSRange range = NSMakeRange(weakSelf.resultString.length, 0);
            [weakSelf.resultTextView scrollRangeToVisible:range];
        });
    }];
}
- (void)executeCmd:(NSString *)cmd {
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/bash";
    NSArray *arguments = [NSArray arrayWithObjects:@"-c",cmd, nil];
    task.arguments = arguments;
    
    NSPipe *pipe = [NSPipe pipe];
    task.standardOutput = pipe;
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
    [self getExecResult:fileHandle];
    
    [task launch];
    [task waitUntilExit];
}
- (void)installPodInDir:(NSString *)dir {
    
    NSTask *podInstallAction = [[NSTask alloc] init];
    podInstallAction.currentDirectoryPath = dir;
    podInstallAction.arguments = @[@"install"];
    podInstallAction.launchPath = @"/usr/local/bin/pod";
    
    NSPipe *pipeOut = [NSPipe pipe];
    [podInstallAction setStandardOutput:pipeOut];
    NSFileHandle *fileHandle = [pipeOut fileHandleForReading];
    [self getExecResult:fileHandle];
    [podInstallAction launch];
    [podInstallAction waitUntilExit];
}
- (void)openXCodeWithFile:(NSString *)file {
    
    NSString *shell = [NSString stringWithFormat:@"open '%@'",file];
    system(shell.UTF8String);
}

#pragma mark - event reponse
- (IBAction)languageAction:(NSButton *)sender {
    
    NSLog(@"%@",sender.title);
    if ([sender.title isEqualToString:@"Swift"]) {
        
        self.language = @"Swift".lowercaseString;
        self.kiwiTestF.title = @"Quick";
        self.spectTestF.hidden = YES;
        
    } else {
        
        self.language = @"ObjC".lowercaseString;
        self.kiwiTestF.title = @"Kiwi";
        self.spectTestF.hidden = NO;
    }
    self.noneTestF.state = 1;
    [self testFrameworksAction:self.noneTestF];
}
- (IBAction)testFrameworksAction:(NSButton *)sender {
    
    NSLog(@"%@",sender.title);
    self.testFrameworks = sender.title.lowercaseString;
}
- (IBAction)viewTestAction:(NSButton *)sender {
    
    NSLog(@"%@",sender.title);
    self.containsViewTest = sender.title.lowercaseString;
}

- (IBAction)finishAction:(NSButton *)sender {
    
    NSString *podName = self.podName.stringValue;
    NSString *podDesc = self.podDesc.stringValue;
    if (podDesc.length == 0) {
        
        podDesc = [NSString stringWithFormat:@"%@ 's Desc",podName];
    }
    NSString *homeUrl = self.podHomeUrl.stringValue;
    NSString *podUrl = self.podUrl.stringValue;
    NSString *podDir = [self.pathControl.URL.absoluteString substringFromIndex:7];
    
    NSString *messageText;
    if (podName.length == 0) {
        
        messageText = @"请输入pod仓库名字";
    }
    if (homeUrl.length == 0) {
        
        messageText = @"请输入pod仓库 HomeUrl";
    }
    if (podUrl.length == 0) {
        
        messageText = @"请输入pod仓库 url";
    }
    NSString *toPath = [podDir stringByAppendingPathComponent:podName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:toPath]) {
        
        messageText = @"目录已存在，请重新命名";
    }
    NSString *dependSpilt = @"@!@#";
    NSMutableArray *podArray = [[NSMutableArray alloc] init];
    NSMutableArray *podUrlArray = [[NSMutableArray alloc] init];
    for (Dependency *depend in self.dependArray) {
        
        NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%@",depend.podName];
        if (depend.version.length > 0) {
            
            [string appendFormat:@",%@",depend.version];
        }
        [podArray addObject:string];
        if (depend.podSpecUrl.length > 0 && ![depend.podSpecUrl isEqualToString:@"https://github.com/CocoaPods/Specs.git"] && ![podUrlArray containsObject:depend.podSpecUrl]) {
            
            [podUrlArray addObject:depend.podSpecUrl];
        }
    }
    NSString *podString = [podArray componentsJoinedByString:dependSpilt];
    podString = podString ? podString : @"";
    NSString *podSpecUrlString = [podUrlArray componentsJoinedByString:dependSpilt];
    podSpecUrlString = podSpecUrlString ? podSpecUrlString : @"";
    
    if (messageText.length > 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = messageText;
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"__PodTemplate__" ofType:@".zip"];
    [SSZipArchive unzipFileAtPath:filePath toDestination:podDir];
    //删除多余的文件
    NSString *trashFile = [podDir stringByAppendingPathComponent:@"__MACOSX"];
    [fileManager removeItemAtPath:trashFile error:nil];
    NSString *originPath = [podDir stringByAppendingPathComponent:@"__PodTemplate__"];
    //重命名
    NSError *removeError = nil;
    [fileManager moveItemAtPath:originPath toPath:toPath error:&removeError];
    if (removeError) {

        NSLog(@"重命名失败：%@",removeError);
    }
    NSString *userName = [DataManager sharedInstance].userName;
    NSString *userEmail = [DataManager sharedInstance].userEmail;
    NSString *prefix = [DataManager sharedInstance].prefix;
    
    NSString *spilt = @"==!@#==";
    NSString *argu = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",userName,spilt,userEmail,spilt,podName,spilt,podDesc,spilt,homeUrl,spilt,podUrl,spilt,self.language,spilt,self.containsDemo,spilt,self.testFrameworks,spilt,self.containsViewTest,spilt,prefix,spilt,podString,spilt,podSpecUrlString];
    NSLog(@"目录:%@",podDir);
    NSLog(@"%@",argu);
    //执行脚本
    NSString *shell = [NSString stringWithFormat:@"cd %@;ruby configure '%@';",toPath,argu];
    [self executeCmd:shell];
    NSString *example = [NSString stringWithFormat:@"%@/Example",toPath];
    [self installPodInDir:example];
    //打开XCode
    NSString *workSpaceFile = [NSString stringWithFormat:@"%@/%@.xcworkspace",example,podName];
    [self openXCodeWithFile:workSpaceFile];
    
    //保存创建的目录
    [[DataManager sharedInstance] saveDefaultDir:podDir];
    
    PodModel *podModel = [[PodModel alloc] init];
    
    podModel.author = userName;
    podModel.name = podName;
    podModel.desc = podDesc;
    podModel.version = @"0.1.0";
    podModel.homeUrl = homeUrl;
    podModel.podUrl = podUrl;
    podModel.podDir = podDir;
    podModel.myDependency = [[NSMutableArray alloc] initWithArray:self.dependArray];
    
    if (self.finishBlock) {
        
        self.finishBlock(podModel);
    }
    [self.presentingViewController dismissViewController:self];
}
- (IBAction)addDependencyAcion:(NSButton *)sender {
    
    AddDependenceVC *addDenpend = [[AddDependenceVC alloc] initWithNibName:nil bundle:nil];
    addDenpend.originDataArray = self.dependArray;
    __weak typeof(self) weakSelf = self;
    addDenpend.finishBlock = ^(NSArray<Dependency *> *dataArray) {
        
        weakSelf.dependArray = dataArray;
    };
    [self presentViewControllerAsSheet:addDenpend];
}
#pragma mark - NSTextFieldDelegate
- (void)controlTextDidChange:(NSNotification *)obj {
    
    self.podDesc.stringValue = [NSString stringWithFormat:@"%@ desc Information",self.podName.stringValue];
}
#pragma mark - NSPathControlDelegate
- (void)clickPathControl:(NSPathControl *)pathControl {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:pathControl.pathItems];
    NSPathControlItem *clickItem = pathControl.clickedPathItem;
    NSInteger location = 0;
    for (NSInteger i = 0;i < array.count;i++) {
        
        NSPathControlItem *item = array[i];
        if ([item.URL.absoluteString isEqualToString:clickItem.URL.absoluteString]) {
            
            location = i;
            break;
        }
    }
    [array removeObjectAtIndex:location];
    [array addObject:clickItem];
    pathControl.pathItems = array;
    pathControl.URL = clickItem.URL;
}
- (void)pathControl:(NSPathControl *)pathControl willDisplayOpenPanel:(NSOpenPanel *)openPanel {
    
    openPanel.allowsMultipleSelection = NO;
    openPanel.message = @"选择创建pod的目录";
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.prompt = @"选择";
    openPanel.title = @"选择目录";
    
    NSString *deskTop = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject;
    openPanel.directoryURL = [NSURL fileURLWithPath:deskTop];
}
#pragma mark - getters and setters
- (void)setDependArray:(NSArray *)dependArray {
    
    _dependArray = dependArray;
    NSMutableString *dependString = [[NSMutableString alloc] init];
    for (Dependency *depend in dependArray) {
        
        NSString *podName = depend.podName;
        NSString *version = depend.version;
        NSString *url = depend.podSpecUrl;
        [dependString appendFormat:@"\n%@  %@  %@",podName,version,url];
    }
    self.dependTextView.string = dependString;
}
- (NSMutableString *)resultString {

    if (!_resultString) {
        
        _resultString = [[NSMutableString alloc] init];
    }
    return _resultString;
}

@end
