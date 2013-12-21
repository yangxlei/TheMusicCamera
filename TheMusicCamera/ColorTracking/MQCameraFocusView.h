
#import <UIKit/UIKit.h>

typedef enum {
    
    FOCUS_AUTO,
    FOCUS_MANUAL,
    
}FocusType;

@interface MQCameraFocusView : UIView {
    
    UIImageView *_focusImageView; 
    
    FocusType _focusType; 
    
    BOOL _isAnimating; 
}

- (void)playAutoAdjustFocusAnimation; 

- (void)playManualAdjustFocusAnimation; 

- (void)playStopAnimation; 

@end
