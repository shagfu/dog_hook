#line 1 "/Volumes/extData/ios/dog_hook/dog_hook/dog_hook.xm"


#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <UIKit/UIKit.h>
#import "TestHook.h"
static __attribute__((constructor)) void _logosLocalCtor_c9f0f895(int __unused argc, char __unused **argv, char __unused **envp)
{
    [[TestHook sharedInstance] dotest];
}

