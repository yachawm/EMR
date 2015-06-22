//
//  Recorder.h
//  M-Note
//
//  Created by Wenly on 2014. 2. 5..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface Recorder : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    float time;
    BOOL timeLock;
    
    NSString *tempFilename;
}

+(Recorder *) manager;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) AVAudioRecorder *avRecorder;
@property (nonatomic, retain) id delegate;

- (void)initAudioWithFilename:(NSString*)filename;
- (void)beginRecordToFile:(NSString*)filename delegate:(id)delegate;
- (void)stopRecord;
- (void)playFile:(NSString*)filename delegate:(id)delegate;

- (void)stopPlaying;

- (void)startTime;
- (void)stopTime;

- (void)appendTempFileToExistFile:(NSString*)filename;

- (NSData*)audioDataFromFilename:(NSString*)filename;

@end
