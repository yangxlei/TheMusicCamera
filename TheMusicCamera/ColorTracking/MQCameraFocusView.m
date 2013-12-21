
#import "MQCameraFocusView.h"

@implementation MQCameraFocusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        UIImage *focusImage = [UIImage imageNamed:@"icon_takephoto_focus_auto@2x.png"]; 
        _focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width/2.0, focusImage.size.height/2.0)]; 
        _focusImageView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0); 
        _focusImageView.image = focusImage; 
        [self addSubview:_focusImageView]; 
//        [_focusImageView release]; 
      
        _focusImageView.hidden = YES; 
        
        _focusType = FOCUS_AUTO; 
        _isAnimating = NO; 
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)playAutoAdjustFocusAnimation
{
    if (_isAnimating) return; 
    
    if (_focusImageView.hidden) {
        
        _isAnimating = YES;
        
        UIImage *focusImage = [UIImage imageNamed:@"icon_takephoto_focus_auto@2x.png"];
        _focusImageView.frame = CGRectMake(0, 0, focusImage.size.width/2.0, focusImage.size.height/2.0); 
        _focusImageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0); 
        _focusImageView.image = focusImage; 
        _focusImageView.hidden = NO; 
        _focusImageView.alpha = 0.5; 
        _focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5); 
        
         
        [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationCurveEaseIn animations:^(void) { 
            _focusImageView.alpha = 1.0; 
            
            _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationCurveEaseIn|UIViewAnimationOptionAutoreverse animations:^(void) {
                
                [UIView setAnimationRepeatCount:3]; 
                _focusImageView.alpha = 0.5; 
                
            }completion:^(BOOL finished) {
                
                [self playStopAnimation];  
            }];  
        }]; 
    }
}

- (void)playManualAdjustFocusAnimation
{
    
    if (_focusImageView.hidden) {
        
        _isAnimating = YES;
        
        UIImage *focusImage = [UIImage imageNamed:@"icon_takephoto_focus_manual@2x.png"];
        _focusImageView.frame = CGRectMake(0, 0, focusImage.size.width/2.0, focusImage.size.height/2.0); 
        _focusImageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0); 
        _focusImageView.image = focusImage; 
        
        _focusImageView.hidden = NO; 
        _focusImageView.alpha = 0.5; 
        _focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5); 

        [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationCurveEaseIn animations:^(void) { 
            _focusImageView.alpha = 1.0; 
            
            _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 delay:0.0f options:UIViewAnimationCurveEaseIn|UIViewAnimationOptionAutoreverse animations:^(void) {
                
                [UIView setAnimationRepeatCount:3]; 
                _focusImageView.alpha = 0.5; 
                
            }completion:^(BOOL finished) {
                
                [self playStopAnimation];  
            }];  
        }];
    }
}

- (void)playStopAnimation
{
    _focusImageView.hidden = YES; 
    _isAnimating = NO; 
    
    [self removeFromSuperview]; 
}
@end
