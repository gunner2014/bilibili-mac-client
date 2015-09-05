//
//  ToolBar.m
//  bilibili
//
//  Created by TYPCN on 2015/9/4.
//  Copyright (c) 2015 TYPCN. All rights reserved.
//

#import "ToolBar.h"
#import "Common.hpp"
#import "WebTabView.h"

@interface BLToolBar ()


@end

@implementation BLToolBar

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end


@interface BLToolBarEvents ()

@property (weak) IBOutlet NSTextField *URLInputField;

@end

@implementation BLToolBarEvents

- (id)init{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToolbarURL:) name:@"BLChangeURL" object:nil];
    return self;
}


- (void)finalize {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateToolbarURL:(NSNotification*) aNotification{
    if(aNotification.object){
        NSString *url = aNotification.object;
        if([url length] > 5){
            [self.URLInputField setStringValue:url];
        }
    }else{
        WebTabView *tc = (WebTabView *)[browser activeTabContents];
        [self.URLInputField setStringValue:[[tc GetTWebView] getURL]];
    }
}

- (IBAction)OpenURL:(id)sender {
    [sender resignFirstResponder];
    CTTabContents *ct = [browser activeTabContents];
    if(ct) {
        [[browser window] makeFirstResponder:ct.view];
    }
    WebTabView *tc = (WebTabView *)[browser activeTabContents];
    id wv = [tc GetTWebView];
    NSString *url = [self.URLInputField stringValue];
    if([url length] < 3){
        return;
    }else if([url isEqualToString:[wv getURL]]){
        return;
    }else if([url containsString:@"http://"] || [url containsString:@"https://"]){
        [wv setURL:url];
    }else{
        [wv setURL:[NSString stringWithFormat:@"http://%@",url]];
    }
}


- (IBAction)goHome:(id)sender {
    WebTabView *tc = (WebTabView *)[browser activeTabContents];
    [[tc GetTWebView] setURL:@"http://www.bilibili.com"];
}
- (IBAction)Refresh:(id)sender {
    WebTabView *tc = (WebTabView *)[browser activeTabContents];
    NSString *u = [[tc GetTWebView] getURL];
    [[tc GetTWebView] setURL:u];
}
- (IBAction)forward:(id)sender {
    WebTabView *tc = (WebTabView *)[browser activeTabContents];
    [[tc GetTWebView] wgoForward];
}
- (IBAction)backward:(id)sender {
    WebTabView *tc = (WebTabView *)[browser activeTabContents];
    [[tc GetTWebView] wgoBack];
}
- (IBAction)menu:(id)sender {
    WebTabView *tc = (WebTabView *)[browser activeTabContents];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[tc GetWebView] subviews][0] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"暂未完成";
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}

@end