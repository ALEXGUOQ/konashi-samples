//
//  ViewController.m
//  KonashiSample
//
//  Created by shuichi on 10/24/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Konashiオブジェクトを初期化
    [Konashi initialize];
    
    // konashiとの接続完了時に発行されるイベントを監視する
    [Konashi addObserver:self
                selector:@selector(flashLED)
                    name:KONASHI_EVENT_READY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


// =============================================================================
#pragma mark - Event Hanler

- (void)flashLED {
    
    [Konashi pinMode:LED2
                mode:OUTPUT];
    
    [Konashi digitalWrite:LED2
                    value:HIGH];
}


// =============================================================================
#pragma mark - Action

- (IBAction)pressFind {
    
    [Konashi find];
}


@end
