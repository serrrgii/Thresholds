[Thresholds](Thresholds/SRGThreshold.h) is a library designed for tracking and handling named events in iOS applications.

[Thresholds](Thresholds/SRGThreshold.h) and [threshold contexts](Thresholds/SRGThresholdContext.h) conform to the  [NSCoding](https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Protocols/NSCoding_Protocol/Reference/Reference.html) protocol and can be stored and retrieved from [NSUserDefaults](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/nsuserdefaults_Class/Reference/Reference.html). 

```objective-c
SRGThresholdContext *thresholdContext = nil;

thresholdContext = [SRGThresholdContext contextWithStringIdentifier:ContextIdentifier failure:&error];

if (!error)
{
  [thresholdContext addThreshold:threshold failure:&error];
  [thresholdContext addThreshold:secondThreshold failure:&error];
  [thresholdContext archive];
}
```
