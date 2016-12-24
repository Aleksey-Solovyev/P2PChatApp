//
//  ConnectViewController.m
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import "ConnectViewController.h"

//////
#import "AppDelegate.h"

//////

@interface ConnectViewController ()

//////
@property (nonatomic, strong) AppDelegate *appDelegate;
//////

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //////
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate p2pConnector] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate p2pConnector] advertiseSelf:_switchVisible.isOn];
    //////
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

//////


- (IBAction)searchUsersButton:(id)sender {
    [[_appDelegate p2pConnector] setupMCBrowser];
    [[[_appDelegate p2pConnector] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate p2pConnector] browser] animated:YES completion:nil];
}
//////

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.p2pConnector.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.p2pConnector.browser dismissViewControllerAnimated:YES completion:nil];
}

//////

- (IBAction)switchVisible:(UISwitch *)sender {
}

//- (IBAction)searchUsersButton:(UIButton *)sender {
//}

- (IBAction)disconnectUserButton:(UIButton *)sender {
}
@end
