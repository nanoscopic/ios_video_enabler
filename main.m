#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMediaIO/CMIOHardware.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // CMI Magic to enable capture of IOS device mirroring over USB
        CMIOObjectPropertyAddress prop = {
            kCMIOHardwarePropertyAllowScreenCaptureDevices,
            kCMIOObjectPropertyScopeGlobal,
            kCMIOObjectPropertyElementMaster
        };
        UInt32 allow = 1;
        CMIOObjectSetPropertyData(kCMIOObjectSystemObject, &prop, 0, NULL, sizeof(allow), &allow );

        printf("started\n");

        NSArray<AVMediaType> *device_types = [NSArray arrayWithObjects: AVCaptureDeviceTypeExternalUnknown, nil];
        AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:device_types mediaType:AVMediaTypeMuxed position:0];
        NSArray<AVCaptureDevice *> *devices = [session devices];
        
        uint8_t count = [devices count];
        for (AVCaptureDevice *device in devices) {
            const char *name = [[device localizedName] UTF8String];
            const char *id = [[device uniqueID] UTF8String];
            //index            = [devices count] + [devices_muxed indexOfObject:device];
            printf("--Device--\n  Name:%s\n  UDID:%s\n", name, id );
        }
        
        NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
        
        // Setup an observer for newly connected devices
        id observeConnect = [
            nCenter addObserverForName:AVCaptureDeviceWasConnectedNotification
            object:nil
            queue:[NSOperationQueue mainQueue]
            usingBlock:^(NSNotification *note)
        {
            NSArray<AVMediaType> *device_types = [NSArray arrayWithObjects: AVCaptureDeviceTypeExternalUnknown, nil];
            AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:device_types mediaType:AVMediaTypeMuxed position:0];
            NSArray<AVCaptureDevice *> *devices = [session devices];
        
            uint8_t count = [devices count];
            for (AVCaptureDevice *device in devices) {
                const char *name = [[device localizedName] UTF8String];
                const char *id = [[device uniqueID] UTF8String];
                //index            = [devices count] + [devices_muxed indexOfObject:device];
                printf("--Device--\n  Name:%s\n  UDID:%s\n", name, id );
            }
        }];
        
        // Setup an observer for disconnected devices
        id observeDisconnect = [
             nCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification
             object:nil
             queue:[NSOperationQueue mainQueue]
             usingBlock:^(NSNotification *note)
        {
            NSArray<AVMediaType> *device_types = [NSArray arrayWithObjects: AVCaptureDeviceTypeExternalUnknown, nil];
            AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:device_types mediaType:AVMediaTypeMuxed position:0];
            NSArray<AVCaptureDevice *> *devices = [session devices];
        
            uint8_t count = [devices count];
            for (AVCaptureDevice *device in devices) {
                const char *name = [[device localizedName] UTF8String];
                const char *id = [[device uniqueID] UTF8String];
                //index            = [devices count] + [devices_muxed indexOfObject:device];
                printf("--Device--\n  Name:%s\n  UDID:%s\n", name, id );
            }
        }];
        
        [[NSRunLoop currentRunLoop] run];
        [nCenter removeObserver:observeConnect];
        [nCenter removeObserver:observeDisconnect];
    }
    return 0;
}
