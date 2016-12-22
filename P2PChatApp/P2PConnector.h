//
//  P2PConnector.h
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import <Foundation/Foundation.h>

//////

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface P2PConnector : NSObject <MCSessionDelegate>

//////

@property (nonatomic, strong) MCPeerID *peerID;

@property (nonatomic, strong) MCSession *session;

@property (nonatomic, strong) MCBrowserViewController *browser;

@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

//////

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;

-(void)setupMCBrowser;

-(void)advertiseSelf:(BOOL)shouldAdvertise;

//////

@end
