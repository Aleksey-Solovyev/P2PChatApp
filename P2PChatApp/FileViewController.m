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
@property (nonatomic, strong) NSMutableArray *arrFiles;
-(NSArray *) getAllDocDirFiles;
/////
@property (nonatomic, strong) NSString *selectedFile;
@property (nonatomic) NSInteger selectedRow;
/////
@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /////
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    /////
    [self copySampleFilesToDocDirIfNeeded];
    /////
    _arrFiles = [[NSMutableArray alloc] initWithArray:[self getAllDocDirFiles]];
    [_tableFiles setDelegate:self];
    [_tableFiles setDataSource:self];
    [_tableFiles reloadData];
}
/////
-(void)copySampleFilesToDocDirIfNeeded{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    
    NSString *file1Path = [_documentsDirectory stringByAppendingPathComponent:@"sample1.txt"];
    NSString *file2Path = [_documentsDirectory stringByAppendingPathComponent:@"sample2.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    if (![fileManager fileExistsAtPath:file1Path] || ![fileManager fileExistsAtPath:file2Path]) {
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"sample1" ofType:@"txt"]
                             toPath:file1Path
                              error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"sample2" ofType:@"txt"]
                             toPath:file2Path
                              error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
    }
}
/////
-(NSArray *)getAllDocDirFiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *allFiles = [fileManager contentsOfDirectoryAtPath:_documentsDirectory error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    return allFiles;
}
/////
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrFiles count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    cell.textLabel.text = [_arrFiles objectAtIndex:indexPath.row];
    
    [[cell textLabel] setFont:[UIFont systemFontOfSize:14.0]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
/////
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedFile = [_arrFiles objectAtIndex:indexPath.row];
    UIActionSheet *confirmSending = [[UIActionSheet alloc] initWithTitle:selectedFile
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
    
    for (int i=0; i < [[_appDelegate.p2pConnector.session connectedPeers] count]; i++) {
        [confirmSending addButtonWithTitle:[[[_appDelegate.p2pConnector.session connectedPeers] objectAtIndex:i] displayName]];
    }
    
    [confirmSending setCancelButtonIndex:[confirmSending addButtonWithTitle:@"Cancel"]];
    
    [confirmSending showInView:self.view];
    
    _selectedFile = [_arrFiles objectAtIndex:indexPath.row];
    _selectedRow = indexPath.row;
}
/////
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [[_appDelegate.p2pConnector.session connectedPeers] count]) {
        NSString *filePath = [_documentsDirectory stringByAppendingPathComponent:_selectedFile];
        NSString *modifiedName = [NSString stringWithFormat:@"%@_%@", _appDelegate.p2pConnector.peerID.displayName, _selectedFile];
        NSURL *resourceURL = [NSURL fileURLWithPath:filePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSProgress *progress = [_appDelegate.p2pConnector.session sendResourceAtURL:resourceURL
                                                                            withName:modifiedName
                                                                              toPeer:[[_appDelegate.p2pConnector.session connectedPeers] objectAtIndex:buttonIndex]
                                    
                                                               withCompletionHandler:^(NSError *error) {
                                                                   if (error) {
                                                                       NSLog(@"Error: %@", [error localizedDescription]);
                                                                   }
                                                                   
                                                                   else{
                                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MCDemo"
                                                                                                                       message:@"File was successfully sent."
                                                                                                                      delegate:self
                                                                                                             cancelButtonTitle:nil
                                                                                                             otherButtonTitles:@"Great!", nil];
                                                                       
                                                                       [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                                                                       
                                                                       [_arrFiles replaceObjectAtIndex:_selectedRow withObject:_selectedFile];
                                                                       [_tableFiles performSelectorOnMainThread:@selector(reloadData)
                                                                                                   withObject:nil
                                                                                                waitUntilDone:NO];
                                                                   }
                                                                   
                                                               }];
            /////
            [progress addObserver:self
                       forKeyPath:@"fractionCompleted"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
            /////
        });
    }
}
/////
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *sendingMessage = [NSString stringWithFormat:@"%@ - Sending %.f%%",
                                _selectedFile,
                                [(NSProgress *)object fractionCompleted] * 100
                                ];
    
    [_arrFiles replaceObjectAtIndex:_selectedRow withObject:sendingMessage];
    
    [_tableFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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

@end
