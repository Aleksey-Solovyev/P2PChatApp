//
//  FileViewController.m
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import "FileViewController.h"
/////
#import "AppDelegate.h"
/////

@interface FileViewController ()
/////
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *documentsDirectory;
-(void) copySampleFilesToDocDirIfNeeded;
/////
@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /////
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
