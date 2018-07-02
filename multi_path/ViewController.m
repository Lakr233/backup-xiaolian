//
//  ViewController.m
//  multi_path
//
//  Created by Ian Beer on 5/28/18.
//  Copyright © 2018 Ian Beer. All rights reserved.
//

#import "ViewController.h"
#import <sys/utsname.h>
#include <dlfcn.h>

extern int  expl0it(void);            //stage 1
extern int  go_jailbreak(void);       //stage 2
extern void reload_environment(void); //stage 3

@interface ViewController ()
- (IBAction)jb:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel     *header;
@property (weak, nonatomic) IBOutlet UILabel     *header2;
@property (weak, nonatomic) IBOutlet UILabel     *header3;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel     *byLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uint32_t flags;
    int csops(pid_t pid, unsigned int ops, void *useraddr, size_t usersize);
    csops(getpid(), 0, &flags, 0);
    
    if (flags & 0x4000000) {
        [self.btn setTitle:@"Jailbroken" forState:UIControlStateDisabled];
        [self.btn setEnabled:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (@available(iOS 11.3, *)) {
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"孝廉" message:@"sorry, but your version is not supported." preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:nil];
    }
}

- (void)post_go {
    int result = go_jailbreak();
    
    if (result == 0) {
        [self.btn setTitle:@"Reloading environment..." forState:UIControlStateDisabled];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            reload_environment();
        });
        
        return;
    }
    
    [self.btn setTitle:[NSString stringWithFormat:@"Error (%i)", result] forState:UIControlStateDisabled];
}

- (void)go {
    int ret = expl0it();
    
    if (ret != 0) {
        [self.btn setTitle:@"Failed." forState:UIControlStateDisabled];
        return;
    }
    
    [self.btn setTitle:@"Jailbreaking (2/2)..." forState:UIControlStateDisabled];
    [self performSelector:@selector(post_go) withObject:nil afterDelay:1.0];
}

- (IBAction)jb:(id)sender {
    [self.btn setTitle:@"Jailbreaking (1/2)..." forState:UIControlStateDisabled];
    [self.btn setEnabled:NO];
    
    [self performSelector:@selector(go) withObject:nil afterDelay:1.5];
}

@end
