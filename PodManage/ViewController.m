//
//  ViewController.m
//  PodManage
//
//  Created by xby on 2017/8/5.
//  Copyright © 2017年 wanxue. All rights reserved.
//

#import "ViewController.h"
#import <SSZipArchive/SSZipArchive.h>

NSString *const SSUserNameKey = @"SSUserNameKey";
NSString *const SSUserEmailKey = @"SSUserEmailKey";
NSString *const SSPodDirKey = @"SSPodDirKey";


@interface ViewController ()

@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSTextField *userEmail;
@property (weak) IBOutlet NSTextField *podName;
@property (weak) IBOutlet NSTextField *podDesc;
@property (weak) IBOutlet NSTextField *podHomeUrl;
@property (weak) IBOutlet NSTextField *podUrl;
@property (weak) IBOutlet NSTextField *prefix;
@property (weak) IBOutlet NSTextField *podDir;

@property (weak) IBOutlet NSButton *kiwiTestF;
@property (weak) IBOutlet NSButton *noneTestF;
@property (weak) IBOutlet NSButton *spectTestF;

@property (copy) NSString *language;
@property (copy) NSString *containsDemo;
@property (copy) NSString *testFrameworks;
@property (copy) NSString *containsViewTest;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.language = @"ObjC".lowercaseString;
    self.containsDemo = @"Yes".lowercaseString;
    self.testFrameworks = @"None".lowercaseString;
    self.containsViewTest = @"No".lowercaseString;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cacheName = [defaults objectForKey:SSUserNameKey];
    if (cacheName) {
        
        self.userName.stringValue = cacheName;
    }
    NSString *cacheEmail = [defaults objectForKey:SSUserEmailKey];
    if (cacheEmail) {
        
        self.userEmail.stringValue = cacheEmail;
    }
    NSString *podDir = [defaults objectForKey:SSPodDirKey];
    if (podDir) {
        
        self.podDir.stringValue = podDir;
    }
}
#pragma mark - NSTextFieldDelegate
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
- (IBAction)demoAction:(NSButton *)sender {
    
    NSLog(@"%@",sender.title);
    self.containsDemo = sender.title.lowercaseString;

}
- (IBAction)testFrameworksAction:(NSButton *)sender {
    
    NSLog(@"%@",sender.title);
    self.testFrameworks = sender.title.lowercaseString;

}
- (IBAction)viewTestAction:(NSButton *)sender {
    
    NSLog(@"%@",sender.title);
    self.containsViewTest = sender.title.lowercaseString;

}
- (IBAction)comfirmAction:(NSButton *)sender {
    
    NSString *userName = self.userName.stringValue;
    NSString *userEmail = self.userEmail.stringValue;
    NSString *podName = self.podName.stringValue;
    NSString *podDesc = self.podDesc.stringValue;
    NSString *homeUrl = self.podHomeUrl.stringValue;
    NSString *podUrl = self.podUrl.stringValue;
    NSString *podDir = self.podDir.stringValue;
    
    
    NSString *messageText;
    if (userName.length == 0) {
        
        messageText = @"请输入用户名";
    }
    if (userEmail.length == 0) {
        
        messageText = @"请输入邮箱";
    }
    if (podName.length == 0) {
        
        messageText = @"请输入pod仓库名字";
    }
    if (podDesc.length == 0) {
        
        messageText = @"请输入pod仓库描述信息";
    }
    if (homeUrl.length == 0) {
        
        messageText = @"请输入pod仓库 HomeUrl";
    }
    if (podUrl.length == 0) {
        
        messageText = @"请输入pod仓库 url";
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (podDir.length == 0) {
        
        messageText = @"请输入pod 的创建目录";
        
    } else {
    
        BOOL isDir;
        if ([fileManager fileExistsAtPath:podDir isDirectory:&isDir]) {
            
            if (!isDir) {
                
                messageText = @"pod 目录不是一个目录";
            }
            
        } else {
        
            messageText = @"pod 目录不存在";
        }
    }
    if (messageText.length > 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = messageText;
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    //保存用户名和密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:SSUserNameKey];
    [defaults setObject:userEmail forKey:SSUserEmailKey];
    [defaults setObject:podDir forKey:SSPodDirKey];
    [defaults synchronize];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"__PodTemplate__" ofType:@".zip"];
    NSString *toPath = [podDir stringByAppendingPathComponent:podName];
    if ([fileManager fileExistsAtPath:toPath]) {
        
        NSLog(@"目录已存在，请重新命名");
        return;
    }
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
    NSString *spilt = @"==!@#==";
    NSString *argu = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",userName,spilt,userEmail,spilt,podName,spilt,podDesc,spilt,homeUrl,spilt,podUrl,spilt,self.language,spilt,self.containsDemo,spilt,self.testFrameworks,spilt,self.containsViewTest,spilt,self.prefix.stringValue];
    NSLog(@"%@",argu);
    //执行脚本
    NSString *shell = [NSString stringWithFormat:@"cd %@;ruby configure '%@';",toPath,argu];
    [self executeCmd:shell];
    NSString *example = [NSString stringWithFormat:@"%@/Example",toPath];
    [self installPodInDir:example];
    //打开XCode
    NSString *workSpaceFile = [NSString stringWithFormat:@"%@/%@.xcworkspace",example,podName];
    [self openXCodeWithFile:workSpaceFile];
}
- (void)openXCodeWithFile:(NSString *)file {

    NSString *shell = [NSString stringWithFormat:@"open '%@'",file];
    system(shell.UTF8String);
}
- (void)installPodInDir:(NSString *)dir {

    NSTask *podInstallAction = [[NSTask alloc] init];
    podInstallAction.currentDirectoryPath = dir;
    podInstallAction.arguments = @[@"install"];
    podInstallAction.launchPath = @"/usr/local/bin/pod";
    
    NSPipe *pipeOut = [NSPipe pipe];
    [podInstallAction setStandardOutput:pipeOut];
    NSFileHandle *output = [pipeOut fileHandleForReading];
    
    [output setReadabilityHandler:^(NSFileHandle * _Nonnull fileHandler) {
        NSData *data = [fileHandler availableData];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"text is %@", text);
    }];
    
    [podInstallAction launch];
    [podInstallAction waitUntilExit];
}
- (void)executeCmd:(NSString *)cmd {

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/bash";
    NSArray *arguments = [NSArray arrayWithObjects:@"-c",cmd, nil];
    task.arguments = arguments;
    
    NSPipe *pipe = [NSPipe pipe];
    task.standardOutput = pipe;
    NSFileHandle *file = [pipe fileHandleForReading];
    [file setReadabilityHandler:^(NSFileHandle * _Nonnull fileHandler) {
        NSData *data = [fileHandler availableData];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSLog(@"text is %@", text);
    }];
    
    [task launch];
    [task waitUntilExit];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
