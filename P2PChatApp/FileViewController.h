//
//  FileViewController.h
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController /* */ <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
/////
@property (weak, nonatomic) IBOutlet UITableView *tableFiles;
/////
@end
