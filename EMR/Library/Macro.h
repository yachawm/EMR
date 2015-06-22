//
//  Macro.h
// SunMedicalCenter
//
//  Created by minyounghu on 13.11.11..
//  Copyright (c) 2013년 (주)공간소프트. All rights reserved.
//

#ifndef sunmedicalcenter_Macro_h
#define sunmedicalcenter_Macro_h

#define STR(x) NSLocalizedString(x, @"")
#define NUM(x) [NSNumber numberWithInt:(x)]
#define FLOAT(x) [NSNumber numberWithFloat:(x)]

#define degreesToRadians(x) (M_PI *(x) / 180.0)

#define GET_STRING(X)       ([[data valueForKey:X] isMemberOfClass:[NSNull class]]||[data valueForKey:X]==nil) ? @"" : [(NSString*) [data objectForKey:X] retain];
#define IS_NOT_NULL(X)      (([[data valueForKey:X] isKindOfClass:[NSNull class]] == NO) && ([data valueForKey:X] != nil))
#define ERROR_MSG(X, Y) {case X: return Y;}

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#ifdef ONLY_LANDSCAP
#define MAINSCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.height
#define MAINSCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.width
#else
#define MAINSCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define MAINSCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
#endif

#define STATUSBAR_HEIGHT        [[UIApplication sharedApplication] statusBarFrame].size.height

#define DEVICE_APNS_ENABLED ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone)
#define ISPAD                  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES

#define SHOW_RECT(rect) NSLog(@"rect: %.0f %.0f %.0f %.0f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

#define _(x) NSLocalizedString(x, x)


#define IPHONE5_SIZE        568
#define WIDESCREEN ([[UIScreen mainScreen] bounds].size.height == IPHONE5_SIZE)


#endif