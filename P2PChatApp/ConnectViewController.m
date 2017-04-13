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


/////
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;
/////
/////
@property(nonatomic, strong) NSMutableArray *arrConnectedDevices;
/////
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
    
    //////
    [_userDeviceName setDelegate:self];
    //////
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:@"MCDidChangeStateNotification" object:nil];
    //////
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    [_foundedUsers setDelegate:self];
    [_foundedUsers setDataSource:self];
    /////
}
/////
/////
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrConnectedDevices count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
/////
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    /////
    if (state != MCSessionStateConnecting) {
    /////
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerDisplayName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                long int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
            }
        }
    }
        [_foundedUsers reloadData];
        
        BOOL peersExist = ([[_appDelegate.p2pConnector.session connectedPeers] count] == 0);
        [_disconnectDeviceButton setEnabled:!peersExist];
        [_userDeviceName setEnabled:peersExist];
    }
    /////
}
/////
-(BOOL)textFieldShouldReturn:(UITextField *) textField{
    [_userDeviceName resignFirstResponder];
    
    _appDelegate.p2pConnector.peerID = nil;
    _appDelegate.p2pConnector.session = nil;
    _appDelegate.p2pConnector.browser = nil;
    
    if ([_switchVisible isOn]) {
        [_appDelegate.p2pConnector.advertiser stop];
    }
    _appDelegate.p2pConnector.advertiser = nil;
    
    [_appDelegate.p2pConnector setupPeerAndSessionWithDisplayName: _userDeviceName.text];
    [_appDelegate.p2pConnector setupMCBrowser];
    [_appDelegate.p2pConnector advertiseSelf:_switchVisible.isOn];
    
    return YES;
}
    /////

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
    /////
- (IBAction)ToggleVisibility:(id)sender {
    [_appDelegate.p2pConnector advertiseSelf:_switchVisible.isOn];
}
    /////
/////
- (IBAction)disconnect:(id)sender {
    [_appDelegate.p2pConnector.session disconnect];
    
    _userDeviceName.enabled = YES;
    
    [_arrConnectedDevices removeAllObjects];
    [_foundedUsers reloadData];
}
/////
@end
