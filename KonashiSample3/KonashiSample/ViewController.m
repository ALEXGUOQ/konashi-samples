//
//  ViewController.m
//  KonashiSample
//
//  Created by shuichi on 10/24/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"


@interface ViewController ()
{
    int currentLED;
    NSTimeInterval startTime;
}
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Konashiオブジェクトを初期化
    [Konashi initialize];
    
    // konashiとの接続完了時に発行されるイベントを監視する
    [Konashi addObserver:self
                selector:@selector(ready)
                    name:KONASHI_EVENT_READY];

    [Konashi addObserver:self
                selector:@selector(pioInputUpdated)
                    name:KONASHI_EVENT_UPDATE_PIO_INPUT];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =============================================================================
#pragma mark - Private

- (void)flashLED:(int)led {
    
    [Konashi pinMode:led
                mode:OUTPUT];
    
    [Konashi digitalWrite:led
                    value:HIGH];
}

- (void)turnOffAll {
    
    for (int i=LED2; i<=LED5; i++) {
        
        [Konashi pinMode:i
                    mode:OUTPUT];
        
        [Konashi digitalWrite:i
                        value:LOW];
    }
}


// =============================================================================
#pragma mark - Event Hanler

- (void)ready {

    // 接続完了したらまずLED2をオン
    currentLED = LED2;
    [self flashLED:currentLED];
}

- (void)pioInputUpdated {
    
    [Konashi pinMode:S1
                mode:INPUT];
    
    // スイッチが押された
    if ([Konashi digitalRead:S1] == HIGH) {

        startTime = [[NSDate date] timeIntervalSince1970];
    }
    // スイッチが離された
    else {
        
        NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval interval = current - startTime;

        // 長押し
        if (interval > 1.0) {
            
            NSString *title = [NSString stringWithFormat:@"メニュー %d が選択されました", currentLED];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        // クリック
        else {
            
            // 全てのLEDをオフ
            [self turnOffAll];

            // 次のLEDへ
            currentLED++;
            
            // LED5の次はLED2
            if (currentLED > LED5) {
                
                currentLED = LED2;
            }
            
            // 次のLEDをオン
            [self flashLED:currentLED];
        }
    }
}


// =============================================================================
#pragma mark - Action

- (IBAction)pressFind {
    
    [Konashi find];
}

@end
