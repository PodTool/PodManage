//
//  DataManager.m
//  PodManage
//
//  Created by xby on 2017/8/19.
//Copyright © 2017年 wanxue. All rights reserved.
//
#import "DataManager.h"

NSString *const SSUserNameKey = @"SSUserNameKey";
NSString *const SSUserEmailKey = @"SSUserEmailKey";
NSString *const SSDemoPrefix = @"SSDemoPrefix";
NSString *const SSDefaultDir = @"SSDefaultDir";

#define kRepoDataPath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"repoData.archive"]

@interface DataManager ()

@end

@implementation DataManager


#pragma mark - life cycle
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static DataManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}


#pragma mark - private

#pragma mark - public
///设置作者名字，会保存到沙盒中
- (void)saveUserName:(NSString *)userName {
    
    if (userName.length == 0) {
        
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:SSUserNameKey];
    self.userName = userName;
}
///设置作者邮箱，会保存到沙盒中
- (void)saveUserEmail:(NSString *)userEmail {
    
    if (userEmail.length == 0) {
        
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userEmail forKey:SSUserEmailKey];
    self.userEmail = userEmail;
}
///设置类的前缀，会保存到沙盒中
- (void)savePrefix:(NSString *)prefix {
    
    if (prefix.length == 0) {
        
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:prefix forKey:SSDemoPrefix];
    self.prefix = prefix;
}
///保存上次用过的目录
- (void)saveDefaultDir:(NSString *)dir {
    
    if (dir.length == 0) {
        
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dir forKey:SSDefaultDir];
    self.defaultDir = [NSURL fileURLWithPath:dir];
}
///保存repo 和 pod 的数据
- (void)saveRepoData {

    if (self.repoDataArray.count == 0) {
        
        return;
    }
    [NSKeyedArchiver archiveRootObject:self.repoDataArray toFile:kRepoDataPath];
}
///清除repoData
- (void)cleanRepoData {

    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:kRepoDataPath error:nil];
}
#pragma mark - delegate

#pragma mark - event response

#pragma mark - getters and setters
- (NSString *)userName {
    
    if (!_userName) {
        
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:SSUserNameKey];
        _userName = _userName ? _userName : @"defaultUserName";
    }
    return _userName;
}
- (NSString *)userEmail {
    
    if (!_userEmail) {
        
        _userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:SSUserEmailKey];
        _userEmail = _userEmail ? _userEmail : @"defaultUserEmail";
    }
    return _userEmail;
}
- (NSString *)prefix {
    
    if (!_prefix) {
        
        _prefix = [[NSUserDefaults standardUserDefaults] objectForKey:SSDemoPrefix];
        _prefix = _prefix ? _prefix : @"XX";
    }
    return _prefix;
}
- (NSURL *)defaultDir {
    
    if (!_defaultDir) {
        
        NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:SSDefaultDir];
        if (string) {
            
            _defaultDir = [NSURL fileURLWithPath:string];
            
        } else {
            
            NSString *deskTop = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES).firstObject;
            _defaultDir = [NSURL fileURLWithPath:deskTop];
        }
    }
    return _defaultDir;
}
- (NSMutableArray *)repoDataArray {
    
    if (!_repoDataArray) {
        
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:kRepoDataPath];;
        _repoDataArray = [[NSMutableArray alloc] initWithArray:array];
    }
    return _repoDataArray;
}

@end
