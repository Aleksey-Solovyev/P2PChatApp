//
//  ChatViewController.h
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController /* */ <UITextFieldDelegate>
/////
@property (weak, nonatomic) IBOutlet UITextField *textMessage;

@property (weak, nonatomic) IBOutlet UITextView *textChat;

- (IBAction)sendMessage:(id)sender;

- (IBAction)cancelMessage:(id)sender;
/////
@end
