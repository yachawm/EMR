//
//  Recorder.m
//  M-Note
//
//  Created by Wenly on 2014. 2. 5..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import "Recorder.h"
#import <AVFoundation/AVFoundation.h>


@implementation Recorder

static Recorder *recorder= nil;

+(Recorder *)manager
{
    @synchronized([Recorder class]) // 오직 하나의 쓰레드만 접근할 수 있도록 함.
    {
        if(recorder==nil)
        {
            recorder = [[self alloc] init];
            if (nil != recorder) {
                
            }
        }
    }
    return recorder;
    
}

- (id)init
{
	if((self = [super init]))// 초기화 선언부분
	{
        // Setup audio session
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	}
	
	return self;
}

- (void)initAudioWithFilename:(NSString*)filename{
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
                               filename,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat: 44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];

    
    // Initiate and prepare the recorder
    if (_avRecorder!=nil) {
        self.avRecorder = nil;
    }
    _avRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    _avRecorder.delegate = _delegate;
    _avRecorder.meteringEnabled = YES;
    [_avRecorder prepareToRecord];


}

- (void)beginRecordToFile:(NSString*)filename delegate:(id)delegate{

    self.delegate = delegate;
//    if([self isFileExist:filename]){
//        tempFilename = [NSString stringWithFormat:@"temp-%@",filename];
//    }
//    else{
//        tempFilename = [NSString stringWithString: filename];
//    }
    
    if (_player.playing) {
        [_player stop];
    }
    
    [self initAudioWithFilename:filename];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    // Start recording
    [_avRecorder setMeteringEnabled:YES];
    
    [_avRecorder record];
    //[recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
}

- (BOOL)isFileExist:(NSString*)filename{
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
                               filename,
                               nil];
    NSURL *fileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]){
        NSLog(@"File '%@'is exist at '%@'",filename, [fileURL path]);
        return YES;
    }
    NSLog(@"File '%@'is NOT exist at '%@'",filename, [fileURL path]);
    return NO;
}

- (void)stopRecord{
    [_avRecorder stop];
    
    

}

- (void)playFile:(NSString*)filename delegate:(id)delegate{
    self.delegate = delegate;
    
    
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
                               filename,
                               nil];
    NSURL *fileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSLog(@"playFile '%@'is exist at '%@'",filename, [fileURL path]);
    
    if (!_avRecorder.recording){
        if (_player!=nil) {
            self.player = nil;
        }
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        [_player setDelegate:_delegate];
        [_player prepareToPlay];
        [_player play];
    }
    
}

- (NSData*)audioDataFromFilename:(NSString*)filename{
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
                               filename,
                               nil];
    NSURL *fileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    
    return data;
}


- (void)stopPlaying{
    
    [_player stop];
    
}

- (void)startTime{
    if (timeLock==NO) {
        timeLock=YES;
        time = 0;
        [self startTimeTrhead];
    }
}

- (void)startTimeTrhead{
    if (timeLock==YES) {
        //self.labelTime.text = [NSString stringWithFormat:@"%.1f",time];
        time += 0.1;
        [self performSelector:@selector(startTimeTrhead) withObject:nil afterDelay:0.1];
    }
}

- (void)stopTime{
    timeLock = NO;
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:YES];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)appendTempFileToExistFile:(NSString*)filename{
    if([tempFilename isEqualToString:filename]){
        
    }
    else{
        //[self appendMediaFile:tempFilename toExistFile:filename];
        [self combineAudioFiles:[NSArray arrayWithObjects:filename,tempFilename, nil]];
    }
    
}

-(void)appendMediaFile:(NSString*)newFilename toExistFile:(NSString*)existFilename
{
    
    NSURL *file1URL = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:
                                                        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
                                                        existFilename,
                                                        nil]];
    
    NSURL *file2URL = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:
                                                        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
                                                        newFilename,
                                                        nil]];
    
    NSURL *outFileURL = file1URL;
    
    //setup asset
//    NSString *firstassetpath = [NSString stringWithFormat:@"%@mpeg4-1.mp4", NSTemporaryDirectory()];
//    NSString *secondassetpath = [NSString stringWithFormat:@"%@mpeg4-2.mp4", NSTemporaryDirectory()];
//    
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    
    AVAsset *firstAsset = [AVAsset assetWithURL:file1URL];
    AVAsset *secondAsset = [AVAsset assetWithURL:file2URL];

    NSLog(@"FirstAsset Is Readable = %d", firstAsset.isReadable);
    NSLog(@"FirstAsset Is playable = %d", firstAsset.isPlayable);
    
    NSLog(@"FirstAsset Is exportable = %d", firstAsset.exportable);
    NSLog(@"SecondAsset Is Readable = %d", secondAsset.isReadable);
    
    NSLog(@"SecondAsset Is playable = %d", secondAsset.isPlayable);
    NSLog(@"SecondAsset Is exportable = %d", secondAsset.exportable);
    
    //setup composition and track
    AVMutableComposition *composition = [[AVMutableComposition alloc]init];
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVAssetExportPresetPassthrough preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //add assets to track
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] atTime:firstAsset.duration error:nil];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    
    //NSString *outputURL = [NSString stringWithFormat:filename, NSTemporaryDirectory()];
    
    NSLog(@"%@", exporter.supportedFileTypes);
    //exporter.outputURL=[NSURL fileURLWithPath:outputURL];
    exporter.outputURL = outFileURL;
    exporter.outputFileType = AVFileTypeAppleM4A;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
    

    
    //    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:composition
//                                                                          presetName:AVAssetExportPresetPassthrough];
//    
//    _assetExport.outputFileType = AVFileTypeCoreAudioFormat;
//    _assetExport.outputURL = exportUrl;
//    _assetExport.shouldOptimizeForNetworkUse = YES;
//    
//    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
//        if (_assetExport.status == AVAssetExportSessionStatusCompleted) {
//            [self performSelector:@selector(sendMessage) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
//        } else {
//            NSLog(@"%@",_assetExport.error);
//            [self performSelector:@selector(sendErrorMessage) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
//        }
//        
//    }];
//    [_assetExport release];
    
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    
    NSLog(@"export method");
    NSLog(@"%i", session.status);
    NSLog(@"%@", session.error);
}

- (BOOL) combineAudioFiles:(NSArray*)audioFiles {
    
    if(audioFiles.count<2)return NO;
    
    
    
    NSError *error = nil;
    BOOL ok = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,    NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    CMTime nextClipStartTime = kCMTimeZero;
    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    for (int i = 0; i< [audioFiles count]; i++) {
        //int key = [[audioFiles objectAtIndex:i] intValue];
        NSString *audioFileName = [audioFiles objectAtIndex:i];
        
        //Build the filename with path
        NSString *soundOne = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", audioFileName]];
        //NSLog(@"voice file - %@",soundOne);
        
        NSURL *url = [NSURL fileURLWithPath:soundOne];
        AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        NSArray *tracks = [avAsset tracksWithMediaType:AVMediaTypeAudio];
        if ([tracks count] == 0)
            return NO;
        CMTimeRange timeRangeInAsset = CMTimeRangeMake(kCMTimeZero, [avAsset duration]);
        AVAssetTrack *clipAudioTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        ok = [compositionAudioTrack insertTimeRange:timeRangeInAsset  ofTrack:clipAudioTrack atTime:nextClipStartTime error:&error];
        if (!ok) {
            NSLog(@"Current Video Track Error: %@",error);
        }
        nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration);
    }
    
    // create the export session
    // no need for a retain here, the session will be retained by the
    // completion handler since it is referenced there
    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    if (nil == exportSession) return NO;
    
    
    
    NSString *tempFile = [documentsDirectory stringByAppendingPathComponent:@"combined.m4a"];
    
    NSURL *toURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:[audioFiles objectAtIndex:0]]];
    NSURL *atURL = [NSURL fileURLWithPath:tempFile];
    
    [[NSFileManager defaultManager] removeItemAtURL:atURL error:nil];
    
    //NSLog(@"Output file path - %@",soundOneNew);
    
    // configure export session  output with all our parameters
    exportSession.outputURL = [NSURL fileURLWithPath:tempFile]; // output path
    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
    
    // perform the export
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@"export method");
        NSLog(@"%i", exportSession.status);
        NSLog(@"%@", exportSession.error);
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
            
            
            [[NSFileManager defaultManager] removeItemAtURL:toURL error:nil];
            [[NSFileManager defaultManager] copyItemAtURL:atURL toURL:toURL error:nil];
            
            
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            NSLog(@"AVAssetExportSessionStatusFailed");
        } else {
            NSLog(@"Export Session Status: %d", exportSession.status);
        }
    }];
    
    return YES;
}


@end
