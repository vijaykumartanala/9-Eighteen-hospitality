#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BluesnapSDK.h"
#import "Kount-Bridging-Header.h"
#import "KDataCollector.h"

FOUNDATION_EXPORT double BluesnapSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char BluesnapSDKVersionString[];

