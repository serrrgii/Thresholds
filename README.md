[Thresholds](Thresholds/SRGThreshold.h) is a library designed for tracking and handling named events in iOS applications.

[Thresholds](Thresholds/SRGThreshold.h) are configured with a number of required counters, a start date and an expiration date.

```objective-c
static NSString *const ThresholdIdentifier = @"my_threshold";
SRGThreshold *threshold = [SRGThreshold thresholdWithStringIdentifier:ThresholdIdentifier
                                                     requiredCounters:@2
                                                            startDate:startDate
                                                              endDate:endDate];
```

Add counters to a [Threshold](Thresholds/SRGThreshold.h) to have it reach its limit and call a handler block. 

```objective-c
NSError *error = nil;
[threshold setDidReachLimitHandler:^(SRGThreshold *treshold) {
  NSLog(@"limit reached for threshold %@", threshold.identifier);
}];
[threshold addCounter:&error];
[threshold addCounter:&error];
```

Trying to add counters in a date out of the start and end date period wil generate an error. When initializing the threshold you can nil start and/or end date to remove one or both date constraints.

[Thresholds](Thresholds/SRGThreshold.h) can be used individually or grouped in [threshold contexts](Thresholds/SRGThresholdContext.h)

```objective-c
SRGThresholdContext *thresholdContext = [SRGThresholdContext contextWithStringIdentifier:ContextIdentifier
                                                                                 failure:&error];
if (!error)
{
  [thresholdContext addThreshold:threshold
                          failure:&error];
  [thresholdContext addThreshold:anotherThreshold
                          failure:&error];
}
```

You can add counters to thresholds inside a context through their parent context.

```objective-c
[thresholdContext setDidReachLimitHandler:^(SRGThresholdContext *context) {
    NSLog(@"reached limit of all context thresholds %@", context.identifier);
}];

[thresholdContext addCounterWithThresholdIdentifier:ThresholdIdentifier failure:&error];
[thresholdContext addCounterWithThresholdIdentifier:AnotherThresholdIdentifier failure:&error];
```

[Thresholds](Thresholds/SRGThreshold.h) and [threshold contexts](Thresholds/SRGThresholdContext.h) conform to the  [NSCoding](https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Protocols/NSCoding_Protocol/Reference/Reference.html) protocol and provide convenience methods to be stored and retrieved from [NSUserDefaults](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/nsuserdefaults_Class/Reference/Reference.html). 

```objective-c

[thresholdContext archive];

SRGThresholdContext *unarchivedContext = [thresholdContext unarchive];

```

[Thresholds](Thresholds/SRGThreshold.h) and [threshold contexts](Thresholds/SRGThresholdContext.h) can be fetched from the archive by identifier.

```objective-c

SRGThresholdContext *unarchivedContext = [SRGThresholdContext fetchWithStringIdentifier:ThresholdIdentifier];

```
