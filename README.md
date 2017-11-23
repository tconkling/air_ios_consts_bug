# air_ios_consts_bug

[Adobe bug tracker issue](https://tracker.adobe.com/#/view/AIR-4198513)

[Adobe AIR Bugs Forum thread](https://forums.adobe.com/thread/2416055)

This demonstrates an error in AIR for iOS. Specifically, `const` values that are declared inside a code block in a function that *also* has a local closure definition will not have their proper values.

The code:

```
public static function testConsts () :void {
    var closure :Function = function () :void {
        // I'm a closure that does nothing, but my existence breaks const initialization on iOS
    };

    var outerVar :Number = 1;
    const outerConst :Number = 2;
    assertEquals(outerVar, 1, "outerVar");
    assertEquals(outerConst, 2, "outerConst");

    if (outerVar == 1) {
        var innerVar :Number = 3;
        const innerConst :Number = 4;
        assertEquals(innerVar, 3, "innerVar");

        // on iOS, this fails. innerConst gets initialized to 0.
        // Removing the closure from the function makes things work as expected.
        assertEquals(innerConst, 4, "innerConst");
    }
}
```

If this function is run in an AIR desktop app or the Flash Player, everything behaves as it should and none of the assertions fail. However, on iOS, the final assertion will fail -- `innerConst` will have a value of 0 rather than 4. 

If you remove the `closure` variable in the function, the assertion will pass. If you move `innerConst`'s initialization out of its enclosing if-statement, the assertion will pass.

## Building and running

- You'll need to add a `cert.p12` and `ios.mobileprovision` file to the project folder in order to install the project on an iOS device.
- You'll probably need to edit `airdesc.xml` to assign a different app ID to the application.
- Assuming you have `ant` installed, `ant install-ios` should build the swf, pacakge it for iOS, and install it on a connected iOS device.

## Expected behavior

The app just runs the simple test function above. Assuming all assertions pass, the app will display a green screen. If an assertion fails, the screen will be red. Running the app on an iOS device produces a red screen. (I've tested this with AIR SDK 26 and AIR SDK 27.)
