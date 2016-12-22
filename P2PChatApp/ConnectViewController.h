//
//  ConnectViewController.h
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectViewController : UIViewController

//////

@property (weak, nonatomic) IBOutlet UITextField *userDeviceName;

@property (weak, nonatomic) IBOutlet UISwitch *switchVisible;

@property (weak, nonatomic) IBOutlet UIButton *searchUsersButton;

@property (weak, nonatomic) IBOutlet UIButton *disconnectDeviceButton;

@property (weak, nonatomic) IBOutlet UITableView *foundedUsers;

//////

- (IBAction)switchVisible:(UISwitch *)sender;

- (IBAction)searchUsersButton:(UIButton *)sender;

- (IBAction)disconnectUserButton:(UIButton *)sender;

//////

@end
