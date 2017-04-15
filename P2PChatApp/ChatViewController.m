//
//  ChatViewController.m
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import "ChatViewController.h"
/////
#import "AppDelegate.h"
/////
@interface ChatViewController ()
/////
@property (nonatomic, strong) AppDelegate *appDelegate;

-(void)sendMyMessage;

-(void)didReceiveDataWithNotification:(NSNotification *)notification;
/////
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /////
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    /////
    _textMessage.delegate = self;
    /////
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:@"MCDidReceiveDataNotification" object:nil];
}

/////
-(void) sendMyMessage{
    NSData *dataToSend = [_textMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.p2pConnector.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.p2pConnector.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [_textChat setText:[_textChat.text stringByAppendingString:[NSString stringWithFormat:@"Me:\n%@\n\n", _textMessage.text]]];
    [_textMessage setText:@""];
    [_textMessage resignFirstResponder];
}
/////
-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [_textChat performSelectorOnMainThread:@selector(setText:) withObject:[_textChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote: \n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}
/////
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMyMessage];
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

- (IBAction)sendMessage:(id)sender {
    /////
    [self sendMyMessage];
    /////
}

- (IBAction)cancelMessage:(id)sender {
    /////
    [_textMessage resignFirstResponder];
    /////
}
@end
