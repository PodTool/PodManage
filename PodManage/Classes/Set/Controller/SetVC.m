//
//  SetVC.m
//  PodManage
//
//  Created by xby on 2017/8/19.
//Copyright © 2017年 wanxue. All rights reserved.
//

#import "SetVC.h"
#import "DataManager.h"

@interface SetVC ()

@property (weak) IBOutlet NSTextField *userNameTF;
@property (weak) IBOutlet NSTextField *emailTF;
@property (weak) IBOutlet NSTextField *demoPrefix;



@end

@implementation SetVC

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

#pragma mark - public

#pragma mark - delegate

#pragma mark - event response

- (IBAction)saveAction:(NSButton *)sender {
    
    [[DataManager sharedInstance] saveUserName:self.userNameTF.stringValue];
    [[DataManager sharedInstance] saveUserEmail:self.emailTF.stringValue];
    [[DataManager sharedInstance] savePrefix:self.demoPrefix.stringValue];
}
#pragma mark - getters and setters



@end
