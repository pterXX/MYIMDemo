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

#import "IMNotificationObserver.h"
#import "IMShortcutMacros.h"
#import "IMShortcutMethod.h"

FOUNDATION_EXPORT double IMShortcutVersionNumber;
FOUNDATION_EXPORT const unsigned char IMShortcutVersionString[];

